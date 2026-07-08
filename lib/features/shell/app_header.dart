import 'package:bayaan/core/icons/lucide_icons.dart';
import 'package:bayaan/core/theme/bayaan_colors.dart';
import 'package:bayaan/core/theme/theme_x.dart';
import 'package:bayaan/core/widgets/bayaan_logo.dart';
import 'package:bayaan/core/widgets/hover_tap.dart';
import 'package:bayaan/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Top bar: drawer button · (mode pill / logo / section title) · new-chat.
class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final c = context.colors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 58, 14, 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BayaanIconButton(
            icon: Icon(LucideIcons.menu, size: 22, color: c.ink),
            hoverColor: c.fill,
            onTap: s.openDrawer,
          ),
          Expanded(child: Center(child: _middle(context, s, c))),
          BayaanIconButton(
            icon: Icon(LucideIcons.edit3, size: 21, color: c.ink),
            hoverColor: c.fill,
            onTap: s.newChat,
          ),
        ],
      ),
    );
  }

  Widget _middle(BuildContext context, AppState s, BayaanColors c) {
    if (s.inChat) {
      final isDeep = s.mode == SearchMode.deep;
      final dot = isDeep ? BayaanBrand.purple : BayaanBrand.blue;
      final bg = isDeep ? c.purpleBg : c.blueTint;
      final border = isDeep ? c.purpleBd : c.blueTintBd;
      final fg = isDeep ? c.purpleText : c.link;
      return Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 13),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
            ),
            const SizedBox(width: 7),
            Text(
              s.modeLabel,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: fg,
              ),
            ),
          ],
        ),
      );
    }
    if (s.showLogo) return const BayaanLogo(size: 30, borderRadius: 7);
    final title = s.sectionTitle;
    if (title != null) {
      return Text(
        title,
        style: TextStyle(
          fontSize: 16.5,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.16,
          color: c.ink,
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
