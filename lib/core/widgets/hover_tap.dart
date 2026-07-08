import 'package:flutter/material.dart';

/// A tappable region that exposes a hover state (for web/desktop) so callers
/// can reproduce the design's `style-hover` background changes.
class HoverTap extends StatefulWidget {
  const HoverTap({
    required this.builder,
    this.onTap,
    this.cursor = SystemMouseCursors.click,
    super.key,
  });

  final ValueWidgetBuilder<bool> builder;
  final VoidCallback? onTap;
  final MouseCursor cursor;

  @override
  State<HoverTap> createState() => _HoverTapState();
}

class _HoverTapState extends State<HoverTap> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.cursor,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: widget.builder(context, _hovering, null),
      ),
    );
  }
}

/// A 40x40 rounded icon button used in headers and toolbars, with a hover
/// fill. Pass any [icon] widget (typically a Lucide icon).
class BayaanIconButton extends StatelessWidget {
  const BayaanIconButton({
    required this.icon,
    required this.hoverColor,
    this.onTap,
    this.size = 40,
    this.radius = 11,
    super.key,
  });

  final Widget icon;
  final Color hoverColor;
  final VoidCallback? onTap;
  final double size;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return HoverTap(
      onTap: onTap,
      builder: (context, hovering, _) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: hovering ? hoverColor : Colors.transparent,
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Center(child: icon),
        );
      },
    );
  }
}
