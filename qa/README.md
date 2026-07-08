# Bayaan QA

This folder is the home of the **dedicated QA process** for the Bayaan
front-end. It has two complementary parts:

1. **Acceptance checklist** — [`CHECKLIST.md`](CHECKLIST.md): a structured,
   per-screen list of everything that must work. Used for manual review and by
   the live QA agent (below).
2. **Automated E2E smoke harness** — [`e2e/`](e2e): [Playwright](https://playwright.dev)
   tests that boot the built web app in a headless browser and verify it loads,
   renders and has no console errors, capturing screenshots as artifacts.

## Quick start

### 1. Serve the app

```bash
# From the repo root — builds (if needed) and serves build/web on :8080
bash qa/serve.sh
```

### 2. Run the automated E2E smoke tests

```bash
cd qa/e2e
npm install          # first time only
npx playwright install --with-deps chromium   # first time only
npm test             # builds + serves + runs the smoke suite
```

Screenshots and the HTML report are written to `qa/e2e/playwright-report/` and
`qa/e2e/test-results/`.

### 3. Manual / agent review

Walk through [`CHECKLIST.md`](CHECKLIST.md) on a mobile viewport (or a real
phone) and tick every item. File anything broken as a GitHub issue using the
bug template.

## The live QA agent (Cursor)

A dedicated Cursor subagent is configured at
[`.cursor/agents/qa.md`](../.cursor/agents/qa.md). It is a **read-only**
reviewer that:

- reads the source to understand intended behaviour,
- drives the running app in a browser,
- works through `CHECKLIST.md`, and
- produces a QA report (health score + findings + screenshots).

It never edits source — it only reports — so it can be pointed at any branch or
the deployed URL safely.

## Notes on testing Flutter web

Flutter renders the UI to a canvas (CanvasKit), so the DOM does not contain the
widget tree by default. The E2E harness enables Flutter's **semantics tree**
(accessibility) so text and controls become queryable. Prefer asserting on:

- the presence of `flutter-view` / the canvas (app booted),
- the absence of severe console errors, and
- semantic text/labels once accessibility is enabled.

For deep interaction assertions, the in-repo `flutter test` (widget +
integration) suites remain the source of truth; the Playwright layer is a
deployment smoke check.
