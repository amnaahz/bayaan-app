import 'dart:async';

import 'package:bayaan/data/mock/mock_answers.dart';
import 'package:bayaan/data/mock/mock_data.dart';
import 'package:bayaan/data/models/agent_models.dart';
import 'package:bayaan/data/models/chat_models.dart';
import 'package:bayaan/data/models/research_models.dart';
import 'package:bayaan/data/models/space_models.dart';
import 'package:bayaan/data/models/ui_models.dart';
import 'package:bayaan/data/repositories/bayaan_repository.dart';
import 'package:flutter/material.dart';

part 'voice_controller.dart';
part 'deep_research_controller.dart';
part 'spaces_controller.dart';
part 'drawer_controller.dart';
part 'agents_controller.dart';

/// Top-level navigation destinations.
enum AppView { home, chat, spaces, artifacts, agents, settings }

/// Search scope selected in the composer mode menu.
enum SearchMode { normal, web, deep }

/// Response style selected in the composer mode menu.
enum ResponseMode { standard, concise, reasoning }

/// Phase of the live voice conversation.
enum VoicePhase { listening, thinking, speaking, followup }

/// Central application controller.
///
/// A faithful Flutter port of the design's single stateful component: one
/// object holds the whole UI state, and the methods that drive it (including
/// the timers that simulate thinking, streaming, voice and research). Methods
/// are grouped into same-library `part` extensions (voice, deep research,
/// spaces, drawer) so each feature stays readable while sharing this state.
class AppState extends ChangeNotifier {
  AppState(this.repo, {this.userName = 'Amena Alzaabi'}) {
    _init();
  }

  final BayaanRepository repo;
  final String userName;

  /// Notifies listeners. Exposed so the feature `part` extensions can trigger
  /// rebuilds (they cannot call the protected [notifyListeners] directly).
  void notify() => notifyListeners();

  // ── View & theme ──────────────────────────────────────────────────────────
  AppView _view = AppView.home;
  AppView get view => _view;
  bool get isHome => _view == AppView.home;
  bool get inChat => _view == AppView.chat;

  bool _isDark = true;
  bool get isDark => _isDark;
  ThemeMode get themeMode => _isDark ? ThemeMode.dark : ThemeMode.light;
  void setDark() {
    _isDark = true;
    notifyListeners();
  }

  void setLight() {
    _isDark = false;
    notifyListeners();
  }

  bool notifOn = true;
  void toggleNotif() {
    notifOn = !notifOn;
    notifyListeners();
  }

  String get firstName => userName.split(' ').first;
  String get userInitials {
    final parts = userName.trim().split(RegExp(r'\s+'));
    final letters = parts.map((w) => w.isEmpty ? '' : w[0]).join();
    return letters.length > 2
        ? letters.substring(0, 2).toUpperCase()
        : letters.toUpperCase();
  }

  String get greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String get dateLine {
    final now = DateTime.now();
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${weekdays[now.weekday - 1]}, ${now.day} ${months[now.month - 1]} '
        '${now.year}';
  }

  // ── Home rotating tagline ──────────────────────────────────────────────────
  int _homeIdx = 0;
  bool _homeFade = false;
  Timer? _homeTimer;
  Timer? _homeSwap;
  String get homeLine => kHomeLines[_homeIdx % kHomeLines.length];
  double get homeLineOpacity => _homeFade ? 0 : 1;

  // ── Chat ────────────────────────────────────────────────────────────────
  final List<ChatMessage> msgs = [];
  final ScrollController chatScroll = ScrollController();
  String draft = '';
  final List<Attachment> attachments = [];
  int? _copiedMsgId;

  SearchMode mode = SearchMode.normal;
  ResponseMode respMode = ResponseMode.standard;
  bool modeMenuOpen = false;
  bool attachMenuOpen = false;

  /// Which mode submenu is expanded (`SearchMode.normal`/`web`) or null.
  SearchMode? submenuFor;

  Timer? _thinkTimer;
  Timer? _streamTimer;

  bool copiedFor(int id) => _copiedMsgId == id;

  // ── Voice state ───────────────────────────────────────────────────────────
  bool voiceOpen = false;
  VoicePhase voicePhase = VoicePhase.listening;
  bool voiceMuted = false;
  int _voiceElapsed = 0;
  int vUserWords = 0;
  int vBotWords = 0;
  final List<Timer> _voiceTimers = [];

  // ── Deep Research state ─────────────────────────────────────────────────
  bool drOpen = false;
  DrPhase drPhase = DrPhase.clarify;
  String drQuery = '';
  int drQIdx = 0;
  List<Object?> drAns = [null, null, <int>[]];
  List<String> drPlan = [];
  int drResearchIdx = -1;
  bool drReportOpen = false;
  bool drExportOpen = false;
  final List<Timer> _drTimers = [];

  // ── Spaces / Notebook state ─────────────────────────────────────────────
  List<Notebook> notebooks = [];
  bool nbOpen = false;
  String nbName = 'Economic Anomalies';
  String nbTab = 'studio';
  List<NotebookSource> nbSources = [];
  final List<NotebookMessage> nbMsgs = [];
  String nbDraft = '';
  bool nbDicting = false;
  int _nbDictWords = 0;
  int _nbDictSec = 0;
  String _nbDictPrev = '';
  final List<Timer> _nbDictTimers = [];

  String outType = 'report';
  int pickedTemplate = 0;
  int pickedFormat = 0;
  int pickedLength = 1;
  String customText = '';
  bool saveTpl = false;
  String tplName = '';
  String focusText = '';

  /// Which studio detail sheet is open: `'report'`, `'audio'` or null.
  String? nbSheet;
  GenerationState? genState;
  Timer? _genTimer;
  final List<LibraryItem> libExtra = [];

  bool nbReportOpen = false;
  bool nbExportOpen = false;

  bool playerOpen = false;
  bool playerPlaying = true;
  int playerSec = 74;
  Timer? _playerTimer;

  bool newNbOpen = false;
  String newNbTitle = '';

  bool addSrcOpen = false;
  String addSrcMode = 'web';
  String addSrcQuery = '';

  String toast = '';
  Timer? _toastTimer;

  /// Studio layout variant (`'A'` or `'B'`) shown in the notebook studio tab.
  String studioVariant = 'A';

  // ── Drawer state ────────────────────────────────────────────────────────
  bool drawerOpen = false;
  List<ChatThread> chats = [];
  List<ChatFolder> folders = [];
  bool newFolderOpen = false;
  String newFolderName = '';
  bool foldersNavOpen = false;
  int? renamingId;
  String renameDraft = '';
  int? _pendingChatForFolder;

  // ── Agents state ──────────────────────────────────────────────────────────
  List<Agent> agents = [];

  /// Agent whose profile overlay is open (null when closed).
  Agent? activeAgent;
  bool get agentOpen => activeAgent != null;

  /// Agent currently applied to the composer (via slash picker / attach menu).
  Agent? attachedAgent;

  /// Composer slash-command picker.
  bool slashOpen = false;
  String slashQuery = '';

  // Create-agent modal.
  bool newAgentOpen = false;
  String naName = '';
  String naDesc = '';
  String naInstr = '';
  bool naGenerating = false;
  bool naToolsOpen = false;
  bool naAdvOpen = false;
  bool naToolWeb = false;
  ResponseMode naResp = ResponseMode.standard;
  bool naViz = true;
  int naScope = 0;
  Timer? _naGenTimer;

  void _init() {
    _homeTimer = Timer.periodic(const Duration(milliseconds: 4200), (_) {
      if (_view != AppView.home) return;
      _homeFade = true;
      notifyListeners();
      _homeSwap = Timer(const Duration(milliseconds: 380), () {
        _homeIdx = (_homeIdx + 1) % kHomeLines.length;
        _homeFade = false;
        notifyListeners();
      });
    });
    _playerTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (playerOpen && playerPlaying) {
        playerSec = (playerSec + 1).clamp(0, 553);
        notifyListeners();
      }
    });
    unawaited(_seed());
  }

  Future<void> _seed() async {
    chats = await repo.fetchChats();
    folders = await repo.fetchFolders();
    notebooks = await repo.fetchNotebooks();
    agents = await repo.fetchAgents();
    nbSources = await repo.fetchNotebookSources('Economic Anomalies');
    notifyListeners();
  }

  void _closeMenus() {
    modeMenuOpen = false;
    submenuFor = null;
    attachMenuOpen = false;
  }

  void onDraftChanged(String value) {
    draft = value;
    notifyListeners();
  }

  void primaryAction() {
    if (draft.trim().isNotEmpty) {
      askQuery(draft.trim());
    } else {
      startVoice();
    }
  }

  void askStarter(Starter s) => askKey(s.answerKey);

  void askKey(String key) => unawaited(_ask(key: key));

  void askQuery(String query) => unawaited(_ask(query: query));

  Future<void> _ask({String? key, String? query}) async {
    if (mode == SearchMode.deep) {
      startDeepResearch(query);
      return;
    }
    _thinkTimer?.cancel();
    _streamTimer?.cancel();

    final answer = key != null
        ? await repo.fetchAnswer(key)
        : await repo.fetchAnswerForQuery(query ?? '');
    final questionText = query ?? answer.question;
    final now = DateTime.now().microsecondsSinceEpoch;
    final botId = now + 1;

    msgs
      ..add(ChatMessage(id: now, role: MessageRole.user, text: questionText))
      ..add(
        ChatMessage(
          id: botId,
          role: MessageRole.bot,
          fullText: answer.text,
          phase: MessagePhase.thinking,
          thinkingLabel: answer.thinkingLabel,
          chartTitle: answer.chartTitle,
          chartUnit: answer.chartUnit,
          bars: answer.bars,
          stats: answer.stats,
          sources: answer.sources,
          followups: answer.followups,
          answerKey: answer.key,
        ),
      );

    _view = AppView.chat;
    drawerOpen = false;
    voiceOpen = false;
    _closeMenus();
    attachments.clear();
    draft = '';
    notifyListeners();
    _scrollChatToEnd();

    final words = answer.text.split(' ').length;
    _thinkTimer = Timer(const Duration(milliseconds: 1100), () {
      final bot = _msgById(botId);
      if (bot == null) return;
      bot.phase = MessagePhase.streaming;
      notifyListeners();
      _streamTimer = Timer.periodic(const Duration(milliseconds: 55), (t) {
        final m = _msgById(botId);
        if (m == null) {
          t.cancel();
          return;
        }
        m.shownWords += 1;
        if (m.shownWords >= words) {
          m.phase = MessagePhase.done;
          t.cancel();
        }
        notifyListeners();
        _scrollChatToEnd();
      });
    });
  }

  ChatMessage? _msgById(int id) {
    for (final m in msgs) {
      if (m.id == id) return m;
    }
    return null;
  }

  void _scrollChatToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (chatScroll.hasClients) {
        chatScroll.jumpTo(chatScroll.position.maxScrollExtent);
      }
    });
  }

  void setVote(int id, MessageVote vote) {
    final m = _msgById(id);
    if (m == null) return;
    m.vote = m.vote == vote ? null : vote;
    notifyListeners();
  }

  void copyMessage(int id) {
    _copiedMsgId = id;
    notifyListeners();
    Timer(const Duration(milliseconds: 1600), () {
      if (_copiedMsgId == id) {
        _copiedMsgId = null;
        notifyListeners();
      }
    });
  }

  void regenerate(ChatMessage m) =>
      askKey(m.answerKey ?? pickAnswerFor(m.fullText));

  void newChat() {
    _thinkTimer?.cancel();
    _streamTimer?.cancel();
    _view = AppView.home;
    msgs.clear();
    drawerOpen = false;
    draft = '';
    notifyListeners();
  }

  // ── Composer menus ────────────────────────────────────────────────────────
  void toggleModeMenu() {
    modeMenuOpen = !modeMenuOpen;
    submenuFor = null;
    attachMenuOpen = false;
    notifyListeners();
  }

  void toggleAttachMenu() {
    attachMenuOpen = !attachMenuOpen;
    modeMenuOpen = false;
    submenuFor = null;
    notifyListeners();
  }

  void closeMenus() {
    _closeMenus();
    notifyListeners();
  }

  void setModeNormal() {
    mode = SearchMode.normal;
    submenuFor = SearchMode.normal;
    notifyListeners();
  }

  void setModeWeb() {
    mode = SearchMode.web;
    submenuFor = SearchMode.web;
    if (respMode == ResponseMode.reasoning) respMode = ResponseMode.standard;
    notifyListeners();
  }

  void setModeDeep() {
    mode = SearchMode.deep;
    modeMenuOpen = false;
    submenuFor = null;
    notifyListeners();
  }

  void setResponseMode(ResponseMode m) {
    respMode = m;
    modeMenuOpen = false;
    submenuFor = null;
    notifyListeners();
  }

  void addAttachment(AttachmentKind kind, String name) {
    attachments.add(
      Attachment(
        id: DateTime.now().microsecondsSinceEpoch,
        kind: kind,
        name: name,
      ),
    );
    attachMenuOpen = false;
    notifyListeners();
  }

  void removeAttachment(int id) {
    attachments.removeWhere((a) => a.id == id);
    notifyListeners();
  }

  String get modeLabel {
    final base = switch (mode) {
      SearchMode.normal => 'Normal',
      SearchMode.web => 'Web Search',
      SearchMode.deep => 'Deep Research',
    };
    if (mode != SearchMode.deep && respMode != ResponseMode.standard) {
      final suffix = respMode == ResponseMode.concise ? 'Concise' : 'Reasoning';
      return '$base · $suffix';
    }
    return base;
  }

  String get composerPlaceholder =>
      _view == AppView.chat ? 'Ask a follow-up…' : 'Ask about UAE statistics…';

  // ── Dictation (composer mic) ──────────────────────────────────────────────
  bool dictating = false;
  int _dictWords = 0;
  int _dictSec = 0;
  String _dictPrevDraft = '';
  final List<Timer> _dictTimers = [];

  String get dictText => kDictationPhrase.split(' ').take(_dictWords).join(' ');
  String get dictTime =>
      '${_dictSec ~/ 60}:${(_dictSec % 60).toString().padLeft(2, '0')}';

  void _clearDictTimers() {
    for (final t in _dictTimers) {
      t.cancel();
    }
    _dictTimers.clear();
  }

  void startDictation() {
    _clearDictTimers();
    dictating = true;
    _dictWords = 0;
    _dictSec = 0;
    _dictPrevDraft = draft;
    _closeMenus();
    notifyListeners();
    _dictTimers
      ..add(
        Timer.periodic(const Duration(seconds: 1), (_) {
          _dictSec += 1;
          notifyListeners();
        }),
      )
      ..add(
        Timer.periodic(const Duration(milliseconds: 300), (_) {
          final max = kDictationPhrase.split(' ').length;
          if (_dictWords < max) {
            _dictWords += 1;
            notifyListeners();
          }
        }),
      );
  }

  void stopDictation({required bool keep}) {
    _clearDictTimers();
    final spoken = kDictationPhrase.split(' ').take(_dictWords).join(' ');
    final base = _dictPrevDraft.trim();
    dictating = false;
    draft = keep
        ? (base.isNotEmpty ? '$base $spoken' : spoken)
        : _dictPrevDraft;
    notifyListeners();
  }

  // ── Navigation ─────────────────────────────────────────────────────────────
  void goHome() {
    _view = AppView.home;
    _closeMenus();
    drawerOpen = false;
    notifyListeners();
  }

  void goSpaces() {
    _view = AppView.spaces;
    _closeMenus();
    drawerOpen = false;
    notifyListeners();
  }

  void goArtifacts() {
    _view = AppView.artifacts;
    _closeMenus();
    drawerOpen = false;
    notifyListeners();
  }

  void goSettings() {
    _view = AppView.settings;
    _closeMenus();
    drawerOpen = false;
    notifyListeners();
  }

  bool get isChatNav => _view == AppView.home || _view == AppView.chat;
  bool get isSpacesNav => _view == AppView.spaces;
  bool get isArtifactsNav => _view == AppView.artifacts;
  bool get isAgentsNav => _view == AppView.agents;

  bool get showComposer => _view == AppView.home || _view == AppView.chat;
  bool get showLogo => _view == AppView.home;
  String? get sectionTitle => switch (_view) {
    AppView.spaces => 'Spaces',
    AppView.artifacts => 'Artifacts',
    AppView.agents => 'Agents',
    AppView.settings => 'Settings',
    _ => null,
  };

  // ── Report viewer (artifacts) ──────────────────────────────────────────────
  bool reportOpen = false;
  void openArtifactReport() {
    reportOpen = true;
    notifyListeners();
  }

  void closeArtifactReport() {
    reportOpen = false;
    notifyListeners();
  }

  // ── Sources panel (citations behind an answer) ──────────────────────────────
  bool sourcesOpen = false;
  void openSources() {
    sourcesOpen = true;
    notifyListeners();
  }

  void closeSources() {
    sourcesOpen = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _homeTimer?.cancel();
    _homeSwap?.cancel();
    _thinkTimer?.cancel();
    _streamTimer?.cancel();
    _clearDictTimers();
    _clearVoiceTimers();
    _clearDrTimers();
    _clearNbDictTimers();
    _genTimer?.cancel();
    _playerTimer?.cancel();
    _naGenTimer?.cancel();
    _toastTimer?.cancel();
    chatScroll.dispose();
    super.dispose();
  }
}
