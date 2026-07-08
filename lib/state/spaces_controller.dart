part of 'app_state.dart';

/// Spaces / Notebook behaviour: notebooks list, notebook overlay tabs,
/// sources, notebook chat, report & audio generation, library, player.
extension SpacesController on AppState {
  // ── Notebook open / close / tabs ──────────────────────────────────────────
  Future<void> openNotebook(Notebook n) async {
    nbOpen = true;
    nbTab = 'studio';
    nbName = n.name;
    nbMsgs.clear();
    if (n.name == 'Economic Anomalies') {
      nbSources = economicAnomaliesSources();
    } else {
      final match = RegExp(r'\d+').firstMatch(n.meta);
      final count = int.tryParse(match?.group(0) ?? '1') ?? 1;
      nbSources = [
        for (var i = 0; i < count; i++)
          NotebookSource(
            kind: SourceKind.values[i % 3],
            name: '${n.name} — source ${i + 1}',
            meta: 'added recently',
          ),
      ];
    }
    notify();
  }

  void closeNotebook() {
    nbOpen = false;
    nbSheet = null;
    nbReportOpen = false;
    playerOpen = false;
    notify();
  }

  void setNbTab(String tab) {
    nbTab = tab;
    notify();
  }

  void setStudioVariant(String v) {
    studioVariant = v;
    notify();
  }

  // ── Sources ────────────────────────────────────────────────────────────────
  int get nbSelectedCount => nbSources.where((s) => s.checked).length;
  int get nbTotalSources => nbSources.length;
  bool get nbHasSources => nbSources.isNotEmpty;
  String get nbMetaLine =>
      '${nbSources.length} ${nbSources.length == 1 ? 'source' : 'sources'} '
      '· updated just now';

  void toggleSource(int i) {
    nbSources[i].checked = !nbSources[i].checked;
    notify();
  }

  // ── New notebook ────────────────────────────────────────────────────────
  void openNewNb() {
    newNbOpen = true;
    newNbTitle = '';
    notify();
  }

  void closeNewNb() {
    newNbOpen = false;
    notify();
  }

  void onNewNbTitle(String v) {
    newNbTitle = v;
    notify();
  }

  void createNotebook() {
    final title = newNbTitle.trim();
    if (title.isEmpty) return;
    final initials = title
        .split(RegExp(r'\s+'))
        .take(2)
        .map((w) => w.isEmpty ? '' : w[0])
        .join()
        .toUpperCase();
    final nb = Notebook(
      name: title,
      initials: initials,
      meta: '0 sources · just now',
      outputs: '',
      hasOutputs: false,
      accent: true,
    );
    notebooks = [
      nb,
      ...notebooks.map((x) => x.copyWith(accent: false)),
    ];
    newNbOpen = false;
    newNbTitle = '';
    nbOpen = true;
    nbTab = 'sources';
    nbName = title;
    nbSources = [];
    nbMsgs.clear();
    addSrcOpen = true;
    addSrcQuery = '';
    notify();
    flashToast('Notebook created');
  }

  // ── Add source sheet ────────────────────────────────────────────────────
  void openAddSrc() {
    addSrcOpen = true;
    addSrcQuery = '';
    notify();
  }

  void closeAddSrc() {
    addSrcOpen = false;
    notify();
  }

  void onAddSrcQuery(String v) {
    addSrcQuery = v;
    notify();
  }

  void setAddSrcMode(String m) {
    addSrcMode = m;
    notify();
  }

  void addSource(String kind) {
    final q = addSrcQuery.trim();
    final src = switch (kind) {
      'search' => NotebookSource(
        kind: SourceKind.url,
        name: q.isEmpty ? 'Web result — SCAD open data' : q,
        meta: 'web page · just now',
      ),
      'file' => NotebookSource(
        kind: SourceKind.pdf,
        name: 'Uploaded document.pdf',
        meta: 'just now',
      ),
      'link' => NotebookSource(
        kind: SourceKind.url,
        name: q.isEmpty ? 'Linked web page' : q,
        meta: 'web page · just now',
      ),
      _ => NotebookSource(
        kind: SourceKind.txt,
        name: 'Pasted text',
        meta: 'just now',
      ),
    };
    nbSources = [...nbSources, src];
    addSrcOpen = false;
    addSrcQuery = '';
    notify();
    flashToast('Source added');
  }

  // ── Notebook chat ───────────────────────────────────────────────────────
  List<String> get nbChatStarters => kNotebookChatStarters;
  bool get nbHasMsgs => nbMsgs.isNotEmpty;

  void onNbDraft(String v) {
    nbDraft = v;
    notify();
  }

  Future<void> nbSend([String? q]) async {
    final text = (q ?? nbDraft).trim();
    if (text.isEmpty) return;
    _clearNbDictTimers();
    nbDicting = false;
    nbDraft = '';
    final now = DateTime.now().microsecondsSinceEpoch;
    final botId = now + 1;
    nbMsgs
      ..add(NotebookMessage(id: now, isUser: true, text: text))
      ..add(NotebookMessage(id: botId, isUser: false, thinking: true));
    notify();
    final answer = await repo.fetchNotebookAnswer(text);
    Timer(const Duration(milliseconds: 1400), () {
      for (final m in nbMsgs) {
        if (m.id == botId) {
          m
            ..thinking = false
            ..text = answer;
        }
      }
      notify();
    });
  }

  // ── Notebook dictation ─────────────────────────────────────────────────
  String get nbDictText =>
      kNotebookDictationPhrase.split(' ').take(_nbDictWords).join(' ');
  String get nbDictTime =>
      '${_nbDictSec ~/ 60}:${(_nbDictSec % 60).toString().padLeft(2, '0')}';

  void _clearNbDictTimers() {
    for (final t in _nbDictTimers) {
      t.cancel();
    }
    _nbDictTimers.clear();
  }

  void nbStartDict() {
    _clearNbDictTimers();
    nbDicting = true;
    _nbDictWords = 0;
    _nbDictSec = 0;
    _nbDictPrev = nbDraft;
    notify();
    _nbDictTimers
      ..add(
        Timer.periodic(const Duration(seconds: 1), (_) {
          _nbDictSec += 1;
          notify();
        }),
      )
      ..add(
        Timer.periodic(const Duration(milliseconds: 300), (_) {
          final max = kNotebookDictationPhrase.split(' ').length;
          if (_nbDictWords < max) {
            _nbDictWords += 1;
            notify();
          }
        }),
      );
  }

  void nbStopDict({required bool keep}) {
    _clearNbDictTimers();
    final spoken = kNotebookDictationPhrase
        .split(' ')
        .take(_nbDictWords)
        .join(' ');
    final base = _nbDictPrev.trim();
    nbDicting = false;
    nbDraft = keep ? (base.isNotEmpty ? '$base $spoken' : spoken) : _nbDictPrev;
    notify();
  }

  // ── Studio output selection ───────────────────────────────────────────────
  void setOutType(String t) {
    outType = t;
    notify();
  }

  void pickTemplate(int i) {
    pickedTemplate = i;
    notify();
  }

  void pickFormat(int i) {
    pickedFormat = i;
    notify();
  }

  void pickLength(int i) {
    pickedLength = i;
    notify();
  }

  void onCustomText(String v) {
    customText = v;
    notify();
  }

  void onFocusText(String v) {
    focusText = v;
    notify();
  }

  void onTplName(String v) {
    tplName = v;
    notify();
  }

  void toggleSaveTpl() {
    saveTpl = !saveTpl;
    notify();
  }

  void openReportSheet() {
    nbSheet = 'report';
    notify();
  }

  void openAudioSheet() {
    nbSheet = 'audio';
    notify();
  }

  void openDetailSheet() {
    nbSheet = outType == 'report' ? 'report' : 'audio';
    notify();
  }

  void closeSheet() {
    nbSheet = null;
    notify();
  }

  void quickGenerate() => startGeneration(outType);

  // ── Generation ──────────────────────────────────────────────────────────
  bool get generating => genState != null;
  String get genTitle => genState?.title ?? '';
  String get genStepLabel =>
      genState == null ? '' : '${kGenerationStepLabels[genState!.step]}…';
  bool get genIsAudio => genState?.kind == OutputKind.audio;

  void startGeneration(String type) {
    _genTimer?.cancel();
    final kind = type == 'audio' ? OutputKind.audio : OutputKind.report;
    final title = kind == OutputKind.report
        ? '${kReportTemplates[pickedTemplate].$1} — Economic Anomalies'
        : '${kAudioFormats[pickedFormat].$1} audio — Economic Anomalies';
    nbSheet = null;
    nbTab = 'studio';
    genState = GenerationState(kind: kind, title: title, step: 0);
    notify();
    void advance() {
      final g = genState;
      if (g == null) return;
      if (g.step >= 2) {
        libExtra.insert(
          0,
          LibraryItem(
            kind: kind,
            title: title,
            meta: kind == OutputKind.report
                ? 'Report · just now'
                : 'Audio · 8:02 · just now',
            isNew: true,
          ),
        );
        genState = null;
        notify();
      } else {
        genState = g.copyWith(step: g.step + 1);
        notify();
        _genTimer = Timer(const Duration(milliseconds: 1900), advance);
      }
    }

    _genTimer = Timer(const Duration(milliseconds: 1900), advance);
  }

  void cancelGen() {
    _genTimer?.cancel();
    genState = null;
    notify();
  }

  // ── Library ────────────────────────────────────────────────────────────
  List<LibraryItem> get libItems => [...libExtra, ...kBaseLibrary];
  String get libCount => '${libItems.length} items';

  void openLibraryItem(LibraryItem item) {
    if (item.kind == OutputKind.report) {
      nbReportOpen = true;
    } else {
      playerOpen = true;
      playerPlaying = true;
    }
    notify();
  }

  void openNbReport() {
    nbReportOpen = true;
    notify();
  }

  void closeNbReport() {
    nbReportOpen = false;
    nbExportOpen = false;
    notify();
  }

  void toggleNbExport() {
    nbExportOpen = !nbExportOpen;
    notify();
  }

  // ── Audio player ────────────────────────────────────────────────────────
  void closePlayer() {
    playerOpen = false;
    notify();
  }

  void togglePlayer() {
    playerPlaying = !playerPlaying;
    notify();
  }

  String get playerTime =>
      '${playerSec ~/ 60}:${(playerSec % 60).toString().padLeft(2, '0')}';
  double get playerProgress => (playerSec / 553).clamp(0.0, 1.0);

  // ── Toast ──────────────────────────────────────────────────────────────
  void flashToast(String msg) {
    _toastTimer?.cancel();
    toast = msg;
    notify();
    _toastTimer = Timer(const Duration(milliseconds: 1900), () {
      toast = '';
      notify();
    });
  }
}
