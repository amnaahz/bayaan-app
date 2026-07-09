import 'package:bayaan/core/icons/lucide_icons.dart';
import 'package:bayaan/core/theme/app_theme.dart';
import 'package:bayaan/core/theme/bayaan_colors.dart';
import 'package:bayaan/core/theme/theme_x.dart';
import 'package:bayaan/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// The internal-data-scope options offered in the advanced section.
const List<String> _scopeOptions = [
  'All SCAD data',
  'Economy only',
  'Demographics only',
];

/// Create-agent flow: name, description, persona/instructions and collapsible
/// tools / advanced sections, presented as a near-full-height sheet.
class NewAgentModal extends StatefulWidget {
  const NewAgentModal({super.key});

  @override
  State<NewAgentModal> createState() => _NewAgentModalState();
}

class _NewAgentModalState extends State<NewAgentModal> {
  final _name = TextEditingController();
  final _desc = TextEditingController();
  final _instr = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _desc.dispose();
    _instr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final c = context.colors;
    final size = MediaQuery.sizeOf(context);
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    // Keep the instructions field in sync when "Generate" rewrites the text.
    if (_instr.text != s.naInstr) {
      _instr.value = TextEditingValue(
        text: s.naInstr,
        selection: TextSelection.collapsed(offset: s.naInstr.length),
      );
    }

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: s.closeNewAgent,
            child: const ColoredBox(color: Color(0x8C000000)),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: size.height * 0.94,
            decoration: BoxDecoration(
              color: c.card,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(26),
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                _grabber(c),
                _header(context, s, c),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(22, 18, 22, 20),
                    children: [
                      _label(c, 'Name'),
                      _input(c, _name, s.onNaName, 'e.g. Statistics Explainer'),
                      const SizedBox(height: 18),
                      _label(c, 'Description'),
                      _input(
                        c,
                        _desc,
                        s.onNaDesc,
                        'A short summary of what this agent is for.',
                        minLines: 2,
                        maxLines: 4,
                      ),
                      const SizedBox(height: 18),
                      _personaHeader(s, c),
                      _input(
                        c,
                        _instr,
                        s.onNaInstr,
                        'Describe the persona, tone, format, and what to '
                        'always / never do. Write a rough draft and hit '
                        'Generate to expand it.',
                        minLines: 4,
                        maxLines: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 7),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Grounded in official SCAD statistics.',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: c.muted,
                                ),
                              ),
                            ),
                            Text(
                              '${s.naInstr.length}/4000',
                              style: AppTheme.mono(color: c.muted),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _CollapsibleSection(
                        icon: LucideIcons.wand,
                        title: 'Tools & response style',
                        open: s.naToolsOpen,
                        onToggle: s.toggleNaTools,
                        child: _toolsBody(s, c),
                      ),
                      const SizedBox(height: 12),
                      _CollapsibleSection(
                        icon: LucideIcons.sliders,
                        title: 'Advanced settings',
                        open: s.naAdvOpen,
                        onToggle: s.toggleNaAdv,
                        child: _advancedBody(s, c),
                      ),
                    ],
                  ),
                ),
                _footer(context, s, c, bottomInset),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _grabber(BayaanColors c) => Container(
    width: 38,
    height: 4,
    margin: const EdgeInsets.only(top: 12, bottom: 4),
    decoration: BoxDecoration(
      color: c.borderStrong,
      borderRadius: BorderRadius.circular(99),
    ),
  );

  Widget _header(BuildContext context, AppState s, BayaanColors c) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 8, 22, 14),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: c.hairline)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create an Agent',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.4,
                    color: c.ink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Give your agent a persona. It steers how the assistant '
                  'responds when you apply it to a conversation.',
                  style: TextStyle(
                    fontSize: 12.5,
                    height: 1.45,
                    color: c.secondary2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          InkWell(
            onTap: s.closeNewAgent,
            borderRadius: BorderRadius.circular(9),
            child: Padding(
              padding: const EdgeInsets.all(7),
              child: Icon(LucideIcons.x, size: 17, color: c.muted),
            ),
          ),
        ],
      ),
    );
  }

  Widget _personaHeader(AppState s, BayaanColors c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Persona / Instructions',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: c.bodyStrong,
              ),
            ),
          ),
          InkWell(
            onTap: s.generatePersona,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (s.naGenerating)
                    SizedBox(
                      width: 13,
                      height: 13,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(c.link),
                      ),
                    )
                  else
                    Icon(LucideIcons.sparkles, size: 15, color: c.link),
                  const SizedBox(width: 6),
                  Text(
                    'Generate',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: c.link,
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

  Widget _toolsBody(AppState s, BayaanColors c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _subLabel(c, 'Tools'),
        Row(
          children: [
            _pill(
              c,
              'Normal',
              selected: !s.naToolWeb,
              onTap: s.toggleNaToolWeb,
            ),
            const SizedBox(width: 9),
            _pill(
              c,
              'Web search',
              selected: s.naToolWeb,
              onTap: s.toggleNaToolWeb,
            ),
          ],
        ),
        _hint(c, 'Choose which tools this agent may use.'),
        const SizedBox(height: 16),
        _subLabel(c, 'Response style'),
        _segmented(c, [
          (
            'Concise',
            s.naResp == ResponseMode.concise,
            () => s.setNaResp(ResponseMode.concise),
          ),
          (
            'Standard',
            s.naResp == ResponseMode.standard,
            () => s.setNaResp(ResponseMode.standard),
          ),
        ]),
        const SizedBox(height: 16),
        _subLabel(c, 'Data visualization'),
        _segmented(c, [
          ('On', s.naViz, () => s.setNaViz(on: true)),
          ('Off', !s.naViz, () => s.setNaViz(on: false)),
        ]),
        _hint(c, 'On enables charts in the answer; Off disables them.'),
      ],
    );
  }

  Widget _advancedBody(AppState s, BayaanColors c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(LucideIcons.database, size: 15, color: c.secondary),
            const SizedBox(width: 8),
            Text(
              'Internal data scope',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: c.bodyStrong,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (var i = 0; i < _scopeOptions.length; i++)
              _pill(
                c,
                _scopeOptions[i],
                selected: s.naScope == i,
                onTap: () => s.setNaScope(i),
              ),
          ],
        ),
        _hint(c, 'Narrows access only, never widens it.'),
        const SizedBox(height: 16),
        _subLabel(c, 'Knowledge files'),
        InkWell(
          onTap: () => s.flashToast('Attach knowledge files (coming soon)'),
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: c.checkBorder, width: 1.5),
            ),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: c.fill,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(LucideIcons.upload, size: 19, color: c.secondary),
                ),
                const SizedBox(height: 10),
                Text(
                  'Add knowledge files',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: c.bodyStrong,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'PDF, DOCX, TXT or CSV · up to 25 MB each',
                  style: TextStyle(fontSize: 11.5, color: c.muted),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _footer(
    BuildContext context,
    AppState s,
    BayaanColors c,
    double bottomInset,
  ) {
    return Container(
      padding: EdgeInsets.fromLTRB(22, 14, 22, 16 + bottomInset),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: c.hairline)),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: s.closeNewAgent,
            borderRadius: BorderRadius.circular(11),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11),
                border: Border.all(color: c.borderStrong),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: c.secondary,
                ),
              ),
            ),
          ),
          const Spacer(),
          Opacity(
            opacity: s.newAgentValid ? 1 : 0.5,
            child: InkWell(
              onTap: s.newAgentValid ? s.createAgent : null,
              borderRadius: BorderRadius.circular(11),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 24,
                ),
                decoration: BoxDecoration(
                  color: BayaanBrand.blue,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Text(
                  'Create Agent',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Small builders ─────────────────────────────────────────────────────────
  Widget _label(BayaanColors c, String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: c.bodyStrong,
      ),
    ),
  );

  Widget _subLabel(BayaanColors c, String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 12.5,
        fontWeight: FontWeight.w600,
        color: c.bodyStrong,
      ),
    ),
  );

  Widget _hint(BayaanColors c, String text) => Padding(
    padding: const EdgeInsets.only(top: 8),
    child: Text(text, style: TextStyle(fontSize: 11.5, color: c.muted)),
  );

  Widget _input(
    BayaanColors c,
    TextEditingController controller,
    ValueChanged<String> onChanged,
    String hint, {
    int minLines = 1,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      minLines: minLines,
      maxLines: maxLines,
      style: TextStyle(fontSize: 14.5, height: 1.5, color: c.ink),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 14, color: c.muted, height: 1.5),
        filled: true,
        fillColor: c.bg,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: BorderSide(color: c.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: BorderSide(color: c.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: BorderSide(color: c.blueHoverBd),
        ),
      ),
    );
  }

  Widget _pill(
    BayaanColors c,
    String label, {
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: selected ? c.blueTint : c.card,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: selected ? c.blueTintBd : c.border),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? c.link : c.secondary,
          ),
        ),
      ),
    );
  }

  Widget _segmented(
    BayaanColors c,
    List<(String, bool, VoidCallback)> items,
  ) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: c.fill,
        borderRadius: BorderRadius.circular(11),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final (label, selected, onTap) in items)
            InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(9),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 7,
                  horizontal: 18,
                ),
                decoration: BoxDecoration(
                  color: selected ? c.segThumb : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: selected ? c.ink : c.secondary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CollapsibleSection extends StatelessWidget {
  const _CollapsibleSection({
    required this.icon,
    required this.title,
    required this.open,
    required this.onToggle,
    required this.child,
  });

  final IconData icon;
  final String title;
  final bool open;
  final VoidCallback onToggle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
              child: Row(
                children: [
                  Icon(icon, size: 16, color: c.secondary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: c.ink,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: open ? 0.5 : 0,
                    duration: const Duration(milliseconds: 180),
                    child: Icon(
                      LucideIcons.chevronDown,
                      size: 15,
                      color: c.faint,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (open)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(15, 14, 15, 16),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: c.hairline)),
              ),
              child: child,
            ),
        ],
      ),
    );
  }
}
