import type { ImSdkClient } from './client.js';
import { createClientMessageId } from './protocol.js';
import { formatTimestamp, hasUiString, resolvedLocale, translateUi } from './presentation.js';
import { ImSdkError } from './types.js';
import type {
  Contact,
  Conversation,
  ConversationTarget,
  CustomerServiceRequest,
  CustomerServiceSession,
  Message,
  RegistrationChannel,
  RegistrationVerificationSettings,
  UserSearchResult,
  FriendRequest,
  ImSdkEvent,
} from './types.js';

export interface ImSdkMessenger {
  openConversation(target: ConversationTarget): Promise<void>;
  openCustomerService(request: CustomerServiceRequest): Promise<CustomerServiceSession>;
  close(): void;
}

const styles = `
:host{--text:#202536;--button:#edf1f7;--focus:#9dbbff;--input-border:#d9deea;--surface:#fff;--background:#f5f7fb;--border:#e2e7f0;--muted:#788296;--accent:#3569e8;--danger:#ac3344;--notice-bg:#fff1ed;--notice-text:#a23c25;--hover:#eef2fa;--avatar-bg:#e2eaff;--avatar-text:#3d66c2;--badge:#e25067;--on-accent:#fff;display:block;width:100%;height:100%;min-height:420px;color:var(--text);font:15px/1.5 -apple-system,BlinkMacSystemFont,"Segoe UI",sans-serif;color-scheme:light}
*{box-sizing:border-box}button,input,textarea,select{font:inherit}button{cursor:pointer;border:0;border-radius:10px;background:var(--button);color:var(--text);padding:9px 13px;min-height:40px}button:hover{filter:brightness(.97)}button:disabled{cursor:default;opacity:.5}button:focus-visible,input:focus-visible,textarea:focus-visible{outline:3px solid var(--focus);outline-offset:2px}input,textarea,select{border:1px solid var(--input-border);border-radius:10px;background:var(--surface);color:var(--text);padding:11px;width:100%;min-width:0}textarea{resize:none;min-height:46px;max-height:130px}.shell{height:100%;min-height:420px;max-height:100dvh;display:flex;flex-direction:column;overflow:hidden;background:var(--background);border:1px solid var(--border);border-radius:18px}.header{display:flex;align-items:center;gap:9px;padding:13px 14px;background:var(--surface);border-bottom:1px solid var(--border);flex:none}.heading{flex:1;min-width:0}.title{font-size:17px;font-weight:650;overflow:hidden;white-space:nowrap;text-overflow:ellipsis}.status{font-size:12px;color:var(--muted)}.icon{padding:7px 11px}.primary{background:var(--accent);color:var(--on-accent)}.danger{color:var(--danger)}.body{flex:1;min-height:0;overflow:auto;overscroll-behavior:contain}.notice{padding:9px 16px;font-size:13px;background:var(--notice-bg);color:var(--notice-text);flex:none;overflow-wrap:anywhere}.notice:empty{display:none}.card{max-width:360px;margin:40px auto;padding:20px}.card h2{font-size:23px;margin:0 0 8px}.muted{color:var(--muted);font-size:13px}.field{display:block;margin:18px 0 0;font-size:13px}.field span{display:block;margin-bottom:6px}.wide{width:100%;margin-top:22px}.captcha{display:flex;gap:8px;align-items:center;margin-top:16px}.captcha input{flex:1}.captcha-question{font-size:14px;margin:10px 0 0;white-space:pre-wrap;overflow-wrap:anywhere}.empty{text-align:center;padding:54px 20px;color:var(--muted)}.list{padding:5px 0}.row{width:100%;display:flex;gap:12px;text-align:start;border-radius:0;background:transparent;padding:15px 17px;align-items:center;border-bottom:1px solid var(--border)}.row:hover{background:var(--hover)}.avatar{flex:none;width:44px;height:44px;display:grid;place-items:center;border-radius:15px;background:var(--avatar-bg);color:var(--avatar-text);font-size:19px;font-weight:600}.row-main{flex:1;min-width:0}.row-top{display:flex;gap:8px;align-items:center}.row-title{font-weight:600;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;flex:1}.preview{font-size:13px;color:var(--muted);overflow:hidden;white-space:nowrap;text-overflow:ellipsis;margin-top:3px}.badge{background:var(--badge);color:var(--on-accent);border-radius:12px;font-size:11px;min-width:20px;padding:1px 5px;text-align:center}.row-time{font-size:11px;color:var(--muted)}.toolbar{padding:9px 14px;display:flex;flex-wrap:wrap;gap:8px;align-items:center;background:var(--surface);border-top:1px solid var(--border);flex:none}.toolbar .spacer{flex:1}.timeline{padding:12px 15px;display:flex;flex-direction:column;gap:15px;min-height:100%}.message{display:flex;flex-direction:column;align-items:flex-start;max-width:86%;align-self:flex-start}.message.self{align-self:flex-end;align-items:flex-end}.meta{font-size:11px;color:var(--muted);margin:0 3px 4px;overflow-wrap:anywhere}.bubble{padding:10px 13px;border-radius:13px 13px 13px 3px;background:var(--surface);border:1px solid var(--border);white-space:pre-wrap;overflow-wrap:anywhere;max-width:100%;user-select:text}.self .bubble{background:var(--accent);color:var(--on-accent);border-color:var(--accent);border-radius:13px 13px 3px 13px}.unsupported{font-style:italic}.history{align-self:center;font-size:12px;min-height:32px;padding:4px 10px}.composer{display:flex;gap:9px;align-items:flex-end;padding:11px 13px calc(11px + env(safe-area-inset-bottom));background:var(--surface);border-top:1px solid var(--border);flex:none}.composer textarea{flex:1}.composer button{flex:none}.new-chat{padding:20px}.new-chat p{font-size:13px;color:var(--muted)}.service{padding:35px 22px;max-width:420px;margin:auto;text-align:center}.service h2{font-size:21px}.service p{color:var(--muted)}.loader{padding:30px;text-align:center;color:var(--muted)}.list-more{display:block;margin:16px auto}.footer-note{font-size:11px;line-height:1.5;color:var(--muted);margin-top:18px}.sr{position:absolute;width:1px;height:1px;padding:0;margin:-1px;overflow:hidden;clip:rect(0,0,0,0);border:0}
@media(max-width:480px){.shell{border-radius:0;border:0}.card{margin:24px auto}.header{padding-top:calc(11px + env(safe-area-inset-top))}.title{font-size:16px}.message{max-width:90%}}
:host([data-theme="dark"]){color-scheme:dark;--text:#eef3fb;--button:#253246;--focus:#80a9ff;--input-border:#43516a;--surface:#182231;--background:#101722;--border:#2e3a4f;--muted:#abbbd0;--accent:#4d7fff;--danger:#ff9aaa;--notice-bg:#402622;--notice-text:#ffbcab;--hover:#202e43;--avatar-bg:#243d6a;--avatar-text:#b8d0ff;--badge:#cc3c59;--on-accent:#fff;}
@media(prefers-color-scheme:dark){:host([data-theme="system"]){color-scheme:dark;--text:#eef3fb;--button:#253246;--focus:#80a9ff;--input-border:#43516a;--surface:#182231;--background:#101722;--border:#2e3a4f;--muted:#abbbd0;--accent:#4d7fff;--danger:#ff9aaa;--notice-bg:#402622;--notice-text:#ffbcab;--hover:#202e43;--avatar-bg:#243d6a;--avatar-text:#b8d0ff;--badge:#cc3c59;--on-accent:#fff;}}
`;

/** Mounts an isolated chat view. Closing removes only nodes owned by this mount. */
export function mountMessenger(client: ImSdkClient, container: HTMLElement): ImSdkMessenger {
  if (!(container instanceof HTMLElement)) throw new TypeError('需要有效的聊天容器');
  let handleEvent: (event: ImSdkEvent) => void = () => {};
  // Subscribe before inserting DOM so an already released client cannot leave
  // a partially mounted page behind.
  const unsubscribe = client.on(event => handleEvent(event));
  type UiText = string | { raw: string } | (() => string);
  const bindings = new Map<Node, Map<string, () => string>>();
  const locale = () => resolvedLocale(client.config?.locale);
  const raw = (value: string): UiText => ({ raw: value });
  const t = (source: string, values: Record<string, string | number> = {}) => translateUi(source, locale(), values);
  const contactName = (contact: Contact): string => contact.displayNameIsDefault ? t(contact.displayNameIsDefault === 'contact' ? '联系人' : '用户') : contact.displayName;
  function binding(value: UiText): () => string {
    return typeof value === 'function' ? value : typeof value === 'object' ? () => value.raw : () => t(value);
  }
  function remember(target: Node, attribute: string, value: UiText): void {
    if (typeof value !== 'function' && (typeof value !== 'string' || !hasUiString(value))) return;
    const entry = bindings.get(target) ?? new Map<string, () => string>();
    entry.set(attribute, binding(value)); bindings.set(target, entry);
  }
  function setText(element: HTMLElement, value: UiText): void {
    const text = document.createTextNode(binding(value)());
    element.replaceChildren(text);
    remember(text, 'data', value);
  }
  function setAttr(element: HTMLElement, attribute: string, value: UiText): void {
    bindings.get(element)?.delete(attribute);
    element.setAttribute(attribute, binding(value)());
    remember(element, attribute, value);
  }
  function node<K extends keyof HTMLElementTagNameMap>(tag: K, className = '', text?: UiText): HTMLElementTagNameMap[K] {
    const element = document.createElement(tag);
    if (className) element.className = className;
    if (text !== undefined) setText(element, text);
    if (tag === 'form') element.addEventListener('invalid', event => {
      // Browser validation bubbles use the browser UI language, so expose the
      // same constraint through the SDK's current language instead.
      event.preventDefault();
      const validity = (event.target as HTMLInputElement).validity;
      setText(notice, validity.valueMissing ? '请填写必填项' : validity.tooShort ? '密码至少6位' : '输入内容格式不正确');
    }, true);
    return element;
  }
  function button(text: UiText, action: () => unknown, className = ''): HTMLButtonElement {
    const element = node('button', className, text); element.type = 'button';
    element.addEventListener('click', () => { try { void Promise.resolve(action()).catch(() => {}); } catch { /* Owned by the action. */ } });
    return element;
  }
  function input(type: string, placeholder: UiText, autocomplete: string): HTMLInputElement {
    const element = node('input'); element.type = type;
    setAttr(element, 'placeholder', placeholder); setAttr(element, 'aria-label', placeholder);
    element.setAttribute('autocomplete', autocomplete); return element;
  }
  function field(label: UiText, element: HTMLElement): HTMLLabelElement {
    const wrapper = node('label', 'field'); wrapper.append(node('span', '', label), element); return wrapper;
  }
  function applyPresentation(): void {
    host.dataset.theme = client.config?.themeMode ?? 'system';
    host.lang = locale();
    host.dir = host.lang === 'ar' ? 'rtl' : 'ltr';
    const scroll = body.scrollTop;
    for (const [target, attributes] of bindings) {
      if (!shadow.contains(target)) { bindings.delete(target); continue; }
      for (const [attribute, read] of attributes) {
        if (target instanceof Text) target.data = read();
        else (target as HTMLElement).setAttribute(attribute, read());
      }
    }
    body.scrollTop = scroll;
  }

  const host = document.createElement('div');
  host.style.cssText = 'height:100%;width:100%;min-height:420px';
  const shadow = host.attachShadow({ mode: 'open' });
  const style = document.createElement('style');
  style.textContent = styles;
  const shell = node('section', 'shell');
  setAttr(shell, 'aria-label', 'IM 聊天');
  const header = node('header', 'header');
  const heading = node('div', 'heading');
  const title = node('div', 'title', '消息');
  const status = node('div', 'status', '');
  heading.append(title, status);
  const back = button('返回', () => showList(), 'icon');
  const refresh = button('刷新', () => refreshCurrent(), 'icon');
  const logoutButton = button('退出登录', async () => {
    if (closed) return;
    logoutButton.disabled = true;
    try { await client.logout(); }
    catch (error) { failure(error); }
    finally { if (!closed) logoutButton.disabled = false; }
  }, 'icon');
  const closeButton = button('关闭', () => close(), 'icon');
  header.append(back, heading, refresh, logoutButton, closeButton);
  const notice = node('div', 'notice');
  notice.setAttribute('role', 'alert');
  const body = node('main', 'body');
  const bottom = node('div');
  shell.append(header, notice, body, bottom);
  shadow.append(style, shell);
  container.append(host);
  const removedBindings = new MutationObserver(() => {
    for (const target of bindings.keys()) if (!shadow.contains(target)) bindings.delete(target);
  });
  removedBindings.observe(shadow, { childList: true, subtree: true });
  applyPresentation();

  let closed = false;
  let revision = 0;
  let messageRevision = 0;
  let page: 'host' | 'login' | 'register' | 'list' | 'chat' | 'new' | 'add-friend' | 'requests' | 'group' | 'service' = 'login';
  let target: ConversationTarget | undefined;
  let serviceRequest: CustomerServiceRequest | undefined;
  let currentMessages: Message[] = [];
  let conversations: Conversation[] = [];
  let nextCursor: string | undefined;
  let listBusy = false;
  let chatBusy = false;
  let historyBusy = false;
  let hasHistory = true;
  let sending = false;
  let composer: HTMLTextAreaElement | undefined;
  let historyButton: HTMLButtonElement | undefined;
  let timeline: HTMLElement | undefined;
  let lastRead = 0;
  let refreshTimer: number | undefined;

  function valid(ownRevision: number, session: number): boolean {
    return !closed && revision === ownRevision && client.sessionRevision === session;
  }
  function failure(error: unknown): void {
    if (closed) return;
    if (!client.isInitialized) { serviceUnavailable(); return; }
    setText(notice, error instanceof ImSdkError && hasUiString(error.message) ? error.message : '操作未完成，请重试');
  }
  function serviceUnavailable(): void {
    setText(notice, '聊天服务暂未就绪，请稍后重试');
  }
  function requireReady(): boolean {
    if (client.isInitialized) return true;
    serviceUnavailable();
    return false;
  }
  function reset(nextPage: typeof page, text: UiText): number {
    revision += 1;
    page = nextPage;
    setText(title, text);
    setText(notice, '');
    body.replaceChildren();
    bottom.replaceChildren();
    back.hidden = nextPage === 'host' || nextPage === 'login' || nextPage === 'list';
    refresh.hidden = !['list', 'chat', 'service', 'requests'].includes(nextPage);
    logoutButton.hidden = nextPage !== 'list' || client.config?.hostManagedAuth === true;
    composer = undefined;
    timeline = undefined;
    historyButton = undefined;
    listBusy = chatBusy = historyBusy = false;
    sending = false;
    return revision;
  }

  function showLogin(): void {
    if (closed) return;
    if (client.config?.hostManagedAuth) { showHostState(); return; }
    const ownRevision = reset('login', '登录聊天');
    target = undefined;
    serviceRequest = undefined;
    setText(status, '');
    currentMessages = [];
    conversations = [];
    if (!client.isInitialized) serviceUnavailable();
    const form = node('form', 'card') as HTMLFormElement;
    form.append(node('h2', '', '欢迎使用'), node('p', 'muted', '登录 IM 账号，即可查看你的消息。'));
    const account = input('text', '账号', 'username');
    const password = input('password', '密码', 'current-password');
    account.required = password.required = true;
    form.append(field('账号', account), field('密码', password));
    let captchaToken: string | undefined;
    const captchaArea = node('div');
    const captchaQuestion = node('p', 'captcha-question');
    const answer = input('text', '安全验证答案', 'off');
    const captchaRow = node('div', 'captcha');
    const captchaAction = button('安全验证', () => loadCaptcha());
    captchaRow.append(captchaAction);
    captchaArea.append(captchaQuestion, captchaRow);
    form.append(captchaArea);
    const submit = node('button', 'primary wide', '登录') as HTMLButtonElement;
    submit.type = 'submit';
    form.append(submit, button('注册新账号', () => showRegister(), 'wide'), node('p', 'footer-note', '登录后即可查看当前账号的单聊和群聊。'));
    body.append(form);

    async function loadCaptcha(): Promise<void> {
      if (!requireReady()) return;
      captchaAction.disabled = true;
      const session = client.sessionRevision;
      try {
        const challenge = await client.requestLoginCaptcha();
        if (!valid(ownRevision, session)) return;
        captchaToken = challenge.token;
        setText(captchaQuestion, raw(challenge.question));
        if (!answer.isConnected) captchaRow.prepend(answer);
        answer.value = '';
        setText(captchaAction, '换一个');
        answer.focus();
      } catch (error) {
        if (valid(ownRevision, session)) failure(error);
      } finally {
        if (valid(ownRevision, session)) captchaAction.disabled = false;
      }
    }
    form.addEventListener('submit', async (event) => {
      event.preventDefault();
      if (submit.disabled) return;
      if (!requireReady()) return;
      setText(notice, '');
      submit.disabled = true;
      setText(submit, '正在登录…');
      const submittedPassword = password.value;
      password.value = '';
      try {
        await client.loginWithPassword({
          account: account.value.trim(),
          password: submittedPassword,
          ...(captchaToken ? { captchaToken, captchaAnswer: answer.value.trim() } : {}),
        });
        // Login intentionally changes the session revision.
        if (!closed && revision === ownRevision && client.isAuthenticated) showList();
      } catch (error) {
        if (closed || revision !== ownRevision) return;
        failure(error);
        if (/captcha/i.test(String((error as { code?: unknown })?.code ?? ''))) await loadCaptcha();
      } finally {
        if (!closed && revision === ownRevision) {
          submit.disabled = false;
          setText(submit, '登录');
        }
      }
    });
  }

  function showHostState(message?: UiText): void {
    if (closed) return;
    reset('host', '消息');
    conversations = [];
    currentMessages = [];
    target = undefined;
    serviceRequest = undefined;
    if (message) {
      const content = node('div', 'empty', message);
      content.append(button('重试', () => enterHostMessenger(), 'wide'));
      body.append(content);
    } else body.append(node('div', 'list'));
  }

  async function enterHostMessenger(): Promise<void> {
    if (closed) return;
    showHostState();
    const ownRevision = revision;
    try {
      const authenticated = await client.synchronizeHostSession();
      if (closed || revision !== ownRevision) return;
      if (authenticated) showList();
      else showHostState('请先在应用中登录');
    } catch {
      if (!closed && revision === ownRevision) showHostState('聊天暂不可用，请重试');
    }
  }

  function showRegister(): void {
    if (closed) return;
    const ownRevision = reset('register', '注册聊天账号');
    setText(status, '');
    const form = node('form', 'card') as HTMLFormElement;
    form.append(node('h2', '', '注册新账号'), node('p', 'muted', '注册后即可开始聊天，无需选择空间。'));
    const displayName = input('text', '昵称', 'nickname');
    const channel = node('select') as HTMLSelectElement;
    setAttr(channel, 'aria-label', '注册方式');
    const identifier = input('tel', '手机号', 'tel');
    const password = input('password', '设置密码', 'new-password');
    password.minLength = 6;
    const confirm = input('password', '确认密码', 'new-password');
    const code = input('text', '注册验证码', 'one-time-code');
    for (const element of [displayName, identifier, password, confirm]) element.required = true;
    const sendCode = button('发送验证码', () => perform('send'));
    const captchaQuestion = node('p', 'captcha-question');
    const captchaAnswer = input('text', '安全验证答案', 'off');
    const captchaArea = node('div');
    const captchaAction = button('换一个安全验证', () => loadCaptcha());
    captchaArea.hidden = true;
    captchaArea.append(captchaQuestion, captchaAnswer, captchaAction);
    const submit = node('button', 'primary wide', '注册并登录') as HTMLButtonElement;
    submit.type = 'submit';
    const settingsRetry = button('重新加载注册方式', () => loadSettings());
    settingsRetry.hidden = true;
    form.append(field('昵称', displayName), field('注册方式', channel), field('手机号或邮箱', identifier),
      field('密码（至少6位）', password), field('确认密码', confirm), field('验证码', code), sendCode,
      captchaArea, submit, settingsRetry, button('返回登录', () => showLogin(), 'wide'));
    body.append(form);
    let settings: RegistrationVerificationSettings | undefined;
    let busy = false;
    let captchaToken: string | undefined;
    let captchaFor: 'send' | 'register' | undefined;
    let nextSendAt = 0;
    const active = (): boolean => !closed && revision === ownRevision;
    function setBusy(value: boolean): void {
      busy = value;
      for (const control of [channel, identifier, displayName, password, confirm, code, captchaAnswer, captchaAction]) control.disabled = value;
      submit.disabled = sendCode.disabled = value || !settings || channel.options.length === 0;
      settingsRetry.disabled = value;
    }
    function clearCaptcha(): void {
      captchaToken = undefined;
      captchaFor = undefined;
      captchaAnswer.value = '';
      captchaArea.hidden = true;
    }
    channel.addEventListener('change', () => {
      identifier.type = channel.value === 'email' ? 'email' : 'tel';
      setAttr(identifier, 'placeholder', channel.value === 'email' ? '邮箱' : '手机号');
      setAttr(identifier, 'aria-label', channel.value === 'email' ? '邮箱' : '手机号');
      identifier.value = code.value = '';
      code.required = channel.value === 'sms' ? settings?.smsRequired === true : settings?.emailRequired === true;
      nextSendAt = 0;
      clearCaptcha();
    });
    identifier.addEventListener('input', () => { code.value = ''; clearCaptcha(); });
    async function loadSettings(): Promise<void> {
      if (busy) return;
      if (!client.isInitialized) {
        settings = undefined;
        settingsRetry.hidden = false;
        setBusy(false);
        serviceUnavailable();
        return;
      }
      setBusy(true);
      const session = client.sessionRevision;
      try {
        settings = await client.getRegistrationVerificationSettings();
        if (!valid(ownRevision, session)) return;
        channel.replaceChildren();
        for (const [value, enabled, label] of [['sms', settings.smsEnabled, '手机号'], ['email', settings.emailEnabled, '邮箱']] as const) {
          if (enabled) { const option = node('option', '', label); option.value = value; channel.append(option); }
        }
        channel.dispatchEvent(new Event('change'));
        settingsRetry.hidden = !!channel.options.length;
        if (!channel.options.length) setText(notice, '暂未开放注册，请联系应用提供方');
      } catch (error) {
        if (active()) { settings = undefined; failure(error); settingsRetry.hidden = false; }
      } finally { if (active()) setBusy(false); }
    }
    async function loadCaptcha(): Promise<void> {
      if (!requireReady()) return;
      const session = client.sessionRevision;
      try {
        const challenge = await client.requestLoginCaptcha();
        if (!valid(ownRevision, session)) return;
        captchaToken = challenge.token;
        setText(captchaQuestion, raw(challenge.question));
        captchaAnswer.value = '';
        captchaArea.hidden = false;
        captchaAnswer.focus();
      } catch (error) { if (active()) failure(error); }
    }
    async function perform(action: 'send' | 'register'): Promise<void> {
      if (busy || !settings || !channel.options.length) return;
      if (action === 'register' && !form.reportValidity()) return;
      if (action === 'register' && password.value !== confirm.value) { setText(notice, '两次输入的密码不一致'); return; }
      if (action === 'send' && Date.now() < nextSendAt) { setText(notice, '验证码已发送，请稍后再试'); return; }
      if (captchaToken && captchaFor !== action) clearCaptcha();
      setBusy(true);
      setText(notice, '');
      const request = { channel: channel.value as RegistrationChannel, identifier: identifier.value.trim(),
        ...(captchaToken ? { captchaToken, captchaAnswer: captchaAnswer.value.trim() } : {}) };
      try {
        if (action === 'send') {
          await client.sendRegistrationCode(request);
          if (!active()) return;
          nextSendAt = Date.now() + 60000;
          setText(notice, '验证码已发送，请查收');
          clearCaptcha();
        } else {
          await client.registerWithPassword({ ...request, displayName: displayName.value.trim(), password: password.value, verificationCode: code.value.trim() });
          password.value = confirm.value = '';
          if (active() && client.isAuthenticated) showList();
        }
      } catch (error) {
        if (!active()) return;
        failure(error);
        const errorCode = String((error as { code?: unknown })?.code ?? '');
        if (/CAPTCHA/.test(errorCode)) { captchaFor = action; await loadCaptcha(); }
        else clearCaptcha();
        if (errorCode === 'REGISTER_LOGIN_FAILED' || errorCode === 'REGISTER_PENDING_APPROVAL') {
          password.value = confirm.value = '';
          submit.disabled = true;
          settings = undefined; // The account exists; never submit a duplicate registration.
        }
      } finally { if (active()) setBusy(false); }
    }
    form.addEventListener('submit', event => { event.preventDefault(); void perform('register'); });
    void loadSettings();
  }

  function showList(): void {
    if (closed) return;
    if (!client.isAuthenticated) { showLogin(); return; }
    reset('list', '消息');
    target = undefined;
    currentMessages = [];
    serviceRequest = undefined;
    const toolbar = node('div', 'toolbar');
    toolbar.append(button('添加好友', () => showAddFriend()), button('好友申请', () => showFriendRequests()),
      node('span', 'spacer'), button('发起单聊', () => showNewChat()));
    bottom.append(toolbar);
    if (client.config?.hostManagedAuth) {
      const cached = client.cachedConversations;
      conversations = cached?.items ?? [];
      nextCursor = cached?.nextCursor;
      if (cached) renderConversations();
      else body.append(node('div', 'list'));
    } else body.append(node('div', 'loader', '正在加载会话…'));
    void loadConversations(false);
  }

  async function loadConversations(append: boolean): Promise<void> {
    if (closed || page !== 'list' || listBusy) return;
    listBusy = true;
    const ownRevision = revision;
    const session = client.sessionRevision;
    try {
      const result = await client.listConversations(append && nextCursor ? { cursor: nextCursor } : {});
      if (!valid(ownRevision, session)) return;
      conversations = append ? mergeConversations(conversations, result.items) : result.items;
      nextCursor = result.nextCursor;
      renderConversations();
    } catch (error) {
      if (valid(ownRevision, session)) {
        failure(error);
        if (!conversations.length) body.replaceChildren(node('div', 'empty', '暂时无法加载会话，请点击刷新重试。'));
      }
    } finally {
      if (valid(ownRevision, session)) listBusy = false;
    }
  }

  function renderConversations(): void {
    const list = node('div', 'list');
    for (const conversation of conversations) {
      const row = button('', () => openConversation(conversation), 'row');
      const displayTitle = (): string => conversation.titleIsDefault ? t(conversation.type === 'group' ? '群聊' : '聊天') : conversation.title;
      setAttr(row, 'aria-label', () => t('{name}，{count} 条未读消息', { name: displayTitle(), count: conversation.unreadCount }));
      const avatar = node('div', 'avatar', conversation.type === 'group' ? '群' : Array.from(conversation.title)[0] ? raw(Array.from(conversation.title)[0]!) : '聊');
      avatar.setAttribute('aria-hidden', 'true');
      const main = node('div', 'row-main');
      const top = node('div', 'row-top');
      top.append(node('span', 'row-title', conversation.titleIsDefault ? displayTitle : raw(conversation.title)));
      if (conversation.lastMessageAt) top.append(node('span', 'row-time', () => formatTimestamp(conversation.lastMessageAt!, locale())));
      main.append(top, node('div', 'preview', conversation.lastMessage ? raw(conversation.lastMessage) : (conversation.type === 'group' ? '群聊' : '暂无消息')));
      row.append(avatar, main);
      if (conversation.unreadCount > 0) row.append(node('span', 'badge', conversation.unreadCount > 99 ? '99+' : String(conversation.unreadCount)));
      list.append(row);
    }
    if (!conversations.length) list.append(node('div', 'empty', '还没有会话。可以发起单聊，或等待新的消息。'));
    if (nextCursor) list.append(button('加载更多会话', () => loadConversations(true), 'list-more'));
    body.replaceChildren(list);
  }

  function showNewChat(): void {
    const ownRevision = reset('new', '发起单聊');
    const session = client.sessionRevision;
    const controls = node('div', 'new-chat');
    const search = input('search', '搜索好友名字', 'off');
    const refreshContacts = button('刷新好友', () => loadContacts());
    controls.append(button('添加好友', () => showAddFriend()), button('好友申请', () => showFriendRequests()),
      button('新建群聊', () => showCreateGroup()), field('选择好友开始聊天', search), refreshContacts);
    const list = node('div', 'list');
    body.append(controls, list);
    let contacts: Contact[] = [];
    let loading = false;
    let opening = false;

    function renderContacts(): void {
      const query = search.value.trim().toLocaleLowerCase();
      const matches = contacts.filter((contact) => contact.displayName.toLocaleLowerCase().includes(query));
      list.replaceChildren();
      for (const contact of matches) {
        const row = button('', () => selectContact(contact), 'row');
        row.disabled = opening;
        setAttr(row, 'aria-label', () => t('与{name}聊天', { name: contactName(contact) }));
        const avatar = node('div', 'avatar', Array.from(contact.displayName)[0] ? raw(Array.from(contact.displayName)[0]!) : '友');
        avatar.setAttribute('aria-hidden', 'true');
        row.append(avatar, node('span', 'row-title', () => contactName(contact)));
        list.append(row);
      }
      if (!matches.length) {
        list.append(node('div', 'empty', contacts.length ? '没有找到匹配的好友。' : '暂无联系人。'));
        if (!contacts.length) list.append(button('返回会话', () => showList(), 'list-more'));
      }
    }

    async function loadContacts(): Promise<void> {
      if (loading || opening || !valid(ownRevision, session)) return;
      loading = true;
      search.disabled = refreshContacts.disabled = true;
      setText(notice, '');
      list.replaceChildren(node('div', 'loader', '正在加载好友…'));
      try {
        const result = await client.listContacts();
        if (!valid(ownRevision, session)) return;
        contacts = result;
        renderContacts();
      } catch (error) {
        if (valid(ownRevision, session)) {
          failure(error);
          list.replaceChildren(node('div', 'empty', '好友加载失败，请刷新重试。'));
        }
      } finally {
        if (valid(ownRevision, session)) {
          loading = false;
          search.disabled = refreshContacts.disabled = false;
        }
      }
    }

    async function selectContact(contact: Contact): Promise<void> {
      if (loading || opening || !valid(ownRevision, session)) return;
      opening = true;
      search.disabled = refreshContacts.disabled = true;
      setText(notice, '');
      renderContacts();
      try {
        const conversation = await client.createDirectConversation(contact.userId);
        if (valid(ownRevision, session)) await openConversation({ ...conversation, title: contact.displayName, titleIsDefault: false },
          contact.displayNameIsDefault ? contact.displayNameIsDefault === 'contact' ? '联系人' : '用户' : undefined);
      } catch (error) {
        if (valid(ownRevision, session)) failure(error);
      } finally {
        if (valid(ownRevision, session)) {
          opening = false;
          search.disabled = refreshContacts.disabled = false;
          renderContacts();
        }
      }
    }

    search.addEventListener('input', () => {
      if (!loading && !opening) renderContacts();
    });
    void loadContacts();
  }

  function showAddFriend(): void {
    if (!client.isAuthenticated) { showLogin(); return; }
    const ownRevision = reset('add-friend', '添加好友');
    const session = client.sessionRevision;
    const form = node('form', 'new-chat') as HTMLFormElement;
    const query = input('search', '搜索账号、手机号或邮箱', 'off');
    query.required = true;
    const message = input('text', '好友申请消息（可选）', 'off');
    const search = node('button', 'primary', '搜索用户') as HTMLButtonElement;
    search.type = 'submit';
    form.append(field('查找用户', query), field('申请消息', message), search, button('查看好友申请', () => showFriendRequests()));
    const list = node('div', 'list');
    body.append(form, list);
    let busy = false;
    let results: UserSearchResult[] = [];
    const submitted = new Map<string, 'pending' | 'accepted'>();
    function render(): void {
      list.replaceChildren();
      for (const user of results.filter(user => user.userId !== client.currentUser?.userId)) {
        const row = node('div', 'row');
        const main = node('div', 'row-main');
        main.append(node('div', 'row-title', () => contactName(user)));
        if (user.lppId) main.append(node('div', 'preview', raw(user.lppId)));
        const state = submitted.get(user.userId);
        const add = button(user.isFriend || state === 'accepted' ? '已是好友' : state === 'pending' ? '已申请' : '添加好友', () => send(user));
        add.disabled = busy || user.isFriend === true || state !== undefined;
        row.append(main, add);
        list.append(row);
      }
      if (!list.children.length) list.append(node('div', 'empty', '没有找到可添加的用户'));
    }
    async function send(user: UserSearchResult): Promise<void> {
      if (busy || !valid(ownRevision, session)) return;
      busy = true;
      search.disabled = true;
      render();
      try {
        const result = await client.sendFriendRequest(user.userId, message.value.trim() || undefined);
        if (!valid(ownRevision, session)) return;
        submitted.set(user.userId, result.status);
        setText(notice, result.status === 'accepted' ? '已成为好友，可返回发起单聊' : '好友申请已发送，等待对方同意');
      } catch (error) { if (valid(ownRevision, session)) failure(error); }
      finally { if (valid(ownRevision, session)) { busy = false; search.disabled = false; render(); } }
    }
    form.addEventListener('submit', async event => {
      event.preventDefault();
      if (busy) return;
      busy = true;
      search.disabled = true;
      setText(notice, '');
      try {
        const found = await client.searchUsers(query.value.trim());
        if (!valid(ownRevision, session)) return;
        results = found;
        render();
      } catch (error) { if (valid(ownRevision, session)) failure(error); }
      finally { if (valid(ownRevision, session)) { busy = false; search.disabled = false; render(); } }
    });
  }

  function showFriendRequests(): void {
    if (!client.isAuthenticated) { showLogin(); return; }
    const ownRevision = reset('requests', '好友申请');
    const session = client.sessionRevision;
    const list = node('div', 'list');
    body.append(list);
    const retry = button('刷新好友申请', () => load(), 'list-more');
    bottom.append(retry);
    let requests: FriendRequest[] = [];
    let busy = false;
    function render(): void {
      list.replaceChildren();
      for (const request of requests) {
        const received = request.toUserId === client.currentUser?.userId;
        const row = node('div', 'row');
        const main = node('div', 'row-main');
        main.append(node('div', 'row-title', () => (received ? request.fromNameIsDefault : request.toNameIsDefault) ? t('用户') : received ? request.fromDisplayName : request.toDisplayName));
        if (request.message) main.append(node('div', 'preview', raw(request.message)));
        const labels = { pending: received ? '待处理' : '已发送，等待对方同意', accepted: '已成为好友', rejected: '已拒绝', cancelled: '已取消', unknown: '状态待确认' };
        main.append(node('div', 'preview', labels[request.status]));
        row.append(main);
        if (received && request.status === 'pending') {
          const accept = button('同意', () => handle(request, 'accept'), 'primary');
          const reject = button('拒绝', () => handle(request, 'reject'));
          accept.disabled = reject.disabled = busy;
          row.append(accept, reject);
        }
        list.append(row);
      }
      if (!requests.length) list.append(node('div', 'empty', '暂无好友申请'));
    }
    async function load(): Promise<void> {
      if (busy || !valid(ownRevision, session)) return;
      busy = retry.disabled = true;
      try {
        const rows = await client.listFriendRequests();
        if (!valid(ownRevision, session)) return;
        requests = rows.filter(row => row.toUserId === client.currentUser?.userId || row.fromUserId === client.currentUser?.userId);
        render();
      } catch (error) { if (valid(ownRevision, session)) failure(error); }
      finally { if (valid(ownRevision, session)) { busy = retry.disabled = false; render(); } }
    }
    async function handle(request: FriendRequest, action: 'accept' | 'reject'): Promise<void> {
      if (busy || !valid(ownRevision, session)) return;
      busy = retry.disabled = true;
      render();
      try {
        await client.handleFriendRequest(request.requestId, action);
        if (!valid(ownRevision, session)) return;
        // Refresh server state even for an already handled request (409).
        requests = (await client.listFriendRequests()).filter(row => row.toUserId === client.currentUser?.userId || row.fromUserId === client.currentUser?.userId);
        if (!valid(ownRevision, session)) return;
        setText(notice, '好友申请状态已更新');
      } catch (error) { if (valid(ownRevision, session)) failure(error); }
      finally { if (valid(ownRevision, session)) { busy = retry.disabled = false; render(); } }
    }
    void load();
  }

  function showCreateGroup(): void {
    if (!client.isAuthenticated) { showLogin(); return; }
    const ownRevision = reset('group', '新建群聊');
    const session = client.sessionRevision;
    const form = node('form', 'new-chat') as HTMLFormElement;
    const name = input('text', '群名称', 'off');
    name.required = true;
    const list = node('div', 'list');
    const submit = node('button', 'primary wide', '创建群聊') as HTMLButtonElement;
    submit.type = 'submit';
    submit.disabled = true;
    const retry = button('刷新可选好友', () => load());
    form.append(field('群名称', name), node('p', 'muted', '选择好友加入群聊，也可以先创建空群。'), retry, list, submit);
    body.append(form);
    const selected = new Set<string>();
    let busy = false;
    let created = false;
    async function load(): Promise<void> {
      if (busy || !valid(ownRevision, session)) return;
      busy = retry.disabled = true;
      submit.disabled = true;
      try {
        const contacts = await client.listContacts();
        if (!valid(ownRevision, session)) return;
        selected.clear();
        list.replaceChildren();
        for (const contact of contacts.filter(contact => contact.userId !== client.currentUser?.userId)) {
          const checkbox = input('checkbox', () => t('邀请{name}', { name: contactName(contact) }), 'off');
          checkbox.style.width = 'auto';
          checkbox.addEventListener('change', () => { if (checkbox.checked) selected.add(contact.userId); else selected.delete(contact.userId); });
          const row = node('label', 'row');
          row.append(checkbox, node('span', 'row-title', () => contactName(contact)));
          list.append(row);
        }
        if (!list.children.length) list.append(node('p', 'muted', '暂无好友，可先添加好友。'));
      } catch (error) { if (valid(ownRevision, session)) failure(error); }
      finally { if (valid(ownRevision, session)) { busy = retry.disabled = false; submit.disabled = created; } }
    }
    form.addEventListener('submit', async event => {
      event.preventDefault();
      if (busy || created) return;
      busy = retry.disabled = submit.disabled = true;
      try {
        const result = await client.createGroup({ title: name.value.trim(), memberUserIds: [...selected] });
        if (!valid(ownRevision, session)) return;
        created = true;
        await openConversation(result);
      } catch (error) { if (valid(ownRevision, session)) failure(error); }
      finally { if (valid(ownRevision, session)) { busy = retry.disabled = false; submit.disabled = created; } }
    });
    void load();
  }

  async function openConversation(requested: ConversationTarget, sdkTitle?: string): Promise<void> {
    if (closed) throw new Error(t('聊天界面已关闭'));
    if (!client.isAuthenticated) throw new Error(t('请先登录'));
    const requestedTitle = requested.titleIsDefault ? (requested.type === 'group' ? '群聊' : '聊天') : requested.title ? raw(requested.title) : '聊天';
    const ownRevision = reset('chat', sdkTitle ?? requestedTitle);
    const session = client.sessionRevision;
    target = { ...requested };
    currentMessages = [];
    lastRead = 0;
    hasHistory = true;
    body.append(node('div', 'loader', '正在加载消息…'));
    try {
      // Resolve the server-owned conversation type before selecting a message route.
      const resolved = await client.getConversation(requested.conversationId);
      if (!valid(ownRevision, session)) return;
      target = resolved;
      setText(title, sdkTitle ?? (requested.title ? requestedTitle : resolved.titleIsDefault ? (resolved.type === 'group' ? '群聊' : '聊天') : raw(resolved.title)));
      renderComposer();
      await loadMessages(false);
    } catch (error) {
      if (valid(ownRevision, session)) {
        failure(error);
        body.replaceChildren(node('div', 'empty', '无法打开会话，请返回列表后重试。'));
      }
      throw error;
    }
  }

  function renderComposer(): void {
    const form = node('form', 'composer') as HTMLFormElement;
    composer = node('textarea') as HTMLTextAreaElement;
    composer.rows = 1;
    composer.maxLength = 10000;
    setAttr(composer, 'placeholder', '输入消息…');
    setAttr(composer, 'aria-label', '消息内容');
    const send = node('button', 'primary', '发送') as HTMLButtonElement;
    send.type = 'submit';
    form.append(composer, send);
    bottom.replaceChildren(form);
    const textInput = composer;
    const ownRevision = revision;
    const session = client.sessionRevision;
    let draftAttempt: { text: string; id: string } | undefined;
    textInput.addEventListener('input', () => {
      if (draftAttempt && draftAttempt.text !== textInput.value) draftAttempt = undefined;
    });
    form.addEventListener('submit', async (event) => {
      event.preventDefault();
      if (sending || !target || !textInput.value.trim()) return;
      sending = true;
      send.disabled = true;
      textInput.disabled = true;
      setText(notice, '');
      const text = textInput.value;
      const sendingTarget = target;
      try {
        // Keep the same idempotency key when the result of this exact draft is uncertain.
        if (!draftAttempt || draftAttempt.text !== text) draftAttempt = { text, id: createClientMessageId() };
        const message = await client.sendText(sendingTarget, text, { clientMessageId: draftAttempt.id });
        if (!valid(ownRevision, session)) return;
        textInput.value = '';
        draftAttempt = undefined;
        currentMessages = mergeMessages(currentMessages, [message]);
        renderMessages(true);
        void loadMessages(false);
      } catch (error) {
        if (valid(ownRevision, session)) failure(error);
      } finally {
        if (valid(ownRevision, session)) {
          sending = false;
          send.disabled = false;
          textInput.disabled = false;
          textInput.focus();
        }
      }
    });
    // Mobile keyboards keep Enter for a new line; desktop Ctrl/Cmd+Enter sends.
    textInput.addEventListener('keydown', (event) => {
      if (event.key === 'Enter' && (event.ctrlKey || event.metaKey) && !event.isComposing) {
        event.preventDefault();
        if (typeof form.requestSubmit === 'function') form.requestSubmit();
        else send.click();
      }
    });
  }

  async function loadMessages(older: boolean): Promise<void> {
    if (closed || page !== 'chat' || !target || (older ? historyBusy : chatBusy)) return;
    if (older) historyBusy = true; else chatBusy = true;
    const ownRevision = revision;
    const ownMessageRevision = messageRevision;
    const validSnapshot = (): boolean => valid(ownRevision, session) && messageRevision === ownMessageRevision;
    const session = client.sessionRevision;
    const currentTarget = target;
    const firstSeq = currentMessages.reduce((min, message) => message.seq > 0 ? Math.min(min, message.seq) : min, Infinity);
    if (historyButton) historyButton.disabled = true;
    const oldHeight = body.scrollHeight;
    const oldTop = body.scrollTop;
    const shouldScroll = !currentMessages.length || body.scrollHeight - body.scrollTop - body.clientHeight < 100;
    try {
      const result = await client.listMessages(currentTarget, { limit: 50, ...(older && Number.isFinite(firstSeq) ? { beforeSeq: firstSeq } : {}) });
      if (!validSnapshot()) return;
      if (older || !currentMessages.length) hasHistory = result.length >= 50;
      if (older) currentMessages = mergeMessages(currentMessages, result);
      else {
        // Replace the authoritative newest window, including removals and recalls.
        // Fewer than one full page means no older messages remain on the server.
        const first = result.reduce((min, message) => Math.min(min, message.seq), Infinity);
        const retained = result.length >= 50 ? currentMessages.filter((message) => message.seq < first) : [];
        currentMessages = mergeMessages(retained, result);
      }
      renderMessages(!older && shouldScroll);
      if (older) body.scrollTop = body.scrollHeight - oldHeight + oldTop;
      void markVisibleRead();
    } catch (error) {
      if (validSnapshot()) {
        failure(error);
        if (!timeline) body.replaceChildren(node('div', 'empty', '消息加载失败，请点击刷新重试。'));
      }
    } finally {
      if (validSnapshot()) {
        if (older) historyBusy = false; else chatBusy = false;
        if (historyButton) historyButton.disabled = false;
      }
    }
  }

  function renderMessages(scrollToBottom: boolean): void {
    timeline = node('div', 'timeline');
    timeline.setAttribute('role', 'log');
    setAttr(timeline, 'aria-label', '聊天消息');
    timeline.setAttribute('aria-live', 'polite');
    if (hasHistory && currentMessages.length) {
      historyButton = button('加载更早消息', () => loadMessages(true), 'history');
      timeline.append(historyButton);
    }
    for (const message of currentMessages) {
      const item = node('article', `message${message.isSelf ? ' self' : ''}`);
      item.append(node('div', 'meta', () => `${message.isSelf ? t('我') : message.senderName || message.senderUserId || t('对方')} · ${formatTimestamp(message.sentAt, locale())}`));
      const bubble = node('div', `bubble${message.type === 'text' ? '' : ' unsupported'}`, message.type === 'text' ? raw(message.text) : unsupportedLabel(message.type));
      item.append(bubble);
      timeline.append(item);
    }
    if (!currentMessages.length) timeline.append(node('div', 'empty', '暂无消息，发一句问候吧。'));
    body.replaceChildren(timeline);
    if (scrollToBottom) body.scrollTop = body.scrollHeight;
  }

  async function markVisibleRead(): Promise<void> {
    if (closed || page !== 'chat' || !target || document.visibilityState === 'hidden' || body.scrollHeight - body.scrollTop - body.clientHeight > 120) return;
    const seq = currentMessages.reduce((max, message) => Math.max(max, message.seq), 0);
    if (!seq || seq <= lastRead) return;
    const ownRevision = revision;
    const session = client.sessionRevision;
    try {
      await client.markRead(target, seq);
      if (valid(ownRevision, session)) lastRead = Math.max(lastRead, seq);
    } catch (error) {
      if (valid(ownRevision, session)) failure(error);
    }
  }

  async function openCustomerService(request: CustomerServiceRequest): Promise<CustomerServiceSession> {
    if (closed) throw new Error(t('聊天界面已关闭'));
    if (!client.isAuthenticated) throw new Error(t('请先登录'));
    const ownRevision = reset('service', '联系客服');
    const session = client.sessionRevision;
    target = undefined;
    serviceRequest = { ...request };
    body.append(node('div', 'loader', '正在连接客服…'));
    try {
      const result = await client.requestCustomerService(request);
      if (!valid(ownRevision, session)) return result;
      if (result.canOpenConversation && result.conversationId) {
        await openConversation({ conversationId: result.conversationId, type: 'direct' }, '客服');
      } else {
        const box = node('div', 'service');
        box.append(node('h2', '', result.status === 'queued' ? '正在排队' : '客服尚未接入'), node('p', '', result.status === 'queued' ? '你的请求已提交。客服接入后才能开始聊天。' : '暂时还无法开始聊天，请稍后刷新状态。'));
        box.append(button('刷新客服状态', () => openCustomerService(request), 'primary'));
        body.replaceChildren(box);
      }
      return result;
    } catch (error) {
      if (valid(ownRevision, session)) {
        failure(error);
        body.replaceChildren(node('div', 'empty', '客服请求未完成，请点击刷新重试。'));
      }
      throw error;
    }
  }

  function refreshCurrent(): Promise<unknown> | void {
    setText(notice, '');
    if (page === 'list') return loadConversations(false);
    if (page === 'chat') return loadMessages(false);
    if (page === 'service' && serviceRequest) return openCustomerService(serviceRequest);
    if (page === 'requests') return showFriendRequests();
  }
  handleEvent = (event) => {
    if (closed) return;
    if (event.type === 'presentationChanged') { applyPresentation(); return; }
    if (event.type === 'ready') {
      scheduleRefresh();
      if (client.config?.hostManagedAuth) void enterHostMessenger();
      else if (page === 'register') showRegister(); else if (!client.isAuthenticated) showLogin();
      return;
    }
    if (event.type === 'sessionChanging') {
      if (client.config?.hostManagedAuth) showHostState();
      else if (page !== 'login' && page !== 'register') showLogin();
      return;
    }
    if (event.type === 'authenticated') { showList(); return; }
    if (event.type === 'loggedOut' || event.type === 'authenticationRequired') {
      if (client.config?.hostManagedAuth) showHostState('请先在应用中登录'); else showLogin();
      return;
    }
    if (event.type === 'hostSessionSynchronized') {
      if (event.authenticated === false) showHostState('请先在应用中登录');
      else if (page === 'host') showList();
      return;
    }
    if (event.type === 'hostSessionError') { showHostState('聊天暂不可用，请重试'); return; }
    if (event.type === 'shutdown') { close(); return; }
    if (event.type === 'connectionChanged') {
      const value = String(event.state ?? event.status ?? '');
      setText(status, value === 'connected' ? '已连接' : value === 'reconnecting' ? '正在恢复连接…' : value === 'connecting' ? '正在连接…' : '连接暂不可用，可手动刷新');
    }
    if (event.type === 'conversationDeleted' && page === 'chat' && (!event.conversationId || event.conversationId === target?.conversationId)) { showList(); return; }
    if (event.type === 'messagesChanged' && page === 'chat' && (!event.conversationId || event.conversationId === target?.conversationId)) {
      if (event.reset && target) {
        // Retire message snapshots while preserving the draft and send attempt ID.
        messageRevision++;
        chatBusy = historyBusy = false;
        currentMessages = [];
        hasHistory = true;
        timeline = undefined;
        body.replaceChildren(node('div', 'loader', '正在更新消息…'));
      }
      void loadMessages(false);
    }
    if (event.type === 'conversationsChanged' && page === 'list') void loadConversations(false);
    if (event.type === 'customerServiceChanged' && page === 'service') {
      // A handoff notification is only a refresh hint; the REST response grants chat access.
      setText(status, '客服状态有更新，请刷新查看');
    }
  };
  const onVisibility = (): void => {
    if (document.visibilityState === 'hidden' || closed) return;
    if (client.config?.hostManagedAuth) {
      // A missed host notification can leave the old account here. Hide it
      // synchronously while the foreground snapshot is still pending.
      showHostState();
      void client.synchronizeHostSession().then(authenticated => {
        if (!closed && authenticated) {
          if (page === 'host') showList(); else return refreshCurrent();
        }
      }).catch(() => { if (!closed) showHostState('聊天暂不可用，请重试'); });
    } else void Promise.resolve(refreshCurrent()).catch(failure);
  };
  const onScroll = (): void => { void markVisibleRead(); };
  document.addEventListener('visibilitychange', onVisibility);
  const onLanguage = (): void => { if (!closed && client.config?.locale === 'system') applyPresentation(); };
  window.addEventListener('languagechange', onLanguage);
  body.addEventListener('scroll', onScroll, { passive: true });
  // REST refresh covers missed events and browser suspension without retaining credentials.
  function scheduleRefresh(): void {
    if (refreshTimer !== undefined) window.clearInterval(refreshTimer);
    refreshTimer = undefined;
    if (!client.isInitialized || closed) return;
    refreshTimer = window.setInterval(() => {
      if (!closed && client.isAuthenticated && document.visibilityState !== 'hidden' && (page === 'list' || page === 'chat')) void Promise.resolve(refreshCurrent()).catch(failure);
    }, client.config?.pollIntervalMs ?? 15000);
  }
  scheduleRefresh();

  function close(): void {
    if (closed) return;
    closed = true;
    revision += 1;
    currentMessages = [];
    conversations = [];
    target = undefined;
    serviceRequest = undefined;
    unsubscribe();
    if (refreshTimer !== undefined) window.clearInterval(refreshTimer);
    refreshTimer = undefined;
    document.removeEventListener('visibilitychange', onVisibility);
    window.removeEventListener('languagechange', onLanguage);
    removedBindings.disconnect(); bindings.clear();
    body.removeEventListener('scroll', onScroll);
    body.replaceChildren();
    bottom.replaceChildren();
    setText(notice, '');
    host.remove();
  }

  if (client.config?.hostManagedAuth) void enterHostMessenger();
  else if (client.isAuthenticated) showList(); else showLogin();
  return { openConversation, openCustomerService, close };
}

function mergeMessages(existing: Message[], incoming: Message[]): Message[] {
  const indexed = new Map(existing.map((message) => [message.messageId, message]));
  for (const message of incoming) indexed.set(message.messageId, message);
  return [...indexed.values()].sort((a, b) => a.seq - b.seq || a.sentAt.localeCompare(b.sentAt));
}
function mergeConversations(existing: Conversation[], incoming: Conversation[]): Conversation[] {
  const indexed = new Map(existing.map((conversation) => [conversation.conversationId, conversation]));
  for (const conversation of incoming) indexed.set(conversation.conversationId, conversation);
  return [...indexed.values()];
}
function unsupportedLabel(type: string): string {
  const labels: Record<string, string> = { image: '[图片]', file: '[文件]', video: '[视频]', voice: '[语音]', audio: '[语音]', system: '[系统消息]', call_log: '[通话记录]', recalled: '[消息已撤回]' };
  return labels[type] || '[此消息类型暂不支持显示]';
}
