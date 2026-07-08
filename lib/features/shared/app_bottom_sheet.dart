import 'package:bayaan/core/theme/theme_x.dart';
import 'package:flutter/material.dart';

/// A modal bottom sheet pinned to the bottom of the phone frame: a scrim plus
/// a rounded, slide-up panel with a drag handle. Content is provided by the
/// caller; the sheet sizes to its content.
class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({
    required this.onDismiss,
    required this.child,
    this.background,
    super.key,
  });

  final VoidCallback onDismiss;
  final Widget child;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onDismiss,
            child: const ColoredBox(color: Color(0x99000000)),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 1, end: 0),
            duration: const Duration(milliseconds: 300),
            curve: const Cubic(0.32, 0.72, 0.35, 1),
            builder: (context, v, child) => Transform.translate(
              offset: Offset(0, v * 320),
              child: child,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: background ?? c.card,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(26),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x80000000),
                    blurRadius: 48,
                    offset: Offset(0, -12),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(22, 12, 22, 34),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 38,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: c.borderStrong,
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                      Flexible(child: child),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
