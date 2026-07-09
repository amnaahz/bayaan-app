import 'package:bayaan/core/icons/lucide_icons.dart';
import 'package:bayaan/core/theme/app_theme.dart';
import 'package:bayaan/core/theme/bayaan_colors.dart';
import 'package:bayaan/core/theme/theme_x.dart';
import 'package:bayaan/data/mock/mock_data.dart';
import 'package:bayaan/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Slide-up panel listing the internal (SCAD) and web sources cited behind an
/// answer. Opened from a chat message's sources row.
class SourcesPanel extends StatelessWidget {
  const SourcesPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.read<AppState>();
    final c = context.colors;
    final count = kInternalSources.length + kWebSources.length;

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: s.closeSources,
            child: const ColoredBox(color: Color(0x8C000000)),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 80,
          bottom: 0,
          child: Material(
            color: c.card,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                Container(
                  width: 38,
                  height: 4,
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  decoration: BoxDecoration(
                    color: c.borderStrong,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(22, 6, 22, 14),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: c.hairline)),
                  ),
                  child: Row(
                    children: [
                      Icon(LucideIcons.folder, size: 18, color: c.secondary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '$count sources',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                            color: c.ink,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: s.closeSources,
                        borderRadius: BorderRadius.circular(9),
                        child: Padding(
                          padding: const EdgeInsets.all(7),
                          child: Icon(LucideIcons.x, size: 17, color: c.muted),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(22, 6, 22, 30),
                    children: [
                      _sectionLabel(c, 'Internal · SCAD'),
                      for (final src in kInternalSources)
                        _InternalRow(title: src.title, tag: src.tag),
                      _sectionLabel(c, 'Web'),
                      for (final w in kWebSources)
                        _WebRow(fav: w.fav, title: w.title, url: w.url),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _sectionLabel(BayaanColors c, String text) => Padding(
    padding: const EdgeInsets.only(top: 14, bottom: 4),
    child: Text(
      text.toUpperCase(),
      style: AppTheme.mono(color: c.muted, fontSize: 10, letterSpacing: 1.2),
    ),
  );
}

class _InternalRow extends StatelessWidget {
  const _InternalRow({required this.title, required this.tag});
  final String title;
  final String tag;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: c.hairline)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: c.redBg,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(LucideIcons.barChart3, size: 18, color: c.red),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                    color: c.ink,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _tag(c, tag, c.purpleText, c.purpleBg),
                    const SizedBox(width: 7),
                    _tag(c, 'Statistical Indicator', c.secondary, c.fill),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: c.blueTintBd),
                      ),
                      child: Text(
                        'OPEN',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: c.link,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tag(BayaanColors c, String label, Color fg, Color bg) => Container(
    padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 9),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      label,
      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: fg),
    ),
  );
}

class _WebRow extends StatelessWidget {
  const _WebRow({required this.fav, required this.title, required this.url});
  final String fav;
  final String title;
  final String url;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: c.hairline)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26,
            height: 26,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: c.fill,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Text(
              fav,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: c.secondary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                    color: c.ink,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  url,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11.5, color: c.muted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(LucideIcons.arrowUpRight, size: 14, color: c.faint),
        ],
      ),
    );
  }
}
