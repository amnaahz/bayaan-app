import 'package:bayaan/core/icons/lucide_icons.dart';
import 'package:bayaan/core/theme/app_theme.dart';
import 'package:bayaan/core/theme/bayaan_colors.dart';
import 'package:bayaan/core/theme/theme_x.dart';
import 'package:bayaan/core/widgets/fade_slide_in.dart';
import 'package:bayaan/data/models/research_models.dart';
import 'package:bayaan/features/shared/report_scaffold.dart';
import 'package:bayaan/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Full-screen Deep Research flow: clarify → plan → approval → research →
/// synthesis → done, plus the generated report viewer.
class DeepResearchOverlay extends StatelessWidget {
  const DeepResearchOverlay({super.key});

  static const _steps = [
    'Clarify',
    'Plan',
    'Approve',
    'Research',
    'Synthesize',
    'Report',
  ];

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final c = context.colors;

    if (s.drReportOpen) return _DrReport(s: s, c: c);

    return ColoredBox(
      color: c.bg,
      child: Column(
        children: [
          _header(s, c),
          _stepper(s, c),
          Expanded(child: _body(context, s, c)),
        ],
      ),
    );
  }

  Widget _header(AppState s, BayaanColors c) => Padding(
    padding: const EdgeInsets.fromLTRB(14, 58, 14, 6),
    child: Row(
      children: [
        InkWell(
          onTap: s.drClose,
          borderRadius: BorderRadius.circular(11),
          child: SizedBox(
            width: 40,
            height: 40,
            child: Icon(LucideIcons.x, size: 20, color: c.ink),
          ),
        ),
        const SizedBox(width: 4),
        Row(
          children: [
            const Icon(
              LucideIcons.microscope,
              size: 17,
              color: BayaanBrand.purple,
            ),
            const SizedBox(width: 8),
            Text(
              'Deep Research',
              style: TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.25,
                color: c.ink,
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _stepper(AppState s, BayaanColors c) => Container(
    padding: const EdgeInsets.fromLTRB(18, 6, 18, 14),
    decoration: BoxDecoration(
      border: Border(bottom: BorderSide(color: c.hairline)),
    ),
    child: Row(
      children: [
        for (var i = 0; i < _steps.length; i++) ...[
          _dot(c, i, s.drStepDone(i), s.drStepActive(i)),
          if (i < _steps.length - 1)
            Expanded(
              child: Container(
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                color: s.drStepDone(i) ? BayaanBrand.purple : c.border,
              ),
            ),
        ],
      ],
    ),
  );

  Widget _dot(BayaanColors c, int i, bool done, bool active) {
    final color = done || active ? BayaanBrand.purple : c.border;
    return Container(
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: done ? BayaanBrand.purple : (active ? c.purpleBg : c.fill),
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 1.5),
      ),
      child: done
          ? const Icon(LucideIcons.check, size: 11, color: Colors.white)
          : Text(
              '${i + 1}',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: active ? BayaanBrand.purple : c.muted,
              ),
            ),
    );
  }

  Widget _body(BuildContext context, AppState s, BayaanColors c) {
    return switch (s.drPhase) {
      DrPhase.clarify => _Clarify(s: s, c: c),
      DrPhase.plan => _Loading(c: c, label: 'Designing a research plan…'),
      DrPhase.approval => _Approval(s: s, c: c),
      DrPhase.research => _Research(s: s, c: c),
      DrPhase.synth => _Loading(c: c, label: 'Synthesizing findings…'),
      DrPhase.done => _Done(s: s, c: c),
    };
  }
}

class _Clarify extends StatelessWidget {
  const _Clarify({required this.s, required this.c});
  final AppState s;
  final BayaanColors c;

  @override
  Widget build(BuildContext context) {
    final q = s.drCurrentQuestion;
    return FadeSlideIn(
      key: ValueKey('clarify-${s.drQIdx}'),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
        children: [
          Text(
            s.drQCount,
            style: AppTheme.mono(color: BayaanBrand.purple, letterSpacing: 1),
          ),
          const SizedBox(height: 12),
          Text(
            q.question,
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w700,
              height: 1.3,
              letterSpacing: -0.42,
              color: c.ink,
            ),
          ),
          if (q.multi) ...[
            const SizedBox(height: 6),
            Text(
              'Select all that apply',
              style: TextStyle(fontSize: 12.5, color: c.secondary2),
            ),
          ],
          const SizedBox(height: 20),
          for (var i = 0; i < q.options.length; i++) _option(i, q),
          const SizedBox(height: 20),
          Row(
            children: [
              if (s.drCanBack)
                _btn(c.card, c.secondary, 'Back', s.drBack, outline: true),
              const Spacer(),
              _btn(
                BayaanBrand.purple,
                Colors.white,
                s.drQIdx == 2 ? 'Build plan' : 'Continue',
                s.drAdvanceClarify,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _option(int i, DrQuestion q) {
    final sel = s.drIsOptionSelected(i);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () => s.drPick(i),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
          decoration: BoxDecoration(
            color: sel ? c.purpleBg : c.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: sel ? c.purpleBd : c.border),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  q.options[i],
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                    color: sel ? c.purpleText : c.bodyStrong,
                  ),
                ),
              ),
              Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: sel ? BayaanBrand.purple : Colors.transparent,
                  borderRadius: BorderRadius.circular(q.multi ? 7 : 999),
                  border: sel
                      ? null
                      : Border.all(color: c.checkBorder, width: 1.5),
                ),
                child: sel
                    ? const Icon(
                        LucideIcons.check,
                        size: 12,
                        color: Colors.white,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _btn(
    Color bg,
    Color fg,
    String label,
    VoidCallback onTap, {
    bool outline = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 22),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: outline ? Border.all(color: c.borderStrong) : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: fg,
          ),
        ),
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading({required this.c, required this.label});
  final BayaanColors c;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 34,
            height: 34,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              color: BayaanBrand.purple,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            label,
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w500,
              color: c.secondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _Approval extends StatelessWidget {
  const _Approval({required this.s, required this.c});
  final AppState s;
  final BayaanColors c;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 12),
            children: [
              Text(
                'RESEARCH PLAN',
                style: AppTheme.mono(
                  color: c.muted,
                  fontSize: 10.5,
                  letterSpacing: 1.3,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Review the plan',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.42,
                  color: c.ink,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Remove any questions you don't need. Bayaan will research "
                'each one across official sources.',
                style: TextStyle(
                  fontSize: 13.5,
                  height: 1.5,
                  color: c.secondary2,
                ),
              ),
              const SizedBox(height: 18),
              for (var i = 0; i < s.drPlan.length; i++)
                FadeSlideIn(
                  key: ValueKey('plan-${s.drPlan[i]}'),
                  delay: Duration(milliseconds: 40 * i),
                  child: _planRow(i),
                ),
            ],
          ),
        ),
        _footer(),
      ],
    );
  }

  Widget _planRow(int i) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 14),
    decoration: BoxDecoration(
      color: c.card,
      borderRadius: BorderRadius.circular(13),
      border: Border.all(color: c.border),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 22,
          height: 22,
          alignment: Alignment.center,
          margin: const EdgeInsets.only(top: 1),
          decoration: BoxDecoration(color: c.purpleBg, shape: BoxShape.circle),
          child: Text(
            '${i + 1}',
            style: AppTheme.mono(
              color: BayaanBrand.purple,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            s.drPlan[i],
            style: TextStyle(fontSize: 14, height: 1.5, color: c.body),
          ),
        ),
        const SizedBox(width: 10),
        InkWell(
          onTap: () => s.drRemovePlan(i),
          child: Icon(LucideIcons.x, size: 16, color: c.faint),
        ),
      ],
    ),
  );

  Widget _footer() => Container(
    padding: const EdgeInsets.fromLTRB(22, 12, 22, 30),
    decoration: BoxDecoration(
      border: Border(top: BorderSide(color: c.hairline)),
    ),
    child: Row(
      children: [
        Text(
          '${s.drPlan.length} questions',
          style: AppTheme.mono(color: c.muted, fontSize: 11.5),
        ),
        const Spacer(),
        InkWell(
          onTap: s.drRun,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 26),
            decoration: BoxDecoration(
              color: BayaanBrand.purple,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.play, size: 15, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Start research',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class _Research extends StatelessWidget {
  const _Research({required this.s, required this.c});
  final AppState s;
  final BayaanColors c;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
      children: [
        Row(
          children: [
            Text(
              'RESEARCHING',
              style: AppTheme.mono(
                color: BayaanBrand.purple,
                fontSize: 10.5,
                letterSpacing: 1.3,
              ),
            ),
            const Spacer(),
            Text(
              '${s.drPct}%',
              style: AppTheme.mono(
                color: c.ink,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: LinearProgressIndicator(
            value: s.drPct / 100,
            minHeight: 4,
            backgroundColor: c.border,
            valueColor: const AlwaysStoppedAnimation(BayaanBrand.purple),
          ),
        ),
        const SizedBox(height: 20),
        for (var i = 0; i < s.drPlan.length; i++) _row(i),
      ],
    );
  }

  Widget _row(int i) {
    final done = s.drResearchRowDone(i);
    final active = s.drResearchRowActive(i);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 14),
      decoration: BoxDecoration(
        color: active ? c.purpleBg : c.card,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: active ? c.purpleBd : c.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: done
                ? const Icon(
                    LucideIcons.checkCircle2,
                    size: 20,
                    color: BayaanBrand.purple,
                  )
                : active
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: BayaanBrand.purple,
                    ),
                  )
                : Icon(LucideIcons.circle, size: 18, color: c.checkBorder),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.drPlan[i],
                  style: TextStyle(
                    fontSize: 13.5,
                    height: 1.45,
                    fontWeight: FontWeight.w500,
                    color: done || active ? c.bodyStrong : c.secondary2,
                  ),
                ),
                if (active) ...[
                  const SizedBox(height: 6),
                  Text(
                    s.drResearchStatus(i),
                    style: AppTheme.mono(
                      color: BayaanBrand.purple,
                      fontSize: 10.5,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Done extends StatelessWidget {
  const _Done({required this.s, required this.c});
  final AppState s;
  final BayaanColors c;

  @override
  Widget build(BuildContext context) {
    return FadeSlideIn(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(22, 20, 22, 30),
        children: [
          Container(
            width: 46,
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: c.purpleBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              LucideIcons.check,
              size: 22,
              color: BayaanBrand.purple,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Research complete',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.44,
              color: c.ink,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Bayaan reviewed ${s.drPlan.length} lines of inquiry across official '
            'labour-force and census sources.',
            style: TextStyle(fontSize: 13.5, height: 1.55, color: c.secondary2),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: c.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: c.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'KEY TREND — UNEMPLOYMENT RATE',
                  style: AppTheme.mono(
                    color: c.muted,
                    fontSize: 10,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                for (final r in _trendRows()) _trend(r),
              ],
            ),
          ),
          const SizedBox(height: 18),
          InkWell(
            onTap: s.drOpenReport,
            borderRadius: BorderRadius.circular(13),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 15),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: BayaanBrand.purple,
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.fileText, size: 16, color: Colors.white),
                  SizedBox(width: 9),
                  Text(
                    'View full report',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<DrTrendRow> _trendRows() => const [
    DrTrendRow(year: '2019', rate: '6.9%', highlight: false),
    DrTrendRow(year: '2021', rate: '5.5%', highlight: false),
    DrTrendRow(year: '2023', rate: '4.6%', highlight: false),
    DrTrendRow(year: '2025', rate: '3.8%', highlight: true),
  ];

  Widget _trend(DrTrendRow r) {
    final width = _pctWidth(r.rate);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 38,
            child: Text(
              r.year,
              style: AppTheme.mono(color: c.secondary2, fontSize: 11.5),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 22,
                  decoration: BoxDecoration(
                    color: c.fill,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: width,
                  child: Container(
                    height: 22,
                    decoration: BoxDecoration(
                      color: r.highlight
                          ? BayaanBrand.purple
                          : BayaanBrand.purple.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            r.rate,
            style: AppTheme.mono(
              color: r.highlight ? BayaanBrand.purple : c.body,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  double _pctWidth(String rate) {
    final v = double.tryParse(rate.replaceAll('%', '')) ?? 0;
    return (v / 8).clamp(0.1, 1.0);
  }
}

class _DrReport extends StatelessWidget {
  const _DrReport({required this.s, required this.c});
  final AppState s;
  final BayaanColors c;

  @override
  Widget build(BuildContext context) {
    final r = ReportBits(c);
    return ReportScaffold(
      onClose: s.drCloseReport,
      onExport: s.drToggleExport,
      exportOpen: s.drExportOpen,
      onExportDismiss: s.drToggleExport,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          r.kicker('DEEP RESEARCH REPORT', color: BayaanBrand.purple),
          r.title('Unemployment in\nAbu Dhabi — 2015–2025'),
          r.meta(
            'Jul 8, 2026 · ${s.drPlan.length} questions · official sources',
          ),
          r.divider(),
          r.heading('Executive summary'),
          r.para(
            "Abu Dhabi's unemployment rate fell from 6.9% in 2019 to 3.8% in "
            '2025, outperforming the UAE national average. Emiratisation '
            'programmes and non-oil sector growth were the primary drivers.',
            cites: [1, 2],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              r.statBox(
                '2025 rate',
                '3.8%',
                note: '↓ from 6.9%',
                noteColor: c.green,
              ),
              const SizedBox(width: 10),
              r.statBox('vs UAE avg', '−0.6pp', note: 'below national'),
            ],
          ),
          const SizedBox(height: 18),
          r.heading('By nationality'),
          r.para(
            'Emirati unemployment declined most sharply among 25–34 year-olds, '
            'reflecting targeted placement and training initiatives, while '
            'expatriate unemployment remained structurally low.',
            cites: [3],
          ),
          const SizedBox(height: 18),
          r.heading('Outlook'),
          r.para(
            'The trend is expected to hold as diversification continues, though '
            'youth-cohort entry to the labour market warrants monitoring.',
            cites: [4],
          ),
          r.divider(),
          r.sources(const [
            'SCAD Labour Force Survey 2025',
            'UAE Federal Competitiveness & Statistics Centre',
            'Abu Dhabi Statistical Yearbook 2024',
            'Emiratisation programme monitor, 2023–2025',
          ]),
        ],
      ),
    );
  }
}
