import 'dart:async';
import 'package:flutter/material.dart';
import 'im_sdk_chat_view.dart';
import 'im_sdk_client.dart';
import 'im_sdk_models.dart';
import 'im_sdk_presentation.dart';

/// Presents the authoritative handoff state, with user-initiated status checks.
class ImSdkCustomerServiceView extends StatefulWidget {
  const ImSdkCustomerServiceView({
    super.key,
    required this.client,
    required this.request,
    required this.onClose,
    this.initialSession,
  });
  final ImSdkClient client;
  final ImSdkCustomerServiceRequest request;
  final ImSdkCustomerServiceSession? initialSession;
  final VoidCallback onClose;

  @override
  State<ImSdkCustomerServiceView> createState() =>
      _ImSdkCustomerServiceViewState();
}

class _ImSdkCustomerServiceViewState extends State<ImSdkCustomerServiceView>
    with WidgetsBindingObserver {
  late int _boundSessionRevision;
  ImSdkCustomerServiceSession? _session;
  bool _busy = false;
  bool _closing = false;
  String? _errorCode;
  bool _hostChecked = false;
  bool _hostChecking = false;

  @override
  void initState() {
    super.initState();
    widget.request.validate();
    _boundSessionRevision = widget.client.sessionRevision;
    _session = widget.initialSession;
    widget.client.revision.addListener(_onClientChanged);
    _hostChecked = widget.client.config?.hostManagedAuth != true;
    if (!_hostChecked) {
      WidgetsBinding.instance.addObserver(this);
      unawaited(_verifyHostEntry());
    } else if (_session == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) unawaited(_refresh());
      });
    }
  }

  bool get _sessionIsCurrent =>
      _hostChecked &&
      widget.client.isAuthenticated &&
      widget.client.sessionRevision == _boundSessionRevision;

  void _onClientChanged() {
    if (!_hostChecked) return;
    if (!_sessionIsCurrent) _close();
  }

  Future<void> _verifyHostEntry() async {
    if (_hostChecking || _closing) return;
    _hostChecking = true;
    setState(() {
      _hostChecked = false;
      _errorCode = null;
    });
    try {
      final ready = await widget.client.synchronizeHostSession();
      if (!mounted || _closing) return;
      if (!ready ||
          (_session != null &&
              _boundSessionRevision != widget.client.sessionRevision)) {
        _close();
        return;
      }
      setState(() {
        _hostChecked = true;
        _boundSessionRevision = widget.client.sessionRevision;
        _errorCode = null;
      });
      if (_session == null) await _refresh();
    } catch (_) {
      if (mounted) setState(() => _errorCode = 'HOST_AUTH_UNAVAILABLE');
    } finally {
      _hostChecking = false;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) unawaited(_verifyHostEntry());
  }

  @override
  void didUpdateWidget(covariant ImSdkCustomerServiceView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.client, widget.client)) {
      oldWidget.client.revision.removeListener(_onClientChanged);
      widget.client.revision.addListener(_onClientChanged);
      _close();
    } else if (oldWidget.request != widget.request) {
      _close();
    } else {
      _onClientChanged();
    }
  }

  Future<void> _refresh() async {
    if (_busy || _closing) return;
    if (!_sessionIsCurrent) {
      _close();
      return;
    }
    setState(() {
      _busy = true;
      _errorCode = null;
    });
    try {
      final session =
          await widget.client.requestCustomerService(widget.request);
      if (mounted && !_closing && _sessionIsCurrent) {
        setState(() => _session = session);
      }
    } on ImSdkException catch (error) {
      if (mounted && !_closing && _sessionIsCurrent) {
        setState(() => _errorCode = error.code);
      }
    } catch (_) {
      if (mounted && !_closing && _sessionIsCurrent) {
        setState(() => _errorCode = 'SERVICE_CONTACT_FAILED');
      }
    } finally {
      if (mounted && !_closing) setState(() => _busy = false);
    }
  }

  void _close() {
    if (_closing || !mounted) return;
    _closing = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onClose();
    });
    WidgetsBinding.instance.scheduleFrame();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.client.revision.removeListener(_onClientChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_hostChecked) {
      return SdkPresentationApp(
          client: widget.client,
          homeBuilder: (context) => Scaffold(
              appBar: AppBar(title: Text(sdkText(context, '企业客服'))),
              body: _errorCode != null
                  ? Center(
                      child: TextButton(
                          onPressed: _verifyHostEntry,
                          child: Text(sdkText(context, '聊天服务暂不可用，重试'))))
                  : const SizedBox.expand()));
    }
    if (!_sessionIsCurrent) _close();
    final session = _session;
    if (_sessionIsCurrent && session?.canOpenConversation == true) {
      return ImSdkChatView(
        client: widget.client,
        target: session!.toConversation(),
        onClose: _close,
      );
    }
    final title = switch (session?.status) {
      ImSdkCustomerServiceStatus.queued => '正在排队',
      ImSdkCustomerServiceStatus.active => '等待会话准备',
      ImSdkCustomerServiceStatus.unknown => '接待状态暂未确认',
      null => '正在联系企业客服',
    };
    return SdkPresentationApp(
      client: widget.client,
      homeBuilder: (context) => Scaffold(
        appBar: AppBar(
          leadingWidth: 104,
          leading: TextButton(
            key: const ValueKey('im_sdk.customerService.close'),
            onPressed: _close,
            child: Text(sdkText(context, '返回宿主')),
          ),
          title: Text(sdkText(context, '企业客服')),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              key: session?.status == ImSdkCustomerServiceStatus.queued
                  ? const ValueKey('im_sdk.customerService.queued')
                  : null,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.support_agent, size: 48),
                const SizedBox(height: 16),
                Text(sdkText(context, title),
                    key: const ValueKey('im_sdk.customerService.status'),
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                Text(sdkText(context, '客服接入后可进入聊天。可手动查看接待状态。'),
                    textAlign: TextAlign.center),
                if (_errorCode != null) ...[
                  const SizedBox(height: 12),
                  Text(sdkText(context, '聊天服务暂不可用'),
                      key: const ValueKey('im_sdk.customerService.error')),
                ],
                const SizedBox(height: 24),
                FilledButton(
                  key: const ValueKey('im_sdk.customerService.refresh'),
                  onPressed: _busy ? null : _refresh,
                  child: Text(sdkText(context, '查看接待状态')),
                ),
                if (_busy) ...[
                  const SizedBox(height: 16),
                  CircularProgressIndicator(
                      semanticsLabel: sdkText(context, '正在加载…')),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
