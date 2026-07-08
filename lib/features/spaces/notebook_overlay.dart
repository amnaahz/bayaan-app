import 'dart:async';

import 'package:bayaan/core/icons/lucide_icons.dart';
import 'package:bayaan/core/theme/app_theme.dart';
import 'package:bayaan/core/theme/bayaan_colors.dart';
import 'package:bayaan/core/theme/theme_x.dart';
import 'package:bayaan/core/widgets/bayaan_logo.dart';
import 'package:bayaan/core/widgets/indicators.dart';
import 'package:bayaan/data/mock/mock_data.dart';
import 'package:bayaan/data/models/space_models.dart';
import 'package:bayaan/features/shared/app_bottom_sheet.dart';
import 'package:bayaan/features/shared/report_scaffold.dart';
import 'package:bayaan/features/spaces/add_sources_sheet.dart';
import 'package:bayaan/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// The full notebook workspace overlay: Sources / Chat / Create tabs plus the
/// report & audio sheets, report viewer and audio player.
class NotebookOverlay extends StatelessWidget {
  const NotebookOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final c = context.colors;
    return ColoredBox(
      color: c.bg,
      child: Stack(
        children: [
          Column(
            children: [
              _header(s, c),
              _tabs(s, c),
              Expanded(child: _body(s, c)),
            ],
          ),
          if (s.addSrcOpen) const AddSourcesSheet(),
          if (s.nbSheet == 'report') _ReportSheet(s: s, c: c),
          if (s.nbSheet == 'audio') _AudioSheet(s: s, c: c),
          if (s.nbReportOpen) _NotebookReport(s: s, c: c),
          if (s.playerOpen) _AudioPlayer(s: s, c: c),
        ],
      ),
    );
  }

  Widget _header(AppState s, BayaanColors c) => Padding(
    padding: const EdgeInsets.fromLTRB(14, 58, 14, 0),
    child: Row(
      children: [
        _iconBtn(c, LucideIcons.chevronLeft, s.closeNotebook),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                s.nbName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.25,
                  color: c.ink,
                ),
              ),
              Text(
                s.nbMetaLine,
                style: AppTheme.mono(color: c.muted, fontSize: 10),
              ),
            ],
          ),
        ),
        _iconBtn(c, LucideIcons.moreVertical, () {}),
      ],
    ),
  );

  Widget _iconBtn(BayaanColors c, IconData icon, VoidCallback onTap) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(11),
    child: Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      child: Icon(icon, size: 19, color: c.ink),
    ),
  );

  Widget _tabs(AppState s, BayaanColors c) {
    Widget tab(String id, String label, {bool dot = false}) {
      final active = s.nbTab == id;
      return InkWell(
        onTap: () => s.setNbTab(id),
        child: Container(
          padding: const EdgeInsets.fromLTRB(2, 8, 2, 11),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: active ? BayaanBrand.blue : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: active ? c.ink : c.secondary2,
                ),
              ),
              if (dot && s.generating) ...[
                const SizedBox(width: 7),
                const PulseDot(color: BayaanBrand.blue),
              ],
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(22, 10, 22, 0),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: c.hairline)),
      ),
      child: Row(
        children: [
          tab('sources', 'Sources'),
          const SizedBox(width: 24),
          tab('chat', 'Chat'),
          const SizedBox(width: 24),
          tab('studio', 'Create', dot: true),
        ],
      ),
    );
  }

  Widget _body(AppState s, BayaanColors c) => switch (s.nbTab) {
    'sources' => _SourcesTab(s: s, c: c),
    'chat' => _ChatTab(s: s, c: c),
    _ => _StudioTab(s: s, c: c),
  };
}

// ── Sources tab ─────────────────────────────────────────────────────────────
class _SourcesTab extends StatelessWidget {
  const _SourcesTab({required this.s, required this.c});
  final AppState s;
  final BayaanColors c;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 30),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${s.nbSelectedCount} OF ${s.nbTotalSources} SELECTED',
              style: AppTheme.mono(
                color: c.muted,
                fontSize: 10.5,
                letterSpacing: 1.3,
              ),
            ),
            InkWell(
              onTap: s.openAddSrc,
              child: Row(
                children: [
                  Icon(LucideIcons.plus, size: 13, color: c.link),
                  const SizedBox(width: 6),
                  Text(
                    'Add source',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: c.link,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        for (var i = 0; i < s.nbSources.length; i++)
          _sourceRow(i, s.nbSources[i]),
        if (s.nbSources.isEmpty)
          InkWell(
            onTap: s.openAddSrc,
            child: Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: c.checkBorder, width: 1.5),
              ),
              child: Column(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: c.fill,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(LucideIcons.filePlus, size: 22, color: c.muted),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Add your first source',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: c.ink,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Search the web, upload a file, paste a link or text.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12.5, color: c.secondary2),
                  ),
                ],
              ),
            ),
          ),
        if (s.nbSources.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 18),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              color: c.bgHover,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: c.hairline),
            ),
            child: Text(
              'Selected sources ground everything in this notebook — chat '
              "answers, reports and audio briefs cite only what's checked.",
              style: TextStyle(
                fontSize: 12.5,
                height: 1.55,
                color: c.secondary2,
              ),
            ),
          ),
      ],
    );
  }

  Widget _sourceRow(int i, NotebookSource src) {
    return InkWell(
      onTap: () => s.toggleSource(i),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 2),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: c.hairline)),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: c.fill,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                src.badge,
                style: AppTheme.mono(
                  color: c.secondary,
                  fontSize: 9.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    src.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: c.ink,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    src.meta,
                    style: AppTheme.mono(color: c.muted, fontSize: 10.5),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            _check(src.checked),
          ],
        ),
      ),
    );
  }

  Widget _check(bool checked) => Container(
    width: 22,
    height: 22,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: checked ? BayaanBrand.blue : Colors.transparent,
      borderRadius: BorderRadius.circular(7),
      border: checked ? null : Border.all(color: c.checkBorder, width: 1.5),
    ),
    child: checked
        ? const Icon(LucideIcons.check, size: 12, color: Colors.white)
        : null,
  );
}

// ── Chat tab ────────────────────────────────────────────────────────────────
class _ChatTab extends StatefulWidget {
  const _ChatTab({required this.s, required this.c});
  final AppState s;
  final BayaanColors c;

  @override
  State<_ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<_ChatTab> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.s;
    final c = widget.c;
    if (_controller.text != s.nbDraft) {
      _controller.value = TextEditingValue(
        text: s.nbDraft,
        selection: TextSelection.collapsed(offset: s.nbDraft.length),
      );
    }
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(22, 26, 22, 10),
            children: [
              if (!s.nbHasMsgs) ...[
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                      letterSpacing: -0.42,
                      color: c.ink,
                    ),
                    children: [
                      const TextSpan(text: 'Ask across your\n'),
                      TextSpan(
                        text: '${s.nbSelectedCount} sources.',
                        style: const TextStyle(
                          color: BayaanBrand.blue,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Every answer is grounded and cited from this notebook only.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: c.secondary2,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'SUGGESTED',
                  style: AppTheme.mono(
                    color: c.muted,
                    fontSize: 10.5,
                    letterSpacing: 1.3,
                  ),
                ),
                for (final q in s.nbChatStarters)
                  InkWell(
                    onTap: () => s.nbSend(q),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: c.hairline)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              q,
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.4,
                                color: c.body,
                              ),
                            ),
                          ),
                          Icon(
                            LucideIcons.arrowUpRight,
                            size: 14,
                            color: c.faint,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
              for (final m in s.nbMsgs) _nbMessage(m, c, s),
            ],
          ),
        ),
        _composer(s, c),
      ],
    );
  }

  Widget _nbMessage(NotebookMessage m, BayaanColors c, AppState s) {
    if (m.isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width * 0.72,
          ),
          padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 15),
          decoration: BoxDecoration(
            color: c.bubble,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
              bottomLeft: Radius.circular(18),
              bottomRight: Radius.circular(5),
            ),
            border: Border.all(color: c.bubbleBd),
          ),
          child: Text(
            m.text,
            style: TextStyle(
              fontSize: 14,
              height: 1.45,
              fontWeight: FontWeight.w500,
              color: c.link,
            ),
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: BayaanLogo(size: 24, borderRadius: 6),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: m.thinking
                ? const ThinkingDots(label: 'reading selected sources…')
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.6,
                            color: c.bodyStrong,
                          ),
                          children: [
                            TextSpan(text: m.text),
                            TextSpan(
                              text: ' [1][2]',
                              style: AppTheme.mono(color: c.link),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'cites ${s.nbSelectedCount} selected sources',
                        style: AppTheme.mono(color: c.muted, fontSize: 10.5),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _composer(AppState s, BayaanColors c) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 26),
      child: s.nbDicting
          ? _dictation(s, c)
          : Container(
              padding: const EdgeInsets.fromLTRB(18, 8, 8, 8),
              decoration: BoxDecoration(
                color: c.card,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: c.border),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x66000000),
                    blurRadius: 28,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onChanged: s.onNbDraft,
                      onSubmitted: (v) {
                        if (v.trim().isNotEmpty) unawaited(s.nbSend());
                      },
                      style: TextStyle(fontSize: 14.5, color: c.bodyStrong),
                      decoration: InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        hintText: 'Ask about your sources…',
                        hintStyle: TextStyle(color: c.muted),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: s.nbStartDict,
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      width: 36,
                      height: 36,
                      alignment: Alignment.center,
                      child: Icon(
                        LucideIcons.mic,
                        size: 16,
                        color: c.secondary,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => s.nbSend(),
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      width: 38,
                      height: 38,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: BayaanBrand.blue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        LucideIcons.arrowUp,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _dictation(AppState s, BayaanColors c) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14.5,
                  height: 1.5,
                  color: c.bodyStrong,
                ),
                children: [
                  TextSpan(text: s.nbDictText),
                  const WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: BlinkingCursor(),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              _circle(
                c.fill,
                LucideIcons.x,
                c.secondary,
                () => s.nbStopDict(keep: false),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PulseDot(
                      color: c.red,
                      duration: const Duration(milliseconds: 1100),
                    ),
                    const SizedBox(width: 10),
                    const WaveBars(
                      heights: [8, 14, 20, 12, 18, 9, 15],
                      color: BayaanBrand.blue,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      s.nbDictTime,
                      style: AppTheme.mono(color: c.secondary2, fontSize: 11.5),
                    ),
                  ],
                ),
              ),
              _circle(
                BayaanBrand.blue,
                LucideIcons.check,
                Colors.white,
                () => s.nbStopDict(keep: true),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _circle(Color bg, IconData icon, Color fg, VoidCallback onTap) =>
      InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          width: 38,
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
          child: Icon(icon, size: 16, color: fg),
        ),
      );
}

// ── Studio (Create) tab ─────────────────────────────────────────────────────
class _StudioTab extends StatelessWidget {
  const _StudioTab({required this.s, required this.c});
  final AppState s;
  final BayaanColors c;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 30),
      children: [
        Text(
          'CREATE',
          style: AppTheme.mono(
            color: c.muted,
            fontSize: 10.5,
            letterSpacing: 1.3,
          ),
        ),
        const SizedBox(height: 10),
        _createCard(
          bg: c.amberBg,
          fg: BayaanBrand.amber,
          icon: LucideIcons.fileText,
          title: 'Report',
          sub: 'Structured, cited brief from your sources',
          onTap: s.openReportSheet,
        ),
        const SizedBox(height: 10),
        _createCard(
          bg: c.greenBg,
          fg: c.green,
          icon: LucideIcons.headphones,
          title: 'Audio brief',
          sub: 'Listen to the findings on the move',
          onTap: s.openAudioSheet,
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Text(
              'LIBRARY',
              style: AppTheme.mono(
                color: c.muted,
                fontSize: 10.5,
                letterSpacing: 1.3,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(child: Container(height: 1, color: c.hairline)),
            const SizedBox(width: 10),
            Text(
              s.libCount,
              style: AppTheme.mono(color: c.faint, fontSize: 10.5),
            ),
          ],
        ),
        if (s.generating) _generationCard(),
        for (final it in s.libItems) _libItem(it),
      ],
    );
  }

  Widget _createCard({
    required Color bg,
    required Color fg,
    required IconData icon,
    required String title,
    required String sub,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: c.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: c.border),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 18, color: fg),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.15,
                      color: c.ink,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    sub,
                    style: TextStyle(
                      fontSize: 12.5,
                      height: 1.4,
                      color: c.secondary2,
                    ),
                  ),
                ],
              ),
            ),
            Icon(LucideIcons.chevronRight, size: 15, color: c.faint),
          ],
        ),
      ),
    );
  }

  Widget _generationCard() {
    final accent = s.genIsAudio ? c.green : BayaanBrand.amber;
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
      decoration: BoxDecoration(
        color: c.bgHover,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accent.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 38,
                height: 38,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(strokeWidth: 1.6, color: accent),
                    Icon(
                      s.genIsAudio
                          ? LucideIcons.headphones
                          : LucideIcons.fileText,
                      size: 16,
                      color: accent,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.genTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: c.ink,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      s.genStepLabel,
                      style: AppTheme.mono(color: accent, fontSize: 10.5),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: s.cancelGen,
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: c.muted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              for (var i = 0; i < 3; i++)
                Expanded(
                  child: Container(
                    height: 3,
                    margin: EdgeInsets.only(left: i == 0 ? 0 : 5),
                    decoration: BoxDecoration(
                      color: (s.genState?.step ?? 0) >= i ? accent : c.fill,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 9),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "You can keep working — it'll appear here when ready.",
              style: TextStyle(fontSize: 11.5, color: c.secondary2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _libItem(LibraryItem it) {
    final isAudio = it.kind == OutputKind.audio;
    return InkWell(
      onTap: () => s.openLibraryItem(it),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 2),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: c.hairline)),
        ),
        child: Row(
          children: [
            if (isAudio)
              Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: c.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.play,
                  size: 13,
                  color: Colors.white,
                ),
              )
            else
              Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: c.amberBg,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(
                  LucideIcons.fileText,
                  size: 16,
                  color: BayaanBrand.amber,
                ),
              ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    it.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: c.ink,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (it.isNew) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 2,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            color: c.blueTint,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            'NEW',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: c.link,
                            ),
                          ),
                        ),
                        const SizedBox(width: 7),
                      ],
                      Text(
                        it.meta,
                        style: AppTheme.mono(color: c.muted, fontSize: 10.5),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(LucideIcons.chevronRight, size: 15, color: c.faint),
          ],
        ),
      ),
    );
  }
}

// ── Report sheet ─────────────────────────────────────────────────────────────
class _ReportSheet extends StatelessWidget {
  const _ReportSheet({required this.s, required this.c});
  final AppState s;
  final BayaanColors c;

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      onDismiss: s.closeSheet,
      background: c.bg,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sheetHeader(
            c,
            c.amberBg,
            BayaanBrand.amber,
            LucideIcons.fileText,
            'New report',
            s.nbSelectedCount,
          ),
          const SizedBox(height: 18),
          Text(
            'FORMAT',
            style: AppTheme.mono(
              color: c.muted,
              fontSize: 10.5,
              letterSpacing: 1.3,
            ),
          ),
          const SizedBox(height: 9),
          for (var i = 0; i < kReportTemplates.length; i++) _templateRow(i),
          const SizedBox(height: 16),
          _generateButton('Generate report', () => s.startGeneration('report')),
        ],
      ),
    );
  }

  Widget _templateRow(int i) {
    final picked = s.pickedTemplate == i;
    final t = kReportTemplates[i];
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => s.pickTemplate(i),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 14),
          decoration: BoxDecoration(
            color: picked ? c.blueTint : c.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: picked ? c.blueTintBd : c.border),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.$1,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: c.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      t.$2,
                      style: TextStyle(fontSize: 12, color: c.secondary2),
                    ),
                  ],
                ),
              ),
              _radio(picked),
            ],
          ),
        ),
      ),
    );
  }

  Widget _radio(bool on) => Container(
    width: 20,
    height: 20,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: on ? BayaanBrand.blue : Colors.transparent,
      shape: BoxShape.circle,
      border: on ? null : Border.all(color: c.checkBorder, width: 1.5),
    ),
    child: on
        ? const Icon(LucideIcons.check, size: 11, color: Colors.white)
        : null,
  );

  Widget _generateButton(String label, VoidCallback onTap) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(13),
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: BayaanBrand.blue,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14.5,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    ),
  );

  Widget _sheetHeader(
    BayaanColors c,
    Color bg,
    Color fg,
    IconData icon,
    String title,
    int sources,
  ) {
    return Row(
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
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.36,
            color: c.ink,
          ),
        ),
        const Spacer(),
        Text(
          '$sources sources',
          style: AppTheme.mono(color: c.muted, fontSize: 10.5),
        ),
      ],
    );
  }
}

// ── Audio sheet ─────────────────────────────────────────────────────────────
class _AudioSheet extends StatelessWidget {
  const _AudioSheet({required this.s, required this.c});
  final AppState s;
  final BayaanColors c;

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      onDismiss: s.closeSheet,
      background: c.bg,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: c.greenBg,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(LucideIcons.headphones, size: 15, color: c.green),
              ),
              const SizedBox(width: 10),
              Text(
                'New audio brief',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.36,
                  color: c.ink,
                ),
              ),
              const Spacer(),
              Text(
                '${s.nbSelectedCount} sources',
                style: AppTheme.mono(color: c.muted, fontSize: 10.5),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'FORMAT',
            style: AppTheme.mono(
              color: c.muted,
              fontSize: 10.5,
              letterSpacing: 1.3,
            ),
          ),
          const SizedBox(height: 9),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 2.5,
            children: [
              for (var i = 0; i < kAudioFormats.length; i++) _formatCard(i),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                'LENGTH',
                style: AppTheme.mono(
                  color: c.muted,
                  fontSize: 10.5,
                  letterSpacing: 1.3,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: c.fill,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    children: [
                      for (var i = 0; i < 3; i++)
                        Expanded(child: _lengthSeg(i)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () => s.startGeneration('audio'),
            borderRadius: BorderRadius.circular(13),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: BayaanBrand.blue,
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Text(
                'Generate audio brief',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _formatCard(int i) {
    final picked = s.pickedFormat == i;
    final f = kAudioFormats[i];
    return InkWell(
      onTap: () => s.pickFormat(i),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 13),
        decoration: BoxDecoration(
          color: picked ? c.blueTint : c.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: picked ? c.blueTintBd : c.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    f.$1,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: c.ink,
                    ),
                  ),
                ),
                if (picked)
                  Container(
                    width: 17,
                    height: 17,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: BayaanBrand.blue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      LucideIcons.check,
                      size: 9,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              f.$2,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11, height: 1.4, color: c.secondary2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _lengthSeg(int i) {
    const labels = ['Short', 'Default', 'Long'];
    final on = s.pickedLength == i;
    return InkWell(
      onTap: () => s.pickLength(i),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: on ? c.card : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          labels[i],
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: on ? c.ink : c.secondary2,
          ),
        ),
      ),
    );
  }
}

// ── Notebook report viewer ───────────────────────────────────────────────────
class _NotebookReport extends StatelessWidget {
  const _NotebookReport({required this.s, required this.c});
  final AppState s;
  final BayaanColors c;

  @override
  Widget build(BuildContext context) {
    final r = ReportBits(c);
    return ReportScaffold(
      onClose: s.closeNbReport,
      onExport: s.toggleNbExport,
      exportOpen: s.nbExportOpen,
      onExportDismiss: s.toggleNbExport,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          r.kicker('BRIEFING DOC'),
          r.title('Economic Anomalies —\nExecutive Brief'),
          r.meta('Jul 8, 2026 · ${s.nbSelectedCount} sources · 4 min read'),
          r.divider(),
          r.heading('Key finding'),
          r.para(
            'Q1 housing rents rose 11.2% year-on-year while broader CPI held '
            'at 2.8% — a divergence not seen since 2015, concentrated in '
            'mid-income districts.',
            cites: [1],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              r.statBox('Housing rents YoY', '+11.2%'),
              const SizedBox(width: 10),
              r.statBox('Headline CPI', '+2.8%'),
            ],
          ),
          const SizedBox(height: 18),
          r.heading('Why it matters'),
          r.para(
            'Rent pressure is eroding real income gains for the middle '
            'quintiles ahead of the housing supply review. If the trend '
            'persists two more quarters, affordability targets are at risk.',
            cites: [2],
          ),
          const SizedBox(height: 18),
          r.heading('Recommended actions'),
          r.para(
            'Fast-track the vacant-unit levy consultation; expand the rental '
            'index to mid-income districts; brief the housing committee before '
            'the Q3 supply review.',
            cites: [3],
          ),
          r.divider(),
          r.sources(const [
            'Q1 Anomaly Notes — rent vs CPI divergence tables',
            'SCAD CPI Bulletin, March 2026',
            'Housing market monitor — district-level rents',
          ]),
        ],
      ),
    );
  }
}

// ── Audio player ─────────────────────────────────────────────────────────────
class _AudioPlayer extends StatelessWidget {
  const _AudioPlayer({required this.s, required this.c});
  final AppState s;
  final BayaanColors c;

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      onDismiss: s.closePlayer,
      background: c.bg,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 88,
            height: 88,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const RadialGradient(
                center: Alignment(-0.32, -0.4),
                colors: [
                  Color(0xFF5BBF77),
                  Color(0xFF228636),
                  Color(0xFF16612B),
                ],
                stops: [0, 0.58, 1],
              ),
            ),
            child: s.playerPlaying
                ? const WaveBars(
                    heights: [12, 22, 30, 22, 12],
                    color: Colors.white,
                    barWidth: 5,
                    gap: 4,
                  )
                : const Icon(
                    LucideIcons.headphones,
                    size: 30,
                    color: Colors.white,
                  ),
          ),
          const SizedBox(height: 16),
          Text(
            'Q1 Housing Inflation — Audio Brief',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.5,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.25,
              color: c.ink,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Deep Dive · English · ${s.nbSelectedCount} sources',
            style: AppTheme.mono(color: c.muted),
          ),
          const SizedBox(height: 22),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: s.playerProgress,
              minHeight: 4,
              backgroundColor: c.border,
              valueColor: const AlwaysStoppedAnimation(BayaanBrand.blue),
            ),
          ),
          const SizedBox(height: 7),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                s.playerTime,
                style: AppTheme.mono(color: c.muted, fontSize: 10.5),
              ),
              Text(
                '9:13',
                style: AppTheme.mono(color: c.muted, fontSize: 10.5),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.rotateCcw, size: 20, color: c.ink),
              const SizedBox(width: 26),
              InkWell(
                onTap: s.togglePlayer,
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  width: 62,
                  height: 62,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: BayaanBrand.blue,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    s.playerPlaying ? LucideIcons.pause : LucideIcons.play,
                    size: 22,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 26),
              Icon(LucideIcons.rotateCcw, size: 20, color: c.ink),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              color: c.panel,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: c.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'NOW DISCUSSING',
                  style: AppTheme.mono(
                    color: c.muted,
                    fontSize: 9.5,
                    letterSpacing: 1.3,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  '"…the striking part is that rents in mid-income districts '
                  'moved eleven percent while everything else stayed flat — '
                  "that's the anomaly worth the committee's attention.\"",
                  style: TextStyle(fontSize: 13, height: 1.55, color: c.body),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
