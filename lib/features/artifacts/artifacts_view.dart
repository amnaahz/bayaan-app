import 'package:bayaan/core/icons/lucide_icons.dart';
import 'package:bayaan/core/theme/app_theme.dart';
import 'package:bayaan/core/theme/bayaan_colors.dart';
import 'package:bayaan/core/theme/theme_x.dart';
import 'package:bayaan/core/widgets/fade_slide_in.dart';
import 'package:bayaan/features/shared/report_scaffold.dart';
import 'package:bayaan/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Artifacts list: versioned, cited reports, charts and tables.
class ArtifactsView extends StatelessWidget {
  const ArtifactsView({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.read<AppState>();
    final c = context.colors;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 30),
      children: [
        FadeSlideIn(
          child: Text(
            'Reports, charts and tables generated from your conversations. '
            'Everything is versioned and cited.',
            style: TextStyle(fontSize: 13, height: 1.5, color: c.secondary2),
          ),
        ),
        const SizedBox(height: 14),
        _row(
          c,
          c.amberBg,
          BayaanBrand.amber,
          LucideIcons.fileText,
          'Abu Dhabi Quarterly GDP Executive Brief',
          'Report · v2 · Jun 18 · 6 sources',
          s.openArtifactReport,
          delayMs: 50,
        ),
        _row(
          c,
          c.amberBg,
          BayaanBrand.amber,
          LucideIcons.fileText,
          'Non-oil Diversification Report',
          'Deep Research · v1 · Jun 12 · 14 sources',
          s.openArtifactReport,
          delayMs: 100,
        ),
        _row(
          c,
          c.blueTint,
          BayaanBrand.blue,
          LucideIcons.barChart3,
          'CPI by division — May 2026',
          'Chart · Jun 10 · 2 sources',
          () {},
          delayMs: 150,
        ),
        _row(
          c,
          c.greenBg,
          c.green,
          LucideIcons.layoutGrid,
          'GDP by sector — data table',
          'Table · Jun 8 · 1 source',
          () {},
          delayMs: 200,
          bottomBorder: true,
        ),
      ],
    );
  }

  Widget _row(
    BayaanColors c,
    Color bg,
    Color fg,
    IconData icon,
    String title,
    String meta,
    VoidCallback onTap, {
    required int delayMs,
    bool bottomBorder = false,
  }) {
    return FadeSlideIn(
      delay: Duration(milliseconds: delayMs),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 2),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: c.hairline),
              bottom: bottomBorder
                  ? BorderSide(color: c.hairline)
                  : BorderSide.none,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, size: 17, color: fg),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: c.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      meta,
                      style: AppTheme.mono(color: c.muted, fontSize: 10.5),
                    ),
                  ],
                ),
              ),
              Icon(LucideIcons.chevronRight, size: 15, color: c.faint),
            ],
          ),
        ),
      ),
    );
  }
}

/// The GDP executive brief report opened from Artifacts.
class ArtifactReportViewer extends StatelessWidget {
  const ArtifactReportViewer({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.read<AppState>();
    final c = context.colors;
    final r = ReportBits(c);
    return ReportScaffold(
      onClose: s.closeArtifactReport,
      onExport: () {},
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Abu Dhabi Quarterly GDP\nExecutive Brief',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w700,
              height: 1.25,
              letterSpacing: -0.42,
              color: c.ink,
            ),
          ),
          r.meta('v2 · Jun 18, 2026 · 6 sources'),
          r.divider(),
          r.heading('Overview'),
          r.para(
            "Abu Dhabi's real GDP reached AED 1.18 trillion in 2023, up 9.3% "
            'year-on-year — the fastest pace since 2011. Non-oil activities '
            'contributed 53.9% of output, led by manufacturing and finance.',
            cites: [1, 2],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              r.statBox('2023 GDP', 'AED 1.18T'),
              const SizedBox(width: 10),
              r.statBox('YoY growth', '+9.3%'),
            ],
          ),
          const SizedBox(height: 18),
          r.heading('Key drivers'),
          r.para(
            'Manufacturing expanded 8.4%, construction 12.1%, and financial '
            'services 9.7% over the period. Momentum was supported by '
            'industrial licensing reform and sustained capital investment.',
            cites: [3],
          ),
          const SizedBox(height: 18),
          r.heading('Outlook'),
          r.para(
            "SCAD's nowcast points to continued non-oil expansion of 5–6% "
            'through 2026, with diversification measures on track against '
            'Vision 2030 targets.',
            cites: [4],
          ),
          r.divider(),
          r.sources(const [
            'SCAD, National Accounts — Annual GDP 2023, Table 2.1',
            'SCAD, Statistical Yearbook of Abu Dhabi 2024',
            'SCAD, Quarterly Economic Performance Q4 2023',
            'SCAD Nowcast Bulletin, May 2026',
          ]),
        ],
      ),
    );
  }
}
