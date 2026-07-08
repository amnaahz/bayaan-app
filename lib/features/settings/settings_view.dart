import 'package:bayaan/core/icons/lucide_icons.dart';
import 'package:bayaan/core/theme/app_theme.dart';
import 'package:bayaan/core/theme/bayaan_colors.dart';
import 'package:bayaan/core/theme/theme_x.dart';
import 'package:bayaan/core/widgets/fade_slide_in.dart';
import 'package:bayaan/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Settings screen: profile, preferences (language, theme, default mode) and
/// general (notifications, privacy, about, sign out).
class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final c = context.colors;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 30),
      children: [
        FadeSlideIn(child: _profile(s, c)),
        const SizedBox(height: 18),
        FadeSlideIn(
          delay: const Duration(milliseconds: 70),
          child: _section(c, 'PREFERENCES', [
            _linkRow(c, LucideIcons.globe, 'Language', trailing: 'English'),
            _divider(c),
            _themeRow(s, c),
            _divider(c),
            _linkRow(
              c,
              LucideIcons.barChart3,
              'Default mode',
              trailing: 'Normal',
            ),
          ]),
        ),
        const SizedBox(height: 18),
        FadeSlideIn(
          delay: const Duration(milliseconds: 140),
          child: _section(c, 'GENERAL', [
            _notifRow(s, c),
            _divider(c),
            _linkRow(c, LucideIcons.check, 'Data & privacy'),
            _divider(c),
            _aboutRow(c),
          ]),
        ),
        const SizedBox(height: 18),
        FadeSlideIn(
          delay: const Duration(milliseconds: 200),
          child: Center(
            child: Text(
              'Sign out',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: c.red,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _profile(AppState s, BayaanColors c) => Container(
    padding: const EdgeInsets.all(15),
    decoration: _cardDeco(c),
    child: Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: BayaanBrand.purple,
          child: Text(
            s.userInitials,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                s.userName,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: c.ink,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Statistics Centre · Abu Dhabi',
                style: TextStyle(fontSize: 12, color: c.muted),
              ),
            ],
          ),
        ),
        Icon(LucideIcons.chevronRight, size: 15, color: c.faint),
      ],
    ),
  );

  Widget _section(BayaanColors c, String title, List<Widget> rows) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          title,
          style: AppTheme.mono(
            color: c.muted,
            fontSize: 10.5,
            letterSpacing: 1.3,
          ),
        ),
      ),
      Container(
        decoration: _cardDeco(c),
        clipBehavior: Clip.antiAlias,
        child: Column(children: rows),
      ),
    ],
  );

  Widget _linkRow(
    BayaanColors c,
    IconData icon,
    String label, {
    String? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
      child: Row(
        children: [
          Icon(icon, size: 18, color: c.secondary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 14, color: c.bodyStrong),
            ),
          ),
          if (trailing != null)
            Text(trailing, style: TextStyle(fontSize: 13, color: c.muted)),
          const SizedBox(width: 8),
          Icon(LucideIcons.chevronRight, size: 14, color: c.faint),
        ],
      ),
    );
  }

  Widget _themeRow(AppState s, BayaanColors c) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
      child: Row(
        children: [
          Icon(LucideIcons.sun, size: 18, color: c.secondary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Theme',
              style: TextStyle(fontSize: 14, color: c.bodyStrong),
            ),
          ),
          _Segmented(
            options: const ['Light', 'Dark'],
            selected: s.isDark ? 1 : 0,
            onSelect: (i) => i == 0 ? s.setLight() : s.setDark(),
            c: c,
          ),
        ],
      ),
    );
  }

  Widget _notifRow(AppState s, BayaanColors c) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
      child: Row(
        children: [
          Icon(LucideIcons.bell, size: 18, color: c.secondary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Notifications',
              style: TextStyle(fontSize: 14, color: c.bodyStrong),
            ),
          ),
          GestureDetector(
            onTap: s.toggleNotif,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 44,
              height: 26,
              padding: const EdgeInsets.all(3),
              alignment: s.notifOn
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              decoration: BoxDecoration(
                color: s.notifOn ? BayaanBrand.blue : c.borderStrong,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: c.card,
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(color: Color(0x40111827), blurRadius: 3),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _aboutRow(BayaanColors c) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
      child: Row(
        children: [
          Icon(LucideIcons.check, size: 18, color: c.secondary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'About Bayaan',
              style: TextStyle(fontSize: 14, color: c.bodyStrong),
            ),
          ),
          Text('v2.4.0', style: AppTheme.mono(color: c.faint)),
        ],
      ),
    );
  }

  Widget _divider(BayaanColors c) => Container(height: 1, color: c.hairline);

  BoxDecoration _cardDeco(BayaanColors c) => BoxDecoration(
    color: c.card,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: c.border),
  );
}

class _Segmented extends StatelessWidget {
  const _Segmented({
    required this.options,
    required this.selected,
    required this.onSelect,
    required this.c,
  });
  final List<String> options;
  final int selected;
  final ValueChanged<int> onSelect;
  final BayaanColors c;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: c.fill,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < options.length; i++)
            GestureDetector(
              onTap: () => onSelect(i),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 13,
                ),
                decoration: BoxDecoration(
                  color: selected == i ? c.segThumb : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: selected == i
                      ? const [
                          BoxShadow(color: Color(0x22000000), blurRadius: 3),
                        ]
                      : null,
                ),
                child: Text(
                  options[i],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: selected == i ? c.ink : c.secondary2,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
