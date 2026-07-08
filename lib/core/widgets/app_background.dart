import 'package:bayaan/core/theme/theme_x.dart';
import 'package:flutter/material.dart';

/// The app's ambient "aurora" background: a base fill with a soft brand-blue
/// radial glow rising from the bottom-centre, mirroring the design's
/// `--bg-app` gradient.
class AppBackground extends StatelessWidget {
  const AppBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final glowStrong = c.isDark
        ? c.appGlow.withValues(alpha: 0.30)
        : c.appGlow.withValues(alpha: 0.90);
    final glowSoft = c.isDark
        ? c.appGlow.withValues(alpha: 0.10)
        : c.appGlow.withValues(alpha: 0.40);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0, 1.8),
          radius: 1.5,
          colors: [glowStrong, glowSoft, c.appBase],
          stops: const [0.0, 0.46, 0.78],
        ),
        color: c.appBase,
      ),
      child: child,
    );
  }
}
