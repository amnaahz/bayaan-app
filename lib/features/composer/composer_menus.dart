import 'package:bayaan/core/icons/lucide_icons.dart';
import 'package:bayaan/core/theme/app_theme.dart';
import 'package:bayaan/core/theme/bayaan_colors.dart';
import 'package:bayaan/core/theme/theme_x.dart';
import 'package:bayaan/core/widgets/fade_slide_in.dart';
import 'package:bayaan/data/models/ui_models.dart';
import 'package:bayaan/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Popover for adding attachments (camera, photo, files, artifacts).
class AttachMenu extends StatelessWidget {
  const AttachMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.read<AppState>();
    final c = context.colors;
    return _MenuScaffold(
      onDismiss: s.closeMenus,
      child: FadeSlideIn(
        offset: 8,
        duration: const Duration(milliseconds: 160),
        child: _card(
          c,
          width: 208,
          children: [
            _row(
              c,
              c.blueTint,
              BayaanBrand.blue,
              LucideIcons.sparkles,
              'Pick an agent',
              s.openAgentPicker,
              trailingChevron: true,
            ),
            _divider(c),
            _row(
              c,
              c.blueTint,
              BayaanBrand.blue,
              LucideIcons.camera,
              'Camera',
              () => s.addAttachment(AttachmentKind.camera, 'Camera photo.jpg'),
            ),
            _row(
              c,
              c.greenBg,
              c.green,
              LucideIcons.image,
              'Photo Library',
              () => s.addAttachment(AttachmentKind.photo, 'Selection.png'),
            ),
            _row(
              c,
              c.amberBg,
              BayaanBrand.amber,
              LucideIcons.fileText,
              'Files',
              () => s.addAttachment(AttachmentKind.file, 'Q1 tables.pdf'),
            ),
            _row(
              c,
              c.purpleBg,
              BayaanBrand.purple,
              LucideIcons.layoutGrid,
              'From Artifacts',
              () => s.addAttachment(AttachmentKind.artifact, 'GDP brief'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(
    BayaanColors c,
    Color bg,
    Color fg,
    IconData icon,
    String label,
    VoidCallback onTap, {
    bool trailingChevron = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 9),
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
              child: Icon(icon, size: 15, color: fg),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: c.textMax,
                ),
              ),
            ),
            if (trailingChevron)
              Icon(LucideIcons.chevronRight, size: 14, color: c.faint),
          ],
        ),
      ),
    );
  }

  Widget _divider(BayaanColors c) => Container(
    height: 1,
    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
    color: c.hairline,
  );
}

/// Popover for search type (Normal / Web / Deep) and response mode.
class ModeMenu extends StatelessWidget {
  const ModeMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final c = context.colors;
    return _MenuScaffold(
      onDismiss: s.closeMenus,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FadeSlideIn(
            offset: 8,
            duration: const Duration(milliseconds: 160),
            child: _card(
              c,
              width: 228,
              children: [
                _modeRow(
                  c,
                  icon: LucideIcons.barChart3,
                  iconColor: BayaanBrand.blue,
                  title: 'Normal',
                  sub: 'Direct answer from official data',
                  selected: s.mode == SearchMode.normal,
                  selColor: BayaanBrand.blue,
                  bg: s.submenuFor == SearchMode.normal ? c.fill : null,
                  chevron: true,
                  onTap: s.setModeNormal,
                ),
                _modeRow(
                  c,
                  icon: LucideIcons.globe,
                  iconColor: BayaanBrand.blue,
                  title: 'Web Search',
                  sub: 'Blend official data with the web',
                  selected: s.mode == SearchMode.web,
                  selColor: BayaanBrand.blue,
                  bg: s.submenuFor == SearchMode.web ? c.fill : null,
                  chevron: true,
                  onTap: s.setModeWeb,
                ),
                _modeRow(
                  c,
                  icon: LucideIcons.sparkles,
                  iconColor: BayaanBrand.purple,
                  title: 'Deep Research',
                  sub: 'Planned, cited report',
                  selected: s.mode == SearchMode.deep,
                  selColor: BayaanBrand.purple,
                  onTap: s.setModeDeep,
                ),
              ],
            ),
          ),
          if (s.submenuFor != null) ...[
            const SizedBox(width: 6),
            _ResponseFlyout(s: s, c: c),
          ],
        ],
      ),
    );
  }

  Widget _modeRow(
    BayaanColors c, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String sub,
    required bool selected,
    required Color selColor,
    required VoidCallback onTap,
    Color? bg,
    bool chevron = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(11),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(11),
        ),
        child: Row(
          children: [
            Icon(icon, size: 17, color: iconColor),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: c.textMax,
                    ),
                  ),
                  Text(
                    sub,
                    style: TextStyle(fontSize: 11.5, color: c.secondary2),
                  ),
                ],
              ),
            ),
            if (selected) Icon(LucideIcons.check, size: 14, color: selColor),
            if (chevron) ...[
              const SizedBox(width: 6),
              Icon(LucideIcons.chevronRight, size: 14, color: c.faint),
            ],
          ],
        ),
      ),
    );
  }
}

class _ResponseFlyout extends StatelessWidget {
  const _ResponseFlyout({required this.s, required this.c});
  final AppState s;
  final BayaanColors c;

  @override
  Widget build(BuildContext context) {
    return FadeSlideIn(
      offset: 8,
      duration: const Duration(milliseconds: 160),
      child: _card(
        c,
        width: 150,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(11, 7, 11, 4),
            child: Text(
              'RESPONSE MODE',
              style: AppTheme.mono(
                color: c.muted,
                fontSize: 9,
                letterSpacing: 1.1,
              ),
            ),
          ),
          _respRow(
            c.blueTint,
            BayaanBrand.blue,
            LucideIcons.menu,
            'Standard',
            s.respMode == ResponseMode.standard,
            () => s.setResponseMode(ResponseMode.standard),
          ),
          _respRow(
            c.greenBg,
            c.green,
            LucideIcons.chevronRight,
            'Concise',
            s.respMode == ResponseMode.concise,
            () => s.setResponseMode(ResponseMode.concise),
          ),
          if (s.mode != SearchMode.web)
            _respRow(
              c.amberBg,
              BayaanBrand.amber,
              LucideIcons.zap,
              'Reasoning',
              s.respMode == ResponseMode.reasoning,
              () => s.setResponseMode(ResponseMode.reasoning),
            ),
        ],
      ),
    );
  }

  Widget _respRow(
    Color bg,
    Color fg,
    IconData icon,
    String label,
    bool selected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 9),
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
              child: Icon(icon, size: 15, color: fg),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: c.textMax,
                ),
              ),
            ),
            if (selected) Icon(LucideIcons.check, size: 13, color: fg),
          ],
        ),
      ),
    );
  }
}

/// Full-area scaffold: a tap-to-dismiss scrim with the menu anchored above
/// the composer (bottom-left).
class _MenuScaffold extends StatelessWidget {
  const _MenuScaffold({required this.onDismiss, required this.child});
  final VoidCallback onDismiss;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onDismiss,
          ),
        ),
        Positioned(
          left: 20,
          bottom: 118,
          child: child,
        ),
      ],
    );
  }
}

Widget _card(
  BayaanColors c, {
  required double width,
  required List<Widget> children,
}) {
  return Container(
    width: width,
    padding: const EdgeInsets.all(6),
    decoration: BoxDecoration(
      color: c.card,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: c.border),
      boxShadow: const [
        BoxShadow(
          color: Color(0x40000000),
          blurRadius: 40,
          offset: Offset(0, 12),
        ),
      ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    ),
  );
}
