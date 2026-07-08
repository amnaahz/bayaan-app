part of 'app_state.dart';

/// Live voice-conversation behaviour and derived view values.
extension VoiceController on AppState {
  static const String _q = kVoiceQuestion;

  String get _answerText => kMockAnswers['tourism']!.text;

  void _clearVoiceTimers() {
    for (final t in _voiceTimers) {
      t.cancel();
    }
    _voiceTimers.clear();
  }

  void startVoice() {
    _clearVoiceTimers();
    voiceOpen = true;
    _closeMenus();
    voicePhase = VoicePhase.listening;
    voiceMuted = false;
    _voiceElapsed = 0;
    vUserWords = 0;
    vBotWords = 0;
    notify();

    _voiceTimers.add(
      Timer.periodic(const Duration(seconds: 1), (_) {
        _voiceElapsed += 1;
        notify();
      }),
    );

    final qWords = _q.split(' ').length;
    final aWords = _answerText.split(' ').length;

    _voiceTimers.add(
      Timer(const Duration(milliseconds: 600), () {
        final ut = Timer.periodic(const Duration(milliseconds: 175), (t) {
          vUserWords += 1;
          if (vUserWords >= qWords) t.cancel();
          notify();
        });
        _voiceTimers.add(ut);
      }),
    );

    final userDoneAt = 600 + qWords * 175;
    _voiceTimers.add(
      Timer(Duration(milliseconds: userDoneAt + 450), () {
        voicePhase = VoicePhase.thinking;
        notify();
      }),
    );
    _voiceTimers.add(
      Timer(Duration(milliseconds: userDoneAt + 1900), () {
        voicePhase = VoicePhase.speaking;
        notify();
        final bt = Timer.periodic(const Duration(milliseconds: 95), (t) {
          vBotWords += 1;
          if (vBotWords >= aWords) {
            t.cancel();
            voicePhase = VoicePhase.followup;
          }
          notify();
        });
        _voiceTimers.add(bt);
      }),
    );
  }

  void toggleMute() {
    voiceMuted = !voiceMuted;
    notify();
  }

  void endVoice() {
    final insert = vBotWords > 3;
    _clearVoiceTimers();
    if (!insert) {
      voiceOpen = false;
      notify();
      return;
    }
    final a = kMockAnswers['tourism']!;
    final now = DateTime.now().microsecondsSinceEpoch;
    msgs
      ..add(ChatMessage(id: now, role: MessageRole.user, text: _q))
      ..add(
        ChatMessage(
          id: now + 1,
          role: MessageRole.bot,
          fullText: a.text,
          shownWords: a.text.split(' ').length,
          thinkingLabel: a.thinkingLabel,
          chartTitle: a.chartTitle,
          chartUnit: a.chartUnit,
          bars: a.bars,
          stats: a.stats,
          sources: a.sources,
          followups: a.followups,
          answerKey: a.key,
        ),
      );
    voiceOpen = false;
    _view = AppView.chat;
    notify();
    _scrollChatToEnd();
  }

  void voiceToText() {
    _clearVoiceTimers();
    voiceOpen = false;
    draft = _q;
    notify();
  }

  void disposeVoice() => _clearVoiceTimers();

  // ── Derived voice view values ─────────────────────────────────────────────
  String get voiceElapsedLabel =>
      '${_voiceElapsed ~/ 60}:${(_voiceElapsed % 60).toString().padLeft(2, '0')}';

  bool get vListening =>
      voicePhase == VoicePhase.listening || voicePhase == VoicePhase.followup;
  bool get vThinking => voicePhase == VoicePhase.thinking;
  bool get vSpeaking => voicePhase == VoicePhase.speaking;
  bool get vWave => voicePhase == VoicePhase.speaking;
  bool get vNotSpeaking => voicePhase != VoicePhase.speaking;
  bool get vAnswerVisible =>
      voicePhase == VoicePhase.speaking || voicePhase == VoicePhase.followup;
  bool get vShowUser =>
      voicePhase == VoicePhase.listening || voicePhase == VoicePhase.thinking;
  bool get vUserTyping =>
      voicePhase == VoicePhase.listening && vUserWords < _q.split(' ').length;
  bool get vBotTyping => voicePhase == VoicePhase.speaking;

  String get voiceUserShown => _q.split(' ').take(vUserWords).join(' ');
  String get voiceBotShown => _answerText.split(' ').take(vBotWords).join(' ');
  String get voiceQuestion => _q;

  List<VoiceChip> get voiceChips =>
      kVoiceChips.where((c) => vBotWords >= c.atWord).toList();

  String get phaseLabel => switch (voicePhase) {
    VoicePhase.listening => 'LISTENING',
    VoicePhase.thinking => 'CONSULTING DATA',
    VoicePhase.speaking => 'BAYAAN SPEAKING',
    VoicePhase.followup => 'LISTENING',
  };

  bool get phaseIsThinking => voicePhase == VoicePhase.thinking;

  Duration get ringSpeed => switch (voicePhase) {
    VoicePhase.listening => const Duration(seconds: 7),
    VoicePhase.thinking => const Duration(milliseconds: 2600),
    VoicePhase.speaking => const Duration(milliseconds: 1300),
    VoicePhase.followup => const Duration(seconds: 7),
  };

  Duration get orbSpeed => switch (voicePhase) {
    VoicePhase.listening => const Duration(milliseconds: 2600),
    VoicePhase.thinking => const Duration(seconds: 2),
    VoicePhase.speaking => const Duration(milliseconds: 1100),
    VoicePhase.followup => const Duration(milliseconds: 2600),
  };

  String get voiceHint => switch (voicePhase) {
    VoicePhase.listening => 'Speak naturally — Bayaan is listening',
    VoicePhase.thinking => '',
    VoicePhase.speaking => 'Key figures surface as they are mentioned',
    VoicePhase.followup =>
      'Ask a follow-up — or tap red to end and keep the transcript',
  };
}
