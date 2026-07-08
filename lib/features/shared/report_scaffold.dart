import 'package:bayaan/core/icons/lucide_icons.dart';
import 'package:bayaan/core/theme/app_theme.dart';
import 'package:bayaan/core/theme/bayaan_colors.dart';
import 'package:bayaan/core/theme/theme_x.dart';
import 'package:flutter/material.dart';

/// Full-screen report reader chrome: back button, centered title and an
/// export button, over a scrollable body. Optionally shows an export popover.
class ReportScaffold extends StatelessWidget {
  const ReportScaffold({
    required this.onClose,
    required this.onExport,
    required this.body,
    this.exportOpen = false,
    this.onExportDismiss,
    super.key,
  });

  final VoidCallback onClose;
  final VoidCallback onExport;
  final Widget body;
  final bool exportOpen;
  final VoidCallback? onExportDismiss;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return ColoredBox(
      color: c.bg,
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(14, 58, 14, 8),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: c.hairline)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _hdrBtn(c, LucideIcons.chevronLeft, onClose),
                    Text(
                      'Report',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: c.ink,
                      ),
                    ),
                    _hdrBtn(c, LucideIcons.upload, onExport),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 22, 24, 40),
                  child: body,
                ),
              ),
            ],
          ),
          if (exportOpen) ...[
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onExportDismiss ?? onExport,
              ),
            ),
            Positioned(
              right: 16,
              top: 106,
              child: _ExportMenu(c: c),
            ),
          ],
        ],
      ),
    );
  }

  Widget _hdrBtn(BayaanColors c, IconData icon, VoidCallback onTap) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(11),
    child: Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      child: Icon(icon, size: 19, color: c.ink),
    ),
  );
}

class _ExportMenu extends StatelessWidget {
  const _ExportMenu({required this.c});
  final BayaanColors c;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 168,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x59000000),
            blurRadius: 36,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _row(LucideIcons.fileText, 'PDF'),
          _row(LucideIcons.fileText, 'Word document'),
          _row(LucideIcons.code, 'Markdown'),
        ],
      ),
    );
  }

  Widget _row(IconData icon, String label) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 11),
    child: Row(
      children: [
        Icon(icon, size: 15, color: c.secondary),
        const SizedBox(width: 10),
        Text(label, style: TextStyle(fontSize: 13.5, color: c.bodyStrong)),
      ],
    ),
  );
}

/// Shared report content primitives.
class ReportBits {
  const ReportBits(this.c);
  final BayaanColors c;

  Widget kicker(String text, {Color? color}) => Text(
    text,
    style: AppTheme.mono(
      color: color ?? c.muted,
      fontSize: 10.5,
      letterSpacing: 1.3,
    ),
  );

  Widget title(String text) => Padding(
    padding: const EdgeInsets.only(top: 8),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        height: 1.25,
        letterSpacing: -0.44,
        color: c.ink,
      ),
    ),
  );

  Widget meta(String text) => Padding(
    padding: const EdgeInsets.only(top: 8),
    child: Text(text, style: AppTheme.mono(color: c.muted)),
  );

  Widget divider() => Container(
    height: 1,
    color: c.hairline,
    margin: const EdgeInsets.symmetric(vertical: 18),
  );

  Widget heading(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: c.ink,
      ),
    ),
  );

  Widget para(String text, {List<int> cites = const []}) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 14, height: 1.65, color: c.body),
        children: [
          TextSpan(text: text),
          for (final n in cites)
            TextSpan(
              text: ' [$n]',
              style: AppTheme.mono(color: c.link),
            ),
        ],
      ),
    ),
  );

  Widget statBox(String label, String value, {String? note, Color? noteColor}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 13),
        decoration: BoxDecoration(
          color: c.panel,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: c.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: c.secondary2,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: AppTheme.mono(
                color: c.ink,
                fontSize: 19,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (note != null) ...[
              const SizedBox(height: 3),
              Text(
                note,
                style: AppTheme.mono(color: noteColor ?? c.muted, fontSize: 10),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget sources(List<String> items) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      kicker('SOURCES'),
      const SizedBox(height: 10),
      for (var i = 0; i < items.length; i++)
        Padding(
          padding: const EdgeInsets.only(bottom: 9),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '[${i + 1}]',
                style: AppTheme.mono(color: c.link, fontSize: 12.5),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  items[i],
                  style: TextStyle(
                    fontSize: 12.5,
                    height: 1.4,
                    color: c.secondary,
                  ),
                ),
              ),
            ],
          ),
        ),
    ],
  );
}
