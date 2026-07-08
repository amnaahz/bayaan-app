# Contributing

Thanks for helping build the Bayaan front-end. This guide keeps the codebase
consistent and easy to review.

## Prerequisites

- Flutter SDK (stable channel) with web enabled: `flutter config --enable-web`
- `flutter pub get` to install dependencies

## Local quality gates

Run these before pushing — CI enforces all of them:

```bash
dart format .                              # format
flutter analyze --fatal-infos --fatal-warnings
flutter test test/ --coverage              # unit + widget tests
```

The analyzer is configured with `very_good_analysis`; the project is expected to
report **zero** issues.

## Branching & commits

- Branch off `main`: `feature/<short-name>`, `fix/<short-name>`, `chore/...`.
- Use [Conventional Commits](https://www.conventionalcommits.org/):
  - `feat: add audio brief length selector`
  - `fix: prevent drawer search overflow on narrow frames`
  - `docs:`, `test:`, `refactor:`, `chore:`, `ci:` ...
- Keep commits focused; write messages that explain the *why*.

## Pull requests

- Fill in the PR template (summary + test plan).
- Ensure CI is green and include screenshots / screen recordings for UI changes.
- Update docs (`README.md`, `ARCHITECTURE.md`) and the QA checklist when
  behaviour changes.

## Code style & conventions

- **Feature-first**: put new UI under `lib/features/<feature>/`.
- **State**: add behaviour to `AppState` (or a feature `part` extension), not to
  widgets. Widgets stay presentational and read state via
  `context.watch` / `context.select`.
- **Theme**: use `context.colors` tokens — never hard-code design colours.
- **Icons**: add new glyphs to `lib/core/icons/lucide_icons.dart` using the
  Lucide code point (do **not** import the upstream `lucide_icons` Dart library).
- **Data**: never call a data source from a widget; go through
  `BayaanRepository`.
- Avoid comments that merely restate code; explain intent or constraints only.

## Adding a screen or overlay

1. Create the widget(s) under `lib/features/<feature>/`.
2. Add any state/flags and intent methods to `AppState` (or a `part` extension).
3. Wire it into [`AppShell`](lib/features/shell/app_shell.dart) — a new `AppView`
   for a full screen, or a boolean-gated entry in the overlay `Stack`.
4. Add unit tests for the new state transitions and a widget/E2E check.
5. Add the flow to [`qa/CHECKLIST.md`](qa/CHECKLIST.md).
