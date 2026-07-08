import 'package:bayaan/core/icons/lucide_icons.dart';
import 'package:bayaan/core/theme/app_theme.dart';
import 'package:bayaan/core/theme/bayaan_colors.dart';
import 'package:bayaan/core/theme/theme_x.dart';
import 'package:bayaan/core/widgets/fade_slide_in.dart';
import 'package:bayaan/data/mock/mock_data.dart';
import 'package:bayaan/data/models/ui_models.dart';
import 'package:bayaan/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Home / daily-briefing screen: greeting, rotating tagline, conversation
/// starters.
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final c = context.colors;

    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.sizeOf(context).height - 220,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 12, 0, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeSlideIn(
                      child: Text(
                        s.dateLine.toUpperCase(),
                        style: AppTheme.mono(
                          color: c.muted,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    FadeSlideIn(
                      delay: const Duration(milliseconds: 50),
                      child: _greeting(context, s, c),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 34),
              FadeSlideIn(
                delay: const Duration(milliseconds: 200),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'START A CONVERSATION',
                        style: AppTheme.mono(
                          color: c.muted,
                          fontSize: 10.5,
                          letterSpacing: 1.3,
                        ),
                      ),
                      const SizedBox(height: 2),
                      for (final st in kStarters) _StarterRow(starter: st),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _greeting(BuildContext context, AppState s, BayaanColors c) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 30,
          height: 1.18,
          letterSpacing: -0.84,
          color: c.ink,
          fontWeight: FontWeight.w400,
        ),
        children: [
          TextSpan(text: '${s.greeting}, '),
          TextSpan(
            text: s.firstName,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const TextSpan(text: '.\n'),
          WidgetSpan(
            child: AnimatedOpacity(
              opacity: s.homeLineOpacity,
              duration: const Duration(milliseconds: 350),
              child: Text(
                s.homeLine,
                style: const TextStyle(
                  fontSize: 30,
                  height: 1.18,
                  letterSpacing: -0.84,
                  color: BayaanBrand.blue,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StarterRow extends StatelessWidget {
  const _StarterRow({required this.starter});

  final Starter starter;

  @override
  Widget build(BuildContext context) {
    final s = context.read<AppState>();
    final c = context.colors;
    final (bg, fg) = switch (starter.tone) {
      StarterTone.blue => (c.blueTint, BayaanBrand.blue),
      StarterTone.purple => (c.purpleBg, BayaanBrand.purple),
      StarterTone.green => (c.greenBg, c.green),
    };

    return InkWell(
      onTap: () => s.askStarter(starter),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 2),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: c.hairline)),
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Text(
                starter.num,
                style: AppTheme.mono(
                  color: fg,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Text(
                starter.question,
                style: TextStyle(fontSize: 14.5, height: 1.35, color: c.body),
              ),
            ),
            Icon(LucideIcons.arrowUpRight, size: 15, color: c.faint),
          ],
        ),
      ),
    );
  }
}
