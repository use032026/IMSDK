#!/usr/bin/env python3
"""Support one explicitly marked SDK host test using its supplied private peer.

Never starts a contact, changes reception settings or sends unrelated messages.
Only exact server-persisted test markers in the exact supplied conversation count.
"""
import argparse
from datetime import datetime, timezone
import json
import os
from pathlib import Path
import re
import sys
import time
import urllib.error
import urllib.parse
import urllib.request
import uuid


class TestStop(Exception):
    pass


def rows(value):
    if isinstance(value, list):
        return [x for x in value if isinstance(x, dict)]
    if isinstance(value, dict):
        for key in ('items', 'messages'):
            if isinstance(value.get(key), list):
                return rows(value[key])
    return []


def message_text(message):
    body = message.get('body')
    if isinstance(body, str):
        try:
            body = json.loads(body)
        except ValueError:
            return None
    return body.get('text') if isinstance(body, dict) else None


class Peer:
    def __init__(self, args):
        self.args = args
        self.deadline = time.monotonic() + min(args.timeout, 90)
        self.config = json.loads(Path(args.config).read_text())
        configuration = self.config.get('configuration') or self.config['config']
        self.base = configuration['apiBaseUrl'].rstrip('/')
        parsed = urllib.parse.urlparse(self.base)
        if parsed.scheme != 'https' or not parsed.netloc or parsed.username or parsed.password:
            raise TestStop('An HTTPS API origin without credentials is required')
        self.source = self.config['credentials']
        self.peer = self.config['peer']['credentials']
        if self.source['userId'] == self.peer['userId']:
            raise TestStop('The test requires two distinct supplied identities')
        self.conversation = args.conversation_id or (self.config.get('directTarget') or {}).get('conversationId')
        if not self.conversation or not re.fullmatch(r'[A-Za-z0-9_-]+', self.conversation):
            raise TestStop('An exact authorized conversation ID is required')
        self.thread = args.thread_id
        if args.mode == 'customer' and (not self.thread or not re.fullmatch(r'[A-Za-z0-9_-]+', self.thread)):
            raise TestStop('Customer mode requires the exact thread created in the host UI')
        if self.source['spaceId'] != self.peer['spaceId']:
            raise TestStop('The source and peer must be in the same authorized space')
        self.evidence = {'mode': args.mode, 'conversationId': self.conversation,
            'threadId': self.thread, 'outgoingMarker': args.outgoing_marker,
            'replyMarker': args.reply_marker, 'startedAt': datetime.now(timezone.utc).isoformat(),
            'events': [], 'sdkHostAccepted': False,
            'scope': 'Backend peer evidence only; host UI/SDK inbound evidence must be recorded separately'}
        self.secrets = []
        for credential in (self.source, self.peer):
            self.secrets.extend(str(v) for k, v in credential.items() if 'token' in k.lower() and v)
        self.log = Path(args.log).resolve()
        self.log.parent.mkdir(parents=True, exist_ok=True)
        self.output = Path(args.evidence).resolve()
        private_root = Path(__file__).resolve().parents[1] / '.work/runtime-private'
        if not self.output.is_relative_to(private_root):
            raise TestStop('Peer evidence must remain under .work/runtime-private')
        self.output.parent.mkdir(parents=True, exist_ok=True, mode=0o700)

    def persist(self):
        fd = os.open(self.output, os.O_CREAT | os.O_TRUNC | os.O_WRONLY, 0o600)
        os.fchmod(fd, 0o600)
        with os.fdopen(fd, 'w') as handle:
            json.dump(self.evidence, handle, ensure_ascii=False, indent=2)
            handle.write('\n')

    def record(self, event):
        self.evidence['events'].append(event)
        fd = os.open(self.log, os.O_CREAT | os.O_APPEND | os.O_WRONLY, 0o600)
        with os.fdopen(fd, 'a') as handle:
            handle.write(json.dumps(event, ensure_ascii=False) + '\n')
        self.persist()

    def request(self, method, endpoint, payload=None):
        headers = {'Authorization': 'Bearer ' + self.peer['accessToken'],
            'Content-Type': 'application/json', 'Accept': 'application/json',
            'User-Agent': 'IMSDK-authorized-test-peer/0.1'}
        req = urllib.request.Request(self.base + endpoint,
            data=json.dumps(payload).encode() if payload is not None else None,
            headers=headers, method=method)
        status, raw, error_type = None, b'', None
        try:
            remaining = self.deadline - time.monotonic()
            if remaining <= 0:
                raise TestStop('Bounded peer test window ended before the next operation')
            with urllib.request.urlopen(req, timeout=min(10, remaining)) as response:
                status, raw = response.status, response.read()
        except urllib.error.HTTPError as error:
            status, raw = error.code, error.read()
        except (urllib.error.URLError, TimeoutError, OSError) as error:
            error_type = type(error).__name__
        try:
            envelope = json.loads(raw) if raw else None
        except ValueError:
            envelope = None
        code = envelope.get('code') if isinstance(envelope, dict) else None
        request_id = envelope.get('requestId') if isinstance(envelope, dict) else None
        event = {'method': method, 'endpoint': endpoint, 'status': status,
            'code': code, 'requestId': request_id, 'errorType': error_type}
        self.record(event)
        if status is None:
            return None
        if not 200 <= status < 300 or code not in (None, 'OK'):
            raise TestStop('Server rejected the test operation; see sanitized status/code/requestId')
        return envelope.get('data') if isinstance(envelope, dict) and 'data' in envelope else envelope

    def detail(self):
        data = self.request('GET', f'/api/client/v1/customer-service/workbench/threads/direct-customer/{self.thread}?limit=100')
        if not isinstance(data, dict):
            raise TestStop('Customer thread detail is unavailable')
        thread = data.get('thread') if isinstance(data.get('thread'), dict) else data
        customer = thread.get('customerUserId')
        assigned = thread.get('assignedStaffUserId') or thread.get('staffUserId')
        conversation = thread.get('conversationId')
        actual_thread = thread.get('threadId')
        if customer != self.source['userId'] or conversation != self.conversation or actual_thread != self.thread:
            raise TestStop('Customer, conversation or thread does not match this exact host test')
        if assigned and assigned != self.peer['userId']:
            raise TestStop('Thread is assigned outside the supplied test peer; no claim or reply attempted')
        return data, thread, assigned

    def ensure_customer_claim(self):
        _, thread, assigned = self.detail()
        status = str(thread.get('threadStatus') or thread.get('status') or '').lower()
        if assigned == self.peer['userId'] and status == 'active':
            return
        self.request('POST', f'/api/client/v1/customer-service/workbench/threads/direct-customer/{self.thread}/claim')
        _, _, assigned = self.detail()
        if assigned != self.peer['userId']:
            raise TestStop('Manual claim did not assign the supplied test peer')
        self.record({'stage': 'manualClaimVerified', 'threadId': self.thread,
            'scope': 'Only the current test thread; reception settings unchanged'})

    def load_messages(self):
        if self.args.mode == 'customer':
            data, _, assigned = self.detail()
            if assigned != self.peer['userId']:
                raise TestStop('Customer test is no longer assigned to the supplied peer')
            return rows(data.get('messages'))
        data = self.request('GET', f'/api/client/v1/direct-chats/{self.conversation}/messages?limit=100')
        return rows(data)

    def find(self, messages, marker, sender):
        for message in messages:
            actual_sender = message.get('senderUserId')
            matches_sender = actual_sender == sender
            if self.args.mode == 'customer' and sender == self.peer['userId']:
                brand = (self.config.get('customerServiceTarget') or {}).get('serviceAccountId')
                matches_sender = matches_sender or (message.get('operatorUserId') == sender and actual_sender == brand)
            if message_text(message) != marker or not matches_sender:
                continue
            if message.get('conversationId') not in (None, self.conversation):
                continue
            if not message.get('messageId') or int(message.get('conversationSeq') or 0) <= 0:
                continue
            return {'messageId': message['messageId'], 'conversationSeq': message['conversationSeq'],
                'clientMsgId': message.get('clientMsgId')}
        return None

    def run(self):
        if self.args.mode == 'customer':
            self.ensure_customer_claim()
        deadline = self.deadline
        outgoing = None
        messages = []
        while time.monotonic() < deadline:
            started = time.monotonic()
            messages = self.load_messages()
            outgoing = self.find(messages, self.args.outgoing_marker, self.source['userId'])
            if outgoing:
                break
            time.sleep(min(max(0, self.deadline - time.monotonic()), max(0, 1 - (time.monotonic() - started))))
        if outgoing is None:
            raise TestStop('Exact outgoing marker was not server-persisted within the bounded test window')
        self.record({'stage': 'outgoingPersisted', 'marker': self.args.outgoing_marker, **outgoing})
        reply = self.find(messages, self.args.reply_marker, self.peer['userId'])
        if not reply:
            client_id = str(uuid.uuid5(uuid.NAMESPACE_URL, self.base + '/' + self.conversation + '/' + self.args.reply_marker))
            body = {'clientMsgId': client_id, 'messageType': 'text', 'body': {'text': self.args.reply_marker}}
            endpoint = (f'/api/client/v1/customer-service/workbench/threads/direct-customer/{self.thread}/messages'
                        if self.args.mode == 'customer' else f'/api/client/v1/direct-chats/{self.conversation}/messages')
            if self.args.mode == 'direct': body['mentions'] = []
            accepted = self.request('POST', endpoint, body)
            if not isinstance(accepted, dict):
                raise TestStop('Reply response did not include a message acknowledgement')
            ack = accepted.get('message') if isinstance(accepted.get('message'), dict) else accepted
            self.record({'stage': 'replyAccepted', 'marker': self.args.reply_marker,
                'messageId': ack.get('messageId'), 'conversationSeq': ack.get('conversationSeq'), 'clientMsgId': client_id})
            reply = self.find(self.load_messages(), self.args.reply_marker, self.peer['userId'])
            if not reply:
                raise TestStop('Reply acknowledgement was not confirmed by persisted history')
        self.record({'stage': 'replyPersisted', 'marker': self.args.reply_marker, **reply})
        self.evidence['backendRoundTripVerified'] = True
        self.persist()
        print(json.dumps({'backendRoundTripVerified': True, 'conversationId': self.conversation,
            'outgoing': outgoing, 'reply': reply, 'evidence': str(self.output),
            'scope': 'Host must separately prove SDK inbound/UI display'}, ensure_ascii=False))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--config', required=True)
    parser.add_argument('--outgoing-marker', required=True)
    parser.add_argument('--reply-marker', required=True)
    parser.add_argument('--log', required=True)
    parser.add_argument('--evidence', required=True)
    parser.add_argument('--mode', choices=('direct', 'customer'), default='direct')
    parser.add_argument('--thread-id')
    parser.add_argument('--conversation-id')
    parser.add_argument('--timeout', type=int, default=90)
    args = parser.parse_args()
    if not 1 <= args.timeout <= 90:
        parser.error('--timeout must be between 1 and 90 seconds')
    for value in (args.outgoing_marker, args.reply_marker):
        if not value or len(value) > 240:
            parser.error('Exact nonempty test markers of at most 240 characters are required')
    peer = None
    try:
        peer = Peer(args)
        peer.run()
    except TestStop as error:
        result = {'backendRoundTripVerified': False, 'reason': str(error)}
        if peer:
            peer.record({'stage': 'stopped', 'reason': str(error)})
            peer.evidence['backendRoundTripVerified'] = False
            peer.persist()
        print(json.dumps(result, ensure_ascii=False))
        sys.exit(1)


if __name__ == '__main__':
    main()
