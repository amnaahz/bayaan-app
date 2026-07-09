import 'package:bayaan/core/icons/lucide_icons.dart';
import 'package:bayaan/core/theme/app_theme.dart';
import 'package:bayaan/core/theme/bayaan_colors.dart';
import 'package:bayaan/core/theme/theme_x.dart';
import 'package:bayaan/core/widgets/bayaan_logo.dart';
import 'package:bayaan/core/widgets/fade_slide_in.dart';
import 'package:bayaan/core/widgets/indicators.dart';
import 'package:bayaan/data/models/answer_models.dart';
import 'package:bayaan/data/models/chat_models.dart';
import 'package:bayaan/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// The chat transcript: user bubbles and streamed assistant answers with
/// charts, stat cards, sources, actions and follow-ups.
class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    return ListView.separated(
      controller: s.chatScroll,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      itemCount: s.msgs.length,
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (context, i) {
        final m = s.msgs[i];
        return m.isUser ? _UserBubble(m: m) : _BotMessage(m: m);
      },
    );
  }
}

class _UserBubble extends StatelessWidget {
  const _UserBubble({required this.m});
  final ChatMessage m;

  @override
  Widget build(BuildContext context) {
    return FadeSlideIn(
      offset: 6,
      duration: const Duration(milliseconds: 250),
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width * 0.78,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: const BoxDecoration(
              color: BayaanBrand.blue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(5),
              ),
            ),
            child: Text(
              m.text,
              style: const TextStyle(
                fontSize: 14.5,
                height: 1.45,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BotMessage extends StatelessWidget {
  const _BotMessage({required this.m});
  final ChatMessage m;

  @override
  Widget build(BuildContext context) {
    return FadeSlideIn(
      offset: 6,
      duration: const Duration(milliseconds: 250),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: BayaanLogo(size: 26, borderRadius: 6),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (m.phase == MessagePhase.thinking)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: ThinkingDots(label: m.thinkingLabel),
                  ),
                if (m.phase != MessagePhase.thinking) ...[
                  _StreamingText(m: m),
                  if (m.phase == MessagePhase.done) ...[
                    const SizedBox(height: 12),
                    _ChartCard(m: m),
                    const SizedBox(height: 12),
                    _StatCards(stats: m.stats),
                    const SizedBox(height: 12),
                    _SourcesRow(sources: m.sources),
                    const SizedBox(height: 12),
                    _Actions(m: m),
                    const SizedBox(height: 12),
                    _FollowUps(followups: m.followups),
                  ],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StreamingText extends StatelessWidget {
  const _StreamingText({required this.m});
  final ChatMessage m;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 14.5, height: 1.58, color: c.bodyStrong),
        children: [
          TextSpan(text: m.shownText),
          if (m.phase == MessagePhase.streaming)
            const WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: BlinkingCursor(),
            ),
        ],
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.m});
  final ChatMessage m;

  Color _barColor(BayaanColors c, BarTone tone) => switch (tone) {
    BarTone.faint => c.blueTintBd,
    BarTone.mid => c.blueHoverBd,
    BarTone.strong => BayaanBrand.blue,
  };

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return FadeSlideIn(
      offset: 8,
      child: Container(
        padding: const EdgeInsets.fromLTRB(15, 14, 15, 12),
        decoration: BoxDecoration(
          color: c.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: c.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    m.chartTitle,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: c.ink,
                    ),
                  ),
                ),
                Text(
                  m.chartUnit,
                  style: AppTheme.mono(color: c.muted, fontSize: 10),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 64,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (var i = 0; i < m.bars.length; i++)
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: i == 0 ? 0 : 9),
                        child: _Bar(
                          heightFactor: m.bars[i].heightFactor,
                          color: _barColor(c, m.bars[i].tone),
                          delayMs: i * 80,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                for (var i = 0; i < m.bars.length; i++)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: i == 0 ? 0 : 9),
                      child: Text(
                        m.bars[i].label,
                        textAlign: TextAlign.center,
                        style: AppTheme.mono(color: c.muted, fontSize: 9.5),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({
    required this.heightFactor,
    required this.color,
    required this.delayMs,
  });
  final double heightFactor;
  final Color color;
  final int delayMs;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 34),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: heightFactor),
          duration: Duration(milliseconds: 500 + delayMs),
          curve: Curves.easeOutCubic,
          builder: (context, value, _) => FractionallySizedBox(
            heightFactor: value.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(5),
                  bottom: Radius.circular(2),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatCards extends StatelessWidget {
  const _StatCards({required this.stats});
  final List<StatCard> stats;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return FadeSlideIn(
      offset: 8,
      delay: const Duration(milliseconds: 100),
      child: Row(
        children: [
          for (var i = 0; i < stats.length; i++)
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: i == 0 ? 0 : 10),
                child: _statCard(c, stats[i]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _statCard(BayaanColors c, StatCard s) {
    final (bg, border, fg, valFg) = switch (s.tone) {
      StatTone.blue => (c.blueTint, c.blueTintBd, c.link, c.blueDeep),
      StatTone.green => (c.greenBg, c.greenBd, c.green, c.greenText),
    };
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 13),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            s.label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: fg,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            s.value,
            style: AppTheme.mono(
              color: valFg,
              fontSize: 19,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.19,
            ),
          ),
        ],
      ),
    );
  }
}

class _SourcesRow extends StatelessWidget {
  const _SourcesRow({required this.sources});
  final String sources;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return FadeSlideIn(
      offset: 8,
      delay: const Duration(milliseconds: 180),
      child: InkWell(
        onTap: context.read<AppState>().openSources,
        borderRadius: BorderRadius.circular(10),
        child: Row(
          children: [
            _avatar('S', BayaanBrand.blue, c),
            Transform.translate(
              offset: const Offset(-6, 0),
              child: _avatar('H', BayaanBrand.purple, c),
            ),
            const SizedBox(width: 1),
            Expanded(
              child: Text(
                sources,
                style: TextStyle(fontSize: 12, color: c.secondary2),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(99),
                border: Border.all(color: c.border),
              ),
              child: Text(
                'verified',
                style: AppTheme.mono(color: c.muted, fontSize: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _avatar(String letter, Color color, BayaanColors c) => Container(
    width: 18,
    height: 18,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: color,
      shape: BoxShape.circle,
      border: Border.all(color: c.card, width: 1.5),
    ),
    child: Text(
      letter,
      style: const TextStyle(
        fontSize: 9,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    ),
  );
}

class _Actions extends StatelessWidget {
  const _Actions({required this.m});
  final ChatMessage m;

  @override
  Widget build(BuildContext context) {
    final s = context.read<AppState>();
    final c = context.colors;
    final copied = context.select<AppState, bool>((x) => x.copiedFor(m.id));

    return FadeSlideIn(
      offset: 8,
      delay: const Duration(milliseconds: 220),
      child: Row(
        children: [
          _iconBtn(
            LucideIcons.thumbsUp,
            active: m.vote == MessageVote.up,
            color: m.vote == MessageVote.up ? BayaanBrand.blue : c.muted,
            onTap: () => s.setVote(m.id, MessageVote.up),
            c: c,
          ),
          _iconBtn(
            LucideIcons.thumbsDown,
            active: m.vote == MessageVote.down,
            color: m.vote == MessageVote.down ? c.red : c.muted,
            onTap: () => s.setVote(m.id, MessageVote.down),
            c: c,
          ),
          Container(
            width: 1,
            height: 16,
            color: c.border,
            margin: const EdgeInsets.symmetric(horizontal: 4),
          ),
          _iconBtn(
            copied ? LucideIcons.check : LucideIcons.copy,
            color: copied ? c.green : c.muted,
            onTap: () => s.copyMessage(m.id),
            c: c,
          ),
          _iconBtn(
            LucideIcons.refreshCw,
            color: c.muted,
            onTap: () => s.regenerate(m),
            c: c,
          ),
          _iconBtn(LucideIcons.share2, color: c.muted, onTap: () {}, c: c),
        ],
      ),
    );
  }

  Widget _iconBtn(
    IconData icon, {
    required Color color,
    required VoidCallback onTap,
    required BayaanColors c,
    bool active = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 30,
        height: 30,
        alignment: Alignment.center,
        child: Icon(icon, size: 15, color: color),
      ),
    );
  }
}

class _FollowUps extends StatelessWidget {
  const _FollowUps({required this.followups});
  final List<String> followups;

  @override
  Widget build(BuildContext context) {
    final s = context.read<AppState>();
    final c = context.colors;
    return FadeSlideIn(
      offset: 8,
      delay: const Duration(milliseconds: 260),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.messageSquare, size: 14, color: c.muted),
              const SizedBox(width: 7),
              Text(
                'Follow-up questions',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: c.secondary2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final f in followups)
                InkWell(
                  onTap: () => s.askQuery(f),
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 7,
                      horizontal: 13,
                    ),
                    decoration: BoxDecoration(
                      color: c.blueTint,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: c.blueTintBd),
                    ),
                    child: Text(
                      f,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: c.link,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
