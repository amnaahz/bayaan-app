import 'package:bayaan/core/theme/bayaan_colors.dart';
import 'package:flutter/material.dart';

/// Convenience access to the [BayaanColors] token set from any widget:
///
/// ```dart
/// final c = context.colors;
/// Container(color: c.card);
/// ```
extension BayaanThemeX on BuildContext {
  BayaanColors get colors =>
      Theme.of(this).extension<BayaanColors>() ?? BayaanColors.dark;
}
