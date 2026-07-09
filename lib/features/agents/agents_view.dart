import 'package:bayaan/core/icons/lucide_icons.dart';
import 'package:bayaan/core/theme/app_theme.dart';
import 'package:bayaan/core/theme/bayaan_colors.dart';
import 'package:bayaan/core/theme/theme_x.dart';
import 'package:bayaan/core/widgets/fade_slide_in.dart';
import 'package:bayaan/data/models/agent_models.dart';
import 'package:bayaan/features/agents/agent_visuals.dart';
import 'package:bayaan/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Agents list: specialised assistants grounded in official SCAD statistics.
class AgentsView extends StatelessWidget {
  const AgentsView({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final c = context.colors;
    final featured = s.featuredAgents;
    final mine = s.myAgents;

    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 12, 22, 30),
      children: [
        FadeSlideIn(
          child: Text(
            'Specialised assistants for SCAD statistics — each grounded in '
            'official data, tuned for a task.',
            style: TextStyle(fontSize: 13, height: 1.5, color: c.secondary2),
          ),
        ),
        const SizedBox(height: 14),
        FadeSlideIn(
          delay: const Duration(milliseconds: 50),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 14),
            decoration: BoxDecoration(
              color: c.fill,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(LucideIcons.search, size: 16, color: c.muted),
                const SizedBox(width: 9),
                Text(
                  'Search agents',
                  style: TextStyle(fontSize: 14, color: c.muted),
                ),
              ],
            ),
          ),
        ),
        _sectionLabel(c, 'Featured · By SCAD'),
        for (var i = 0; i < featured.length; i++)
          FadeSlideIn(
            delay: Duration(milliseconds: 40 * i),
            child: _AgentRow(agent: featured[i]),
          ),
        if (mine.isNotEmpty) ...[
          _sectionLabel(c, 'Created by you'),
          for (final a in mine) FadeSlideIn(child: _AgentRow(agent: a)),
        ],
        FadeSlideIn(
          delay: const Duration(milliseconds: 260),
          child: InkWell(
            onTap: s.openNewAgent,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 2),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(color: c.checkBorder, width: 1.5),
                    ),
                    child: Icon(LucideIcons.plus, size: 17, color: c.muted),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Create an agent',
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                            color: c.secondary2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Give it a name, a task and instructions.',
                          style: TextStyle(fontSize: 12, color: c.muted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _sectionLabel(BayaanColors c, String text) => Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 2),
    child: Text(
      text,
      style: AppTheme.mono(color: c.muted, fontSize: 10.5, letterSpacing: 1.3),
    ),
  );
}

class _AgentRow extends StatelessWidget {
  const _AgentRow({required this.agent});
  final Agent agent;

  @override
  Widget build(BuildContext context) {
    final s = context.read<AppState>();
    final c = context.colors;
    final tile = agentTileColors(c, agent.tone);

    return InkWell(
      onTap: () => s.openAgent(agent),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 2),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: c.hairline)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: tile.bg,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Text(
                agent.initials,
                style: AppTheme.mono(
                  color: tile.fg,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    agent.name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.15,
                      color: c.ink,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    agent.tag,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12.5, color: c.secondary2),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            if (agent.private)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 9),
                decoration: BoxDecoration(
                  color: c.fill,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'Private',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: c.secondary,
                  ),
                ),
              )
            else
              Icon(LucideIcons.chevronRight, size: 15, color: c.faint),
          ],
        ),
      ),
    );
  }
}
