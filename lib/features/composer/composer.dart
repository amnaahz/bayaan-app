import 'package:bayaan/core/icons/lucide_icons.dart';
import 'package:bayaan/core/theme/app_theme.dart';
import 'package:bayaan/core/theme/bayaan_colors.dart';
import 'package:bayaan/core/theme/theme_x.dart';
import 'package:bayaan/core/widgets/indicators.dart';
import 'package:bayaan/data/models/ui_models.dart';
import 'package:bayaan/features/agents/agent_visuals.dart';
import 'package:bayaan/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// The bottom composer: attachments, text input (or live dictation), the
/// attach/mode toolbar, dictation mic and the send/voice primary action.
class Composer extends StatefulWidget {
  const Composer({super.key});

  @override
  State<Composer> createState() => _ComposerState();
}

class _ComposerState extends State<Composer> {
  final _controller = TextEditingController();
  final _focus = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final c = context.colors;

    if (_controller.text != s.draft) {
      _controller.value = TextEditingValue(
        text: s.draft,
        selection: TextSelection.collapsed(offset: s.draft.length),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 26),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
        decoration: BoxDecoration(
          color: c.card,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: c.border),
          boxShadow: const [
            BoxShadow(
              color: Color(0x66000000),
              blurRadius: 28,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (s.attachedAgent != null) ...[
              _AgentPill(s: s, c: c),
              const SizedBox(height: 12),
            ],
            if (s.attachments.isNotEmpty) ...[
              _Attachments(s: s, c: c),
              const SizedBox(height: 12),
            ],
            if (s.dictating)
              _Dictation(s: s, c: c)
            else ...[
              TextField(
                controller: _controller,
                focusNode: _focus,
                onChanged: (v) {
                  s.handleSlashInput(v);
                  s.onDraftChanged(v);
                },
                onSubmitted: (v) {
                  if (v.trim().isNotEmpty) s.askQuery(v.trim());
                },
                textInputAction: TextInputAction.send,
                style: TextStyle(fontSize: 15, color: c.bodyStrong),
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText: s.composerPlaceholder,
                  hintStyle: TextStyle(fontSize: 15, color: c.muted),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const SizedBox(height: 14),
              _Toolbar(s: s, c: c),
            ],
          ],
        ),
      ),
    );
  }
}

class _AgentPill extends StatelessWidget {
  const _AgentPill({required this.s, required this.c});
  final AppState s;
  final BayaanColors c;

  @override
  Widget build(BuildContext context) {
    final agent = s.attachedAgent!;
    final tile = agentTileColors(c, agent.tone);
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.fromLTRB(6, 5, 8, 5),
        decoration: BoxDecoration(
          color: c.blueTint,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: c.blueTintBd),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 22,
              height: 22,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: tile.bg,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Text(
                agent.initials,
                style: AppTheme.mono(
                  color: tile.fg,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 180),
              child: Text(
                agent.name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: c.link,
                ),
              ),
            ),
            const SizedBox(width: 7),
            InkWell(
              onTap: s.detachAgent,
              child: Icon(LucideIcons.x, size: 13, color: c.link),
            ),
          ],
        ),
      ),
    );
  }
}

class _Attachments extends StatelessWidget {
  const _Attachments({required this.s, required this.c});
  final AppState s;
  final BayaanColors c;

  (Color, Color, IconData) _style(AttachmentKind k) => switch (k) {
    AttachmentKind.camera => (c.blueTint, BayaanBrand.blue, LucideIcons.camera),
    AttachmentKind.photo => (c.greenBg, c.green, LucideIcons.image),
    AttachmentKind.file => (c.amberBg, BayaanBrand.amber, LucideIcons.fileText),
    AttachmentKind.artifact => (
      c.purpleBg,
      BayaanBrand.purple,
      LucideIcons.layoutGrid,
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final a in s.attachments) _chip(a),
      ],
    );
  }

  Widget _chip(Attachment a) {
    final (bg, fg, icon) = _style(a.kind);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 9),
      decoration: BoxDecoration(
        color: c.fill,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: c.borderStrong),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 22,
            height: 22,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, size: 12, color: fg),
          ),
          const SizedBox(width: 7),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 140),
            child: Text(
              a.name,
              overflow: TextOverflow.ellipsis,
              style: AppTheme.mono(color: c.body),
            ),
          ),
          const SizedBox(width: 7),
          InkWell(
            onTap: () => s.removeAttachment(a.id),
            child: Container(
              width: 16,
              height: 16,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: c.borderStrong,
                shape: BoxShape.circle,
              ),
              child: Icon(LucideIcons.x, size: 9, color: c.secondary),
            ),
          ),
        ],
      ),
    );
  }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar({required this.s, required this.c});
  final AppState s;
  final BayaanColors c;

  @override
  Widget build(BuildContext context) {
    final isDeep = s.mode == SearchMode.deep;
    final modeBg = isDeep ? c.purpleBg : c.blueTint;
    final modeBorder = isDeep ? c.purpleBd : c.blueTintBd;
    final modeFg = isDeep ? c.purpleText : c.link;

    return Row(
      children: [
        _RoundBtn(
          onTap: s.toggleAttachMenu,
          bg: s.attachMenuOpen ? c.borderStrong : c.fill,
          child: AnimatedRotation(
            turns: s.attachMenuOpen ? 0.125 : 0,
            duration: const Duration(milliseconds: 180),
            child: Icon(LucideIcons.plus, size: 20, color: c.secondary),
          ),
        ),
        const SizedBox(width: 10),
        InkWell(
          onTap: s.toggleModeMenu,
          borderRadius: BorderRadius.circular(999),
          child: Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 13),
            decoration: BoxDecoration(
              color: modeBg,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: modeBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.barChart3, size: 14, color: modeFg),
                const SizedBox(width: 7),
                Text(
                  s.modeLabel,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: modeFg,
                  ),
                ),
                const SizedBox(width: 5),
                Icon(LucideIcons.chevronDown, size: 12, color: modeFg),
              ],
            ),
          ),
        ),
        const Spacer(),
        _RoundBtn(
          onTap: s.startDictation,
          bg: c.fill,
          child: Icon(LucideIcons.mic, size: 18, color: c.secondary),
        ),
        const SizedBox(width: 10),
        _SendButton(s: s),
      ],
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({required this.s});
  final AppState s;

  @override
  Widget build(BuildContext context) {
    final hasDraft = s.draft.trim().isNotEmpty;
    return InkWell(
      onTap: s.primaryAction,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: BayaanBrand.blue,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0x4D297DE3),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: hasDraft
            ? const Icon(LucideIcons.arrowUp, size: 17, color: Colors.white)
            : const _MiniLevels(),
      ),
    );
  }
}

class _MiniLevels extends StatelessWidget {
  const _MiniLevels();

  @override
  Widget build(BuildContext context) {
    const heights = [4.0, 10.0, 16.0, 10.0, 4.0];
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < heights.length; i++) ...[
          if (i > 0) const SizedBox(width: 1.6),
          Container(
            width: 2.4,
            height: heights[i],
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(1.2),
            ),
          ),
        ],
      ],
    );
  }
}

class _Dictation extends StatelessWidget {
  const _Dictation({required this.s, required this.c});
  final AppState s;
  final BayaanColors c;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 15, height: 1.5, color: c.bodyStrong),
              children: [
                TextSpan(text: s.dictText),
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
            _RoundBtn(
              onTap: () => s.stopDictation(keep: false),
              bg: c.fill,
              size: 38,
              child: Icon(LucideIcons.x, size: 16, color: c.secondary),
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
                    s.dictTime,
                    style: AppTheme.mono(color: c.secondary2, fontSize: 11.5),
                  ),
                ],
              ),
            ),
            _RoundBtn(
              onTap: () => s.stopDictation(keep: true),
              bg: BayaanBrand.blue,
              child: const Icon(
                LucideIcons.check,
                size: 17,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RoundBtn extends StatelessWidget {
  const _RoundBtn({
    required this.onTap,
    required this.bg,
    required this.child,
    this.size = 40,
  });
  final VoidCallback onTap;
  final Color bg;
  final Widget child;
  final double size;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
        child: child,
      ),
    );
  }
}
