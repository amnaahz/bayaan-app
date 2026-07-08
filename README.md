# Bayaan — Mobile Front-End

Bayaan is a mobile-first AI assistant for **Abu Dhabi official statistics**. This
repository is a faithful, fully-interactive **Flutter Web** implementation of the
approved product design, built so the team can dogfood the experience on a
phone, gather user feedback, and later wire it to a real backend.

> The app runs entirely on **mock data** today. Every screen, animation and flow
> is interactive — there are no dead ends — so testers get a realistic feel of
> the product before any backend exists.

**▶ Live demo: <https://amnaahz.github.io/bayaan-app/>** — open it on your phone.

[![CI](https://github.com/amnaahz/bayaan-app/actions/workflows/ci.yml/badge.svg)](https://github.com/amnaahz/bayaan-app/actions/workflows/ci.yml)
[![Deploy](https://github.com/amnaahz/bayaan-app/actions/workflows/deploy.yml/badge.svg)](https://github.com/amnaahz/bayaan-app/actions/workflows/deploy.yml)

---

## Features

- **Home / daily briefing** — greeting, rotating tagline, conversation starters.
- **Chat** — streaming answers with charts, stat cards, cited sources, actions
  (vote / copy / regenerate / share) and follow-up questions.
- **Composer** — attachments, search modes (Normal / Web / Deep Research),
  response modes (Standard / Concise / Reasoning) and live dictation.
- **Voice** — full-screen live conversation with an animated orb and transcript.
- **Deep Research** — clarify → plan → approve → research → synthesize → report,
  with export.
- **Spaces / Notebooks** — grounded workspaces: sources, grounded chat, and a
  studio that generates cited **reports** and **audio briefs**, plus a library
  and audio player.
- **Artifacts** — generated reports, charts and tables with a report reader.
- **Settings** — profile, language, **light / dark theme**, notifications.
- **Navigation drawer** — chat history (pinned + grouped), folders, rename,
  pin, move and delete.

## Tech stack

| Concern            | Choice                                             |
| ------------------ | -------------------------------------------------- |
| Framework          | Flutter (Web target, mobile-first responsive)      |
| State management   | `ChangeNotifier` + `provider`                      |
| Icons              | Lucide (bundled font) + inline SVG brand mark      |
| Typography         | Geist / Geist Mono via `google_fonts`              |
| Lints              | `very_good_analysis` (strict)                      |
| Data layer         | `BayaanRepository` interface + mock implementation |

## Getting started

Prerequisites: the [Flutter SDK](https://docs.flutter.dev/get-started/install)
(stable channel) with web enabled (`flutter config --enable-web`).

```bash
flutter pub get
flutter run -d chrome      # run locally in Chrome
```

### Build for the web

```bash
flutter build web --release
# output in build/web/ — serve it with any static file server:
python3 -m http.server --directory build/web 8080
```

## Project layout

```
lib/
  app.dart                 # root MaterialApp + provider wiring
  main.dart                # entry point; selects the repository binding
  core/
    config/                # AppConfig (--dart-define driven, backend-ready)
    icons/                 # Lucide icon shim (plain IconData over bundled font)
    theme/                 # design tokens, ThemeData, context.colors extension
    widgets/               # shared widgets (logo, animations, indicators)
  data/
    models/                # immutable UI/domain models
    mock/                  # ported design data
    repositories/          # BayaanRepository interface + MockBayaanRepository
  state/                   # AppState controller (+ feature `part` extensions)
  features/                # one folder per feature (shell, home, chat, ...)
test/                      # unit + widget tests
integration_test/          # on-device end-to-end test
qa/                        # QA runbook, checklist, and Playwright E2E harness
```

See [`ARCHITECTURE.md`](ARCHITECTURE.md) for the design rationale and data flow.

## Testing & QA

```bash
flutter analyze                          # static analysis (zero issues expected)
dart format --set-exit-if-changed .      # formatting gate
flutter test test/ --coverage            # unit + widget tests + coverage
flutter test integration_test/           # end-to-end (requires a device/emulator)
```

A dedicated QA process lives in [`qa/`](qa/README.md):

- an **acceptance checklist** ([`qa/CHECKLIST.md`](qa/CHECKLIST.md)) for manual /
  agent-driven review of every screen and flow, and
- a **Playwright E2E smoke harness** ([`qa/e2e/`](qa/e2e)) that drives the built
  web app in a headless browser for deterministic, repeatable checks.

## Connecting a backend later

The UI never talks to a data source directly — it goes through
[`BayaanRepository`](lib/data/repositories/bayaan_repository.dart). To integrate
the real Bayaan backend / Claude:

1. Implement `BayaanRepository` with an HTTP client.
2. Swap the binding in [`main.dart`](lib/main.dart).
3. Configure the endpoint at build time:

   ```bash
   flutter build web --release \
     --dart-define=BAYAAN_USE_MOCK_DATA=false \
     --dart-define=BAYAAN_API_BASE_URL=https://api.example.com
   ```

No widget or state-machine code needs to change.

## Contributing

Please read [`CONTRIBUTING.md`](CONTRIBUTING.md) for the branch, commit and PR
conventions, and the local quality gates.
