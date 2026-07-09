import 'package:bayaan/core/icons/lucide_icons.dart';
import 'package:bayaan/core/theme/app_theme.dart';
import 'package:bayaan/core/theme/bayaan_colors.dart';
import 'package:bayaan/core/theme/theme_x.dart';
import 'package:bayaan/core/widgets/fade_slide_in.dart';
import 'package:bayaan/core/widgets/hover_tap.dart';
import 'package:bayaan/features/agents/agent_visuals.dart';
import 'package:bayaan/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Full-surface agent profile: identity, description, capabilities,
/// conversation starters and a "Start chat" action.
class AgentProfileOverlay extends StatelessWidget {
  const AgentProfileOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final c = context.colors;
    final agent = s.activeAgent;
    if (agent == null) return const SizedBox.shrink();
    final tile = agentTileColors(c, agent.tone);
    final topInset = MediaQuery.paddingOf(context).top;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Material(
      color: c.bg,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(14, topInset + 14, 14, 0),
            child: Row(
              children: [
                BayaanIconButton(
                  icon: Icon(LucideIcons.chevronLeft, size: 20, color: c.ink),
                  hoverColor: c.fill,
                  onTap: s.closeAgent,
                ),
                Expanded(
                  child: Text(
                    'Agent',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: c.secondary,
                    ),
                  ),
                ),
                BayaanIconButton(
                  icon: Icon(
                    LucideIcons.moreVertical,
                    size: 19,
                    color: c.ink,
                  ),
                  hoverColor: c.fill,
                  onTap: () {},
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(22, 8, 22, 30),
              children: [
                FadeSlideIn(
                  child: Column(
                    children: [
                      Container(
                        width: 74,
                        height: 74,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: tile.bg,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x24000000),
                              blurRadius: 16,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          agent.initials,
                          style: AppTheme.mono(
                            color: tile.fg,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        agent.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.4,
                          color: c.ink,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'BY ${agent.by.toUpperCase()} · UAE STATISTICS',
                        style: AppTheme.mono(
                          color: c.muted,
                          letterSpacing: 0.9,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 50),
                  child: Text(
                    agent.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: c.bodyStrong,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 100),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final cap in agent.capabilities)
                        _CapChip(label: cap, c: c),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 26, bottom: 4),
                  child: Text(
                    'Conversation starters',
                    style: AppTheme.mono(
                      color: c.muted,
                      fontSize: 10.5,
                      letterSpacing: 1.3,
                    ),
                  ),
                ),
                for (var i = 0; i < agent.starters.length; i++)
                  FadeSlideIn(
                    delay: Duration(milliseconds: 120 + 40 * i),
                    child: _StarterCard(
                      text: agent.starters[i],
                      onTap: () => s.startAgentWith(agent.starters[i]),
                      c: c,
                    ),
                  ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 12, 20, 20 + bottomInset),
            decoration: BoxDecoration(
              color: c.bg,
              border: Border(top: BorderSide(color: c.hairline)),
            ),
            child: InkWell(
              onTap: s.startAgent,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: BayaanBrand.blue,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      LucideIcons.messageSquare,
                      size: 18,
                      color: Colors.white,
                    ),
                    SizedBox(width: 9),
                    Text(
                      'Start chat',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CapChip extends StatelessWidget {
  const _CapChip({required this.label, required this.c});
  final String label;
  final BayaanColors c;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: c.fill,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: c.border),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: c.secondary,
        ),
      ),
    );
  }
}

class _StarterCard extends StatelessWidget {
  const _StarterCard({
    required this.text,
    required this.onTap,
    required this.c,
  });
  final String text;
  final VoidCallback onTap;
  final BayaanColors c;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 9),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
          decoration: BoxDecoration(
            color: c.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: c.border),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: c.bodyStrong,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Icon(LucideIcons.arrowRight, size: 15, color: c.link),
            ],
          ),
        ),
      ),
    );
  }
}
