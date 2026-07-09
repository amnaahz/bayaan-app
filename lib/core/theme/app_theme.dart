import 'package:bayaan/core/theme/bayaan_colors.dart';
import 'package:flutter/material.dart';

/// Builds the light and dark [ThemeData] for Bayaan.
///
/// Typography uses Geist (UI) with Geist Mono reserved for figures and
/// micro-labels (accessed via [AppTheme.mono]). Both families are bundled with
/// the app (see `pubspec.yaml`) so they render without a runtime network fetch.
/// The full design token set is attached as a [BayaanColors] theme extension.
abstract final class AppTheme {
  /// Bundled font family names (must match the `fonts:` entries in pubspec).
  static const String fontSans = 'Geist';
  static const String fontMono = 'Geist Mono';

  static ThemeData dark() => _build(BayaanColors.dark, Brightness.dark);
  static ThemeData light() => _build(BayaanColors.light, Brightness.light);

  /// Geist Mono text style helper for figures / uppercase micro-labels.
  static TextStyle mono({
    required Color color,
    double fontSize = 11,
    FontWeight fontWeight = FontWeight.w500,
    double? letterSpacing,
    double? height,
  }) {
    return TextStyle(
      fontFamily: fontMono,
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  static ThemeData _build(BayaanColors c, Brightness brightness) {
    final base = ThemeData(brightness: brightness, useMaterial3: true);
    final textTheme = base.textTheme.apply(
      fontFamily: fontSans,
      bodyColor: c.body,
      displayColor: c.ink,
    );

    return base.copyWith(
      scaffoldBackgroundColor: c.bg,
      canvasColor: c.bg,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      primaryColor: BayaanBrand.blue,
      colorScheme: base.colorScheme.copyWith(
        brightness: brightness,
        primary: BayaanBrand.blue,
        secondary: BayaanBrand.purple,
        surface: c.card,
        error: c.red,
      ),
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      extensions: [c],
    );
  }
}
