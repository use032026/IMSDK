import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:im_sdk/app/theme/theme.dart';
import 'package:im_sdk/core/platform/local_file.dart';
import 'package:im_sdk/core/utils/debouncer.dart';
import 'package:im_sdk/core/widgets/app_toast.dart';
import 'package:im_sdk/core/widgets/user_avatar.dart';
import 'package:im_sdk/features/chat/presentation/controllers/conversation_actions_controller.dart';
import 'package:im_sdk/features/chat/domain/entities/message.dart';
import 'package:im_sdk/features/chat/domain/entities/scheduled_message.dart';
import 'package:im_sdk/features/chat/domain/services/chat_attachment_policy.dart';
import 'package:im_sdk/features/chat/domain/services/chat_draft_hydration_policy.dart';
import 'package:im_sdk/features/chat/domain/services/chat_text_send_draft_policy.dart';
import 'package:im_sdk/features/chat/domain/services/mention_composer.dart';
import 'package:im_sdk/features/chat/domain/services/scheduled_message_time_policy.dart';
import 'package:im_sdk/features/chat/domain/services/draft_translation_policy.dart';
import 'package:im_sdk/features/chat/application/draft_translation_controller.dart';
import 'package:im_sdk/features/chat/presentation/models/translation_language_options.dart';
import 'package:im_sdk/features/chat/infrastructure/chat_attachment_picker.dart';
import 'package:im_sdk/features/chat/presentation/pages/chat_camera_capture_page.dart';
import 'package:im_sdk/features/chat/presentation/models/chat_picked_media.dart';
import 'package:im_sdk/features/chat/presentation/widgets/emoji_picker_panel.dart';
import 'package:im_sdk/features/chat/presentation/widgets/voice_recorder.dart';
import 'package:im_sdk/features/customer_service/data/models/customer_service_models.dart';
import 'package:im_sdk/features/customer_service/application/customer_service_ai_reply_controller.dart';
import 'package:im_sdk/features/customer_service/presentation/providers/customer_service_providers.dart';
import 'package:im_sdk/features/customer_service/presentation/widgets/customer_service_ai_reply_sheet.dart';
import 'package:im_sdk/features/settings/presentation/providers/chat_input_settings_provider.dart';
import 'package:im_sdk/l10n/app_localizations.dart';
import 'package:path/path.dart' as p;

enum _InputMode { text, voice, emoji, tools }

class ChatMentionCandidate {
  final String userId;
  final String displayName;
  final String? avatarUrl;

  const ChatMentionCandidate({
    required this.userId,
    required this.displayName,
    this.avatarUrl,
  });
}

class ChatTextSendRequest {
  final String text;
  final List<Mention>? mentions;

  const ChatTextSendRequest({
    required this.text,
    this.mentions,
  });
}

typedef ScheduledTextUpdateCallback = FutureOr<bool> Function({
  required String scheduledMessageId,
  required String text,
  required DateTime scheduledAt,
});

class ChatInputToolbar extends ConsumerStatefulWidget {
  final String conversationId;
  final String? translationScopeKey;
  final String? translationSessionKey;
  final DraftTranslationSelectionStore? translationSelections;
  final DraftTranslationExecutor? onTranslateDraft;
  final bool isGroup;
  final String? initialDraft; // 进入会话时恢复的草稿

  /// 群全员禁言时为 true
  final bool isMuted;

  /// 当前用户是否可以发言（管理员/群主不受禁言限制）
  final bool canSpeak;

  /// 当前不可发言时展示在输入框里的原因。
  final String? muteReason;

  final FutureOr<bool> Function(String text) onSendText;
  final FutureOr<bool> Function(ChatTextSendRequest request)? onSendTextRequest;
  final FutureOr<bool> Function(String text, DateTime scheduledAt)?
      onScheduleText;
  final DateTime? scheduledSendAt;
  final ValueChanged<DateTime?>? onScheduledSendAtChanged;
  final ScheduledMessage? scheduledMessageForEdit;
  final ScheduledTextUpdateCallback? onUpdateScheduledText;
  final VoidCallback? onCancelScheduledEdit;
  final FutureOr<void> Function(String filePath, int duration) onSendVoice;
  final FutureOr<String?> Function(String filePath)? onTranscribeVoice;
  final FutureOr<void> Function(List<ChatPickedMedia> media) onSendMedia;
  final FutureOr<void> Function(
          String filePath, String fileName, String mimeType, int sizeBytes)?
      onSendFile;
  final VoidCallback? onVoiceCall;
  final VoidCallback? onVideoCall;
  final VoidCallback? onFavorite;
  final VoidCallback? onSendContactCard;
  final String? quickReplyScope;
  final CustomerServiceAiReplyTarget? aiReplyTarget;
  final String? aiReplyContextText;
  final String? externalInsertText;
  final int externalInsertToken;
  final int inputSurfaceDismissToken;
  final List<ChatMentionCandidate> mentionCandidates;
  final bool canMentionAll;
  final VoiceRecordingBackend? voiceRecordingBackend;
  final ChatAttachmentPicker? attachmentPicker;

  const ChatInputToolbar({
    super.key,
    required this.conversationId,
    this.translationScopeKey,
    this.translationSessionKey,
    this.translationSelections,
    this.onTranslateDraft,
    required this.isGroup,
    this.initialDraft,
    this.isMuted = false,
    this.canSpeak = true,
    this.muteReason,
    required this.onSendText,
    this.onSendTextRequest,
    this.onScheduleText,
    this.scheduledSendAt,
    this.onScheduledSendAtChanged,
    this.scheduledMessageForEdit,
    this.onUpdateScheduledText,
    this.onCancelScheduledEdit,
    required this.onSendVoice,
    this.onTranscribeVoice,
    required this.onSendMedia,
    this.onSendFile,
    this.onVoiceCall,
    this.onVideoCall,
    this.onFavorite,
    this.onSendContactCard,
    this.quickReplyScope,
    this.aiReplyTarget,
    this.aiReplyContextText,
    this.externalInsertText,
    this.externalInsertToken = 0,
    this.inputSurfaceDismissToken = 0,
    this.mentionCandidates = const [],
    this.canMentionAll = false,
    this.voiceRecordingBackend,
    this.attachmentPicker,
  });

  @override
  ConsumerState<ChatInputToolbar> createState() => _ChatInputToolbarState();
}

class _ChatInputToolbarState extends ConsumerState<ChatInputToolbar> {
  static const _draftHydrationPolicy = ChatDraftHydrationPolicy();
  static const _sendDraftPolicy = ChatTextSendDraftPolicy();
  static const _draftTranslationPolicy = DraftTranslationPolicy();
  static const double _toolbarHorizontalPadding = 2;
  static const double _toolbarVerticalPadding = 7;
  static const double _inputHeight = 42;

  _InputMode _mode = _InputMode.text;
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  late DraftTranslationController _draftTranslation;
  bool _translationInitialized = false;
  late final ChatAttachmentPicker _attachmentPicker;
  MentionComposerDraft _mentionDraft = const MentionComposerDraft.empty();
  Timer? _draftTimer;
  bool _sendingText = false;
  bool _sendingTranslation = false;
  bool _hasLocalInputInteraction = false;
  bool _wasClearedBySend = false;
  DateTime? _scheduledSendAt;
  int? _lastMentionPromptTextLength;

  bool get _isMutedForUser => widget.isMuted && !widget.canSpeak;

  bool get _isEditingScheduledMessage => widget.scheduledMessageForEdit != null;

  DraftTranslationBlockReason? get _translationBlock =>
      _draftTranslationPolicy.blockReason(
        source: _textController.text,
        hasMentions: _mentionDraft.mentions.isNotEmpty,
        scheduled: _scheduledSendAt != null || _isEditingScheduledMessage,
        canSend: !_isMutedForUser,
      );

  DraftTranslationBlockReason? get _translationSelectionBlock =>
      _draftTranslationPolicy.selectionBlockReason(
        hasMentions: _mentionDraft.mentions.isNotEmpty,
        scheduled: _scheduledSendAt != null || _isEditingScheduledMessage,
        canSend: !_isMutedForUser,
      );

  String get _translationScopeKey =>
      widget.translationScopeKey ?? widget.conversationId;

  @override
  void initState() {
    super.initState();
    _attachmentPicker =
        widget.attachmentPicker ?? PlatformChatAttachmentPicker();
    // 恢复草稿
    final editMessage = widget.scheduledMessageForEdit;
    if (editMessage != null) {
      _hydrateDraft(editMessage.body.text?.trim() ?? '');
      _scheduledSendAt = editMessage.scheduledAt.toLocal();
      _hasLocalInputInteraction = true;
    } else if (widget.initialDraft != null && widget.initialDraft!.isNotEmpty) {
      _hydrateDraft(widget.initialDraft!);
    } else if (widget.scheduledSendAt != null) {
      _scheduledSendAt = widget.scheduledSendAt;
    }
    _draftTranslation = _newDraftTranslationController();
    _draftTranslation.update(
      scopeKey: _translationScopeKey,
      source: _textController.text,
      composing: false,
      sessionKey: widget.translationSessionKey ?? '',
    );
    _translationInitialized = true;
    _textController.addListener(_syncDraftTranslation);
  }

  DraftTranslationController _newDraftTranslationController() =>
      DraftTranslationController(
        selections: widget.translationSelections,
        executor: (source, language, cancellation) =>
            widget.onTranslateDraft?.call(source, language, cancellation) ??
            Future<String?>.value(),
        onChanged: (_) {
          if (mounted && _translationInitialized) setState(() {});
        },
      );

  @override
  void didUpdateWidget(covariant ChatInputToolbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(
        widget.translationSelections, oldWidget.translationSelections)) {
      _draftTranslation.dispose();
      _draftTranslation = _newDraftTranslationController();
    }
    final conversationChanged =
        widget.conversationId != oldWidget.conversationId ||
            widget.translationScopeKey != oldWidget.translationScopeKey ||
            widget.translationSessionKey != oldWidget.translationSessionKey;
    if (conversationChanged) {
      _draftTimer?.cancel();
      _textController.clear();
      _mentionDraft = const MentionComposerDraft.empty();
      _setScheduledSendAt(null, notify: true, rebuild: false);
      _hasLocalInputInteraction = false;
      _wasClearedBySend = false;
      _sendingText = false;
      _sendingTranslation = false;
      _lastMentionPromptTextLength = null;
    }

    final editMessage = widget.scheduledMessageForEdit;
    final oldEditMessage = oldWidget.scheduledMessageForEdit;
    if (editMessage?.scheduledMessageId != oldEditMessage?.scheduledMessageId) {
      if (editMessage != null) {
        _hydrateDraft(editMessage.body.text?.trim() ?? '');
        _scheduledSendAt = editMessage.scheduledAt.toLocal();
        _hasLocalInputInteraction = true;
        _wasClearedBySend = false;
        _mode = _InputMode.text;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _focusNode.requestFocus();
          unawaited(
            SystemChannels.textInput.invokeMethod<void>('TextInput.show'),
          );
        });
      } else if (oldEditMessage != null) {
        _setScheduledSendAt(null, notify: false, rebuild: false);
      }
    }

    if (editMessage == null &&
        widget.scheduledSendAt != oldWidget.scheduledSendAt &&
        widget.scheduledSendAt != _scheduledSendAt) {
      _setScheduledSendAt(widget.scheduledSendAt,
          notify: false, rebuild: false);
    }

    final nextDraft = widget.initialDraft;
    final draftChanged = nextDraft != oldWidget.initialDraft;
    if ((conversationChanged || draftChanged) &&
        _draftHydrationPolicy.shouldHydrate(
          currentConversationId: _translationScopeKey,
          previousConversationId:
              oldWidget.translationScopeKey ?? oldWidget.conversationId,
          incomingDraft: nextDraft,
          currentInput: _textController.text,
          hasLocalInputInteraction: _hasLocalInputInteraction,
          wasClearedBySend: _wasClearedBySend,
        )) {
      _hydrateDraft(nextDraft!);
    }
    _syncDraftTranslation();
    if (widget.inputSurfaceDismissToken != oldWidget.inputSurfaceDismissToken) {
      _dismissInputSurface();
    }
    if (widget.externalInsertToken == oldWidget.externalInsertToken) return;
    final text = widget.externalInsertText?.trim();
    if (text == null || text.isEmpty || _isMutedForUser) return;
    _insertTextAtCursor(text);
    _setMode(_InputMode.text);
    _focusNode.requestFocus();
  }

  void _dismissInputSurface() {
    _focusNode.unfocus();
    _mode = _InputMode.text;
    unawaited(SystemChannels.textInput.invokeMethod<void>('TextInput.hide'));
  }

  void _hydrateDraft(String draft) {
    _textController.text = draft;
    _mentionDraft = MentionComposerDraft(
      text: draft,
      tokens: const [],
    );
    _textController.selection = TextSelection.fromPosition(
      TextPosition(offset: draft.length),
    );
  }

  void _syncDraftTranslation() {
    final composing = _textController.value.composing;
    _draftTranslation.update(
      scopeKey: _translationScopeKey,
      source: _textController.text,
      composing: composing.isValid && !composing.isCollapsed,
      sessionKey: widget.translationSessionKey ?? '',
    );
  }

  @override
  void dispose() {
    _draftTimer?.cancel();
    _textController.removeListener(_syncDraftTranslation);
    _draftTranslation.dispose();
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /// Persist locally on every edit; only remote synchronization is debounced.
  void _scheduleDraftSave(String text) {
    _draftTimer?.cancel();
    final actions = ref.read(conversationActionsControllerProvider);
    final conversationId = widget.conversationId;
    final isGroup = widget.isGroup;
    actions.updateDraft(conversationId, isGroup: isGroup, text: text);
    _draftTimer = Timer(const Duration(milliseconds: 500), () {
      unawaited(
          actions.syncDraft(conversationId, isGroup: isGroup, text: text));
    });
  }

  void _setMode(_InputMode mode) {
    if (_isMutedForUser) {
      _focusNode.unfocus();
      if (_mode != _InputMode.text) {
        setState(() => _mode = _InputMode.text);
      }
      return;
    }
    setState(() => _mode = mode);
    if (mode == _InputMode.text) {
      _focusNode.requestFocus();
    } else {
      _focusNode.unfocus();
    }
  }

  Future<void> _sendText() async {
    if (_isMutedForUser) return;
    if (_sendingText) return;
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    final request = ChatTextSendRequest(
      text: text,
      mentions: widget.isGroup ? _mentionDraft.mentions : null,
    );
    final scheduledAt = _scheduledSendAt;
    final actions = ref.read(conversationActionsControllerProvider);
    final conversationId = widget.conversationId;
    final scopeKey = _translationScopeKey;
    final sessionKey = widget.translationSessionKey;
    _hasLocalInputInteraction = true;
    setState(() => _sendingText = true);
    _textController.clear();
    _mentionDraft = const MentionComposerDraft.empty();
    _wasClearedBySend = true;
    _draftTimer?.cancel();
    try {
      final editingMessage = widget.scheduledMessageForEdit;
      final result = await actions.sendTextWithDraft(
        conversationId,
        isGroup: widget.isGroup,
        sourceText: text,
        preserveSourceOnFailure: scheduledAt != null,
        send: () {
          if (scheduledAt == null) {
            return widget.onSendTextRequest?.call(request) ??
                widget.onSendText(text);
          }
          if (editingMessage != null) {
            return widget.onUpdateScheduledText?.call(
                  scheduledMessageId: editingMessage.scheduledMessageId,
                  text: text,
                  scheduledAt: scheduledAt,
                ) ??
                false;
          }
          return widget.onScheduleText?.call(text, scheduledAt) ?? false;
        },
      );
      if (!mounted ||
          _translationScopeKey != scopeKey ||
          widget.translationSessionKey != sessionKey) {
        return;
      }
      final sent = result.sent;
      if (sent) {
        if (scheduledAt != null && mounted) {
          _setScheduledSendAt(null);
        }
        if (editingMessage != null) {
          widget.onCancelScheduledEdit?.call();
        }
      }
      final resolvedDraft = _sendDraftPolicy.resolveAfterSend(
        sent: sent,
        sentText: text,
        currentInput: _textController.text,
        preserveSourceOnFailure: scheduledAt != null,
      );
      if (!sent &&
          !result.superseded &&
          _textController.text.isEmpty &&
          resolvedDraft.isNotEmpty) {
        _hydrateDraft(resolvedDraft);
        _wasClearedBySend = false;
        _focusNode.requestFocus();
      }
    } finally {
      if (mounted &&
          _translationScopeKey == scopeKey &&
          widget.translationSessionKey == sessionKey) {
        setState(() => _sendingText = false);
      }
    }
  }

  Future<void> _sendTranslatedText() async {
    final source = _textController.text;
    final scopeKey = _translationScopeKey;
    final sessionKey = widget.translationSessionKey;
    final actions = ref.read(conversationActionsControllerProvider);
    final conversationId = widget.conversationId;
    final translation = _draftTranslation.state;
    if (_sendingText ||
        _translationBlock != null ||
        !translation.canSend(_translationScopeKey, source)) {
      return;
    }

    _hasLocalInputInteraction = true;
    _draftTimer?.cancel();
    setState(() {
      _sendingText = true;
      _sendingTranslation = true;
    });
    try {
      final result = await actions.sendTextWithDraft(
        conversationId,
        isGroup: widget.isGroup,
        sourceText: source,
        preserveSourceOnFailure: true,
        send: () => widget.onSendText(translation.text),
      );
      if (!mounted ||
          !result.sent ||
          _translationScopeKey != scopeKey ||
          widget.translationSessionKey != sessionKey) {
        return;
      }
      if (!result.superseded && _textController.text == source) {
        _draftTimer?.cancel();
        _textController.clear();
        _mentionDraft = const MentionComposerDraft.empty();
        _wasClearedBySend = true;
      }
    } finally {
      if (mounted &&
          _translationScopeKey == scopeKey &&
          widget.translationSessionKey == sessionKey) {
        setState(() {
          _sendingText = false;
          _sendingTranslation = false;
        });
      }
    }
  }

  Future<void> _openTranslationLanguagePicker() async {
    final l10n = AppLocalizations.of(context);
    final blocked = _translationSelectionBlock;
    if (blocked != null) {
      final message = switch (blocked) {
        DraftTranslationBlockReason.mentions =>
          l10n.chatTranslationMentionsUnsupported,
        DraftTranslationBlockReason.scheduled =>
          l10n.chatTranslationScheduledUnsupported,
        DraftTranslationBlockReason.cannotSend =>
          widget.muteReason ?? l10n.chatInputMutedAdminOnly,
        DraftTranslationBlockReason.emptyDraft => l10n.chatTranslationEnterText,
      };
      AppToast.info(context, message);
      return;
    }
    final language = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const _DraftTranslationLanguageSheet(),
    );
    if (!mounted || language == null) return;
    try {
      await _draftTranslation.selectTarget(language);
    } catch (_) {
      if (mounted) {
        AppToast.error(context, l10n.commonOperationFailed);
      }
    }
    if (!mounted) return;
    setState(() => _mode = _InputMode.text);
    _focusNode.requestFocus();
  }

  Future<void> _closeDraftTranslation() async {
    try {
      await _draftTranslation.close();
    } catch (_) {
      if (mounted) {
        AppToast.error(
            context, AppLocalizations.of(context).commonOperationFailed);
      }
    }
  }

  Future<void> _openSchedulePicker() async {
    if (_isMutedForUser) return;
    final selected = await showModalBottomSheet<DateTime>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const _ScheduledMessageTimeSheet(),
    );
    if (selected == null || !mounted) return;
    _setScheduledSendAt(selected);
    _setMode(_InputMode.text);
    _focusNode.requestFocus();
  }

  void _setScheduledSendAt(
    DateTime? value, {
    bool notify = true,
    bool rebuild = true,
  }) {
    if (_scheduledSendAt == value) return;
    if (rebuild && mounted) {
      setState(() => _scheduledSendAt = value);
    } else {
      _scheduledSendAt = value;
    }
    if (notify && !_isEditingScheduledMessage) {
      widget.onScheduledSendAtChanged?.call(value);
    }
  }

  bool get _isComposingText {
    final composing = _textController.value.composing;
    return composing.isValid && !composing.isCollapsed;
  }

  bool _isPlainEnter(KeyEvent event) {
    if (event is! KeyDownEvent) return false;
    final key = event.logicalKey;
    if (key != LogicalKeyboardKey.enter &&
        key != LogicalKeyboardKey.numpadEnter) {
      return false;
    }
    final pressed = HardwareKeyboard.instance.logicalKeysPressed;
    return !pressed.contains(LogicalKeyboardKey.shiftLeft) &&
        !pressed.contains(LogicalKeyboardKey.shiftRight) &&
        !pressed.contains(LogicalKeyboardKey.controlLeft) &&
        !pressed.contains(LogicalKeyboardKey.controlRight) &&
        !pressed.contains(LogicalKeyboardKey.altLeft) &&
        !pressed.contains(LogicalKeyboardKey.altRight) &&
        !pressed.contains(LogicalKeyboardKey.metaLeft) &&
        !pressed.contains(LogicalKeyboardKey.metaRight);
  }

  Future<void> _pickMediaFromGallery() async {
    if (_isMutedForUser) return;
    try {
      final files = await _attachmentPicker.pickMedia();
      if (files.isNotEmpty) {
        await _sendPickedFiles(files, allowFileAttachments: false);
      }
    } catch (e) {
      // 部分系统相册能力不可用时降级为单张选图，至少保留旧体验。
      try {
        final file = await _attachmentPicker.pickFallbackImage();
        if (file != null) {
          await _sendPickedFiles([file], allowFileAttachments: false);
        }
      } catch (_) {
        // 静默失败
      }
    }
  }

  Future<void> _openCameraPicker() async {
    if (_isMutedForUser) return;
    final result = await Navigator.of(context).push<ChatCameraCaptureResult>(
      MaterialPageRoute(builder: (_) => const ChatCameraCapturePage()),
    );
    if (result == null || !mounted) return;
    await _sendCapturedMedia(result);
  }

  Future<void> _sendCapturedMedia(ChatCameraCaptureResult result) async {
    int? sizeBytes;
    try {
      sizeBytes = await localFileLength(result.path);
    } catch (_) {
      sizeBytes = null;
    }
    final media = result.kind == ChatCameraCaptureKind.video
        ? ChatPickedMedia.video(
            path: result.path,
            fileName: result.name,
            mimeType: result.mimeType,
            sizeBytes: sizeBytes,
          )
        : ChatPickedMedia.image(
            path: result.path,
            fileName: result.name,
            mimeType: result.mimeType,
            sizeBytes: sizeBytes,
          );
    await Future.sync(() => widget.onSendMedia([media]));
  }

  Future<void> _sendPickedFiles(
    List<ChatPickedLocalFile> files, {
    bool allowFileAttachments = true,
  }) async {
    final dispatch = await classifyChatPickedFiles(
      files,
      allowFileAttachments: allowFileAttachments,
    );
    for (final file in dispatch.files) {
      await Future.sync(
        () => widget.onSendFile?.call(
          file.filePath,
          file.fileName,
          file.mimeType,
          file.sizeBytes,
        ),
      );
    }
    if (dispatch.oversizedFiles.isNotEmpty) {
      if (mounted) {
        AppToast.error(context, AppLocalizations.of(context).chatFileTooLarge);
      }
    }
    if (dispatch.unsupportedFiles.isNotEmpty && mounted) {
      AppToast.error(context, _unsupportedFileTypeText(context));
    }
    if (dispatch.media.isEmpty) return;
    await Future.sync(() => widget.onSendMedia(dispatch.media));
  }

  Future<void> _pickFile() async {
    if (_isMutedForUser) return;
    ChatPickedLocalFile? file;
    try {
      file = await _attachmentPicker.pickDocument();
    } on ChatAttachmentPickException catch (error) {
      if (!mounted) return;
      if (error.failure == ChatAttachmentPickFailure.tooLarge) {
        AppToast.error(context, AppLocalizations.of(context).chatFileTooLarge);
      } else if (error.failure == ChatAttachmentPickFailure.unsupportedType) {
        AppToast.error(
          context,
          _fileValidationErrorText(
            context,
            error.rejection ?? ChatFileAttachmentRejection.unsupportedType,
            extension: error.extension,
          ),
        );
      } else {
        AppToast.error(context, _filePickFailedText(context));
      }
      return;
    }
    if (file == null) return;
    final fileName = _pickedFileName(file.name, file.path);
    final validation = validateChatFileAttachment(
      fileName: fileName,
      mimeType: file.mimeType,
      sizeBytes: file.sizeBytes,
    );
    if (!validation.isAccepted) {
      if (mounted) {
        AppToast.error(
          context,
          _fileValidationErrorText(
            context,
            validation.rejection!,
            extension: validation.extension,
          ),
        );
      }
      return;
    }
    final pickedFile = ChatPickedFileAttachment.fromPickedFile(
      file,
      validatedExtension: validation.extension,
    );
    await Future.sync(
      () => widget.onSendFile?.call(
        pickedFile.filePath,
        pickedFile.fileName,
        pickedFile.mimeType,
        pickedFile.sizeBytes,
      ),
    );
  }

  String _filePickFailedText(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;
    if (languageCode == 'en') {
      return 'Unable to read the file. Download it to this device and retry';
    }
    if (languageCode == 'ja') return 'ファイルを端末にダウンロードしてから、もう一度お試しください';
    if (languageCode == 'ko') return '파일을 기기에 다운로드한 후 다시 시도해 주세요';
    if (languageCode == 'vi') {
      return 'Không thể đọc tệp. Hãy tải tệp về thiết bị rồi thử lại';
    }
    return '无法读取文件，请确认文件已下载到本机后重试';
  }

  String _fileValidationErrorText(
    BuildContext context,
    ChatFileAttachmentRejection rejection, {
    String extension = '',
  }) {
    if (rejection == ChatFileAttachmentRejection.tooLarge) {
      return AppLocalizations.of(context).chatFileTooLarge;
    }
    final languageCode = Localizations.localeOf(context).languageCode;
    if (rejection == ChatFileAttachmentRejection.mediaUsePhotos) {
      if (languageCode == 'en') return 'Send images and videos from Photos';
      if (languageCode == 'ja') return '画像と動画は「写真」から送信してください';
      if (languageCode == 'ko') return '사진과 동영상은 “사진”에서 보내 주세요';
      if (languageCode == 'vi') {
        return 'Vui lòng gửi ảnh và video từ mục “Ảnh”';
      }
      return '图片和视频请通过“照片”入口发送';
    }
    if (rejection == ChatFileAttachmentRejection.unrecognizedType) {
      if (languageCode == 'en') return 'Unable to identify the file type';
      if (languageCode == 'ja') return 'ファイル形式を識別できません';
      if (languageCode == 'ko') return '파일 형식을 확인할 수 없습니다';
      if (languageCode == 'vi') return 'Không thể xác định loại tệp';
      return '无法识别文件类型';
    }
    if (rejection == ChatFileAttachmentRejection.typeMismatch) {
      if (languageCode == 'en') {
        return 'The file type does not match its extension';
      }
      if (languageCode == 'ja') return 'ファイル形式と拡張子が一致しないため送信できません';
      if (languageCode == 'ko') return '파일 형식과 확장자가 일치하지 않아 보낼 수 없습니다';
      if (languageCode == 'vi') {
        return 'Loại tệp không khớp với phần mở rộng nên không thể gửi';
      }
      return '文件类型与扩展名不一致，无法发送';
    }
    final normalizedExtension = extension.trim().toLowerCase();
    if (normalizedExtension.isEmpty) return _unsupportedFileTypeText(context);
    if (languageCode == 'en') {
      return '.$normalizedExtension files are not supported yet';
    }
    if (languageCode == 'ja') return '.$normalizedExtension ファイルはまだ送信できません';
    if (languageCode == 'ko') return '.$normalizedExtension 파일은 아직 보낼 수 없습니다';
    if (languageCode == 'vi') {
      return 'Chưa hỗ trợ gửi tệp .$normalizedExtension';
    }
    return '暂不支持发送 .$normalizedExtension 文件';
  }

  String _unsupportedFileTypeText(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;
    if (languageCode == 'en') return 'This file type is not supported yet';
    if (languageCode == 'ja') return 'このファイル形式はまだ対応していません';
    if (languageCode == 'ko') return '아직 지원하지 않는 파일 형식입니다';
    if (languageCode == 'vi') return 'Chưa hỗ trợ loại tệp này';
    return '暂不支持发送此类型文件';
  }

  void _insertEmoji(String emoji) {
    if (_isMutedForUser) return;
    _insertTextAtCursor(emoji);
  }

  void _insertTextAtCursor(String insertedText) {
    _hasLocalInputInteraction = true;
    _wasClearedBySend = false;
    final text = _textController.text;
    final sel = _textController.selection;
    final start = sel.start < 0 ? text.length : sel.start;
    final end = sel.end < 0 ? text.length : sel.end;
    final newText = text.replaceRange(start, end, insertedText);
    _mentionDraft = MentionComposerDraft(
      text: newText,
      tokens: _mentionDraft.tokens,
    );
    _textController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: start + insertedText.length),
    );
    _scheduleDraftSave(newText);
    setState(() {}); // 触发重建，更新发送按钮状态
  }

  void _handleTextChanged(String text) {
    _hasLocalInputInteraction = true;
    if (text.isNotEmpty) {
      _wasClearedBySend = false;
    }
    _mentionDraft = MentionComposerDraft(
      text: text,
      tokens: _mentionDraft.tokens,
    );
    _scheduleDraftSave(text);
    if (!widget.isGroup || _isMutedForUser) {
      _lastMentionPromptTextLength = null;
      return;
    }
    if (!_endsWithMentionTrigger(text)) {
      _lastMentionPromptTextLength = null;
      return;
    }
    if (_lastMentionPromptTextLength == text.length) return;
    _lastMentionPromptTextLength = text.length;
    unawaited(_openMentionPicker(replaceTypedAt: true));
  }

  bool _endsWithMentionTrigger(String text) {
    return text.endsWith('@') || text.endsWith('＠');
  }

  bool _isMentionTriggerChar(String text) {
    return text == '@' || text == '＠';
  }

  Future<void> _openMentionPicker({bool replaceTypedAt = false}) async {
    if (_isMutedForUser || !widget.isGroup) return;
    final selected = await showModalBottomSheet<_MentionPickResult>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _MentionPickerSheet(
        candidates: widget.mentionCandidates,
        canMentionAll: widget.canMentionAll,
      ),
    );
    if (selected == null || selected.items.isEmpty || !mounted) return;
    final selection = _textController.selection;
    var start =
        selection.start < 0 ? _textController.text.length : selection.start;
    var end = selection.end < 0 ? _textController.text.length : selection.end;
    if (replaceTypedAt && start > 0 && end == start) {
      final text = _textController.text;
      if (_isMentionTriggerChar(text.substring(start - 1, start))) {
        start -= 1;
      }
    }
    var draft = _mentionDraft;
    var cursor = start;
    for (var index = 0; index < selected.items.length; index++) {
      final item = selected.items[index];
      final selectionStart = index == 0 ? start : cursor;
      final selectionEnd = index == 0 ? end : cursor;
      if (item.isAll) {
        draft = draft.insertAll(
          selectionStart: selectionStart,
          selectionEnd: selectionEnd,
        );
        cursor += '@所有人 '.length;
      } else {
        draft = draft.insertUser(
          userId: item.userId!,
          displayName: item.displayName!,
          selectionStart: selectionStart,
          selectionEnd: selectionEnd,
        );
        cursor += '@${item.displayName} '.length;
      }
    }
    _mentionDraft = draft;
    _hasLocalInputInteraction = true;
    _wasClearedBySend = false;
    _textController.value = TextEditingValue(
      text: draft.text,
      selection: TextSelection.collapsed(offset: cursor),
    );
    _scheduleDraftSave(draft.text);
    _setMode(_InputMode.text);
    _focusNode.requestFocus();
  }

  Future<void> _openQuickReplies() async {
    if (_isMutedForUser || widget.quickReplyScope == null) return;
    final selected = await showModalBottomSheet<CsQuickReply>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _QuickReplyPickerSheet(scope: widget.quickReplyScope),
    );
    if (selected == null || !mounted) return;
    _insertTextAtCursor(selected.content);
    _setMode(_InputMode.text);
    _focusNode.requestFocus();
  }

  Future<void> _openAiReplySuggestions() async {
    final target = widget.aiReplyTarget;
    if (_isMutedForUser || target == null) return;
    final selected = await showCustomerServiceAiReplySheet(
      context,
      target: target,
      contextText: widget.aiReplyContextText,
    );
    if (selected == null || !mounted) return;
    _insertTextAtCursor(selected);
    _setMode(_InputMode.text);
    _focusNode.requestFocus();
  }

  void _deleteLastChar() {
    final text = _textController.text;
    if (text.isEmpty) return;
    final sel = _textController.selection;
    final pos = sel.start < 0 ? text.length : sel.start;
    if (pos == 0) return;
    // 用 Characters 正确处理 emoji（多字节字符）
    final chars = text.substring(0, pos).characters;
    if (chars.isEmpty) return;
    final newPrefix = chars.skipLast(1).string;
    final newText = newPrefix + text.substring(pos);
    _hasLocalInputInteraction = true;
    _wasClearedBySend = false;
    _textController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newPrefix.length),
    );
    setState(() {}); // 更新发送按钮状态
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    final toolbar = Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(
              height: 0.5,
              thickness: 0.5,
              color: Theme.of(context).dividerColor),
          if (widget.onTranslateDraft != null &&
              _draftTranslation.state.targetLanguage != null)
            _DraftTranslationBar(
              state: _draftTranslation.state,
              sending: _sendingTranslation,
              canSend: !_sendingText &&
                  _translationBlock == null &&
                  _draftTranslation.state.canSend(
                    _translationScopeKey,
                    _textController.text,
                  ),
              onRetry: _draftTranslation.retry,
              onClose: () => unawaited(_closeDraftTranslation()),
              onSend: () => unawaited(_sendTranslatedText()),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: _toolbarHorizontalPadding,
              vertical: _toolbarVerticalPadding,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 左：麦克风 / 键盘
                _CircleIconButton(
                  icon: _mode == _InputMode.voice
                      ? Icons.keyboard_alt_outlined
                      : Icons.mic_none_rounded,
                  onTap: _isMutedForUser
                      ? null
                      : () => _setMode(
                            _mode == _InputMode.voice
                                ? _InputMode.text
                                : _InputMode.voice,
                          ),
                ),
                // 中：输入框 / 按住说话（同一个容器样式）
                Expanded(child: _buildInputArea()),
                // 右：表情
                _CircleIconButton(
                  icon: _mode == _InputMode.emoji
                      ? Icons.keyboard_alt_outlined
                      : Icons.mood,
                  showBorder: false,
                  onTap: _isMutedForUser
                      ? null
                      : () => _setMode(
                            _mode == _InputMode.emoji
                                ? _InputMode.text
                                : _InputMode.emoji,
                          ),
                ),
                // 右：+，发送交给键盘右下角的 send action
                _buildMoreButton(),
              ],
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            child: _buildExpandedPanel(bottomPadding),
          ),
        ],
      ),
    );
    // Treat all composer controls as one region so chat touches (including a
    // drag on a short list) dismiss input without interrupting toolbar actions.
    return TextFieldTapRegion(
      onTapOutside: (_) {
        if (_focusNode.hasFocus ||
            _mode == _InputMode.emoji ||
            _mode == _InputMode.tools) {
          setState(_dismissInputSurface);
        }
      },
      child: toolbar,
    );
  }

  Widget _buildInputArea() {
    final inputColor = Theme.of(context).colorScheme.surfaceContainerHighest;
    final enterToSend = ref.watch(chatEnterToSendProvider);
    if (_isMutedForUser) {
      final textColor = Theme.of(context).colorScheme.onSurfaceVariant;
      return Container(
        height: _inputHeight,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: inputColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            widget.muteReason ??
                AppLocalizations.of(context).chatInputMutedAdminOnly,
            maxLines: 1,
            style: TextStyle(fontSize: 14, color: textColor),
          ),
        ),
      );
    }

    if (_mode == _InputMode.voice) {
      // 语音模式与文字输入使用同一固定高度，切换时不发生跳动。
      return VoiceRecorder(
        onSendVoice: widget.onSendVoice,
        onSendText: widget.onSendText,
        onTranscribeVoice: widget.onTranscribeVoice,
        onCancel: () => setState(() => _mode = _InputMode.voice),
        recordingBackend: widget.voiceRecordingBackend,
      );
    }

    // 文字模式：和"按住说话"完全相同的 Container 结构
    return Container(
      key: const ValueKey('chat-input-surface'),
      width: double.infinity,
      height: _inputHeight,
      decoration: BoxDecoration(
        color: inputColor,
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.center,
      child: Focus(
        onKeyEvent: (node, event) {
          if (!enterToSend) return KeyEventResult.ignored;
          if (!_isPlainEnter(event)) return KeyEventResult.ignored;
          // Let the IME confirm its candidate before clearing the input.
          if (_isComposingText) return KeyEventResult.ignored;
          unawaited(_sendText());
          return KeyEventResult.handled;
        },
        child: TextField(
          controller: _textController,
          focusNode: _focusNode,
          maxLines: 1,
          textInputAction: TextInputAction.send,
          // 使用 editingComplete 承接软键盘发送，且不注册 onSubmitted。
          // Flutter 会在 onSubmitted 存在时重建 TextInputConnection；
          // iOS 因此切换 input view，造成键盘和输入栏短暂收缩。
          onEditingComplete: () {
            if (_isComposingText) return;
            unawaited(_sendText());
          },
          onChanged: _handleTextChanged,
          onTap: () {
            if (_mode != _InputMode.text) {
              setState(() => _mode = _InputMode.text);
            }
          },
          textAlignVertical: TextAlignVertical.center,
          cursorColor: Theme.of(context).colorScheme.onSurface,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context).chatInputHint,
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 15,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            isCollapsed: true,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
          style: TextStyle(
            fontSize: 15,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  Widget _buildMoreButton() {
    return _CircleIconButton(
      icon: _mode == _InputMode.tools
          ? Icons.close_rounded
          : Icons.add_circle_outline_rounded,
      showBorder: false,
      onTap: _isMutedForUser
          ? null
          : () => _setMode(
                _mode == _InputMode.tools ? _InputMode.text : _InputMode.tools,
              ),
    );
  }

  Widget _buildExpandedPanel(double bottomPadding) {
    if (_mode == _InputMode.emoji && !_isMutedForUser) {
      return EmojiPickerPanel(
        onEmojiSelected: _insertEmoji,
        onDelete: _deleteLastChar,
        onSend: _sendText,
        hasSendContent: _textController.text.trim().isNotEmpty,
      );
    }

    if (_mode == _InputMode.tools && !_isMutedForUser) {
      return _ToolsPanel(
        isGroup: widget.isGroup,
        bottomPadding: bottomPadding,
        onPickImages: _pickMediaFromGallery,
        onTakePhoto: _openCameraPicker,
        onPickFile: _pickFile,
        onVoiceCall: widget.onVoiceCall,
        onVideoCall: widget.onVideoCall,
        onFavorite: widget.onFavorite,
        onSendContactCard: widget.onSendContactCard,
        onScheduleMessage: _openSchedulePicker,
        onQuickReply: widget.quickReplyScope == null ? null : _openQuickReplies,
        onAiReply:
            widget.aiReplyTarget == null ? null : _openAiReplySuggestions,
        onTranslate: widget.onTranslateDraft == null
            ? null
            : () => unawaited(_openTranslationLanguagePicker()),
        translationAvailable: _translationSelectionBlock == null,
      );
    }

    return const SizedBox.shrink();
  }
}

class ChatPickedFileAttachment {
  final String filePath;
  final String fileName;
  final String extension;
  final String mimeType;
  final int sizeBytes;

  const ChatPickedFileAttachment({
    required this.filePath,
    required this.fileName,
    required this.extension,
    required this.mimeType,
    required this.sizeBytes,
  });

  factory ChatPickedFileAttachment.fromPickedFile(
    ChatPickedLocalFile file, {
    String? validatedExtension,
  }) {
    final fileName = _pickedFileName(file.name, file.path);
    final extension =
        validatedExtension?.trim().toLowerCase().isNotEmpty == true
            ? validatedExtension!.trim().toLowerCase()
            : _fileExtension(fileName, file.path);
    return ChatPickedFileAttachment(
      filePath: file.path,
      fileName: fileName,
      extension: extension,
      mimeType: chatFileAttachmentMimeType(extension),
      sizeBytes: file.sizeBytes,
    );
  }
}

class ChatPickedFilesDispatch {
  final List<ChatPickedMedia> media;
  final List<ChatPickedFileAttachment> files;
  final List<ChatPickedFileAttachment> oversizedFiles;
  final List<ChatPickedLocalFile> unsupportedFiles;

  const ChatPickedFilesDispatch({
    required this.media,
    required this.files,
    required this.oversizedFiles,
    required this.unsupportedFiles,
  });
}

Future<ChatPickedFilesDispatch> classifyChatPickedFiles(
  List<ChatPickedLocalFile> files, {
  int maxFileSizeBytes = chatFileAttachmentMaxSizeBytes,
  bool allowFileAttachments = true,
}) async {
  final media = <ChatPickedMedia>[];
  final attachments = <ChatPickedFileAttachment>[];
  final oversized = <ChatPickedFileAttachment>[];
  final unsupported = <ChatPickedLocalFile>[];
  for (final file in files) {
    final picked = ChatPickedMedia.tryFromPickedFile(
      path: file.path,
      name: file.name,
      mimeType: file.mimeType,
      sizeBytes: file.sizeBytes,
    );
    if (picked != null) {
      media.add(picked);
      continue;
    }
    if (!allowFileAttachments) {
      unsupported.add(file);
      continue;
    }
    final attachment = ChatPickedFileAttachment.fromPickedFile(file);
    if (!isChatFileAttachmentCandidate(
      fileName: attachment.fileName,
      mimeType: file.mimeType,
    )) {
      unsupported.add(file);
      continue;
    }
    if (attachment.sizeBytes > maxFileSizeBytes) {
      oversized.add(attachment);
      continue;
    }
    attachments.add(attachment);
  }
  return ChatPickedFilesDispatch(
    media: media,
    files: attachments,
    oversizedFiles: oversized,
    unsupportedFiles: unsupported,
  );
}

String _pickedFileName(String fileName, String filePath) {
  final trimmed = fileName.trim();
  if (trimmed.isNotEmpty) return trimmed;
  final basename = p.basename(filePath);
  return basename.isEmpty ? 'file' : basename;
}

String _fileExtension(String fileName, String filePath) {
  final fromName = p.extension(fileName).replaceFirst('.', '');
  if (fromName.trim().isNotEmpty) return fromName;
  return p.extension(filePath).replaceFirst('.', '');
}

// ---------------------------------------------------------------------------
// 圆圈图标按钮（对照微信：白底圆形 + 细边框）
// ---------------------------------------------------------------------------

class _CircleIconButton extends StatelessWidget {
  static const double _hitExtent = 44;
  static const double _borderedSurfaceExtent = 36;
  static const double _iconSize = 30;

  final IconData icon;
  final VoidCallback? onTap;
  final bool showBorder;

  const _CircleIconButton({
    required this.icon,
    required this.onTap,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Opacity(
        opacity: disabled ? 0.38 : 1,
        child: SizedBox.square(
          dimension: _hitExtent,
          child: Center(
            child: Container(
              width: showBorder ? _borderedSurfaceExtent : _hitExtent,
              height: showBorder ? _borderedSurfaceExtent : _hitExtent,
              decoration: showBorder
                  ? BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).dividerColor,
                        width: 0.8,
                      ),
                    )
                  : null,
              alignment: Alignment.center,
              child: Icon(
                icon,
                size: _iconSize,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ScheduledMessageTimeSheet extends StatefulWidget {
  const _ScheduledMessageTimeSheet();

  @override
  State<_ScheduledMessageTimeSheet> createState() =>
      _ScheduledMessageTimeSheetState();
}

class _ScheduledMessageTimeSheetState
    extends State<_ScheduledMessageTimeSheet> {
  static const _timePolicy = ScheduledMessageTimePolicy();
  late final List<DateTime> _dates;
  late int _selectedDateIndex;
  late int _selectedHour;
  late int _selectedMinute;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final defaultTime = _timePolicy.defaultScheduledAt(now);
    _dates = List.generate(
      14,
      (index) =>
          DateTime(now.year, now.month, now.day).add(Duration(days: index)),
    );
    _selectedDateIndex = defaultTime.difference(_dates.first).inDays;
    _selectedHour = defaultTime.hour;
    _selectedMinute = defaultTime.minute;
  }

  DateTime get _selectedAt {
    final date = _dates[_selectedDateIndex];
    return DateTime(
      date.year,
      date.month,
      date.day,
      _selectedHour,
      _selectedMinute,
    );
  }

  bool get _isValid => _timePolicy.canScheduleAt(_selectedAt, DateTime.now());

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 378,
      child: Column(
        children: [
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.only(top: 8, bottom: 10),
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Row(
              children: [
                const SizedBox(width: 48),
                Expanded(
                  child: Center(
                    child: Text(
                      '选择时间',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Theme.of(context).dividerColor),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(
                      initialItem: _selectedDateIndex,
                    ),
                    itemExtent: 46,
                    magnification: 1.06,
                    useMagnifier: true,
                    onSelectedItemChanged: (index) {
                      setState(() => _selectedDateIndex = index);
                    },
                    children: _dates
                        .map(
                          (date) => Center(
                            child: Text(
                              _formatSchedulePickerDate(date),
                              maxLines: 1,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        )
                        .toList(growable: false),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(
                      initialItem: _selectedHour,
                    ),
                    itemExtent: 46,
                    magnification: 1.06,
                    useMagnifier: true,
                    onSelectedItemChanged: (index) {
                      setState(() => _selectedHour = index);
                    },
                    children: List.generate(
                      24,
                      (hour) => Center(
                        child: Text(
                          hour.toString().padLeft(2, '0'),
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(
                      initialItem: _selectedMinute,
                    ),
                    itemExtent: 46,
                    magnification: 1.06,
                    useMagnifier: true,
                    onSelectedItemChanged: (index) {
                      setState(() => _selectedMinute = index);
                    },
                    children: List.generate(
                      60,
                      (minute) => Center(
                        child: Text(
                          minute.toString().padLeft(2, '0'),
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: _isValid
                    ? () => Navigator.of(context).pop(_selectedAt)
                    : null,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF2F6FED),
                  disabledBackgroundColor:
                      colorScheme.onSurface.withValues(alpha: 0.12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  '保存',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _formatSchedulePickerDate(DateTime date) {
  return '${date.month}月${date.day}日 ${_weekdayText(date)}';
}

String _weekdayText(DateTime date) {
  const weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
  return weekdays[date.weekday - 1];
}

class _MentionPickResult {
  final List<_MentionPickItem> items;

  const _MentionPickResult.all() : items = const [_MentionPickItem.all()];

  _MentionPickResult.user({
    required String userId,
    required String displayName,
  }) : items = [
          _MentionPickItem.user(userId: userId, displayName: displayName)
        ];

  _MentionPickResult.multiple(this.items);
}

class _MentionPickItem {
  final bool isAll;
  final String? userId;
  final String? displayName;

  const _MentionPickItem.all()
      : isAll = true,
        userId = null,
        displayName = null;

  const _MentionPickItem.user({
    required this.userId,
    required this.displayName,
  }) : isAll = false;
}

class _MentionPickerSheet extends StatefulWidget {
  final List<ChatMentionCandidate> candidates;
  final bool canMentionAll;

  const _MentionPickerSheet({
    required this.candidates,
    required this.canMentionAll,
  });

  @override
  State<_MentionPickerSheet> createState() => _MentionPickerSheetState();
}

class _MentionPickerSheetState extends State<_MentionPickerSheet> {
  final _searchController = TextEditingController();
  final _selectedUserIds = <String>{};
  bool _multiSelect = false;
  bool _selectedAll = false;
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ChatMentionCandidate> get _visibleCandidates {
    final query = _query.trim().toLowerCase();
    final candidates = widget.candidates
        .where((candidate) => candidate.displayName.trim().isNotEmpty)
        .where((candidate) {
      if (query.isEmpty) return true;
      return candidate.displayName.toLowerCase().contains(query) ||
          candidate.userId.toLowerCase().contains(query);
    }).toList(growable: false);
    return [...candidates]..sort((left, right) {
        final leftInitial = _mentionCandidateInitial(left);
        final rightInitial = _mentionCandidateInitial(right);
        final groupCompare = leftInitial.compareTo(rightInitial);
        if (groupCompare != 0) return groupCompare;
        return left.displayName.compareTo(right.displayName);
      });
  }

  int get _selectedCount => _selectedUserIds.length + (_selectedAll ? 1 : 0);

  List<_MentionPickItem> get _selectedItems {
    final items = <_MentionPickItem>[];
    if (_selectedAll) items.add(const _MentionPickItem.all());
    for (final candidate in widget.candidates) {
      if (!_selectedUserIds.contains(candidate.userId)) continue;
      items.add(
        _MentionPickItem.user(
          userId: candidate.userId,
          displayName: candidate.displayName,
        ),
      );
    }
    return items;
  }

  void _toggleMultiSelect() {
    setState(() {
      _multiSelect = true;
    });
  }

  void _cancelMultiSelect() {
    setState(() {
      _multiSelect = false;
      _selectedAll = false;
      _selectedUserIds.clear();
    });
  }

  void _toggleAll() {
    if (!_multiSelect) {
      Navigator.of(context).pop(const _MentionPickResult.all());
      return;
    }
    setState(() {
      _selectedAll = !_selectedAll;
    });
  }

  void _toggleCandidate(ChatMentionCandidate candidate) {
    if (!_multiSelect) {
      Navigator.of(context).pop(
        _MentionPickResult.user(
          userId: candidate.userId,
          displayName: candidate.displayName,
        ),
      );
      return;
    }
    setState(() {
      if (_selectedUserIds.contains(candidate.userId)) {
        _selectedUserIds.remove(candidate.userId);
      } else {
        _selectedUserIds.add(candidate.userId);
      }
    });
  }

  void _completeMultiSelect() {
    final items = _selectedItems;
    if (items.isEmpty) return;
    Navigator.of(context).pop(_MentionPickResult.multiple(items));
  }

  Map<String, List<ChatMentionCandidate>> _groupCandidates(
    List<ChatMentionCandidate> candidates,
  ) {
    final groups = <String, List<ChatMentionCandidate>>{};
    for (final candidate in candidates) {
      final initial = _mentionCandidateInitial(candidate);
      groups.putIfAbsent(initial, () => []).add(candidate);
    }
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final visibleCandidates = _visibleCandidates;
    final groupedCandidates = _groupCandidates(visibleCandidates);
    final groupKeys = groupedCandidates.keys.toList(growable: false);
    return SafeArea(
      top: false,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.72,
        child: Column(
          children: [
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(top: 8, bottom: 10),
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
              child: Row(
                children: [
                  SizedBox(
                    width: 72,
                    child: _multiSelect
                        ? TextButton(
                            onPressed: _cancelMultiSelect,
                            child: const Text('取消'),
                          )
                        : IconButton(
                            visualDensity: VisualDensity.compact,
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close_rounded),
                          ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        '选择提醒的人',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 72,
                    child: _multiSelect
                        ? FilledButton(
                            onPressed: _selectedCount > 0
                                ? _completeMultiSelect
                                : null,
                            style: FilledButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              backgroundColor: const Color(0xFF16C06E),
                              disabledBackgroundColor:
                                  colorScheme.onSurface.withValues(alpha: 0.12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text('完成 ($_selectedCount)'),
                          )
                        : TextButton(
                            onPressed: _toggleMultiSelect,
                            child: const Text('多选'),
                          ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: _MentionSearchField(
                controller: _searchController,
                selectedCandidates: widget.candidates
                    .where((candidate) =>
                        _selectedUserIds.contains(candidate.userId))
                    .toList(growable: false),
                selectedAll: _selectedAll,
                onChanged: (value) => setState(() => _query = value),
              ),
            ),
            if (widget.canMentionAll && _query.trim().isEmpty)
              _MentionTile(
                icon: Icons.campaign_outlined,
                title: '@所有人',
                subtitle: '提醒群内全部成员',
                selected: _selectedAll,
                multiSelect: _multiSelect,
                onTap: _toggleAll,
              ),
            Expanded(
              child: visibleCandidates.isEmpty
                  ? Center(
                      child: Text(
                        _query.trim().isEmpty ? '暂无可提醒成员' : '未找到相关成员',
                        style: TextStyle(
                          fontSize: 14,
                          color: colorScheme.onSurface.withValues(alpha: 0.56),
                        ),
                      ),
                    )
                  : Stack(
                      children: [
                        ListView.builder(
                          padding: EdgeInsets.only(bottom: 12 + bottomPadding),
                          itemCount: groupKeys.length,
                          itemBuilder: (context, groupIndex) {
                            final key = groupKeys[groupIndex];
                            final members = groupedCandidates[key]!;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(18, 14, 0, 6),
                                  child: Text(
                                    key,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: colorScheme.onSurface
                                          .withValues(alpha: 0.56),
                                    ),
                                  ),
                                ),
                                ...members.map(
                                  (candidate) => _MentionTile(
                                    avatarUrl: candidate.avatarUrl,
                                    title: candidate.displayName,
                                    selected: _selectedUserIds
                                        .contains(candidate.userId),
                                    multiSelect: _multiSelect,
                                    onTap: () => _toggleCandidate(candidate),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        Positioned(
                          top: 16,
                          right: 4,
                          bottom: 16 + bottomPadding,
                          child: _MentionIndexRail(labels: groupKeys),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

String _mentionCandidateInitial(ChatMentionCandidate candidate) {
  final name = candidate.displayName.trim();
  if (name.isEmpty) return '#';
  final first = name.characters.first;
  final codeUnit = first.codeUnitAt(0);
  if (codeUnit >= 65 && codeUnit <= 90) return first;
  if (codeUnit >= 97 && codeUnit <= 122) return first.toUpperCase();
  const pinyinInitials = {
    '阿': 'A',
    '艾': 'A',
    '安': 'A',
    '昂': 'A',
    '邦': 'B',
    '半': 'B',
    '保': 'B',
    '别': 'B',
    '波': 'B',
    '蔡': 'C',
    '曹': 'C',
    '陈': 'C',
    '程': 'C',
    '戴': 'D',
    '邓': 'D',
    '丁': 'D',
    '董': 'D',
    '方': 'F',
    '范': 'F',
    '冯': 'F',
    '傅': 'F',
    '高': 'G',
    '郭': 'G',
    '何': 'H',
    '韩': 'H',
    '胡': 'H',
    '黄': 'H',
    '贾': 'J',
    '姜': 'J',
    '蒋': 'J',
    '李': 'L',
    '梁': 'L',
    '林': 'L',
    '刘': 'L',
    '卢': 'L',
    '吕': 'L',
    '罗': 'L',
    '马': 'M',
    '潘': 'P',
    '彭': 'P',
    '任': 'R',
    '沈': 'S',
    '石': 'S',
    '宋': 'S',
    '苏': 'S',
    '孙': 'S',
    '唐': 'T',
    '田': 'T',
    '王': 'W',
    '魏': 'W',
    '吴': 'W',
    '汪': 'W',
    '夏': 'X',
    '谢': 'X',
    '许': 'X',
    '徐': 'X',
    '薛': 'X',
    '杨': 'Y',
    '姚': 'Y',
    '叶': 'Y',
    '余': 'Y',
    '于': 'Y',
    '袁': 'Y',
    '张': 'Z',
    '赵': 'Z',
    '郑': 'Z',
    '钟': 'Z',
    '周': 'Z',
    '朱': 'Z',
  };
  final initial = pinyinInitials[first];
  if (initial != null) return initial;
  return '#';
}

class _MentionSearchField extends StatelessWidget {
  final TextEditingController controller;
  final List<ChatMentionCandidate> selectedCandidates;
  final bool selectedAll;
  final ValueChanged<String> onChanged;

  const _MentionSearchField({
    required this.controller,
    required this.selectedCandidates,
    required this.selectedAll,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final selectedItems = [
      if (selectedAll)
        const ChatMentionCandidate(userId: '__all__', displayName: '所有人'),
      ...selectedCandidates,
    ];
    return Container(
      constraints: const BoxConstraints(minHeight: 48),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          if (selectedItems.isEmpty)
            Icon(
              Icons.search_rounded,
              color: colorScheme.onSurface.withValues(alpha: 0.36),
            )
          else
            ...selectedItems.take(5).map(
                  (candidate) => Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: _MentionAvatar(
                      icon: candidate.userId == '__all__'
                          ? Icons.campaign_outlined
                          : null,
                      avatarUrl: candidate.avatarUrl,
                      title: candidate.displayName,
                      radius: 18,
                    ),
                  ),
                ),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: '搜索',
                hintStyle: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.38),
                  fontSize: 16,
                ),
                isCollapsed: true,
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MentionTile extends StatelessWidget {
  final IconData? icon;
  final String? avatarUrl;
  final String title;
  final String? subtitle;
  final bool selected;
  final bool multiSelect;
  final VoidCallback onTap;

  const _MentionTile({
    this.icon,
    this.avatarUrl,
    required this.title,
    this.subtitle,
    this.selected = false,
    this.multiSelect = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: subtitle == null ? 56 : 64,
        child: Row(
          children: [
            const SizedBox(width: 16),
            if (multiSelect) ...[
              _MentionCheckbox(selected: selected),
              const SizedBox(width: 12),
            ],
            _MentionAvatar(icon: icon, avatarUrl: avatarUrl, title: title),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurface.withValues(alpha: 0.56),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (!multiSelect)
              Icon(
                Icons.chevron_right_rounded,
                color: colorScheme.onSurface.withValues(alpha: 0.28),
              ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}

class _MentionCheckbox extends StatelessWidget {
  final bool selected;

  const _MentionCheckbox({required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? const Color(0xFF16C06E) : Colors.transparent,
        border: selected
            ? null
            : Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.28),
                width: 1.4,
              ),
      ),
      alignment: Alignment.center,
      child: selected
          ? Icon(
              Icons.check_rounded,
              size: 18,
              color: Theme.of(context).colorScheme.surface,
            )
          : null,
    );
  }
}

class _MentionIndexRail extends StatelessWidget {
  final List<String> labels;

  const _MentionIndexRail({required this.labels});

  @override
  Widget build(BuildContext context) {
    if (labels.isEmpty) return const SizedBox.shrink();
    final colorScheme = Theme.of(context).colorScheme;
    return IgnorePointer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_rounded,
            size: 14,
            color: colorScheme.onSurface.withValues(alpha: 0.54),
          ),
          ...labels.map(
            (label) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 1),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: label == labels.first
                      ? const Color(0xFF16C06E)
                      : colorScheme.onSurface.withValues(alpha: 0.72),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MentionAvatar extends StatelessWidget {
  final IconData? icon;
  final String? avatarUrl;
  final String title;
  final double radius;

  const _MentionAvatar({
    this.icon,
    this.avatarUrl,
    required this.title,
    this.radius = 20,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = radius * 2;
    if (icon == null) {
      return UserAvatar(
        avatarUrl: avatarUrl,
        name: title,
        size: size,
        borderRadius: radius * 0.3,
      );
    }
    return CircleAvatar(
      radius: radius,
      backgroundColor: colorScheme.primary.withValues(alpha: 0.12),
      child: Icon(icon, size: radius + 1, color: colorScheme.primary),
    );
  }
}

// ---------------------------------------------------------------------------
// 更多工具面板
// ---------------------------------------------------------------------------

class _ToolsPanel extends StatelessWidget {
  final bool isGroup;
  final double bottomPadding;
  final VoidCallback onPickImages;
  final VoidCallback onTakePhoto;
  final VoidCallback onPickFile;
  final VoidCallback? onVoiceCall;
  final VoidCallback? onVideoCall;
  final VoidCallback? onFavorite;
  final VoidCallback? onSendContactCard;
  final VoidCallback onScheduleMessage;
  final VoidCallback? onQuickReply;
  final VoidCallback? onAiReply;
  final VoidCallback? onTranslate;
  final bool translationAvailable;

  const _ToolsPanel({
    required this.isGroup,
    required this.bottomPadding,
    required this.onPickImages,
    required this.onTakePhoto,
    required this.onPickFile,
    this.onVoiceCall,
    this.onVideoCall,
    required this.onFavorite,
    this.onSendContactCard,
    required this.onScheduleMessage,
    this.onQuickReply,
    this.onAiReply,
    this.onTranslate,
    this.translationAvailable = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tools = [
      _ToolItem(
          icon: Icons.photo_library_outlined,
          label: l10n.chatToolPhotos,
          onTap: onPickImages),
      _ToolItem(
          icon: Icons.camera_alt_outlined,
          label: l10n.chatToolCamera,
          onTap: onTakePhoto),
      _ToolItem(
          icon: Icons.insert_drive_file_outlined,
          label: l10n.chatToolFile,
          onTap: onPickFile),
      _ToolItem(
        icon: Icons.schedule_send_outlined,
        label: '定时消息',
        onTap: onScheduleMessage,
      ),
      _ToolItem(
          icon: Icons.contact_page_outlined,
          label: l10n.chatToolContactCard,
          onTap: () {
            onSendContactCard?.call();
          }),
      if (onQuickReply != null)
        _ToolItem(
          icon: Icons.quickreply_outlined,
          label: '话术',
          onTap: onQuickReply!,
        ),
      if (onAiReply != null)
        _ToolItem(
          icon: Icons.auto_awesome_outlined,
          label: 'AI回复',
          onTap: onAiReply!,
        ),
      if (onTranslate != null)
        _ToolItem(
          icon: Icons.translate_outlined,
          label: l10n.chatToolTranslate,
          onTap: onTranslate!,
          available: translationAvailable,
        ),
      if (!isGroup && onVoiceCall != null)
        _ToolItem(
            icon: Icons.phone_outlined,
            label: l10n.chatToolVoiceCall,
            onTap: onVoiceCall!),
      if (!isGroup && onVideoCall != null)
        _ToolItem(
            icon: Icons.videocam_outlined,
            label: l10n.chatToolVideoCall,
            onTap: onVideoCall!),
      if (onFavorite != null)
        _ToolItem(
            icon: Icons.star_border_rounded,
            label: l10n.chatToolFavorites,
            onTap: onFavorite!),
    ];

    final pages = <List<_ToolItem>>[];
    for (var i = 0; i < tools.length; i += 8) {
      pages.add(tools.skip(i).take(8).toList(growable: false));
    }

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + bottomPadding),
      child: SizedBox(
        height: 178,
        child: PageView.builder(
          itemCount: pages.length,
          physics: pages.length > 1
              ? const PageScrollPhysics()
              : const NeverScrollableScrollPhysics(),
          itemBuilder: (context, pageIndex) {
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 6,
                crossAxisSpacing: 10,
                mainAxisExtent: 82,
              ),
              itemCount: pages[pageIndex].length,
              itemBuilder: (context, index) =>
                  _ToolCell(item: pages[pageIndex][index]),
            );
          },
        ),
      ),
    );
  }
}

class _QuickReplyPickerSheet extends ConsumerStatefulWidget {
  final String? scope;

  const _QuickReplyPickerSheet({required this.scope});

  @override
  ConsumerState<_QuickReplyPickerSheet> createState() =>
      _QuickReplyPickerSheetState();
}

class _QuickReplyPickerSheetState
    extends ConsumerState<_QuickReplyPickerSheet> {
  final _searchController = TextEditingController();
  final _searchDebouncer = Debouncer();
  String _query = '';

  @override
  void dispose() {
    _searchDebouncer.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _searchDebouncer.run(() {
      if (mounted) setState(() => _query = value.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    final repliesAsync =
        ref.watch(customerServiceQuickRepliesProvider(widget.scope));
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.62,
      child: Column(
        children: [
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.only(top: 8, bottom: 8),
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: Row(
              children: [
                Text(
                  '常用话术',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: _QuickReplySheetSearchField(
              controller: _searchController,
              query: _query,
              onChanged: _onSearchChanged,
              onClear: () => setState(() {
                _searchDebouncer.cancel();
                _searchController.clear();
                _query = '';
              }),
            ),
          ),
          Expanded(
            child: repliesAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
              error: (_, __) => _QuickReplyStateView(
                icon: Icons.cloud_off_outlined,
                title: '话术加载失败',
                subtitle: '请稍后重试',
                onRetry: () => ref
                    .read(customerServiceQuickRepliesProvider(widget.scope)
                        .notifier)
                    .refresh(),
              ),
              data: (replies) {
                final filtered = _filterQuickReplyPickerItems(replies, _query);
                if (replies.isEmpty) {
                  return const _QuickReplyStateView(
                    icon: Icons.quickreply_outlined,
                    title: '暂无话术',
                    subtitle: '话术库启用后会显示在这里',
                  );
                }
                if (filtered.isEmpty) {
                  return const _QuickReplyStateView(
                    icon: Icons.search_off_outlined,
                    title: '没有匹配的话术',
                    subtitle: '换个关键词试试',
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, index) {
                    final reply = filtered[index];
                    return _QuickReplyPickerTile(reply: reply);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickReplySheetSearchField extends StatelessWidget {
  final TextEditingController controller;
  final String query;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _QuickReplySheetSearchField({
    required this.controller,
    required this.query,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: '搜索话术',
        prefixIcon: Icon(
          Icons.search,
          color: colorScheme.onSurface.withValues(alpha: 0.42),
        ),
        suffixIcon: query.trim().isEmpty
            ? null
            : IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: onClear,
                icon: Icon(
                  Icons.cancel,
                  size: 18,
                  color: colorScheme.onSurface.withValues(alpha: 0.38),
                ),
              ),
        filled: true,
        fillColor: Theme.of(context).scaffoldBackgroundColor,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

List<CsQuickReply> _filterQuickReplyPickerItems(
  List<CsQuickReply> replies,
  String query,
) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return replies;
  return replies.where((reply) {
    final searchable = [
      reply.title,
      reply.content,
      reply.category,
      reply.scopeLabel,
      ...reply.tags,
    ].join(' ').toLowerCase();
    return searchable.contains(q);
  }).toList(growable: false);
}

class _QuickReplyPickerTile extends StatelessWidget {
  final CsQuickReply reply;

  const _QuickReplyPickerTile({required this.reply});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.of(context).pop(reply),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      reply.title.isNotEmpty ? reply.title : '未命名话术',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    reply.category,
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurface.withValues(alpha: 0.46),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                reply.content,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.35,
                  color: colorScheme.onSurface.withValues(alpha: 0.78),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickReplyStateView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onRetry;

  const _QuickReplyStateView({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 44,
              color: colorScheme.onSurface.withValues(alpha: 0.28),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 13,
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 12),
              TextButton(onPressed: onRetry, child: const Text('重试')),
            ],
          ],
        ),
      ),
    );
  }
}

class _DraftTranslationLanguageSheet extends StatelessWidget {
  const _DraftTranslationLanguageSheet();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.65,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
              child: Text(
                l10n.chatTranslationChooseLanguage,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final language in translationTargetNativeNames.entries)
                    ListTile(
                      key: ValueKey('translation-language-${language.key}'),
                      title: Text(translationTargetOptionLabel(
                          language.key, deviceLocale)),
                      onTap: () => Navigator.pop(context, language.key),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DraftTranslationBar extends StatelessWidget {
  const _DraftTranslationBar({
    required this.state,
    required this.sending,
    required this.canSend,
    required this.onRetry,
    required this.onClose,
    required this.onSend,
  });

  final DraftTranslationState state;
  final bool sending;
  final bool canSend;
  final VoidCallback onRetry;
  final VoidCallback onClose;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final state = this.state;
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    final previewLineHeight = MediaQuery.textScalerOf(context).scale(13) * 1.3;
    final preview = switch (state.status) {
      DraftTranslationStatus.success => state.text,
      DraftTranslationStatus.failed => l10n.chatTranslationFailed,
      DraftTranslationStatus.empty => l10n.chatTranslationEmpty,
      DraftTranslationStatus.idle => l10n.chatTranslationEnterText,
      _ => l10n.chatTranslationTranslating,
    };
    return Container(
      key: const Key('draft-translation-bar'),
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 7, 8, 7),
      decoration: BoxDecoration(
        color: colors.secondaryContainer,
        border: Border(bottom: BorderSide(color: colors.outlineVariant)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: previewLineHeight * 3,
                  child: SingleChildScrollView(
                    key: ObjectKey(state),
                    child: Text(
                      preview,
                      key: const Key('draft-translation-preview'),
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.3,
                        color: colors.onSecondaryContainer,
                      ),
                    ),
                  ),
                ),
                if (state.status == DraftTranslationStatus.failed ||
                    state.status == DraftTranslationStatus.empty)
                  TextButton(
                    onPressed: onRetry,
                    child: Text(l10n.commonRetry),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    key: const Key('send-translated-draft'),
                    onPressed: canSend ? onSend : null,
                    child: Text(
                      sending ? l10n.chatTranslationSending : l10n.commonSend,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  IconButton(
                    key: const Key('close-draft-translation'),
                    onPressed: sending ? null : onClose,
                    icon: const Icon(Icons.close, size: 18),
                    tooltip: l10n.commonClose,
                    constraints:
                        const BoxConstraints(minWidth: 36, minHeight: 36),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Text(
                  translationTargetNativeName(state.targetLanguage),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: colors.onSecondaryContainer,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ToolItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool available;
  const _ToolItem(
      {required this.icon,
      required this.label,
      required this.onTap,
      this.available = true});
}

class _ToolCell extends StatelessWidget {
  final _ToolItem item;
  const _ToolCell({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: item.onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Icon(item.icon,
                size: 28,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: item.available ? 1 : 0.38)),
          ),
          const SizedBox(height: 4),
          Text(
            item.label,
            style: TextStyle(
              fontSize: 11,
              height: 1.15,
              color: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant
                  .withValues(alpha: item.available ? 1 : 0.5),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
