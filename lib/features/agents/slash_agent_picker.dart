import 'package:bayaan/core/theme/app_theme.dart';
import 'package:bayaan/core/theme/theme_x.dart';
import 'package:bayaan/core/widgets/fade_slide_in.dart';
import 'package:bayaan/features/agents/agent_visuals.dart';
import 'package:bayaan/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Composer "/" popover for applying an agent to the conversation.
class SlashAgentPicker extends StatelessWidget {
  const SlashAgentPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final c = context.colors;
    final results = s.slashFiltered;

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: s.closeSlash,
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: 100,
          child: FadeSlideIn(
            offset: 8,
            duration: const Duration(milliseconds: 160),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 300),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: c.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: c.border),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x73000000),
                    blurRadius: 44,
                    offset: Offset(0, 14),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 7, 10, 4),
                    child: Text(
                      'AGENTS · TYPE TO FILTER',
                      style: AppTheme.mono(
                        color: c.muted,
                        fontSize: 9,
                        letterSpacing: 1.4,
                      ),
                    ),
                  ),
                  if (results.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 12,
                      ),
                      child: Center(
                        child: Text(
                          'No agents match',
                          style: TextStyle(fontSize: 13, color: c.muted),
                        ),
                      ),
                    )
                  else
                    Flexible(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        children: [
                          for (final a in results)
                            _SlashRow(
                              onTap: () => s.pickSlashAgent(a),
                              initials: a.initials,
                              name: a.name,
                              tag: a.tag,
                              tile: agentTileColors(c, a.tone),
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
}

class _SlashRow extends StatelessWidget {
  const _SlashRow({
    required this.onTap,
    required this.initials,
    required this.name,
    required this.tag,
    required this.tile,
  });

  final VoidCallback onTap;
  final String initials;
  final String name;
  final String tag;
  final ({Color bg, Color fg}) tile;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(11),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 10),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: tile.bg,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Text(
                initials,
                style: AppTheme.mono(
                  color: tile.fg,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: c.ink,
                    ),
                  ),
                  Text(
                    tag,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11.5, color: c.secondary2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
