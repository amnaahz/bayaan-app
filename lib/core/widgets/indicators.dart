import 'dart:math' as math;

import 'package:bayaan/core/theme/app_theme.dart';
import 'package:bayaan/core/theme/bayaan_colors.dart';
import 'package:bayaan/core/theme/theme_x.dart';
import 'package:flutter/material.dart';

/// Three brand-blue dots that pulse in sequence, with a trailing label.
/// Mirrors the design's `pulseDot` thinking indicator.
class ThinkingDots extends StatefulWidget {
  const ThinkingDots({required this.label, super.key});

  final String label;

  @override
  State<ThinkingDots> createState() => _ThinkingDotsState();
}

class _ThinkingDotsState extends State<ThinkingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  double _opacityFor(double phase) {
    final t = (_c.value + phase) % 1.0;
    // 0.25 -> 1 -> 0.25 across the cycle.
    final wave = t < 0.5 ? t / 0.5 : (1 - t) / 0.5;
    return 0.25 + 0.75 * wave;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _dot(_opacityFor(0)),
            const SizedBox(width: 6),
            _dot(_opacityFor(0.16)),
            const SizedBox(width: 6),
            _dot(_opacityFor(0.33)),
            const SizedBox(width: 9),
            Flexible(
              child: Text(
                widget.label,
                overflow: TextOverflow.ellipsis,
                style: AppTheme.mono(color: c.secondary2, fontSize: 11.5),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _dot(double opacity) => Opacity(
    opacity: opacity,
    child: Container(
      width: 6,
      height: 6,
      decoration: const BoxDecoration(
        color: BayaanBrand.blue,
        shape: BoxShape.circle,
      ),
    ),
  );
}

/// A blinking caret shown at the end of streaming text.
class BlinkingCursor extends StatefulWidget {
  const BlinkingCursor({this.width = 8, this.height = 15, super.key});

  final double width;
  final double height;

  @override
  State<BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) => Opacity(
        opacity: _c.value < 0.5 ? 1 : 0,
        child: Container(
          width: widget.width,
          height: widget.height,
          margin: const EdgeInsets.only(left: 2),
          decoration: BoxDecoration(
            color: BayaanBrand.blue,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}

/// An animated equaliser / waveform of bars, used for dictation, the voice
/// orb and the audio player.
class WaveBars extends StatefulWidget {
  const WaveBars({
    required this.heights,
    required this.color,
    this.barWidth = 3,
    this.gap = 3,
    super.key,
  });

  /// The peak height (px) of each bar.
  final List<double> heights;
  final Color color;
  final double barWidth;
  final double gap;

  @override
  State<WaveBars> createState() => _WaveBarsState();
}

class _WaveBarsState extends State<WaveBars>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxH = widget.heights.reduce(math.max);
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        return SizedBox(
          height: maxH,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < widget.heights.length; i++) ...[
                if (i > 0) SizedBox(width: widget.gap),
                _bar(widget.heights[i], i),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _bar(double peak, int i) {
    final phase = (_c.value + i * 0.12) * 2 * math.pi;
    final scale = 0.45 + 0.55 * (0.5 + 0.5 * math.sin(phase));
    return Container(
      width: widget.barWidth,
      height: peak * scale,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(99),
      ),
    );
  }
}

/// A single dot that pulses opacity continuously (e.g. the live/recording
/// indicator).
class PulseDot extends StatefulWidget {
  const PulseDot({
    required this.color,
    this.size = 7,
    this.duration = const Duration(milliseconds: 1400),
    super.key,
  });

  final Color color;
  final double size;
  final Duration duration;

  @override
  State<PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<PulseDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: widget.duration,
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.35, end: 1).animate(_c),
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
      ),
    );
  }
}
