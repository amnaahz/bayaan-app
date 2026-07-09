part of 'app_state.dart';

/// Agents: browsing, profiles, applying an agent to the composer (slash picker
/// / attach menu) and the create-agent flow.
extension AgentsController on AppState {
  List<Agent> get featuredAgents =>
      agents.where((a) => a.featured).toList(growable: false);

  List<Agent> get myAgents =>
      agents.where((a) => !a.featured).toList(growable: false);

  void goAgents() {
    _view = AppView.agents;
    _closeMenus();
    drawerOpen = false;
    notify();
  }

  // ── Profile overlay ────────────────────────────────────────────────────────
  void openAgent(Agent a) {
    activeAgent = a;
    notify();
  }

  void closeAgent() {
    activeAgent = null;
    notify();
  }

  /// "Start chat" from an agent profile: apply the agent and open a fresh chat.
  void startAgent() {
    final a = activeAgent;
    if (a == null) return;
    attachedAgent = a;
    activeAgent = null;
    newChat();
    flashToast('Chat started with ${a.name}');
  }

  /// Tap a conversation starter on the profile: apply the agent and ask.
  void startAgentWith(String question) {
    final a = activeAgent;
    if (a != null) attachedAgent = a;
    activeAgent = null;
    askQuery(question);
  }

  void detachAgent() {
    attachedAgent = null;
    notify();
  }

  // ── Slash / attach agent picker ─────────────────────────────────────────────
  List<Agent> get slashFiltered {
    final q = slashQuery.replaceFirst('/', '').trim().toLowerCase();
    if (q.isEmpty) return agents;
    return agents
        .where(
          (a) =>
              a.name.toLowerCase().contains(q) ||
              a.tag.toLowerCase().contains(q),
        )
        .toList(growable: false);
  }

  bool get slashEmpty => slashFiltered.isEmpty;

  /// Opens the agent picker (from the attach menu's "Pick an agent").
  void openAgentPicker() {
    attachMenuOpen = false;
    modeMenuOpen = false;
    slashQuery = '';
    slashOpen = true;
    notify();
  }

  void closeSlash() {
    slashOpen = false;
    notify();
  }

  /// Reacts to composer text: opens the picker when a "/" command is started.
  void handleSlashInput(String value) {
    if (value.startsWith('/')) {
      slashQuery = value;
      slashOpen = true;
    } else if (slashOpen) {
      slashOpen = false;
    }
  }

  void pickSlashAgent(Agent a) {
    attachedAgent = a;
    slashOpen = false;
    if (draft.startsWith('/')) draft = '';
    notify();
  }

  // ── Create-agent modal ──────────────────────────────────────────────────────
  void openNewAgent() {
    newAgentOpen = true;
    naName = '';
    naDesc = '';
    naInstr = '';
    naGenerating = false;
    naToolsOpen = false;
    naAdvOpen = false;
    naToolWeb = false;
    naResp = ResponseMode.standard;
    naViz = true;
    naScope = 0;
    drawerOpen = false;
    notify();
  }

  void closeNewAgent() {
    _naGenTimer?.cancel();
    newAgentOpen = false;
    naGenerating = false;
    notify();
  }

  void onNaName(String v) {
    naName = v;
    notify();
  }

  void onNaDesc(String v) {
    naDesc = v;
    notify();
  }

  void onNaInstr(String v) {
    naInstr = v;
    notify();
  }

  void toggleNaTools() {
    naToolsOpen = !naToolsOpen;
    notify();
  }

  void toggleNaAdv() {
    naAdvOpen = !naAdvOpen;
    notify();
  }

  void toggleNaToolWeb() {
    naToolWeb = !naToolWeb;
    notify();
  }

  void setNaResp(ResponseMode m) {
    naResp = m;
    notify();
  }

  void setNaViz({required bool on}) {
    naViz = on;
    notify();
  }

  void setNaScope(int i) {
    naScope = i;
    notify();
  }

  /// Simulates the "Generate" persona expansion.
  void generatePersona() {
    if (naGenerating) return;
    naGenerating = true;
    notify();
    _naGenTimer?.cancel();
    _naGenTimer = Timer(const Duration(milliseconds: 1200), () {
      final seed = naInstr.trim();
      final topic = naName.trim().isEmpty
          ? 'official statistics'
          : naName.trim();
      naInstr =
          '${seed.isEmpty ? '' : '$seed\n\n'}You are $topic, an assistant '
          'grounded strictly in official SCAD data. Always cite the source '
          'release and reporting period. Prefer clear, concise answers with a '
          'figure and one line of context. When data is unavailable, say so '
          'plainly rather than estimating. Never speculate beyond published '
          'statistics.';
      naGenerating = false;
      notify();
    });
  }

  bool get newAgentValid => naName.trim().isNotEmpty;

  void createAgent() {
    if (!newAgentValid) return;
    final name = naName.trim();
    final initials = _initialsFor(name);
    final agent = Agent(
      id: 'u${DateTime.now().microsecondsSinceEpoch}',
      name: name,
      initials: initials,
      tone: AgentTone.green,
      tag: naDesc.trim().isEmpty ? 'Custom agent' : naDesc.trim(),
      by: 'You',
      description: naDesc.trim().isEmpty
          ? 'A custom agent grounded in official SCAD statistics.'
          : naDesc.trim(),
      capabilities: [
        if (naToolWeb) 'Web search' else 'Official data',
        if (naResp == ResponseMode.concise) 'Concise' else 'Standard',
        if (naViz) 'Charts',
      ],
      starters: const [
        'What can you help me with?',
        'Summarize the latest figures.',
      ],
      private: true,
    );
    agents = [...agents, agent];
    newAgentOpen = false;
    _view = AppView.agents;
    flashToast('Agent "$name" created');
  }

  String _initialsFor(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    final letters = parts.map((w) => w.isEmpty ? '' : w[0]).join();
    return (letters.length > 2 ? letters.substring(0, 2) : letters)
        .toUpperCase();
  }
}
