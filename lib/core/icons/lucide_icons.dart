import 'package:flutter/widgets.dart';

/// Lucide icon glyphs used across the app.
///
/// The upstream `lucide_icons` package (0.257.0) defines its icons by
/// subclassing [IconData], which no longer compiles because Flutter made
/// [IconData] a `final` class. We therefore construct the glyphs directly here
/// with the plain [IconData] constructor while still rendering from the font
/// bundled by the `lucide_icons` package (family `Lucide`).
///
/// Only the icons referenced by the UI are declared. Add more code points from
/// the Lucide font as needed.
abstract final class LucideIcons {
  const LucideIcons._();

  static const IconData arrowUp = IconData(
    0xf15b,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const IconData arrowUpRight = IconData(
    0xf167,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const IconData barChart3 = IconData(
    0xf187,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const IconData bell = IconData(
    0xf19c,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const IconData camera = IconData(
    0xf1df,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const IconData check = IconData(
    0xf1ee,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const IconData checkCircle2 = IconData(
    0xf1f1,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const IconData chevronDown = IconData(
    0xf1f5,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const IconData chevronLeft = IconData(
    0xf1f9,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const IconData chevronRight = IconData(
    0xf1fb,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const IconData circle = IconData(
    0xf20b,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const IconData clipboard = IconData(
    0xf218,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const IconData code = IconData(
    0xf23f,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const IconData copy = IconData(
    0xf252,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const IconData edit3 = IconData(
    0xf292,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const IconData filePlus = IconData(
    0xf2c8,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const IconData fileText = IconData(
    0xf2d3,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const IconData folder = IconData(
    0xf2f8,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const IconData globe = IconData(
    0xf33a,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const IconData headphones = IconData(
    0xf353,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const IconData image = IconData(
    0xf365,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const IconData layoutGrid = IconData(
    0xf38a,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const IconData link = IconData(
    0xf397,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const IconData menu = IconData(
    0xf3ca,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const IconData messageSquare = IconData(
    0xf3ce,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const IconData mic = IconData(0xf3d2, fontFamily: _f, fontPackage: _p);
  static const IconData micOff = IconData(
    0xf3d4,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const IconData microscope = IconData(
    0xf3d5,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const IconData moreHorizontal = IconData(
    0xf3ed,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const IconData moreVertical = IconData(
    0xf3ee,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const IconData pause = IconData(
    0xf438,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const IconData pencil = IconData(
    0xf43d,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const IconData phone = IconData(
    0xf440,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const IconData pin = IconData(0xf450, fontFamily: _f, fontPackage: _p);
  static const IconData play = IconData(
    0xf457,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const IconData plus = IconData(
    0xf45e,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const IconData refreshCw = IconData(
    0xf480,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const IconData rotateCcw = IconData(
    0xf491,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const IconData search = IconData(
    0xf4ad,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const IconData settings = IconData(
    0xf4b9,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const IconData share2 = IconData(
    0xf4bd,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const IconData sparkles = IconData(
    0xf4e8,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const IconData sun = IconData(0xf50f, fontFamily: _f, fontPackage: _p);
  static const IconData thumbsDown = IconData(
    0xf537,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const IconData thumbsUp = IconData(
    0xf538,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const IconData trash2 = IconData(
    0xf546,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const IconData upload = IconData(
    0xf561,
    fontFamily: _f,
    fontPackage: _p,
  );
  static const IconData x = IconData(0xf59e, fontFamily: _f, fontPackage: _p);
  static const IconData zap = IconData(0xf5a3, fontFamily: _f, fontPackage: _p);

  static const String _f = 'Lucide';
  static const String _p = 'lucide_icons';
}
