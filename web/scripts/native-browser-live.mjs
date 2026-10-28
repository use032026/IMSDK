import { createServer } from 'node:http';
import { readFile, mkdir, writeFile } from 'node:fs/promises';
import { resolve } from 'node:path';
import { createHash, randomUUID, randomBytes } from 'node:crypto';

// Drive the SDK's real DOM handlers in a normal browser window, without remote
// automation permissions. The one-use loopback page is not a deployed product.
const args = process.argv.slice(2);
const option = key => { const index = args.indexOf(key); return index < 0 ? undefined : args[index + 1]; };
const fixtureFile = option('--fixture'), directFile = option('--direct'), groupFile = option('--group');
if (!fixtureFile || !directFile || !groupFile) throw new Error('Private fixture/direct/group files required');
const fixture = JSON.parse(await readFile(resolve(fixtureFile), 'utf8'));
const direct = JSON.parse(await readFile(resolve(directFile), 'utf8'));
const group = JSON.parse(await readFile(resolve(groupFile), 'utf8'));
const label = option('--label') ?? 'safari';
if (!/^[a-zA-Z0-9_-]{1,32}$/.test(label)) throw new Error('Invalid label');
const runId = new Date().toISOString().replace(/[^0-9]/g, '').slice(0,14) + '-' + label;
const evidence = resolve(option('--evidence') ?? `../logs/web-compat-20261027/${label}`);
await mkdir(evidence,{recursive:true});
const bundle = await readFile(resolve(option('--bundle') ?? '../dist/web/im-sdk.js'));
const api = fixture.configuration.apiBaseUrl.replace(/\/+$/,'');
const source = fixture.source, peer = fixture.peer;
const prefix = '/' + randomBytes(18).toString('hex');
let origin, peerToken, approved = false, booted = false, completed = false, closing = false;
let directState, groupState;
const report = { runId, label, nativeBrowserWindow: true, realBackend: true, mockedResponses: false, securityBypass: false,
  bundleSha256: createHash('sha256').update(bundle).digest('hex'), startedAt:new Date().toISOString(), passed:false,
  stages:[], requests:[], browserEvents:[], errors:[], scope:{existingDirectOnly:true,exactTwoMemberGroupOnly:true,newGroups:false,membersOrPermissionsChanged:false} };
class Stop extends Error { constructor(code){super(code);this.code=code;} }
function ensure(value,code){if(!value)throw new Stop(code);}
async function save(){await writeFile(resolve(evidence,'report.json'),JSON.stringify(report,null,2));}
async function stage(name,detail={}){const event={stage:name,at:new Date().toISOString(),...detail};report.stages.push(event);console.log(JSON.stringify(event));await save();}
const rows = value => Array.isArray(value)?value:value?.items??[];
function text(message){try{return(typeof message.body==='string'?JSON.parse(message.body):message.body)?.text;}catch{return undefined;}}
function claims(token){try{return JSON.parse(Buffer.from(token.split('.')[1],'base64url').toString());}catch{return{};}}
async function request(path,{token,method='GET',body}={}){
  let response;
  try{response=await fetch(api+path,{method,headers:{Accept:'application/json',...(token?{Authorization:`Bearer ${token}`} : {}),...(body===undefined?{}:{'Content-Type':'application/json'})},body:body===undefined?undefined:JSON.stringify(body),signal:AbortSignal.timeout(20000),redirect:'error'});}catch{throw new Stop('PEER_TRANSPORT_'+method);}
  let envelope;try{envelope=await response.json();}catch{throw new Stop('PEER_INVALID_JSON');}
  report.requests.push({path:path.split('?')[0],method,status:response.status});
  ensure(response.ok&&envelope.code==='OK','PEER_HTTP_'+response.status);
  return envelope.data;
}
async function verifyScope(){
  ensure(direct.sourceUserId===source.userId&&direct.peerUserId===peer.userId&&group.sourceUserId===source.userId&&group.peerUserId===peer.userId&&group.parentApproved===true&&source.userId!==peer.userId,'PRIVATE_SCOPE_MISMATCH');
  let cursor,match;
  for(let count=0;count<6;count++){
    const page=await request('/api/client/v1/conversations?'+new URLSearchParams({limit:'100',...(cursor?{cursor}:{})}),{token:peerToken});
    match=rows(page).find(item=>item.conversationId===direct.conversationId&&item.conversationType==='direct'&&item.peerUserId===source.userId);
    if(match||!page.nextCursor)break;cursor=page.nextCursor;
  }
  ensure(match,'DIRECT_PAIR_NOT_VERIFIED');
  const detail=await request('/api/client/v1/groups/'+encodeURIComponent(group.groupId),{token:peerToken});
  const members=rows(await request('/api/client/v1/groups/'+encodeURIComponent(group.groupId)+'/members',{token:peerToken}));
  const ids=members.map(item=>item.userId||item.memberUserId||item.targetUserId||item.id||item.user?.userId||item.user?.id);
  ensure(detail.ownerUserId===source.userId&&ids.length===2&&new Set(ids).size===2&&ids.includes(source.userId)&&ids.includes(peer.userId),'EXACT_TWO_GROUP_MEMBERS_NOT_VERIFIED');
  approved=true;
}
async function prepare(){
  const platform=await request('/api/platform/v1/auth/login',{method:'POST',body:{identifier:peer.account,password:peer.password,loginType:'lpp_id'}});
  ensure(platform.platformUserId===peer.platformUserId&&platform.platformToken,'PEER_PLATFORM_MISMATCH');
  const selected=await request('/api/platform/v1/auth/select-personal-space',{method:'POST',token:platform.platformToken});
  const profile=await request('/api/client/v1/profile/me',{token:selected.accessToken});
  const accepted=claims(selected.accessToken);
  ensure(profile.userId===peer.userId&&selected.userId===peer.userId&&selected.platformUserId===peer.platformUserId&&String(accepted.space_type)==='1'&&accepted.platform_user_id===peer.platformUserId,'PEER_IDENTITY_MISMATCH');
  peerToken=selected.accessToken;
  await verifyScope();
  await stage('peerAndExistingScopeVerified',{exactDirectPair:true,exactTwoGroupMembers:true});
}
async function roundTrip(kind){
  ensure(approved,'SCOPE_NOT_PREPARED');
  const id=kind==='direct'?direct.conversationId:group.groupId;
  const endpoint='/api/client/v1/'+(kind==='direct'?'direct-chats':'groups')+'/'+encodeURIComponent(id)+'/messages';
  const marker=`WEB-${label.toUpperCase()}-${kind.toUpperCase()}-${runId}`;
  const reply=`WEB-${label.toUpperCase()}-${kind.toUpperCase()}-REPLY-${runId}`;
  let outgoing;
  for(let count=0;count<12;count++){
    const matches=rows(await request(endpoint+'?limit=100',{token:peerToken})).filter(item=>item.senderUserId===source.userId&&text(item)===marker&&item.messageId&&Number(item.conversationSeq)>0);
    ensure(matches.length<=1,'SOURCE_MESSAGE_DUPLICATED');
    if(matches[0]){outgoing=matches[0];break;}
    await new Promise(resolve=>setTimeout(resolve,1000));
  }
  ensure(outgoing,'SOURCE_MESSAGE_NOT_PERSISTED');
  await stage(kind+'SourcePersisted',{messageId:outgoing.messageId,seq:outgoing.conversationSeq,exactSender:true,exactCount:1});
  if(kind==='group')await verifyScope();
  await request(endpoint,{token:peerToken,method:'POST',body:{clientMsgId:randomUUID(),messageType:'text',body:{text:reply},replyToMessageId:outgoing.messageId,mentions:[]}});
  const replies=rows(await request(endpoint+'?limit=100',{token:peerToken})).filter(item=>item.senderUserId===peer.userId&&text(item)===reply&&Number(item.conversationSeq)>Number(outgoing.conversationSeq));
  ensure(replies.length===1,'PEER_REPLY_NOT_PERSISTED');
  const state={sourceText:marker,sourceMessageId:outgoing.messageId,sourceSeq:outgoing.conversationSeq,replyText:reply,replyMessageId:replies[0].messageId,replySeq:replies[0].conversationSeq,peerReadback:true};
  report[kind]=state;
  await save();return state;
}

const page = `<!doctype html><html lang="zh-CN"><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover"><title>IM SDK Safari / 微信真实联调</title><style>html,body{margin:0;height:100%;font:14px -apple-system,sans-serif;background:#eff3fa}#status{padding:8px 15px;color:#42516b}#chat{height:calc(100vh - 44px);height:calc(100dvh - 44px);max-width:560px;margin:auto}#next{position:fixed;right:12px;top:5px;z-index:5;padding:6px 12px}</style><div id="status">正在准备真实服务验证…</div><button id="next" hidden>继续群聊验证</button><div id="chat"></div><script src="${prefix}/im-sdk.js"></script><script>
(async function(){
  var root=${JSON.stringify(prefix)}, info=document.getElementById('status');
  async function post(path,body){var r=await fetch(root+path,{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify(body||{})});var data=await r.json();if(!r.ok)throw new Error(data.code||'HARNESS_REQUEST_FAILED');return data;}
  async function until(test,code){var deadline=Date.now()+30000;while(Date.now()<deadline){if(await test())return;await new Promise(r=>setTimeout(r,120));}throw new Error(code);}
  function shadow(){return document.querySelector('#chat>div').shadowRoot;}
  function check(condition,code){if(!condition)throw new Error(code);}
  window.nativeLiveEvents=[];var seed;
  try{
    seed=await post('/bootstrap',{ua:navigator.userAgent,platform:navigator.platform,secureContext:window.isSecureContext,requestSubmit:typeof HTMLFormElement.prototype.requestSubmit==='function',visualViewport:!!window.visualViewport});
    window.nativeLiveClient=new IMSDK.ImSdkClient();
    nativeLiveClient.on(function(e){nativeLiveEvents.push({type:e.type,state:e.state,code:e.code,conversationId:e.conversationId});});
    nativeLiveClient.initialize(seed.config);
    window.nativeLiveView=IMSDK.mountMessenger(nativeLiveClient,document.getElementById('chat'));
    var form=shadow().querySelector('form'),account=form.querySelector('input[type=text]'),password=form.querySelector('input[type=password]');
    account.value=seed.account;password.value=seed.password;seed.password='';seed.account='';form.querySelector('button[type=submit]').click();
    await until(()=>nativeLiveClient.isAuthenticated||nativeLiveEvents.some(e=>e.type==='authenticationFailed'),'LOGIN_TIMED_OUT');
    check(nativeLiveClient.isAuthenticated,'LOGIN_'+((nativeLiveEvents.filter(e=>e.type==='authenticationFailed').pop()||{}).code||'FAILED'));
    var user=nativeLiveClient.currentUser;check(user.userId===seed.expected.userId&&user.platformUserId===seed.expected.platformUserId&&user.spaceId==='personal','SOURCE_IDENTITY_MISMATCH');
    await post('/stage',{stage:'nativeBrowserPasswordLoginVerified'});
    await until(()=>nativeLiveEvents.some(e=>e.type==='connectionChanged'&&e.state==='connected'),'REAL_GATEWAY_NOT_CONNECTED');
    await post('/stage',{stage:'realSignalRConnected'});
    async function run(kind){
      var target=seed[kind],marker=target.marker;
      await nativeLiveView.openConversation(target);
      var input=shadow().querySelector('textarea');check(!!input,'COMPOSER_MISSING');input.value=marker;input.dispatchEvent(new Event('input',{bubbles:true}));
      shadow().querySelector('form.composer button[type=submit]').click();
      await until(()=>!input.value,'SEND_NOT_ACCEPTED');
      var eventStart=nativeLiveEvents.length;
      var result=await post('/peer-'+kind);
      await until(()=>Array.from(shadow().querySelectorAll('.bubble')).some(e=>e.textContent===result.replyText),'PEER_REPLY_NOT_VISIBLE');
      var notified=nativeLiveEvents.slice(eventStart).some(e=>e.type==='messagesChanged'&&(!e.conversationId||e.conversationId===target.conversationId));
      check(notified,'NO_REAL_MESSAGE_NOTIFICATION');
      await post('/stage',{stage:kind+'BrowserReplyVisible',conversationId:target.conversationId,replyMessageId:result.replyMessageId,replySeq:result.replySeq,realNotificationForConversation:notified});
      info.textContent=(kind==='direct'?'Safari/微信 单聊':'Safari/微信 群聊')+'：真实双向收发通过';
    }
    await run('direct');
    var next=document.getElementById('next');next.hidden=false;
    await new Promise(resolve=>{next.onclick=resolve;});next.hidden=true;
    await run('group');
    await post('/complete',{events:nativeLiveEvents});
    info.textContent='登录、单聊、群聊：真实服务验证全部通过';
    document.title='PASS · IM SDK '+${JSON.stringify(label)};
  }catch(e){
    var code=/^[A-Z0-9_]{1,100}$/.test(e.message||'')?e.message:'BROWSER_HARNESS_ERROR';
    info.textContent='验证停止：'+code;document.title='FAIL · IM SDK';
    await post('/failure',{code:code,events:nativeLiveEvents}).catch(()=>{});
  }
})();</script></html>`;
async function bodyOf(req){let value='';for await(const part of req){value+=part;if(value.length>20000)throw new Stop('REQUEST_TOO_LARGE');}return value?JSON.parse(value):{};}
const server=createServer(async(req,res)=>{
  res.setHeader('Cache-Control','no-store');res.setHeader('Referrer-Policy','no-referrer');
  try{
    ensure(['127.0.0.1','::1','::ffff:127.0.0.1'].includes(req.socket.remoteAddress),'LOOPBACK_ONLY');
    const path=new URL(req.url,'http://localhost').pathname;
    if(req.method==='GET'&&path===prefix+'/'){res.setHeader('Content-Type','text/html; charset=utf-8');res.end(page);return;}
    if(req.method==='GET'&&path===prefix+'/im-sdk.js'){res.setHeader('Content-Type','application/javascript');res.end(bundle);return;}
    if(req.method==='GET'){res.writeHead(404).end();return;}
    ensure(req.method==='POST'&&path.startsWith(prefix+'/')&&req.headers.origin===origin,'INVALID_HARNESS_REQUEST');
    const data=await bodyOf(req);let output={ok:true};
    if(path===prefix+'/bootstrap'){
      ensure(!booted,'BOOTSTRAP_ALREADY_USED');booted=true;
      report.browser={userAgent:String(data.ua||''),platform:String(data.platform||''),secureContext:!!data.secureContext,requestSubmit:!!data.requestSubmit,visualViewport:!!data.visualViewport};
      await prepare();await stage('nativeBrowserOpened',report.browser);
      output={config:{apiBaseUrl:api,serviceRealmId:fixture.configuration.serviceRealmId,privacyConsentGranted:true,passwordLogin:{space:'personal',loginType:'lpp_id'},pollIntervalMs:300000},
        account:source.account,password:source.password,expected:{userId:source.userId,platformUserId:source.platformUserId},
        direct:{conversationId:direct.conversationId,type:'direct',marker:`WEB-${label.toUpperCase()}-DIRECT-${runId}`},group:{conversationId:group.groupId,type:'group',marker:`WEB-${label.toUpperCase()}-GROUP-${runId}`}};
    }else if(path===prefix+'/peer-direct'){ensure(!directState,'DIRECT_REPLY_ALREADY_SENT');directState=roundTrip('direct');output=await directState;}
    else if(path===prefix+'/peer-group'){ensure(report.direct?.browserVisible===true&&!groupState,'GROUP_SEQUENCE_INVALID');groupState=roundTrip('group');output=await groupState;}
    else if(path===prefix+'/stage'){
      ensure(['nativeBrowserPasswordLoginVerified','realSignalRConnected','directBrowserReplyVisible','groupBrowserReplyVisible'].includes(data.stage),'UNEXPECTED_STAGE');
      if(data.stage==='directBrowserReplyVisible')report.direct.browserVisible=true;
      if(data.stage==='groupBrowserReplyVisible')report.group.browserVisible=true;
      await stage(data.stage,{...(data.replySeq?{replySeq:data.replySeq}:{}),...(data.realNotificationForConversation?{realNotificationForConversation:true}:{})});
    }else if(path===prefix+'/complete'){
      ensure(report.direct?.browserVisible&&report.group?.browserVisible,'MISSING_ROUNDTRIP_EVIDENCE');
      report.browserEvents=data.events;report.passed=true;completed=true;report.finishedAt=new Date().toISOString();await stage('allNativeBrowserChecksPassed');
    }else if(path===prefix+'/failure'){
      report.errors.push(/^[A-Z0-9_]{1,100}$/.test(data.code||'')?data.code:'BROWSER_FAILURE');report.browserEvents=data.events;completed=true;await stage('validationFailed',{code:report.errors.at(-1)});
    }else throw new Stop('UNKNOWN_HARNESS_PATH');
    res.setHeader('Content-Type','application/json');res.end(JSON.stringify(output));
  }catch(error){const code=error instanceof Stop?error.code:'HARNESS_ERROR';report.errors.push(code);await save();res.writeHead(400,{'Content-Type':'application/json'}).end(JSON.stringify({code}));console.log(JSON.stringify({stage:'requestStopped',code}));}
});
await new Promise(resolve=>server.listen(0,'127.0.0.1',resolve));origin=`http://127.0.0.1:${server.address().port}`;report.origin=origin;
await save();console.log(JSON.stringify({stage:'ready',url:origin+prefix+'/',report:resolve(evidence,'report.json')}));
const deadline=setTimeout(()=>{if(!completed){report.errors.push('NATIVE_BROWSER_DEADLINE');void save();}void shutdown();},15*60*1000);
async function shutdown(){if(closing)return;closing=true;clearTimeout(deadline);peerToken=undefined;await save();server.close(()=>process.exit(report.passed?0:1));}
process.on('SIGINT',()=>void shutdown());process.on('SIGTERM',()=>void shutdown());
