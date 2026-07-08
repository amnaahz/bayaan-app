import { test, expect, Page } from '@playwright/test';

/**
 * Wait for the Flutter web app to boot (the CanvasKit canvas is attached).
 */
async function waitForFlutter(page: Page): Promise<void> {
  await page.waitForSelector('canvas', { timeout: 45_000 });
  // Give the first frame + entrance animations a moment to settle.
  await page.waitForTimeout(2000);
}

/**
 * Flutter renders to a canvas, so the widget tree is not in the DOM until the
 * semantics (accessibility) tree is enabled. The engine injects a hidden
 * `flt-semantics-placeholder` positioned at (-1,-1); dispatching pointer/click
 * events on it turns semantics on, after which widget text/labels appear as
 * ARIA nodes we can assert against.
 *
 * NOTE: In headless Chromium, CanvasKit pixels often do not survive a
 * screenshot readback (the capture can be blank even though the app renders
 * correctly on real devices). We therefore assert on the semantics tree rather
 * than pixels.
 */
async function enableSemantics(page: Page): Promise<void> {
  await page.evaluate(() => {
    const find = (root: Document | ShadowRoot): Element | null => {
      const el = root.querySelector(
        'flt-semantics-placeholder,[aria-label="Enable accessibility"]',
      );
      if (el) return el;
      for (const e of Array.from(root.querySelectorAll('*'))) {
        if ((e as HTMLElement).shadowRoot) {
          const r = find((e as HTMLElement).shadowRoot as ShadowRoot);
          if (r) return r;
        }
      }
      return null;
    };
    const el = find(document);
    if (!el) return;
    const opts = { bubbles: true, cancelable: true, composed: true, clientX: 0, clientY: 0 };
    el.dispatchEvent(new PointerEvent('pointerdown', opts));
    el.dispatchEvent(new PointerEvent('pointerup', opts));
    el.dispatchEvent(new MouseEvent('mousedown', opts));
    el.dispatchEvent(new MouseEvent('mouseup', opts));
    el.dispatchEvent(new MouseEvent('click', opts));
  });
  await page.waitForTimeout(1500);
}

/** Collect all semantic labels / leaf text from the (shadow) DOM. */
async function semanticTexts(page: Page): Promise<string[]> {
  return page.evaluate(() => {
    const out: string[] = [];
    const walk = (root: Document | ShadowRoot) => {
      for (const el of Array.from(root.querySelectorAll('*'))) {
        const label = el.getAttribute && el.getAttribute('aria-label');
        if (label) out.push(label);
        if (el.childElementCount === 0 && el.textContent && el.textContent.trim()) {
          out.push(el.textContent.trim());
        }
        if ((el as HTMLElement).shadowRoot) {
          walk((el as HTMLElement).shadowRoot as ShadowRoot);
        }
      }
    };
    walk(document);
    return Array.from(new Set(out));
  });
}

test.describe('Bayaan web smoke', () => {
  test('boots and renders without severe console errors', async ({ page }) => {
    const errors: string[] = [];
    page.on('console', (msg) => {
      if (msg.type() === 'error') errors.push(msg.text());
    });
    page.on('pageerror', (err) => errors.push(String(err)));

    await page.goto('/');
    await waitForFlutter(page);

    // The Flutter canvas must be present and sized.
    const canvas = page.locator('canvas').first();
    await expect(canvas).toBeVisible();

    await page.screenshot({ path: 'test-results/home.png' });

    const severe = errors.filter(
      (e) => !/fonts|favicon|manifest|Failed to load resource|WebGL|GPU stall/i.test(e),
    );
    expect(severe, `Unexpected console errors:\n${severe.join('\n')}`).toEqual([]);
  });

  test('renders home content (via semantics tree)', async ({ page }) => {
    await page.goto('/');
    await waitForFlutter(page);
    await enableSemantics(page);

    const texts = await semanticTexts(page);
    // The brand wordmark in the header and the default composer mode pill are
    // reliable signals that the shell + composer actually rendered.
    expect(texts.join(' | ')).toContain('Bayaan');
    expect(texts.join(' | ')).toContain('Normal');
  });
});
