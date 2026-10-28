#!/usr/bin/env python3
"""Discover only the supplied test identities; credentials stay in private files.

Allowed writes are login and space-token issuance. This script does not create
users, friends, conversations, messages, service threads, roles or status changes.
"""
import argparse
import base64
from datetime import datetime, timedelta, timezone
from hashlib import sha256
import json
import os
from pathlib import Path
import re
import sys
import tempfile
import urllib.error
import urllib.parse
import urllib.request
import uuid


def private_json(path, value):
    path.parent.mkdir(parents=True, exist_ok=True, mode=0o700)
    fd, temporary = tempfile.mkstemp(prefix='.' + path.name, dir=path.parent)
    try:
        os.fchmod(fd, 0o600)
        with os.fdopen(fd, 'w') as handle:
            json.dump(value, handle, ensure_ascii=False, indent=2)
            handle.write('\n')
        os.replace(temporary, path)
    finally:
        if os.path.exists(temporary):
            os.unlink(temporary)


def items(value):
    if isinstance(value, list):
        return [x for x in value if isinstance(x, dict)]
    if isinstance(value, dict):
        for name in ('items', 'tenants', 'friends', 'conversations', 'members'):
            if isinstance(value.get(name), list):
                return items(value[name])
    return []


class Discovery:
    def __init__(self, args, config):
        self.args, self.config = args, config
        self.base = (args.base_url or config.get('apiBaseUrl', '')).rstrip('/')
        parsed = urllib.parse.urlparse(self.base)
        if parsed.scheme != 'https' or not parsed.netloc or parsed.username or parsed.password or parsed.query or parsed.fragment:
            raise ValueError('An HTTPS API base without credentials/query/fragment is required')
        self.output = Path(args.output_dir).resolve()
        private_root = Path(__file__).resolve().parents[1] / '.work/runtime-private'
        if not self.output.is_relative_to(private_root):
            raise ValueError('Sensitive output must stay under this SDK .work/runtime-private directory, outside source/dist delivery')
        self.output.mkdir(parents=True, exist_ok=True, mode=0o700)
        self.log = Path(args.log).resolve()
        self.log.parent.mkdir(parents=True, exist_ok=True)
        self.secrets = [x['password'] for x in config['accounts']]
        self.raw = {'apiBaseUrl': self.base, 'host': args.host, 'accounts': [], 'responses': []}
        self.summary = {'host': args.host, 'accounts': [], 'directPairs': [], 'serviceAccountCandidates': [], 'errors': []}
        self.realm = 'validation-' + sha256(self.base.encode()).hexdigest()[:16]
        self.device_file = self.output / (args.host + '-device-ids.json')
        self.devices = json.loads(self.device_file.read_text()) if self.device_file.exists() else {}

    def redact(self, value):
        text = str(value)
        for secret in sorted(set(self.secrets), key=len, reverse=True):
            if secret:
                text = text.replace(secret, '<redacted>')
        text = re.sub(r'eyJ[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+', '<redacted-jwt>', text)
        return text[:350]

    def record(self, value):
        safe = json.dumps(value, ensure_ascii=False)
        fd = os.open(self.log, os.O_CREAT | os.O_APPEND | os.O_WRONLY, 0o600)
        with os.fdopen(fd, 'a') as handle:
            handle.write(safe + '\n')

    def checkpoint(self):
        private_json(self.output / (self.args.host + '-discovery.json'), self.raw)
        private_json(self.output / (self.args.host + '-summary.json'), self.summary)

    def request(self, account, method, endpoint, *, token=None, payload=None):
        headers = {'Accept': 'application/json', 'Content-Type': 'application/json', 'User-Agent': 'IMSDK-authorized-host-validation/0.1'}
        if token:
            headers['Authorization'] = 'Bearer ' + token
        body = json.dumps(payload).encode() if payload is not None else None
        request = urllib.request.Request(self.base + endpoint, data=body, headers=headers, method=method)
        status, raw, response_headers, failure = None, b'', {}, None
        try:
            with urllib.request.urlopen(request, timeout=self.args.timeout) as response:
                status, raw, response_headers = response.status, response.read(), dict(response.headers)
        except urllib.error.HTTPError as error:
            status, raw, response_headers = error.code, error.read(), dict(error.headers)
        except (urllib.error.URLError, TimeoutError, OSError) as error:
            failure = type(error).__name__
        try:
            envelope = json.loads(raw) if raw else None
        except (UnicodeDecodeError, json.JSONDecodeError):
            envelope = {'nonJsonBody': raw.decode('utf-8', errors='replace')}
        code = envelope.get('code') if isinstance(envelope, dict) else None
        request_id = (envelope.get('requestId') or envelope.get('traceId')) if isinstance(envelope, dict) else None
        if not request_id:
            request_id = next((v for k, v in response_headers.items() if k.lower() in ('x-request-id', 'x-correlation-id', 'traceparent')), None)
        message = envelope.get('message', '') if isinstance(envelope, dict) else ''
        for key in ('accessToken', 'refreshToken', 'platformToken', 'platformRefreshToken', 'deviceSessionToken'):
            def collect(value):
                if isinstance(value, dict):
                    for k, v in value.items():
                        if k == key and isinstance(v, str): self.secrets.append(v)
                        else: collect(v)
                elif isinstance(value, list):
                    for v in value: collect(v)
            collect(envelope)
        entry = {'account': account, 'method': method, 'endpoint': endpoint, 'status': status,
                 'code': code, 'requestId': request_id, 'errorType': failure}
        if message and (status is None or status >= 400 or code not in (None, 'OK')):
            entry['message'] = self.redact(message)
        self.record(entry)
        self.raw['responses'].append({**entry, 'response': envelope})
        self.checkpoint()
        ok = failure is None and status is not None and 200 <= status < 300 and code in (None, 'OK')
        if not ok:
            self.summary['errors'].append(entry)
            return None
        return envelope.get('data') if isinstance(envelope, dict) and 'data' in envelope else envelope

    def discover_account(self, index, account):
        label = f'account-{index + 1}'
        key = sha256(account['loginName'].encode()).hexdigest()
        device = self.devices.setdefault(key, str(uuid.uuid4()))
        private_json(self.device_file, self.devices)
        login_type = 'email' if '@' in account['loginName'] else 'auto'
        login = self.request(label, 'POST', '/api/platform/v1/auth/login', payload={
            'identifier': account['loginName'], 'password': account['password'], 'loginType': login_type,
            'issueRefreshToken': True, 'deviceId': device, 'devicePlatform': self.args.device_platform,
            'deviceName': 'IM SDK ' + self.args.host + ' validation', 'appVersion': '0.1.0',
        })
        result = {'label': label, 'deviceId': device, 'loginName': account['loginName'], 'spaces': []}
        self.raw['accounts'].append(result)
        summary = {'label': label, 'loginSucceeded': isinstance(login, dict) and bool(login.get('platformToken')), 'spaces': []}
        self.summary['accounts'].append(summary)
        if not summary['loginSucceeded']:
            print(json.dumps(summary, ensure_ascii=False), flush=True)
            self.checkpoint()
            return
        result['platform'] = login
        platform_token = login['platformToken']
        directory = self.request(label, 'GET', '/api/platform/v1/my/tenants', token=platform_token)
        tenants = items(directory) if directory is not None else items(login.get('tenants'))
        result['tenantDirectory'] = tenants
        result['officialInbox'] = self.request(label, 'GET', '/api/platform/v1/my/official-accounts', token=platform_token)
        targets = [('personal', None)] + [(x.get('tenantId'), x) for x in tenants if x.get('tenantId')]
        for space_id, tenant in targets:
            endpoint = '/api/platform/v1/auth/select-personal-space' if tenant is None else '/api/platform/v1/auth/select-tenant'
            selected = self.request(label, 'POST', endpoint, token=platform_token,
                                    payload=None if tenant is None else {'tenantId': space_id})
            if not isinstance(selected, dict) or not selected.get('accessToken'):
                continue
            access = selected['accessToken']
            profile = self.request(label, 'GET', '/api/client/v1/profile/me', token=access)
            if not isinstance(profile, dict):
                continue
            user_id = profile.get('userId')
            platform_user_id = profile.get('platformUserId') or selected.get('platformUserId')
            verified = bool(user_id and platform_user_id and platform_user_id == login.get('platformUserId') and
                            (not selected.get('userId') or selected['userId'] == user_id))
            role = int(tenant.get('membershipRole', 0) or 0) if tenant else 0
            space = {'spaceId': space_id, 'selection': selected, 'profile': profile, 'identityVerified': verified,
                     'membershipRole': role, 'userType': profile.get('userType')}
            if tenant:
                members = self.request(label, 'GET', '/api/client/v1/tenant/members', token=access)
                space['members'] = members
                own = next((x for x in items(members) if x.get('userId') == user_id), None)
                if own is not None:
                    role = int(own.get('membershipRole', role) or 0)
                    space['membershipRole'] = role
                official = self.request(label, 'GET', '/api/client/v1/official-account', token=access)
                space['officialAccount'] = official
                if isinstance(official, dict):
                    service_id = official.get('serviceAccountId')
                    official_user_id = official.get('officialUserId')
                    if service_id or official_user_id:
                        self.summary['serviceAccountCandidates'].append({
                            'label': label, 'spaceId': space_id,
                            'serviceAccountId': service_id,
                            'officialUserId': official_user_id,
                            'source': 'GET /api/client/v1/official-account',
                            'contactVerified': False,
                        })
                if role >= 2 and profile.get('userType') == 2:
                    space['receptionStatus'] = self.request(label, 'GET', '/api/client/v1/customer-service/reception/status', token=access)
            space['friends'] = self.request(label, 'GET', '/api/client/v1/friends', token=access)
            space['conversations'] = self.request(label, 'GET', '/api/client/v1/conversations', token=access)
            expiry = datetime.now(timezone.utc) + timedelta(seconds=int(selected.get('expiresIn') or 3600))
            credentials = {'platformUserId': platform_user_id, 'userId': user_id, 'spaceId': space_id,
                'accessToken': access, 'refreshToken': selected.get('refreshToken', ''),
                'expiresAt': expiry.isoformat().replace('+00:00', 'Z'), 'platformToken': platform_token}
            if login.get('platformRefreshToken'): credentials['platformRefreshToken'] = login['platformRefreshToken']
            device_session = login.get('deviceSession')
            if isinstance(device_session, dict) and device_session.get('deviceSessionToken'):
                credentials['deviceSessionToken'] = device_session['deviceSessionToken']
            space['hostConfig'] = {'config': {'apiBaseUrl': self.base, 'serviceRealmId': self.realm,
                'privacyConsentGranted': True, 'storageNamespace': 'host_validation_' + self.args.host},
                'credentials': credentials}
            result['spaces'].append(space)
            summary['spaces'].append({'spaceId': space_id, 'identityVerified': verified, 'userType': profile.get('userType'),
                'membershipRole': role, 'friendCount': len(items(space['friends'])),
                'conversationCount': len(items(space['conversations'])),
                'officialProfilePresent': isinstance(space.get('officialAccount'), dict),
                'receptionStatus': space.get('receptionStatus')})
            self.checkpoint()
        print(json.dumps(summary, ensure_ascii=False), flush=True)

    def refresh_template(self, template_path):
        template = json.loads(Path(template_path).read_text())
        label = template['accountLabel']
        index = int(label.rsplit('-', 1)[1]) - 1
        if index not in range(4):
            raise ValueError('Template account is outside the four authorized identities')
        account = self.config['accounts'][index]
        key = sha256(account['loginName'].encode()).hexdigest()
        device = self.devices.setdefault(key, str(uuid.uuid4()))
        private_json(self.device_file, self.devices)
        login = self.request(label, 'POST', '/api/platform/v1/auth/login', payload={
            'identifier': account['loginName'], 'password': account['password'],
            'loginType': 'email' if '@' in account['loginName'] else 'auto',
            'issueRefreshToken': True, 'deviceId': device,
            'devicePlatform': self.args.device_platform,
            'deviceName': 'IM SDK ' + self.args.host + ' validation', 'appVersion': '0.1.0'})
        if not isinstance(login, dict) or not login.get('platformToken'):
            raise RuntimeError('Fresh host login failed; see sanitized request log')
        space_id = template['credentials']['spaceId']
        endpoint = '/api/platform/v1/auth/select-personal-space' if space_id == 'personal' else '/api/platform/v1/auth/select-tenant'
        selected = self.request(label, 'POST', endpoint, token=login['platformToken'],
            payload=None if space_id == 'personal' else {'tenantId': space_id})
        if not isinstance(selected, dict) or not selected.get('accessToken'):
            raise RuntimeError('Fresh host space selection failed; see sanitized request log')
        profile = self.request(label, 'GET', '/api/client/v1/profile/me', token=selected['accessToken'])
        if not isinstance(profile, dict):
            raise RuntimeError('Fresh host profile verification failed; see sanitized request log')
        token_parts = selected['accessToken'].split('.')
        claims = json.loads(base64.urlsafe_b64decode(token_parts[1] + '=' * (-len(token_parts[1]) % 4)))
        claim_user = claims.get('http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier')
        claim_platform = claims.get('platform_user_id')
        if not (profile.get('userId') == selected.get('userId') == claim_user and
                selected.get('platformUserId') == login.get('platformUserId') == claim_platform):
            raise RuntimeError('Server-issued identity responses and accepted token claims do not agree')
        expiry = datetime.fromtimestamp(int(claims['exp']), timezone.utc)
        credentials = {'platformUserId': claim_platform, 'userId': claim_user,
            'spaceId': space_id, 'accessToken': selected['accessToken'],
            'refreshToken': selected['refreshToken'],
            'expiresAt': expiry.isoformat().replace('+00:00', 'Z'),
            'platformToken': login['platformToken']}
        if login.get('platformRefreshToken'):
            credentials['platformRefreshToken'] = login['platformRefreshToken']
        configuration = dict(template.get('configuration') or template['config'])
        configuration['storageNamespace'] = 'host-validation-' + self.args.host
        configuration['apiBaseUrl'] = self.base
        template.update(config=configuration, configuration=configuration,
            credentials=credentials, deviceId=device,
            evidence={**template.get('evidence', {}), 'host': self.args.host,
                'serverAcceptedIdentityClaimsMatch': True, 'deviceIdIsHostSpecific': True})
        scenario = Path(template_path).stem.removeprefix('host-validation-')
        output = self.output / (self.args.host + '-' + scenario + '.json')
        private_json(output, template)
        self.raw['accounts'].append({'label': label, 'deviceId': device,
            'platform': login, 'spaces': [{'spaceId': space_id, 'selection': selected,
                'profile': profile, 'identityVerified': True}]})
        self.checkpoint()
        print(json.dumps({'host': self.args.host, 'scenario': scenario,
            'identityVerified': True, 'privateConfig': str(output),
            'scope': 'Fresh independent host ticket only; no message or service-state write'}, ensure_ascii=False), flush=True)

    def match_existing(self):
        identities = {}
        for account in self.raw['accounts']:
            for space in account['spaces']:
                if space['identityVerified']:
                    identities[(space['spaceId'], space['profile']['userId'])] = account['label']
        for account in self.raw['accounts']:
            for space in account['spaces']:
                for conversation in items(space.get('conversations')):
                    peer = conversation.get('peerUserId')
                    other = identities.get((space['spaceId'], peer))
                    if other and other != account['label'] and conversation.get('conversationType', 'direct') == 'direct':
                        self.summary['directPairs'].append({'from': account['label'], 'to': other,
                            'spaceId': space['spaceId'], 'conversationId': conversation.get('conversationId'), 'peerUserId': peer})
        self.checkpoint()
        print(json.dumps({'host': self.args.host, 'loginSucceeded': sum(x['loginSucceeded'] for x in self.summary['accounts']),
            'existingAuthorizedDirectPairs': len(self.summary['directPairs']),
            'serviceAccountCandidates': len(self.summary['serviceAccountCandidates']),
            'errorCount': len(self.summary['errors']), 'privateOutput': str(self.output / (self.args.host + '-discovery.json'))}, ensure_ascii=False), flush=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--accounts', required=True)
    parser.add_argument('--output-dir', required=True)
    parser.add_argument('--log', required=True)
    parser.add_argument('--base-url')
    parser.add_argument('--host', default='discovery')
    parser.add_argument('--device-platform', choices=('android', 'ios'), default='android')
    parser.add_argument('--timeout', type=int, default=10)
    parser.add_argument('--refresh-template', action='append', default=[], help='Private previously discovered direct/customer config; only issue fresh host tickets')
    args = parser.parse_args()
    if not re.fullmatch(r'[A-Za-z0-9_-]{1,40}', args.host):
        parser.error('--host must be a safe unique installation label')
    config = json.loads(Path(args.accounts).read_text())
    if len(config.get('accounts', [])) != 4:
        parser.error('This run is scoped to exactly the four supplied test accounts')
    discovery = Discovery(args, config)
    if args.refresh_template:
        for template in args.refresh_template:
            discovery.refresh_template(template)
    else:
        for index, account in enumerate(config['accounts']):
            discovery.discover_account(index, account)
        discovery.match_existing()


if __name__ == '__main__':
    main()
