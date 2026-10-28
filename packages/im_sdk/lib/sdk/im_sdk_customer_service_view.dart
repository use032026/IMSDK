import 'dart:async';
import 'package:flutter/material.dart';
import 'package:im_sdk/app/theme/theme.dart';
import 'im_sdk_chat_view.dart';
import 'im_sdk_client.dart';
import 'im_sdk_models.dart';

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

class _ImSdkCustomerServiceViewState extends State<ImSdkCustomerServiceView> {
  late final int _boundSessionRevision;
  ImSdkCustomerServiceSession? _session;
  bool _busy = false;
  bool _closing = false;
  String? _errorCode;

  @override
  void initState() {
    super.initState();
    widget.request.validate();
    _boundSessionRevision = widget.client.sessionRevision;
    _session = widget.initialSession;
    widget.client.revision.addListener(_onClientChanged);
    if (_session == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) unawaited(_refresh());
      });
    }
  }

  bool get _sessionIsCurrent =>
      widget.client.isAuthenticated &&
      widget.client.sessionRevision == _boundSessionRevision;

  void _onClientChanged() {
    if (!_sessionIsCurrent) _close();
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
    widget.client.revision.removeListener(_onClientChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: Scaffold(
        appBar: AppBar(
          leadingWidth: 104,
          leading: TextButton(
            key: const ValueKey('im_sdk.customerService.close'),
            onPressed: _close,
            child: const Text('返回宿主'),
          ),
          title: const Text('企业客服'),
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
                Text(title,
                    key: const ValueKey('im_sdk.customerService.status'),
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                const Text('客服接入后可进入聊天。可手动查看接待状态。',
                    textAlign: TextAlign.center),
                if (_errorCode != null) ...[
                  const SizedBox(height: 12),
                  Text('暂时无法查看（$_errorCode）',
                      key: const ValueKey('im_sdk.customerService.error')),
                ],
                const SizedBox(height: 24),
                FilledButton(
                  key: const ValueKey('im_sdk.customerService.refresh'),
                  onPressed: _busy ? null : _refresh,
                  child: const Text('查看接待状态'),
                ),
                if (_busy) ...[
                  const SizedBox(height: 16),
                  const CircularProgressIndicator(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
