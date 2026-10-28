import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final activeChatConversationProvider = StateProvider<String?>((ref) => null);

/// Coordinates the active-chat marker without notifying Riverpod listeners
/// from widget lifecycle methods such as `deactivate` or `activate`.
class ActiveChatLifecycle {
  ActiveChatLifecycle(this._controller);

  final StateController<String?> _controller;
  var _isActive = true;
  var _revision = 0;

  void markActive(String conversationId) {
    _isActive = true;
    _revision += 1;
    _controller.state = conversationId;
  }

  void activate(String conversationId) {
    _isActive = true;
    final revision = ++_revision;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isActive || revision != _revision || !_controller.mounted) return;
      _controller.state = conversationId;
    });
  }

  void deactivate(Set<String> conversationIds) {
    _isActive = false;
    final revision = ++_revision;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_isActive || revision != _revision || !_controller.mounted) return;
      if (conversationIds.contains(_controller.state)) {
        _controller.state = null;
      }
    });
  }
}
