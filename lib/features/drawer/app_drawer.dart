import 'package:bayaan/core/icons/lucide_icons.dart';
import 'package:bayaan/core/theme/app_theme.dart';
import 'package:bayaan/core/theme/bayaan_colors.dart';
import 'package:bayaan/core/theme/theme_x.dart';
import 'package:bayaan/core/widgets/bayaan_logo.dart';
import 'package:bayaan/data/models/chat_models.dart';
import 'package:bayaan/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Sliding navigation drawer: brand, search, new chat, nav destinations,
/// folders, chat history (pinned + grouped) and profile footer.
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final open = s.drawerOpen;
    final width = MediaQuery.sizeOf(context).width;
    final panelWidth = width < 360 ? width * 0.86 : 320.0;

    return Stack(
      children: [
        IgnorePointer(
          ignoring: !open,
          child: GestureDetector(
            onTap: s.closeDrawer,
            child: AnimatedOpacity(
              opacity: open ? 1 : 0,
              duration: const Duration(milliseconds: 250),
              child: Container(color: const Color(0x99000000)),
            ),
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
          left: open ? 0 : -panelWidth - 8,
          top: 0,
          bottom: 0,
          width: panelWidth,
          child: _Panel(s: s),
        ),
      ],
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.s});
  final AppState s;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Material(
      color: c.card,
      elevation: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 58, 20, 14),
            child: Row(
              children: [
                const BayaanLogo(size: 30, borderRadius: 7),
                const SizedBox(width: 11),
                Text(
                  'Bayaan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: c.textMax,
                  ),
                ),
              ],
            ),
          ),
          _searchBox(c),
          _newChatButton(c),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _navItems(context, c),
                Container(
                  height: 1,
                  color: c.borderStrong,
                  margin: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                ),
                _history(context, c),
              ],
            ),
          ),
          _footer(context, c),
        ],
      ),
    );
  }

  Widget _searchBox(BayaanColors c) => Container(
    margin: const EdgeInsets.fromLTRB(20, 6, 20, 4),
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 13),
    decoration: BoxDecoration(
      color: c.fill,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Icon(LucideIcons.search, size: 17, color: c.muted),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            'Search conversations',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 14, color: c.muted),
          ),
        ),
      ],
    ),
  );

  Widget _newChatButton(BayaanColors c) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
    child: InkWell(
      onTap: s.newChat,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: BayaanBrand.blue,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.plus, size: 17, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'New Chat',
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
  );

  Widget _navItems(BuildContext context, BayaanColors c) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _navRow(
            c,
            LucideIcons.messageSquare,
            'Chat',
            active: s.isChatNav,
            onTap: s.newChat,
          ),
          _foldersNav(context, c),
          _navRow(
            c,
            LucideIcons.sparkles,
            'Agents',
            active: s.isAgentsNav,
            onTap: s.goAgents,
            badge: 'GPT',
          ),
          _navRow(
            c,
            LucideIcons.layoutGrid,
            'Spaces',
            active: s.isSpacesNav,
            onTap: s.goSpaces,
          ),
          _navRow(
            c,
            LucideIcons.fileText,
            'Artifacts',
            active: s.isArtifactsNav,
            onTap: s.goArtifacts,
          ),
        ],
      ),
    );
  }

  Widget _navRow(
    BayaanColors c,
    IconData icon,
    String label, {
    required bool active,
    required VoidCallback onTap,
    String? badge,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: active ? c.fill : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: active ? c.ink : c.secondary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                  color: active ? c.ink : c.secondary,
                ),
              ),
            ),
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 7),
                decoration: BoxDecoration(
                  color: c.blueTint,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  badge,
                  style: AppTheme.mono(
                    color: c.link,
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _foldersNav(BuildContext context, BayaanColors c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: s.toggleFoldersNav,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            child: Row(
              children: [
                Icon(LucideIcons.folder, size: 18, color: c.secondary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Folders',
                    style: TextStyle(fontSize: 14, color: c.secondary),
                  ),
                ),
                AnimatedRotation(
                  turns: s.foldersNavOpen ? 0.5 : 0,
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
        if (s.foldersNavOpen) ...[
          for (final f in s.folders) _folderRow(context, c, f),
          InkWell(
            onTap: s.openNewFolder,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 8, 12, 8),
              child: Row(
                children: [
                  Icon(LucideIcons.plus, size: 14, color: c.muted),
                  const SizedBox(width: 9),
                  Text(
                    'New folder',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: c.muted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _folderRow(BuildContext context, BayaanColors c, ChatFolder f) {
    final chats = s.chatsInFolder(f.id);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => s.toggleFolderOpen(f.id),
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 8, 12, 8),
            child: Row(
              children: [
                AnimatedRotation(
                  turns: f.open ? 0.25 : 0,
                  duration: const Duration(milliseconds: 180),
                  child: Icon(
                    LucideIcons.chevronRight,
                    size: 13,
                    color: c.faint,
                  ),
                ),
                const SizedBox(width: 9),
                Icon(LucideIcons.folder, size: 15, color: c.link),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    f.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13.5, color: c.body),
                  ),
                ),
                Text(
                  '${chats.length}',
                  style: TextStyle(fontSize: 10.5, color: c.muted),
                ),
              ],
            ),
          ),
        ),
        if (f.open)
          if (chats.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(43, 6, 12, 6),
              child: Text(
                'Empty — use ⋯ on a chat to add',
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: c.faint,
                ),
              ),
            )
          else
            for (final ch in chats)
              InkWell(
                onTap: () => s.openChatFromDrawer(ch),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(43, 6, 12, 6),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          ch.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 13, color: c.secondary),
                        ),
                      ),
                      InkWell(
                        onTap: () => s.removeChatFromFolder(ch.id),
                        child: Icon(LucideIcons.x, size: 12, color: c.faint),
                      ),
                    ],
                  ),
                ),
              ),
      ],
    );
  }

  Widget _history(BuildContext context, BayaanColors c) {
    final pinned = s.pinnedChats;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (pinned.isNotEmpty) ...[
            _groupHeader(c, 'PINNED'),
            for (final ch in pinned) _ChatRow(chat: ch),
          ],
          for (final g in ChatGroup.values)
            if (s.chatsInGroup(g).isNotEmpty) ...[
              _groupHeader(c, g.label.toUpperCase()),
              for (final ch in s.chatsInGroup(g)) _ChatRow(chat: ch),
            ],
        ],
      ),
    );
  }

  Widget _groupHeader(BayaanColors c, String label) => Padding(
    padding: const EdgeInsets.only(top: 14, bottom: 6),
    child: Text(
      label,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.6,
        color: c.muted,
      ),
    ),
  );

  Widget _footer(BuildContext context, BayaanColors c) {
    return InkWell(
      onTap: s.goSettings,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: c.borderStrong)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 17,
              backgroundColor: BayaanBrand.purple,
              child: Text(
                s.userInitials,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.userName,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: c.bodyStrong,
                    ),
                  ),
                  Text(
                    'SCAD · Analyst',
                    style: TextStyle(fontSize: 11.5, color: c.muted),
                  ),
                ],
              ),
            ),
            Icon(LucideIcons.settings, size: 18, color: c.muted),
          ],
        ),
      ),
    );
  }
}

class _ChatRow extends StatefulWidget {
  const _ChatRow({required this.chat});
  final ChatThread chat;

  @override
  State<_ChatRow> createState() => _ChatRowState();
}

class _ChatRowState extends State<_ChatRow> {
  final _renameController = TextEditingController();
  final GlobalKey<State<StatefulWidget>> _menuKey = GlobalKey();

  @override
  void dispose() {
    _renameController.dispose();
    super.dispose();
  }

  Future<void> _openMenu(AppState s, BayaanColors c) async {
    final box = _menuKey.currentContext!.findRenderObject()! as RenderBox;
    final overlay =
        Overlay.of(context).context.findRenderObject()! as RenderBox;
    final pos = RelativeRect.fromRect(
      Rect.fromPoints(
        box.localToGlobal(box.size.bottomLeft(Offset.zero), ancestor: overlay),
        box.localToGlobal(box.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
    final chat = widget.chat;
    final result = await showMenu<String>(
      context: context,
      position: pos,
      color: c.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: c.border),
      ),
      items: [
        _item('rename', LucideIcons.pencil, 'Rename', c),
        _item('pin', LucideIcons.pin, chat.pinned ? 'Unpin' : 'Pin', c),
        const PopupMenuDivider(),
        for (final f in s.folders)
          _item(
            'folder:${f.id}',
            LucideIcons.folder,
            f.name,
            c,
            trailing: chat.folderId == f.id,
          ),
        _item('newfolder', LucideIcons.plus, 'New folder…', c, color: c.link),
        const PopupMenuDivider(),
        _item('delete', LucideIcons.trash2, 'Delete chat', c, color: c.red),
      ],
    );
    if (result == null) return;
    if (result == 'rename') {
      s.startRename(chat.id);
    } else if (result == 'pin') {
      s.togglePinChat(chat.id);
    } else if (result == 'newfolder') {
      s.openNewFolder(pendingChat: chat.id);
    } else if (result == 'delete') {
      s.deleteChat(chat.id);
    } else if (result.startsWith('folder:')) {
      s.moveChatToFolder(chat.id, result.substring(7));
    }
  }

  PopupMenuItem<String> _item(
    String value,
    IconData icon,
    String label,
    BayaanColors c, {
    Color? color,
    bool trailing = false,
  }) {
    return PopupMenuItem<String>(
      value: value,
      height: 40,
      child: Row(
        children: [
          Icon(icon, size: 15, color: color ?? c.secondary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 13.5, color: color ?? c.bodyStrong),
            ),
          ),
          if (trailing) Icon(LucideIcons.check, size: 12, color: c.link),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final c = context.colors;
    final chat = widget.chat;
    final renaming = s.renamingId == chat.id;

    if (renaming && _renameController.text != s.renameDraft) {
      _renameController.text = s.renameDraft;
    }

    return InkWell(
      onTap: renaming ? null : () => s.openChatFromDrawer(chat),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(
          children: [
            if (chat.pinned) ...[
              Icon(LucideIcons.pin, size: 13, color: c.muted),
              const SizedBox(width: 6),
            ],
            Expanded(
              child: renaming
                  ? TextField(
                      controller: _renameController,
                      autofocus: true,
                      onChanged: s.onRenameDraft,
                      onSubmitted: (_) => s.commitRename(),
                      onEditingComplete: s.commitRename,
                      style: TextStyle(fontSize: 14, color: c.ink),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        filled: true,
                        fillColor: c.fill,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: BorderSide(color: c.blueHoverBd),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: BorderSide(color: c.blueHoverBd),
                        ),
                      ),
                    )
                  : Text(
                      chat.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14, color: c.body),
                    ),
            ),
            InkWell(
              key: _menuKey,
              onTap: () => _openMenu(s, c),
              borderRadius: BorderRadius.circular(7),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  LucideIcons.moreHorizontal,
                  size: 15,
                  color: c.faint,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
