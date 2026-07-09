import 'dart:async';

import 'package:bayaan/data/models/chat_models.dart';
import 'package:bayaan/data/models/research_models.dart';
import 'package:bayaan/data/repositories/bayaan_repository.dart';
import 'package:bayaan/state/app_state.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';

/// Runs [body] inside a [FakeAsync] zone with a freshly-seeded [AppState].
///
/// The controller starts periodic timers in its constructor, so every test
/// runs under fake time and disposes the state at the end to avoid leaks.
void withState(void Function(AppState s, FakeAsync async) body) {
  fakeAsync((async) {
    final state = AppState(const MockBayaanRepository());
    async.flushMicrotasks(); // resolve _seed()
    body(state, async);
    state.dispose();
    async.flushTimers();
  });
}

void main() {
  // The controller schedules post-frame callbacks (auto-scroll), which require
  // an initialized binding even in these pure state tests.
  TestWidgetsFlutterBinding.ensureInitialized();

  group('seeding & navigation', () {
    test('seeds chats, folders and notebooks from the repository', () {
      withState((s, async) {
        expect(s.chats, isNotEmpty);
        expect(s.folders, isNotEmpty);
        expect(s.notebooks, isNotEmpty);
      });
    });

    test('starts on the home view', () {
      withState((s, async) {
        expect(s.view, AppView.home);
        expect(s.isHome, isTrue);
      });
    });

    test('navigates between top-level destinations', () {
      withState((s, async) {
        s.goSpaces();
        expect(s.view, AppView.spaces);
        s.goArtifacts();
        expect(s.view, AppView.artifacts);
        s.goSettings();
        expect(s.view, AppView.settings);
        s.newChat();
        expect(s.view, AppView.home);
      });
    });

    test('drawer open/close toggles state', () {
      withState((s, async) {
        expect(s.drawerOpen, isFalse);
        s.openDrawer();
        expect(s.drawerOpen, isTrue);
        s.closeDrawer();
        expect(s.drawerOpen, isFalse);
      });
    });
  });

  group('theme', () {
    test('switches between light and dark', () {
      withState((s, async) {
        expect(s.isDark, isTrue);
        s.setLight();
        expect(s.isDark, isFalse);
        expect(s.themeMode.name, 'light');
        s.setDark();
        expect(s.isDark, isTrue);
        expect(s.themeMode.name, 'dark');
      });
    });
  });

  group('composer mode', () {
    test('mode label reflects search and response modes', () {
      withState((s, async) {
        expect(s.modeLabel, 'Normal');
        s.setModeWeb();
        expect(s.modeLabel, contains('Web'));
        s.setResponseMode(ResponseMode.concise);
        expect(s.modeLabel, contains('Concise'));
        s.setModeDeep();
        expect(s.modeLabel, 'Deep Research');
      });
    });
  });

  group('chat ask flow', () {
    test('asking a key opens chat with a user + streaming bot message', () {
      withState((s, async) {
        s.askKey('gdp');
        async.flushMicrotasks();

        expect(s.view, AppView.chat);
        expect(s.msgs.length, 2);
        expect(s.msgs.first.role, MessageRole.user);
        expect(s.msgs.last.role, MessageRole.bot);

        // Thinking → streaming → done.
        async.elapse(const Duration(seconds: 10));
        expect(s.msgs.last.phase, MessagePhase.done);
      });
    });

    test('deep-research mode routes ask into the research overlay', () {
      withState((s, async) {
        s.setModeDeep();
        s.askQuery('unemployment study');
        async.flushMicrotasks();

        expect(s.drOpen, isTrue);
        expect(s.view, AppView.home); // chat view not entered
        expect(s.drPhase, DrPhase.clarify);
      });
    });
  });

  group('drawer: folders, pin, rename, delete', () {
    test('creates a folder and assigns a pending chat to it', () {
      withState((s, async) {
        final chatId = s.chats.first.id;
        final before = s.folders.length;

        s.openNewFolder(pendingChat: chatId);
        s.onNewFolderName('Fiscal');
        expect(s.newFolderValid, isTrue);
        s.createFolder();

        expect(s.folders.length, before + 1);
        final newFolder = s.folders.last;
        expect(newFolder.name, 'Fiscal');
        expect(
          s.chatsInFolder(newFolder.id).map((c) => c.id),
          contains(chatId),
        );
      });
    });

    test('moving a chat to a folder toggles membership', () {
      withState((s, async) {
        final chat = s.chats.first;
        final folderId = s.folders.first.id;

        s.moveChatToFolder(chat.id, folderId);
        expect(s.chatsInFolder(folderId).map((c) => c.id), contains(chat.id));

        s.moveChatToFolder(chat.id, folderId); // toggle back off
        expect(
          s.chatsInFolder(folderId).map((c) => c.id),
          isNot(contains(chat.id)),
        );
      });
    });

    test('pin then read pinned list', () {
      withState((s, async) {
        final chat = s.chats.first;
        s.togglePinChat(chat.id);
        expect(s.pinnedChats.map((c) => c.id), contains(chat.id));
      });
    });

    test('rename updates the chat title', () {
      withState((s, async) {
        final chat = s.chats.first;
        s.startRename(chat.id);
        s.onRenameDraft('Renamed thread');
        s.commitRename();
        expect(
          s.chats.firstWhere((c) => c.id == chat.id).title,
          'Renamed thread',
        );
        expect(s.renamingId, isNull);
      });
    });

    test('delete removes a chat', () {
      withState((s, async) {
        final chat = s.chats.first;
        final count = s.chats.length;
        s.deleteChat(chat.id);
        expect(s.chats.length, count - 1);
        expect(s.chats.map((c) => c.id), isNot(contains(chat.id)));
      });
    });
  });

  group('deep research flow', () {
    test('single and multi-select clarify answers', () {
      withState((s, async) {
        s.startDeepResearch('study');
        expect(s.drPhase, DrPhase.clarify);

        // Q1 single-select.
        s.drPick(1);
        expect(s.drIsOptionSelected(1), isTrue);
        s.drPick(2);
        expect(s.drIsOptionSelected(2), isTrue);
        expect(s.drIsOptionSelected(1), isFalse);

        s.drAdvanceClarify(); // → Q2
        s.drAdvanceClarify(); // → Q3 (multi)
        expect(s.drQIdx, 2);
        s.drPick(0);
        s.drPick(2);
        expect(s.drIsOptionSelected(0), isTrue);
        expect(s.drIsOptionSelected(2), isTrue);
      });
    });

    test('advances through plan, approval, research and done', () {
      withState((s, async) {
        s.startDeepResearch('study');
        s.drAdvanceClarify();
        s.drAdvanceClarify();
        s.drAdvanceClarify(); // last → plan phase, schedules approval

        expect(s.drPhase, DrPhase.plan);
        async.elapse(const Duration(seconds: 2));
        expect(s.drPhase, DrPhase.approval);

        final planCount = s.drPlan.length;
        s.drRemovePlan(0);
        expect(s.drPlan.length, planCount - 1);

        s.drRun();
        expect(s.drPhase, DrPhase.research);
        async.elapse(const Duration(seconds: 30));
        expect(s.drPhase, DrPhase.done);
        expect(s.drPct, 100);
      });
    });
  });

  group('spaces / notebooks', () {
    test('opening a notebook loads its sources', () {
      withState((s, async) {
        final nb = s.notebooks.firstWhere(
          (n) => n.name == 'Economic Anomalies',
        );
        unawaited(s.openNotebook(nb));
        async.flushMicrotasks();
        expect(s.nbOpen, isTrue);
        expect(s.nbSources, isNotEmpty);
        expect(s.nbSelectedCount, s.nbSources.length);
      });
    });

    test('toggling a source updates the selected count', () {
      withState((s, async) {
        final nb = s.notebooks.firstWhere(
          (n) => n.name == 'Economic Anomalies',
        );
        unawaited(s.openNotebook(nb));
        async.flushMicrotasks();
        final before = s.nbSelectedCount;
        s.toggleSource(0);
        expect(s.nbSelectedCount, before - 1);
      });
    });

    test('adding a source appends to the list', () {
      withState((s, async) {
        final nb = s.notebooks.firstWhere(
          (n) => n.name == 'Economic Anomalies',
        );
        unawaited(s.openNotebook(nb));
        async.flushMicrotasks();
        final before = s.nbTotalSources;
        s.openAddSrc();
        s.onAddSrcQuery('New web source');
        s.addSource('search');
        expect(s.nbTotalSources, before + 1);
      });
    });

    test('creating a notebook opens it and prepends to the list', () {
      withState((s, async) {
        final before = s.notebooks.length;
        s.openNewNb();
        s.onNewNbTitle('Fresh notebook');
        s.createNotebook();
        expect(s.notebooks.length, before + 1);
        expect(s.notebooks.first.name, 'Fresh notebook');
        expect(s.nbOpen, isTrue);
      });
    });

    test('report generation produces a library item', () {
      withState((s, async) {
        final nb = s.notebooks.firstWhere(
          (n) => n.name == 'Economic Anomalies',
        );
        unawaited(s.openNotebook(nb));
        async.flushMicrotasks();
        final before = s.libItems.length;

        s.startGeneration('report');
        expect(s.generating, isTrue);
        async.elapse(const Duration(seconds: 10));
        expect(s.generating, isFalse);
        expect(s.libItems.length, before + 1);
      });
    });
  });

  group('agents', () {
    test('seeds featured and user agents', () {
      withState((s, async) {
        expect(s.agents, isNotEmpty);
        expect(s.featuredAgents, isNotEmpty);
        expect(s.myAgents, isNotEmpty);
      });
    });

    test('navigating to agents sets the view', () {
      withState((s, async) {
        s.goAgents();
        expect(s.view, AppView.agents);
        expect(s.isAgentsNav, isTrue);
        expect(s.sectionTitle, 'Agents');
      });
    });

    test('opening a profile and starting a chat applies the agent', () {
      withState((s, async) {
        final agent = s.featuredAgents.first;
        s.openAgent(agent);
        expect(s.agentOpen, isTrue);
        expect(s.activeAgent, agent);

        s.startAgent();
        expect(s.agentOpen, isFalse);
        expect(s.attachedAgent, agent);
        expect(s.view, AppView.home);
      });
    });

    test('a profile starter asks with the agent applied', () {
      withState((s, async) {
        final agent = s.featuredAgents.first;
        s.openAgent(agent);
        s.startAgentWith(agent.starters.first);
        async.flushMicrotasks();
        expect(s.attachedAgent, agent);
        expect(s.view, AppView.chat);
      });
    });

    test('slash picker filters and applies an agent', () {
      withState((s, async) {
        s.handleSlashInput('/');
        expect(s.slashOpen, isTrue);
        expect(s.slashFiltered, isNotEmpty);

        s.slashQuery = '/inflation';
        final matches = s.slashFiltered;
        expect(
          matches.every(
            (a) =>
                a.tag.toLowerCase().contains('inflation') ||
                a.name.toLowerCase().contains('inflation'),
          ),
          isTrue,
        );

        final pick = s.agents.first;
        s.pickSlashAgent(pick);
        expect(s.slashOpen, isFalse);
        expect(s.attachedAgent, pick);
      });
    });

    test('creating an agent appends a private agent', () {
      withState((s, async) {
        final before = s.agents.length;
        s.openNewAgent();
        s.onNaName('Fiscal Brief');
        expect(s.newAgentValid, isTrue);
        s.createAgent();
        expect(s.agents.length, before + 1);
        expect(s.agents.last.name, 'Fiscal Brief');
        expect(s.agents.last.private, isTrue);
        expect(s.view, AppView.agents);
      });
    });

    test('generate persona fills instructions', () {
      withState((s, async) {
        s.openNewAgent();
        s.onNaName('Explainer');
        s.generatePersona();
        expect(s.naGenerating, isTrue);
        async.elapse(const Duration(seconds: 2));
        expect(s.naGenerating, isFalse);
        expect(s.naInstr, isNotEmpty);
      });
    });
  });

  group('sources panel', () {
    test('open/close toggles state', () {
      withState((s, async) {
        expect(s.sourcesOpen, isFalse);
        s.openSources();
        expect(s.sourcesOpen, isTrue);
        s.closeSources();
        expect(s.sourcesOpen, isFalse);
      });
    });
  });

  group('voice', () {
    test('starting and ending a voice session toggles the overlay', () {
      withState((s, async) {
        s.startVoice();
        expect(s.voiceOpen, isTrue);
        s.toggleMute();
        expect(s.voiceMuted, isTrue);
        s.endVoice();
        expect(s.voiceOpen, isFalse);
      });
    });
  });
}
