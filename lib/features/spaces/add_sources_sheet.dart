import 'package:bayaan/core/icons/lucide_icons.dart';
import 'package:bayaan/core/theme/bayaan_colors.dart';
import 'package:bayaan/core/theme/theme_x.dart';
import 'package:bayaan/features/shared/app_bottom_sheet.dart';
import 'package:bayaan/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Bottom sheet for grounding a notebook with sources: web search, file
/// upload, link or pasted text.
class AddSourcesSheet extends StatelessWidget {
  const AddSourcesSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final c = context.colors;
    final webActive = s.addSrcMode == 'web';

    return AppBottomSheet(
      onDismiss: s.closeAddSrc,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Add sources',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.36,
              color: c.ink,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Ground this notebook — add audio, video, text, web pages or PDFs.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12.5, height: 1.5, color: c.secondary2),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: c.border),
            ),
            child: Column(
              children: [
                TextField(
                  onChanged: s.onAddSrcQuery,
                  onSubmitted: (_) => s.addSource('search'),
                  style: TextStyle(fontSize: 14, color: c.bodyStrong),
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText: 'Search web for a new resource',
                    hintStyle: TextStyle(color: c.muted),
                  ),
                ),
                Divider(color: c.hairline, height: 20),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: c.fill,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        children: [
                          _seg(
                            c,
                            'Web search',
                            webActive,
                            () => s.setAddSrcMode('web'),
                            icon: LucideIcons.globe,
                          ),
                          _seg(
                            c,
                            'Internal data',
                            !webActive,
                            () => s.setAddSrcMode('internal'),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () => s.addSource('search'),
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        width: 36,
                        height: 36,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: BayaanBrand.blue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          LucideIcons.search,
                          size: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          DottedBox(
            child: Column(
              children: [
                Text(
                  'or drop your file',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: c.ink,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'pdf, images, docs, audio, and more',
                  style: TextStyle(fontSize: 11.5, color: c.secondary2),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _tile(
                      c,
                      LucideIcons.upload,
                      'Upload file',
                      () => s.addSource('file'),
                    ),
                    const SizedBox(width: 8),
                    _tile(
                      c,
                      LucideIcons.link,
                      'Add link',
                      () => s.addSource('link'),
                    ),
                    const SizedBox(width: 8),
                    _tile(
                      c,
                      LucideIcons.clipboard,
                      'Paste text',
                      () => s.addSource('paste'),
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

  Widget _seg(
    BayaanColors c,
    String label,
    bool active,
    VoidCallback onTap, {
    IconData? icon,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        decoration: BoxDecoration(
          color: active ? c.card : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 13, color: active ? c.ink : c.secondary2),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: active ? c.ink : c.secondary2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile(
    BayaanColors c,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 6),
          decoration: BoxDecoration(
            color: c.panel,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: c.border),
          ),
          child: Column(
            children: [
              Icon(icon, size: 17, color: c.secondary),
              const SizedBox(height: 7),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: c.bodyStrong,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A dashed-border container used as the file drop zone.
class DottedBox extends StatelessWidget {
  const DottedBox({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.checkBorder, width: 1.5),
      ),
      child: child,
    );
  }
}
