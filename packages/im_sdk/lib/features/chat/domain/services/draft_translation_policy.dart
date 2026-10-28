enum DraftTranslationBlockReason {
  emptyDraft,
  mentions,
  scheduled,
  cannotSend,
}

/// Eligibility for translating and sending a plain text draft.
class DraftTranslationPolicy {
  const DraftTranslationPolicy();

  DraftTranslationBlockReason? selectionBlockReason({
    required bool hasMentions,
    required bool scheduled,
    required bool canSend,
  }) {
    if (!canSend) return DraftTranslationBlockReason.cannotSend;
    if (hasMentions) return DraftTranslationBlockReason.mentions;
    if (scheduled) return DraftTranslationBlockReason.scheduled;
    return null;
  }

  DraftTranslationBlockReason? blockReason({
    required String source,
    required bool hasMentions,
    required bool scheduled,
    required bool canSend,
  }) {
    final selectionBlock = selectionBlockReason(
      hasMentions: hasMentions,
      scheduled: scheduled,
      canSend: canSend,
    );
    if (selectionBlock != null) return selectionBlock;
    return source.trim().isEmpty
        ? DraftTranslationBlockReason.emptyDraft
        : null;
  }
}
