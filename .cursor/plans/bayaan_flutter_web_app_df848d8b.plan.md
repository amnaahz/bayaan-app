---
name: Bayaan Flutter Web App
overview: Build a full, faithful Flutter Web implementation of the Bayaan v4 mobile design (AI assistant for Abu Dhabi statistics) as a clean, team-ready, best-practices repository (front-end only with a backend-ready data layer), with automated tests + GitHub Actions CI and a dedicated live browser QA agent, then host it as a shareable mobile-testable link.
todos:
  - id: repo-setup
    content: "Initialize clean, GitHub-ready repo: Flutter web project (bayaan_app), feature-first architecture, very_good_analysis lint + dart format config, .gitignore, README, CONTRIBUTING, ARCHITECTURE.md, PR/issue templates, CODEOWNERS, EditorConfig, conventional-commit setup. Add deps (provider, lucide_icons, flutter_svg, google_fonts) and web/ (manifest, theme color, mobile viewport)."
    status: completed
  - id: theme
    content: Port dark+light design tokens into BayaanColors ThemeExtension + AppTheme (ThemeData) and text styles (Geist/Geist Mono) from the confirmed palette. Add the real Bayaan brand assets (bayaan-mark, bayaan-logo) and a scalable BayaanLogo widget; set favicon/manifest icons.
    status: completed
  - id: state-data-layer
    content: Build AppState ChangeNotifier mirroring the design's state + methods; define domain models (Message, Chat, Folder, Notebook, Source, Answer, LibraryItem); add a backend-ready data layer (repository interfaces with mock implementations now, env config via --dart-define) so real APIs slot in later without UI changes.
    status: completed
  - id: shell
    content: "Build AppShell: phone-frame responsive container, header, bottom nav, and the state-driven overlay Stack; shared widgets (icon buttons, pills, segmented control, FadeSlideIn, thinking dots, streaming text, toast)."
    status: completed
  - id: home-chat
    content: Implement Home (greeting, rotating tagline, indicators/sparklines, starters) and Chat (user/bot bubbles, thinking, streaming, bar-chart card, stat cards, sources row, message actions, follow-up chips).
    status: completed
  - id: composer-voice
    content: Implement Composer (input, attachments, attach menu, mode menu + response modes, dictation) and the Voice live-conversation overlay (animated orb, transcript, surfacing chips, controls, transcript hand-off to chat).
    status: completed
  - id: drawer
    content: "Implement Drawer: profile, nav items, chats grouped (Pinned/Today/7-days), folders with expand/move, chat context menu (pin/rename/delete/move), new-folder modal."
    status: completed
  - id: spaces-notebooks
    content: Implement Spaces/Notebooks list + search, notebook overlay (Sources/Chat/Studio tabs, A/B studio variants), report & audio sheets, generation progress, report viewer, audio player, add-sources sheet, new-notebook modal, toast.
    status: completed
  - id: deep-research
    content: "Implement Deep Research flow: clarify questions (single/multi), plan editor, approval, animated research progress with statuses, synthesis, done + report viewer + export menu."
    status: completed
  - id: artifacts-settings
    content: Implement Artifacts list (reports/charts/tables) with report viewer, and Settings (profile, language, light/dark toggle wired to theme, default mode, notifications toggle, about, sign out).
    status: completed
  - id: tests
    content: "Add automated tests: unit tests (AppState logic, pickAnswerFor, generation/deep-research state machines), widget tests (key components + screens), golden tests (screens in light + dark), and integration_test flows (ask→stream, voice hand-off, deep research, notebook generation). Wire coverage."
    status: completed
  - id: ci
    content: "Add GitHub Actions CI: format check + analyze + test (with coverage) + flutter build web on PRs; a deploy workflow on main (build + publish to host). Add status badges to README."
    status: completed
  - id: qa-agent
    content: "Set up the dedicated QA agent: qa/ runbook + per-screen/flow acceptance checklist, a serve script for the built web app, a reusable Cursor QA subagent prompt/config the team can trigger, and a deterministic Playwright E2E smoke harness (runnable locally + in CI) that screenshots every screen/flow."
    status: completed
  - id: build-host-qa
    content: Cross-check fidelity vs design, fix responsiveness/safe-areas; flutter build web; deploy to a static host; run the QA agent to produce a QA report (screenshots + pass/fail per checklist); fix findings; return the shareable link. Swap in real brand assets when provided.
    status: completed
isProject: false
---

# Bayaan Flutter Web App

Faithful, front-end-only Flutter Web clone of `Bayaan App v4  final.dc.html` (AI stats assistant for Abu Dhabi / SCAD), delivered as a **clean, team-ready repository** with front-end best practices, automated tests + CI, and a **dedicated QA agent**. Mobile-first, dark+light theming, all screens/overlays/animations. Mock data behind a backend-ready data layer. Then `flutter build web` and host for a shareable link.

## Key technical decisions
- **Target:** Flutter Web (Flutter 3.44.5 installed). Mobile-first; on desktop, center content in a phone-width column so the link looks intentional on any device.
- **State:** Single `AppState` (`ChangeNotifier`, via `provider`) that mirrors the design's one big state object + methods (`ask`, `startVoice`, `startDeepResearch`, `startGeneration`, dictation, etc.) and drives all timers/animations. Faithful mapping of the original React-like `Component`, kept UI-agnostic and testable.
- **Overlay model:** One `AppShell` `Stack` toggled by state flags (`drawerOpen`, `voiceOpen`, `drOpen`, `nbOpen`, sheets, modals, toast) — exactly like the source. No Navigator routes for overlays.
- **Icons/brand:** `lucide_icons` (design uses Lucide/feather stroke icons). Real brand assets provided: `bayaan-mark.png` (glyph) and `bayaan-logo.png` (blue rounded-square app icon). A `BayaanLogo` widget renders the mark as crisp vector using the design's embedded path data (design lines ~1531-1540) so it scales/tints perfectly (white inside the voice orb, blue app-icon in header + chat avatar); the provided PNGs are bundled as source-of-truth/fallback and reused for the web favicon/manifest icons.
- **Fonts:** Geist + Geist Mono via `google_fonts` (swap to bundled files if you provide them).
- **Theme tokens:** Port the full `[data-theme="dark"]` / `[data-theme="light"]` CSS variables (design lines 33-34) into a `ThemeExtension` (`BayaanColors`) so every widget reads tokens like the original `var(--...)`. Canonical source is the user's palette doc (`Bayaan Color Palette-print.dc.html`): brand blues (`#297DE3` / `#1F65BD` / `#184F97`), Ink `#1B1F33`, one accent trio per meaning (Amber=Reports, Green=Audio/positive, Purple=Deep Research, Red=destructive/live), two brand gradients (voice orb `#5D97EC→#297DE3→#1A55B0`, audio artwork `#5BBF77→#228636→#16612B`), desktop backdrop `#E7E5DF`.

## Repository & engineering standards (team-ready)
- **Structure:** feature-first — `lib/core/` (theme, config, utils, widgets), `lib/data/` (models, repositories + mock impls), `lib/state/`, `lib/features/<feature>/` (each feature owns its widgets). Documented in `ARCHITECTURE.md`.
- **Quality gates:** `very_good_analysis` lint ruleset + `analysis_options.yaml`, `dart format`, strict null-safety, no `print` (use a logger), `.editorconfig`.
- **Docs & governance:** `README.md` (setup, run, build, test, deploy, contribute), `CONTRIBUTING.md` (branching + conventional commits), `.github/` PR template, issue templates, `CODEOWNERS`.
- **Backend-ready:** all mock data behind repository interfaces (e.g. `AnswersRepository`, `ChatsRepository`, `NotebooksRepository`) with in-memory mock impls today; swapping to real HTTP/Claude backend later = new impl + DI change, no UI churn. Runtime config (API base URL, flags) via `--dart-define` + a typed `AppConfig`.

## Testing & CI
- **Tests:** unit (state machines, `pickAnswerFor`, generation/deep-research logic), widget (components + screens render in both themes), golden (key screens light + dark), `integration_test` flows (ask→thinking→stream→extras; voice hand-off to chat; deep-research clarify→report; notebook report/audio generation). Coverage tracked.
- **CI (GitHub Actions):** PR workflow = `dart format --set-exit-if-changed` + `flutter analyze` + `flutter test --coverage` + `flutter build web`. Main workflow = build + deploy to host. README status badges.

## Dedicated QA agent (both automated + live)
- **Live browser QA agent:** a reusable Cursor QA subagent (browse/QA capability) driven by `qa/CHECKLIST.md` (per-screen + per-flow acceptance criteria derived from the design). It opens the running/hosted app, walks every screen, overlay and flow, screenshots each, and writes a pass/fail report to `qa/reports/`. Team re-runs it any time via a documented prompt in `qa/README.md`.
- **Deterministic E2E:** a Playwright smoke harness (`qa/e2e/`) that loads the built web app, exercises the core flows, and captures per-screen screenshots — runnable locally and in CI for regression safety.
- I will run the QA agent once after the first deploy, fix findings, and hand over the report + re-run instructions.

## Interactivity & UX acceptance (fully functional)
- Every interactive element behaves like the source: taps, hovers, menus, bottom sheets, modals, toggles, drawer, tabs, and back/close actions all work with smooth transitions — no dead ends or placeholder buttons.
- Core experiences are live end-to-end on mock data: type/pick a question → thinking → streamed answer with chart/stats/sources/follow-ups; voice conversation with animated orb + transcript hand-off; deep research clarify→plan→research→report; notebook report/audio generation → library → viewer/player; theme light/dark switch; chat pin/rename/delete/move + folders.
- Feels good on a phone: 60fps animations, correct safe-areas, tap targets, scroll behavior, and keyboard handling. This is enforced by the QA agent checklist.

## Data mapped from the design (mock)
- 5 canned answers (`gdp`, `inflation`, `population`, `tourism`, `trade`) with text, bar charts, stat cards, sources, follow-ups (design lines 1715-1798).
- Chats + folders, notebooks list + sources, library items, Deep Research clarify-questions/plan/statuses, voice script + surfacing chips (design lines 1621-1710, 2272-2299).
- Keyword router `pickAnswerFor` for free-text/follow-ups (design lines 2759-2765).

## Screens & flows to implement (full)
- Views: Home/Daily Briefing, Chat, Spaces/Notebooks, Artifacts, Settings.
- Overlays/flows: Drawer (+ new-folder modal, chat menu, move-to-folder, rename), Composer (attach menu, mode menu with Normal/Web/Deep + Standard/Concise/Reasoning, dictation), Voice live conversation, Deep Research (clarify→plan→approval→research→synth→done→report/export), Notebook overlay (Sources/Chat/Studio tabs, A/B studio variants, report & audio sheets, generation progress, report viewer, audio player, add-sources sheet, new-notebook modal), Report viewer, Toast.

## Animations (Flutter equivalents)
- Streaming word-by-word text + blinking cursor (timer in `AppState`), thinking pulse dots, `fadeUp` entrances (reusable `FadeSlideIn`), `growBar` bar charts (`TweenAnimationBuilder`), voice orb breathe/ring/spin + waveform (AnimationControllers), bottom-sheet slideUp, toast fade.

## Hosting
- `flutter build web` (CanvasKit for fidelity). `web/manifest.json` + theme color; SPA rewrites config. Deploy static (Vercel MCP available) and return the shareable URL.

## Notes / dependency on you
- Real brand assets received (`bayaan-mark.png`, `bayaan-logo.png`) — these are now the source of truth; no recreation needed. Fonts use `google_fonts` Geist unless you provide licensed font files to bundle.
- CI deploy + the live QA agent run best against a hosted URL; I'll wire deploy and run QA once it's live.
