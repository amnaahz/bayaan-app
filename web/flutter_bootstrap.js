// Custom Flutter web bootstrap.
//
// We intentionally call `_flutter.loader.load()` WITHOUT `serviceWorkerSettings`
// so that no service worker is registered. For this frequently-redeployed
// testing build we want testers to always receive the latest assets; the
// default caching service worker was serving stale bundles after redeploys,
// which showed up as a black screen on devices that had visited an older build.
//
// (Flutter's service worker is deprecated and slated for removal anyway.)

{{flutter_js}}
{{flutter_build_config}}

_flutter.loader.load();
