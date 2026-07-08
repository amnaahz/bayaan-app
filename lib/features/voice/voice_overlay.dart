import 'dart:async';

import 'package:bayaan/core/icons/lucide_icons.dart';
import 'package:bayaan/core/theme/app_theme.dart';
import 'package:bayaan/core/theme/bayaan_colors.dart';
import 'package:bayaan/core/theme/theme_x.dart';
import 'package:bayaan/core/widgets/bayaan_logo.dart';
import 'package:bayaan/core/widgets/fade_slide_in.dart';
import 'package:bayaan/core/widgets/indicators.dart';
import 'package:bayaan/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// The full-screen live voice conversation: animated orb, live transcript,
/// key-figure chips and call controls.
class VoiceOverlay extends StatelessWidget {
  const VoiceOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final c = context.colors;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [c.bg, c.bubble, c.bubbleBd],
          stops: const [0, 0.7, 1],
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 64, 24, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const PulseDot(color: BayaanBrand.redLive),
                    const SizedBox(width: 9),
                    Text(
                      'Live conversation',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: c.ink,
                      ),
                    ),
                  ],
                ),
                Text(
                  s.voiceElapsedLabel,
                  style: AppTheme.mono(color: c.muted, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 38),
          _Orb(s: s, c: c),
          const SizedBox(height: 18),
          Text(
            s.phaseLabel,
            style: AppTheme.mono(
              color: _phaseColor(s, c),
              fontWeight: FontWeight.w600,
              letterSpacing: 1.8,
            ),
          ),
          Expanded(
            child: _Transcript(s: s, c: c),
          ),
          _Controls(s: s, c: c),
          Padding(
            padding: const EdgeInsets.only(bottom: 22),
            child: Text(
              s.voiceHint,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11.5, color: c.muted),
            ),
          ),
        ],
      ),
    );
  }

  Color _phaseColor(AppState s, BayaanColors c) {
    if (s.vThinking) return BayaanBrand.purple;
    if (s.vSpeaking) return BayaanBrand.blue;
    return c.secondary2;
  }
}

class _Orb extends StatefulWidget {
  const _Orb({required this.s, required this.c});
  final AppState s;
  final BayaanColors c;

  @override
  State<_Orb> createState() => _OrbState();
}

class _OrbState extends State<_Orb> with TickerProviderStateMixin {
  late final AnimationController _spin = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 6),
  )..repeat();
  late final AnimationController _breathe = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  )..repeat(reverse: true);

  @override
  void didUpdateWidget(covariant _Orb oldWidget) {
    super.didUpdateWidget(oldWidget);
    _spin.duration = widget.s.ringSpeed;
    _breathe.duration = widget.s.orbSpeed;
  }

  @override
  void dispose() {
    _spin.dispose();
    _breathe.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.s;
    return SizedBox(
      width: 158,
      height: 158,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (s.vListening) ...[
            const _RingPulse(delay: Duration.zero),
            const _RingPulse(delay: Duration(milliseconds: 550)),
          ],
          RotationTransition(
            turns: _spin,
            child: Container(
              width: 138,
              height: 138,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: SweepGradient(
                  colors: [
                    Color(0x00297DE3),
                    Color(0x66297DE3),
                    Color(0x40A548F2),
                    Color(0x00297DE3),
                  ],
                ),
              ),
            ),
          ),
          ScaleTransition(
            scale: Tween<double>(begin: 0.97, end: 1.05).animate(_breathe),
            child: Container(
              width: 112,
              height: 112,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  center: Alignment(-0.32, -0.4),
                  colors: [
                    Color(0xFF5D97EC),
                    Color(0xFF297DE3),
                    Color(0xFF1A55B0),
                  ],
                  stops: [0, 0.58, 1],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x59297DE3),
                    blurRadius: 44,
                    offset: Offset(0, 18),
                  ),
                ],
              ),
              child: s.vWave
                  ? const WaveBars(
                      heights: [14, 26, 38, 26, 14],
                      color: Colors.white,
                      barWidth: 6,
                      gap: 4.5,
                    )
                  : BayaanMark(size: 42, color: widget.c.card),
            ),
          ),
        ],
      ),
    );
  }
}

class _RingPulse extends StatefulWidget {
  const _RingPulse({required this.delay});
  final Duration delay;

  @override
  State<_RingPulse> createState() => _RingPulseState();
}

class _RingPulseState extends State<_RingPulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  );

  @override
  void initState() {
    super.initState();
    unawaited(
      Future.delayed(widget.delay, () {
        if (mounted) unawaited(_c.repeat());
      }),
    );
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final t = _c.value;
        return Opacity(
          opacity: (1 - t) * 0.6,
          child: Transform.scale(
            scale: 0.7 + t * 0.6,
            child: Container(
              width: 158,
              height: 158,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF297DE3).withValues(alpha: 0.30),
                  width: 1.5,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Transcript extends StatelessWidget {
  const _Transcript({required this.s, required this.c});
  final AppState s;
  final BayaanColors c;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(30, 26, 30, 0),
      child: Column(
        children: [
          if (s.vShowUser)
            Text(
              '“${s.voiceUserShown}”',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                height: 1.45,
                letterSpacing: -0.2,
                color: c.ink,
              ),
            ),
          if (s.vAnswerVisible) ...[
            Text(
              '“${s.voiceQuestion}”',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: c.muted,
              ),
            ),
            const SizedBox(height: 10),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 330),
              child: Text(
                s.voiceBotShown,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.5, height: 1.6, color: c.body),
              ),
            ),
            const SizedBox(height: 22),
            Wrap(
              spacing: 9,
              runSpacing: 9,
              alignment: WrapAlignment.center,
              children: [
                for (final chip in s.voiceChips)
                  FadeSlideIn(
                    key: ValueKey(chip.label),
                    offset: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 14,
                      ),
                      decoration: BoxDecoration(
                        color: c.card,
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(color: c.tintGrey),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x1A297DE3),
                            blurRadius: 16,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            chip.value,
                            style: AppTheme.mono(
                              color: c.blueDeep,
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            chip.label,
                            style: TextStyle(
                              fontSize: 10.5,
                              color: c.secondary2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ],
          if (s.vThinking)
            const Padding(
              padding: EdgeInsets.only(top: 14),
              child: ThinkingDots(label: 'consulting SCAD releases…'),
            ),
        ],
      ),
    );
  }
}

class _Controls extends StatelessWidget {
  const _Controls({required this.s, required this.c});
  final AppState s;
  final BayaanColors c;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _sideBtn(
            icon: s.voiceMuted ? LucideIcons.micOff : LucideIcons.mic,
            iconColor: s.voiceMuted ? BayaanBrand.redLive : c.ink,
            bg: s.voiceMuted ? c.blueTint : c.card,
            onTap: s.toggleMute,
          ),
          const SizedBox(width: 22),
          InkWell(
            onTap: s.endVoice,
            borderRadius: BorderRadius.circular(999),
            child: Container(
              width: 68,
              height: 68,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: BayaanBrand.blue,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x47000000),
                    blurRadius: 28,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Transform.rotate(
                angle: 2.356,
                child: const Icon(
                  LucideIcons.phone,
                  size: 26,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 22),
          _sideBtn(
            icon: LucideIcons.messageSquare,
            iconColor: c.ink,
            bg: c.card,
            onTap: s.voiceToText,
          ),
        ],
      ),
    );
  }

  Widget _sideBtn({
    required IconData icon,
    required Color iconColor,
    required Color bg,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 54,
        height: 54,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          shape: BoxShape.circle,
          border: Border.all(color: c.tintGrey),
          boxShadow: const [
            BoxShadow(
              color: Color(0x52000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 21, color: iconColor),
      ),
    );
  }
}
