# Architecture

This document explains how the Bayaan front-end is structured and why.

## Goals

1. **Faithful to the design.** The app mirrors the approved single-surface
   mobile design — including its overlay model, animations and micro-interactions.
2. **Fully interactive on mock data.** Testers experience real flows with no
   dead ends, before any backend exists.
3. **Backend-ready.** A single data seam lets us swap mock data for a real API
   without touching UI or state-machine code.
4. **Team-ready.** Feature-first layout, strict lints, tests, CI and QA.

## Layers

```
┌─────────────────────────────────────────────────────────┐
│ features/  — widgets per feature (presentation only)     │
├─────────────────────────────────────────────────────────┤
│ state/     — AppState (ChangeNotifier) single controller │
├─────────────────────────────────────────────────────────┤
│ data/      — repositories (interface) + models + mocks   │
├─────────────────────────────────────────────────────────┤
│ core/      — theme tokens, config, icons, shared widgets │
└─────────────────────────────────────────────────────────┘
```

### `core/`

- **theme/** ports the design's CSS custom properties into a `BayaanColors`
  `ThemeExtension` (dark + light) plus `AppTheme` (`ThemeData`, typography). A
  `context.colors` extension mirrors the original `var(--token)` usage 1:1.
- **config/** `AppConfig` is read from `--dart-define` flags, so the same build
  can target mock data or a real endpoint.
- **icons/** a small `LucideIcons` shim that constructs plain `IconData` over the
  Lucide font bundled by the `lucide_icons` package. (The upstream package's own
  `LucideIconData extends IconData` no longer compiles now that Flutter made
  `IconData` a `final` class, so we avoid importing it directly.)
- **widgets/** cross-feature building blocks: the brand logo/mark, entrance
  animation (`FadeSlideIn`), thinking/pulse/wave indicators, hover helpers and
  the ambient background.

### `data/`

- **models/** small immutable value types for chat, answers, research, spaces
  and UI concerns.
- **mock/** the design's canned content (answers, chats, notebooks, research
  plans, taglines, ...).
- **repositories/** `BayaanRepository` is the **only** seam to a data source.
  `MockBayaanRepository` fulfils it in-memory today; a real implementation can
  be dropped in later (see the README's "Connecting a backend" section).

### `state/`

The design is a single stateful component. We mirror that with one
`AppState extends ChangeNotifier` object that owns the entire UI state and the
timers that simulate thinking, streaming, voice and research.

To keep it readable, feature behaviour is split into **same-library `part`
extensions**:

- `voice_controller.dart` — live voice session.
- `deep_research_controller.dart` — the multi-phase research flow.
- `spaces_controller.dart` — notebooks, sources, generation, library, player.
- `drawer_controller.dart` — chat history, folders, rename/pin/move/delete.

Because they are `part of` the same library, the extensions share private state
while the public API stays cohesive. (`notify()` wraps the protected
`notifyListeners()` so extensions can trigger rebuilds.)

### `features/`

Presentation only — widgets read state via `context.watch<AppState>()` /
`context.select` and call intent methods on `AppState`. No feature reaches into
another feature's internals.

## The overlay model

The design is **not** a stack of routed pages; it is one surface with overlays
(drawer, menus, voice, deep research, notebook, modals, toast). We reproduce this
with a single `Stack` in [`AppShell`](lib/features/shell/app_shell.dart):

- a base column (header + active screen + composer), then
- conditionally-mounted overlays layered on top.

The active screen is chosen from `AppState.view`; overlays are driven by boolean
flags (`drawerOpen`, `voiceOpen`, `drOpen`, `nbOpen`, ...). This keeps navigation
behaviour identical to the design and makes every transition testable through
plain state assertions.

## Responsiveness

`AppShell` fills the screen on phones. On wider viewports it centers a
phone-sized frame (and overrides `MediaQuery` size for the framed subtree) so the
mobile layout can be reviewed on desktop and in CI without distortion.

## Testing strategy

- **Unit** (`test/state/`) — drive `AppState` through every flow using
  `fake_async` for deterministic control of its timers/microtasks.
- **Widget** (`test/widget/`) — real tap/gesture flows against the composed app.
- **Integration** (`integration_test/`) — an on-device end-to-end journey.
- **Web E2E** (`qa/e2e/`) — Playwright smoke tests against the built site.
