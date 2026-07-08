/// Typed runtime configuration.
///
/// Values are supplied at build time via `--dart-define`, e.g.:
/// `flutter build web --dart-define=BAYAAN_API_BASE_URL=https://api.example.com`
///
/// The front-end currently runs entirely on mock repositories, but keeping
/// configuration centralized here means wiring a real backend later is a
/// config + repository swap with no UI changes.
class AppConfig {
  const AppConfig({
    required this.apiBaseUrl,
    required this.useMockData,
  });

  factory AppConfig.fromEnvironment() {
    const apiBaseUrl = String.fromEnvironment('BAYAAN_API_BASE_URL');
    const useMock = bool.fromEnvironment(
      'BAYAAN_USE_MOCK_DATA',
      defaultValue: true,
    );
    return const AppConfig(
      apiBaseUrl: apiBaseUrl,
      useMockData: useMock,
    );
  }

  /// Base URL for the (future) Bayaan backend / Claude integration.
  final String apiBaseUrl;

  /// When true, the app is driven by in-memory mock repositories.
  final bool useMockData;
}
