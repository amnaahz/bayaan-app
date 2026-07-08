import 'package:bayaan/core/theme/bayaan_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Builds the light and dark [ThemeData] for Bayaan.
///
/// Typography uses Geist (UI) with Geist Mono reserved for figures and
/// micro-labels (accessed via [AppTheme.mono]). The full design token set is
/// attached as a [BayaanColors] theme extension.
abstract final class AppTheme {
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
    return GoogleFonts.geistMono(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  static ThemeData _build(BayaanColors c, Brightness brightness) {
    final base = ThemeData(brightness: brightness, useMaterial3: true);
    final textTheme = GoogleFonts.geistTextTheme(base.textTheme).apply(
      bodyColor: c.body,
      displayColor: c.ink,
    );

    return base.copyWith(
      scaffoldBackgroundColor: c.bg,
      canvasColor: c.bg,
      textTheme: textTheme,
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
