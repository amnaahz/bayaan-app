import 'package:flutter/material.dart';

/// Theme-independent brand colors. These are used verbatim in the design
/// regardless of light/dark mode (e.g. the primary action blue `#297DE3`).
abstract final class BayaanBrand {
  /// Primary brand blue — actions, links, active states.
  static const Color blue = Color(0xFF297DE3);

  /// Deep-research / secondary accent purple.
  static const Color purple = Color(0xFFA548F2);

  /// Reports accent amber (icon tone).
  static const Color amber = Color(0xFFE79A00);

  /// "Live" indicator red (recording dot).
  static const Color redLive = Color(0xFFE5484D);

  /// Pure white, used on colored surfaces.
  static const Color white = Color(0xFFFFFFFF);

  /// Voice orb radial gradient: `#5D97EC -> #297DE3 -> #1A55B0`.
  static const List<Color> orbGradient = [
    Color(0xFF5D97EC),
    Color(0xFF297DE3),
    Color(0xFF1A55B0),
  ];

  /// Audio player artwork radial gradient: `#5BBF77 -> #228636 -> #16612B`.
  static const List<Color> audioGradient = [
    Color(0xFF5BBF77),
    Color(0xFF228636),
    Color(0xFF16612B),
  ];
}

/// A [ThemeExtension] that ports the full set of CSS design tokens
/// (`--bg`, `--card`, `--ink`, ...) from the Bayaan design for both themes.
///
/// Widgets read these via `context.colors` (see `theme_x.dart`) so the code
/// mirrors the original `var(--token)` usage one-to-one.
@immutable
class BayaanColors extends ThemeExtension<BayaanColors> {
  const BayaanColors({
    required this.bg,
    required this.bgHover,
    required this.card,
    required this.panel,
    required this.fill,
    required this.hairline,
    required this.border,
    required this.borderStrong,
    required this.segThumb,
    required this.selected,
    required this.checkBorder,
    required this.faint,
    required this.muted,
    required this.secondary2,
    required this.secondary,
    required this.body,
    required this.bodyStrong,
    required this.textMax,
    required this.ink,
    required this.link,
    required this.blueDeep,
    required this.blueTint,
    required this.blueTintBd,
    required this.blueHoverBd,
    required this.blueGenBd,
    required this.btnHover,
    required this.amberBg,
    required this.greenBg,
    required this.greenBd,
    required this.greenText,
    required this.green,
    required this.purpleBg,
    required this.purpleBd,
    required this.purpleText,
    required this.redBg,
    required this.red,
    required this.bubble,
    required this.bubbleBd,
    required this.tintPurple,
    required this.tintGrey,
    required this.appBase,
    required this.appGlow,
    required this.isDark,
  });

  final Color bg;
  final Color bgHover;
  final Color card;
  final Color panel;
  final Color fill;
  final Color hairline;
  final Color border;
  final Color borderStrong;
  final Color segThumb;
  final Color selected;
  final Color checkBorder;
  final Color faint;
  final Color muted;
  final Color secondary2;
  final Color secondary;
  final Color body;
  final Color bodyStrong;
  final Color textMax;
  final Color ink;
  final Color link;
  final Color blueDeep;
  final Color blueTint;
  final Color blueTintBd;
  final Color blueHoverBd;
  final Color blueGenBd;
  final Color btnHover;
  final Color amberBg;
  final Color greenBg;
  final Color greenBd;
  final Color greenText;
  final Color green;
  final Color purpleBg;
  final Color purpleBd;
  final Color purpleText;
  final Color redBg;
  final Color red;
  final Color bubble;
  final Color bubbleBd;
  final Color tintPurple;
  final Color tintGrey;

  /// Base fill behind the app "aurora" background gradient.
  final Color appBase;

  /// Glow color used for the radial gradient in the app background.
  final Color appGlow;

  final bool isDark;

  static const BayaanColors dark = BayaanColors(
    bg: Color(0xFF171B23),
    bgHover: Color(0xFF1D222B),
    card: Color(0xFF1E232D),
    panel: Color(0xFF20252F),
    fill: Color(0xFF252B36),
    hairline: Color(0xFF2A3039),
    border: Color(0xFF2E3540),
    borderStrong: Color(0xFF353D49),
    segThumb: Color(0xFF39424F),
    selected: Color(0xFF1B2634),
    checkBorder: Color(0xFF39404D),
    faint: Color(0xFF4A505C),
    muted: Color(0xFF6E7684),
    secondary2: Color(0xFF9AA1AD),
    secondary: Color(0xFFA6ACB8),
    body: Color(0xFFC7CCD6),
    bodyStrong: Color(0xFFE8EBF0),
    textMax: Color(0xFFEDF0F5),
    ink: Color(0xFFF2F4F8),
    link: Color(0xFF6FA5EE),
    blueDeep: Color(0xFF7FB0F5),
    blueTint: Color(0xFF15263E),
    blueTintBd: Color(0xFF20395C),
    blueHoverBd: Color(0xFF2E5A94),
    blueGenBd: Color(0xFF1B3151),
    btnHover: Color(0xFF4A90E8),
    amberBg: Color(0xFF2E2513),
    greenBg: Color(0xFF14291B),
    greenBd: Color(0xFF1F4228),
    greenText: Color(0xFF7ECD96),
    green: Color(0xFF46B968),
    purpleBg: Color(0xFF271A36),
    purpleBd: Color(0xFF3C2A57),
    purpleText: Color(0xFFC495F5),
    redBg: Color(0xFF3A181B),
    red: Color(0xFFF16A6A),
    bubble: Color(0xFF1D2A3E),
    bubbleBd: Color(0xFF25344C),
    tintPurple: Color(0xFF2A1D3D),
    tintGrey: Color(0xFF2C3442),
    appBase: Color(0xFF171B23),
    appGlow: Color(0xFF297DE3),
    isDark: true,
  );

  static const BayaanColors light = BayaanColors(
    bg: Color(0xFFFDFDFC),
    bgHover: Color(0xFFFAFBFD),
    card: Color(0xFFFFFFFF),
    panel: Color(0xFFF8F9FB),
    fill: Color(0xFFF3F4F6),
    hairline: Color(0xFFF0F0EE),
    border: Color(0xFFECEDEF),
    borderStrong: Color(0xFFE5E7EB),
    segThumb: Color(0xFFFFFFFF),
    selected: Color(0xFFF8F9FB),
    checkBorder: Color(0xFFD1D5DB),
    faint: Color(0xFFC6C9CE),
    muted: Color(0xFF9CA3AF),
    secondary2: Color(0xFF6B7280),
    secondary: Color(0xFF4B5563),
    body: Color(0xFF374151),
    bodyStrong: Color(0xFF1F2937),
    textMax: Color(0xFF111827),
    ink: Color(0xFF1B1F33),
    link: Color(0xFF1F65BD),
    blueDeep: Color(0xFF184F97),
    blueTint: Color(0xFFEAF2FF),
    blueTintBd: Color(0xFFCFE3FF),
    blueHoverBd: Color(0xFFA6C7FB),
    blueGenBd: Color(0xFFDCE9FB),
    btnHover: Color(0xFF1F65BD),
    amberBg: Color(0xFFFEF1C9),
    greenBg: Color(0xFFD8F3D6),
    greenBd: Color(0xFFBCE8B9),
    greenText: Color(0xFF1A6B2B),
    green: Color(0xFF228636),
    purpleBg: Color(0xFFF3E8FE),
    purpleBd: Color(0xFFE4D1FC),
    purpleText: Color(0xFF8436C6),
    redBg: Color(0xFFFEE2E2),
    red: Color(0xFFDC2626),
    bubble: Color(0xFFF1F6FE),
    bubbleBd: Color(0xFFE9F1FD),
    tintPurple: Color(0xFFF8F3FE),
    tintGrey: Color(0xFFE3EAF4),
    appBase: Color(0xFFFDFDFC),
    appGlow: Color(0xFFCFE3FF),
    isDark: false,
  );

  @override
  BayaanColors copyWith({bool? isDark}) => isDark ?? this.isDark ? dark : light;

  @override
  BayaanColors lerp(ThemeExtension<BayaanColors>? other, double t) {
    if (other is! BayaanColors) return this;
    return t < 0.5 ? this : other;
  }
}
