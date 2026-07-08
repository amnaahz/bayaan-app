import 'package:bayaan/core/icons/lucide_icons.dart';
import 'package:bayaan/core/theme/app_theme.dart';
import 'package:bayaan/core/theme/bayaan_colors.dart';
import 'package:bayaan/core/theme/theme_x.dart';
import 'package:bayaan/core/widgets/fade_slide_in.dart';
import 'package:bayaan/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// A centered dialog with title, subtitle, a single text field and
/// Cancel / Create actions. Used for New Folder and New Notebook.
class _CreateDialog extends StatefulWidget {
  const _CreateDialog({
    required this.title,
    required this.subtitle,
    required this.fieldLabel,
    required this.hint,
    required this.value,
    required this.valid,
    required this.onChanged,
    required this.onCancel,
    required this.onCreate,
  });

  final String title;
  final String subtitle;
  final String fieldLabel;
  final String hint;
  final String value;
  final bool valid;
  final ValueChanged<String> onChanged;
  final VoidCallback onCancel;
  final VoidCallback onCreate;

  @override
  State<_CreateDialog> createState() => _CreateDialogState();
}

class _CreateDialogState extends State<_CreateDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.value,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return GestureDetector(
      onTap: widget.onCancel,
      child: ColoredBox(
        color: const Color(0x8C000000),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: GestureDetector(
              onTap: () {},
              child: FadeSlideIn(
                offset: 12,
                child: Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: c.card,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: c.border),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x80000000),
                        blurRadius: 60,
                        offset: Offset(0, 20),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.title,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.36,
                                    color: c.ink,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.subtitle,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: c.secondary2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: widget.onCancel,
                            child: Icon(
                              LucideIcons.x,
                              size: 18,
                              color: c.muted,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 8),
                        child: Text(
                          widget.fieldLabel,
                          style: AppTheme.mono(
                            color: c.muted,
                            fontSize: 10.5,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),
                      TextField(
                        controller: _controller,
                        autofocus: true,
                        onChanged: widget.onChanged,
                        onSubmitted: (_) {
                          if (widget.valid) widget.onCreate();
                        },
                        style: TextStyle(fontSize: 14.5, color: c.bodyStrong),
                        decoration: InputDecoration(
                          hintText: widget.hint,
                          hintStyle: TextStyle(color: c.muted),
                          filled: true,
                          fillColor: c.panel,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 13,
                            horizontal: 15,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: c.border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: c.border),
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      Row(
                        children: [
                          _cancelBtn(c, widget.onCancel),
                          const Spacer(),
                          _createBtn(c, widget.valid, widget.onCreate),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _cancelBtn(BayaanColors c, VoidCallback onTap) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(10),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
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
  );

  Widget _createBtn(BayaanColors c, bool valid, VoidCallback onTap) => InkWell(
    onTap: valid ? onTap : null,
    borderRadius: BorderRadius.circular(10),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 22),
      decoration: BoxDecoration(
        color: valid ? BayaanBrand.blue : c.borderStrong,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text(
        'Create',
        style: TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    ),
  );
}

/// New folder modal.
class NewFolderModal extends StatelessWidget {
  const NewFolderModal({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    return _CreateDialog(
      title: 'New folder',
      subtitle: 'Group related chats together.',
      fieldLabel: 'NAME',
      hint: 'e.g. Labour & income',
      value: s.newFolderName,
      valid: s.newFolderValid,
      onChanged: s.onNewFolderName,
      onCancel: s.closeNewFolder,
      onCreate: s.createFolder,
    );
  }
}

/// New notebook modal.
class NewNotebookModal extends StatelessWidget {
  const NewNotebookModal({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    return _CreateDialog(
      title: 'New notebook',
      subtitle: 'Give your notebook a name. You can rename it later.',
      fieldLabel: 'TITLE',
      hint: 'e.g. Q3 research notes',
      value: s.newNbTitle,
      valid: s.newNbTitle.trim().isNotEmpty,
      onChanged: s.onNewNbTitle,
      onCancel: s.closeNewNb,
      onCreate: s.createNotebook,
    );
  }
}

/// A success toast shown near the top of the frame.
class AppToast extends StatelessWidget {
  const AppToast({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final c = context.colors;
    if (s.toast.isEmpty) return const SizedBox.shrink();
    return Positioned(
      top: 64,
      left: 0,
      right: 0,
      child: IgnorePointer(
        child: Center(
          child: FadeSlideIn(
            offset: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 16),
              decoration: BoxDecoration(
                color: c.card,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: c.border),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x73000000),
                    blurRadius: 28,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: c.green,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      LucideIcons.check,
                      size: 10,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 9),
                  Text(
                    s.toast,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: c.ink,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
