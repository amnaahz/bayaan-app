import 'package:bayaan/core/icons/lucide_icons.dart';
import 'package:bayaan/core/theme/app_theme.dart';
import 'package:bayaan/core/theme/theme_x.dart';
import 'package:bayaan/core/widgets/fade_slide_in.dart';
import 'package:bayaan/data/models/space_models.dart';
import 'package:bayaan/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Spaces list: grounded notebook workspaces.
class SpacesView extends StatelessWidget {
  const SpacesView({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final c = context.colors;
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 12, 22, 30),
      children: [
        FadeSlideIn(
          child: Text(
            'Grounded workspaces — sources in, cited briefings out.',
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
                  'Search notebooks',
                  style: TextStyle(fontSize: 14, color: c.muted),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 18, bottom: 2),
          child: Text(
            '${s.notebooks.length} NOTEBOOKS',
            style: AppTheme.mono(
              color: c.muted,
              fontSize: 10.5,
              letterSpacing: 1.3,
            ),
          ),
        ),
        for (var i = 0; i < s.notebooks.length; i++)
          FadeSlideIn(
            delay: Duration(milliseconds: 40 * i),
            child: _NotebookRow(nb: s.notebooks[i]),
          ),
        FadeSlideIn(
          delay: const Duration(milliseconds: 260),
          child: InkWell(
            onTap: s.openNewNb,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 2),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: c.checkBorder, width: 1.5),
                    ),
                    child: Icon(LucideIcons.plus, size: 16, color: c.muted),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    'New notebook',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: c.secondary2,
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

class _NotebookRow extends StatelessWidget {
  const _NotebookRow({required this.nb});
  final Notebook nb;

  @override
  Widget build(BuildContext context) {
    final s = context.read<AppState>();
    final c = context.colors;
    final tileBg = nb.accent ? c.blueTint : c.fill;
    final tileFg = nb.accent ? c.link : c.secondary;
    return InkWell(
      onTap: () => s.openNotebook(nb),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 2),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: c.hairline)),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: tileBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                nb.initials,
                style: AppTheme.mono(
                  color: tileFg,
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
                    nb.name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.15,
                      color: c.ink,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    nb.meta,
                    style: AppTheme.mono(color: c.muted, fontSize: 10.5),
                  ),
                ],
              ),
            ),
            if (nb.hasOutputs)
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 9),
                decoration: BoxDecoration(
                  color: c.blueTint,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  nb.outputs,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: c.link,
                  ),
                ),
              ),
            Icon(LucideIcons.chevronRight, size: 15, color: c.faint),
          ],
        ),
      ),
    );
  }
}
