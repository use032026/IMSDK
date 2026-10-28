import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_sdk/features/customer_service/data/models/customer_service_models.dart';

class CustomerServiceAiReplyTarget {
  final String threadType;
  final String threadId;
  final String? customerMessageId;

  const CustomerServiceAiReplyTarget({
    required this.threadType,
    required this.threadId,
    this.customerMessageId,
  });

  @override
  bool operator ==(Object other) =>
      other is CustomerServiceAiReplyTarget &&
      other.threadType == threadType &&
      other.threadId == threadId &&
      other.customerMessageId == customerMessageId;

  @override
  int get hashCode => Object.hash(threadType, threadId, customerMessageId);
}

CustomerServiceAiReplyTarget? customerServiceAiReplyTarget({
  required String? threadType,
  required String? threadId,
  required bool hasLoadedThreadDetail,
  required bool canReply,
  String? customerMessageId,
}) {
  if (!hasLoadedThreadDetail || !canReply) return null;
  final normalizedType = _normalizeAiReplyThreadType(threadType);
  final normalizedId = threadId?.trim() ?? '';
  if (normalizedType == null || normalizedId.isEmpty) return null;
  return CustomerServiceAiReplyTarget(
    threadType: normalizedType,
    threadId: normalizedId,
    customerMessageId: customerMessageId?.trim(),
  );
}

String? _normalizeAiReplyThreadType(String? value) {
  final normalized = (value ?? '').trim().toLowerCase().replaceAll('-', '_');
  return switch (normalized) {
    'temp_session' => 'temp_session',
    'im_direct' || 'direct_customer' => 'im_direct',
    _ => null,
  };
}

enum CustomerServiceAiReplyFailureOperation { history, generate, adopt }

class CustomerServiceAiReplyInvalidSuggestion implements Exception {
  const CustomerServiceAiReplyInvalidSuggestion();

  @override
  String toString() => 'AI suggestion is missing an id or text';
}

class CustomerServiceAiReplyState {
  final List<CsAiSuggestion> suggestions;
  final String? selectedSuggestionId;
  final bool isLoadingHistory;
  final bool isGenerating;
  final bool isAdopting;
  final Object? error;
  final CustomerServiceAiReplyFailureOperation? failureOperation;

  const CustomerServiceAiReplyState({
    this.suggestions = const [],
    this.selectedSuggestionId,
    this.isLoadingHistory = false,
    this.isGenerating = false,
    this.isAdopting = false,
    this.error,
    this.failureOperation,
  });

  CsAiSuggestion? get selectedSuggestion {
    if (suggestions.isEmpty) return null;
    final selectedId = selectedSuggestionId;
    if (selectedId == null || selectedId.isEmpty) return suggestions.first;
    for (final suggestion in suggestions) {
      if (suggestion.suggestionId == selectedId) return suggestion;
    }
    return suggestions.first;
  }
}

typedef CustomerServiceAiReplyHistoryLoader = Future<List<CsAiSuggestion>>
    Function(CustomerServiceAiReplyTarget target);
typedef CustomerServiceAiReplyGenerator = Future<CsAiSuggestion> Function(
  CustomerServiceAiReplyTarget target,
);
typedef CustomerServiceAiReplyAdopter = Future<void> Function(
  String suggestionId,
);

class CustomerServiceAiReplyController
    extends StateNotifier<CustomerServiceAiReplyState> {
  final CustomerServiceAiReplyTarget target;
  final CustomerServiceAiReplyHistoryLoader _loadHistory;
  final CustomerServiceAiReplyGenerator _generate;
  final CustomerServiceAiReplyAdopter _adopt;
  int _operationRevision = 0;
  bool _disposed = false;

  CustomerServiceAiReplyController({
    required this.target,
    required CustomerServiceAiReplyHistoryLoader loadHistory,
    required CustomerServiceAiReplyGenerator generate,
    required CustomerServiceAiReplyAdopter adopt,
  })  : _loadHistory = loadHistory,
        _generate = generate,
        _adopt = adopt,
        super(const CustomerServiceAiReplyState());

  Future<void> loadHistory() async {
    final revision = ++_operationRevision;
    state = CustomerServiceAiReplyState(
      suggestions: state.suggestions,
      selectedSuggestionId: state.selectedSuggestionId,
      isLoadingHistory: true,
    );
    try {
      final loaded = await _loadHistory(target);
      if (!_isCurrent(revision)) return;
      final suggestions = loaded.where((item) => item.isUsable).toList(
            growable: false,
          );
      state = CustomerServiceAiReplyState(
        suggestions: suggestions,
        selectedSuggestionId:
            suggestions.isEmpty ? null : suggestions.first.suggestionId,
      );
    } catch (error) {
      if (!_isCurrent(revision)) return;
      state = CustomerServiceAiReplyState(
        suggestions: state.suggestions,
        selectedSuggestionId: state.selectedSuggestionId,
        error: error,
        failureOperation: CustomerServiceAiReplyFailureOperation.history,
      );
    }
  }

  Future<void> generateSuggestion() async {
    final revision = ++_operationRevision;
    state = CustomerServiceAiReplyState(
      suggestions: state.suggestions,
      selectedSuggestionId: state.selectedSuggestionId,
      isGenerating: true,
    );
    try {
      final suggestion = await _generate(target);
      if (!_isCurrent(revision)) return;
      if (!suggestion.isUsable) {
        throw const CustomerServiceAiReplyInvalidSuggestion();
      }
      final suggestions = [
        suggestion,
        ...state.suggestions.where(
          (item) => item.suggestionId != suggestion.suggestionId,
        ),
      ];
      state = CustomerServiceAiReplyState(
        suggestions: suggestions,
        selectedSuggestionId: suggestion.suggestionId,
      );
    } catch (error) {
      if (!_isCurrent(revision)) return;
      state = CustomerServiceAiReplyState(
        suggestions: state.suggestions,
        selectedSuggestionId: state.selectedSuggestionId,
        error: error,
        failureOperation: CustomerServiceAiReplyFailureOperation.generate,
      );
    }
  }

  void selectSuggestion(String suggestionId) {
    if (!state.suggestions.any(
      (suggestion) => suggestion.suggestionId == suggestionId,
    )) {
      return;
    }
    state = CustomerServiceAiReplyState(
      suggestions: state.suggestions,
      selectedSuggestionId: suggestionId,
    );
  }

  Future<String?> adoptSelected() async {
    final selected = state.selectedSuggestion;
    final suggestionId = selected?.suggestionId.trim() ?? '';
    final text = selected?.text.trim() ?? '';
    if (suggestionId.isEmpty || text.isEmpty) return null;
    final revision = ++_operationRevision;
    state = CustomerServiceAiReplyState(
      suggestions: state.suggestions,
      selectedSuggestionId: suggestionId,
      isAdopting: true,
    );
    try {
      await _adopt(suggestionId);
      if (!_isCurrent(revision)) return null;
      state = CustomerServiceAiReplyState(
        suggestions: state.suggestions,
        selectedSuggestionId: suggestionId,
      );
      return text;
    } catch (error) {
      if (!_isCurrent(revision)) return null;
      state = CustomerServiceAiReplyState(
        suggestions: state.suggestions,
        selectedSuggestionId: suggestionId,
        error: error,
        failureOperation: CustomerServiceAiReplyFailureOperation.adopt,
      );
      return null;
    }
  }

  bool _isCurrent(int revision) => !_disposed && revision == _operationRevision;

  @override
  void dispose() {
    _disposed = true;
    _operationRevision++;
    super.dispose();
  }
}
