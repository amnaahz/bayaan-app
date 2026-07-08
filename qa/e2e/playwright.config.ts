import { defineConfig, devices } from '@playwright/test';

const PORT = Number(process.env.PORT ?? 8080);
const baseURL = `http://localhost:${PORT}`;

/**
 * Playwright config for the Bayaan Flutter web smoke suite.
 *
 * The `webServer` block builds (if needed) and serves `build/web` via
 * `qa/serve.sh`, then Playwright drives it in a mobile-sized Chromium.
 */
export default defineConfig({
  testDir: './tests',
  timeout: 60_000,
  expect: { timeout: 15_000 },
  fullyParallel: false,
  retries: process.env.CI ? 1 : 0,
  reporter: [['html', { open: 'never' }], ['list']],
  use: {
    baseURL,
    // Mobile-first viewport to match the intended experience.
    viewport: { width: 414, height: 896 },
    screenshot: 'only-on-failure',
    trace: 'retain-on-failure',
  },
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'], viewport: { width: 414, height: 896 } },
    },
  ],
  webServer: {
    command: 'bash ../serve.sh',
    url: baseURL,
    timeout: 240_000,
    reuseExistingServer: !process.env.CI,
    env: { PORT: String(PORT) },
  },
});
