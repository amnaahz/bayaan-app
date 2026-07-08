part of 'app_state.dart';

/// Deep Research multi-phase flow behaviour and derived view values.
extension DeepResearchController on AppState {
  void _clearDrTimers() {
    for (final t in _drTimers) {
      t.cancel();
    }
    _drTimers.clear();
  }

  void startDeepResearch([String? q]) {
    _clearDrTimers();
    drOpen = true;
    drPhase = DrPhase.clarify;
    drQIdx = 0;
    drAns = [null, null, <int>[]];
    drQuery = (q == null || q.trim().isEmpty)
        ? 'Do a study on unemployment in Abu Dhabi'
        : q.trim();
    drPlan = [...kDrPlanDefault];
    drResearchIdx = -1;
    drReportOpen = false;
    drExportOpen = false;
    _closeMenus();
    draft = '';
    notify();
  }

  DrQuestion get drCurrentQuestion => kDrQuestions[drQIdx];
  bool get drCanBack => drQIdx > 0;
  String get drQCount => 'Question ${drQIdx + 1}/${kDrQuestions.length}';

  bool drIsOptionSelected(int i) {
    final ans = drAns[drQIdx];
    if (drCurrentQuestion.multi) {
      return (ans! as List<int>).contains(i);
    }
    return ans == i;
  }

  void drPick(int i) {
    if (drCurrentQuestion.multi) {
      final cur = List<int>.from(drAns[drQIdx]! as List<int>);
      if (cur.contains(i)) {
        cur.remove(i);
      } else {
        cur.add(i);
      }
      drAns[drQIdx] = cur;
    } else {
      drAns[drQIdx] = i;
    }
    notify();
  }

  void drBack() {
    drQIdx = (drQIdx - 1).clamp(0, kDrQuestions.length - 1);
    notify();
  }

  void drAdvanceClarify() {
    if (drQIdx < kDrQuestions.length - 1) {
      drQIdx += 1;
      notify();
    } else {
      drPhase = DrPhase.plan;
      notify();
      _drTimers.add(
        Timer(const Duration(milliseconds: 1700), () {
          drPhase = DrPhase.approval;
          notify();
        }),
      );
    }
  }

  void drRemovePlan(int i) {
    drPlan = [
      for (var j = 0; j < drPlan.length; j++)
        if (j != i) drPlan[j],
    ];
    notify();
  }

  void drRun() {
    drPhase = DrPhase.research;
    drResearchIdx = 0;
    notify();
    _drTimers.add(
      Timer.periodic(const Duration(milliseconds: 1300), (_) {
        if (drResearchIdx < drPlan.length - 1) {
          drResearchIdx += 1;
          notify();
        } else {
          _clearDrTimers();
          drPhase = DrPhase.synth;
          drResearchIdx = drPlan.length;
          notify();
          _drTimers.add(
            Timer(const Duration(milliseconds: 2000), () {
              drPhase = DrPhase.done;
              notify();
            }),
          );
        }
      }),
    );
  }

  void drOpenReport() {
    drReportOpen = true;
    drExportOpen = false;
    notify();
  }

  void drCloseReport() {
    drReportOpen = false;
    drExportOpen = false;
    notify();
  }

  void drToggleExport() {
    drExportOpen = !drExportOpen;
    notify();
  }

  void drClose() {
    _clearDrTimers();
    drOpen = false;
    drReportOpen = false;
    drExportOpen = false;
    notify();
  }

  void disposeDeepResearch() => _clearDrTimers();

  // ── Derived view values ────────────────────────────────────────────────────
  int get _phaseIdx => switch (drPhase) {
    DrPhase.clarify => 0,
    DrPhase.plan => 1,
    DrPhase.approval => 2,
    DrPhase.research => 3,
    DrPhase.synth => 4,
    DrPhase.done => 5,
  };

  bool drStepDone(int i) =>
      _phaseIdx > i || (drPhase == DrPhase.done && i == 5);
  bool drStepActive(int i) => _phaseIdx == i;

  bool drResearchRowDone(int i) =>
      drResearchIdx > i || drPhase == DrPhase.synth || drPhase == DrPhase.done;
  bool drResearchRowActive(int i) =>
      drPhase == DrPhase.research && drResearchIdx == i;
  String drResearchStatus(int i) => kDrStatuses[i % kDrStatuses.length];

  int get _drDoneCount => (drPhase == DrPhase.synth || drPhase == DrPhase.done)
      ? drPlan.length
      : (drResearchIdx < 0 ? 0 : drResearchIdx);
  int get drPct =>
      drPlan.isEmpty ? 0 : ((_drDoneCount / drPlan.length) * 100).round();
}
