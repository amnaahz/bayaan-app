part of 'app_state.dart';

/// Navigation drawer behaviour: chat history, folders, rename, pin, move.
extension DrawerController on AppState {
  void openDrawer() {
    drawerOpen = true;
    notify();
  }

  void closeDrawer() {
    drawerOpen = false;
    renamingId = null;
    notify();
  }

  /// Opens a chat from the drawer. As in the design, every history item
  /// re-opens the GDP answer thread.
  void openChatFromDrawer(ChatThread c) {
    if (renamingId == c.id) return;
    drawerOpen = false;
    askKey('gdp');
  }

  // ── Grouping helpers ───────────────────────────────────────────────────────
  List<ChatThread> get pinnedChats => chats.where((c) => c.pinned).toList();
  List<ChatThread> chatsInGroup(ChatGroup g) =>
      chats.where((c) => !c.pinned && c.group == g).toList();

  List<ChatThread> chatsInFolder(String folderId) =>
      chats.where((c) => c.folderId == folderId).toList();

  // ── Folders ────────────────────────────────────────────────────────────────
  void toggleFoldersNav() {
    foldersNavOpen = !foldersNavOpen;
    notify();
  }

  void toggleFolderOpen(String id) {
    for (final f in folders) {
      if (f.id == id) f.open = !f.open;
    }
    notify();
  }

  void openNewFolder({int? pendingChat}) {
    newFolderOpen = true;
    newFolderName = '';
    foldersNavOpen = true;
    _pendingChatForFolder = pendingChat;
    notify();
  }

  void closeNewFolder() {
    newFolderOpen = false;
    notify();
  }

  void onNewFolderName(String v) {
    newFolderName = v;
    notify();
  }

  bool get newFolderValid => newFolderName.trim().isNotEmpty;

  void createFolder() {
    final name = newFolderName.trim();
    if (name.isEmpty) return;
    final id = 'f${DateTime.now().microsecondsSinceEpoch}';
    folders = [...folders, ChatFolder(id: id, name: name, open: true)];
    if (_pendingChatForFolder != null) {
      for (final c in chats) {
        if (c.id == _pendingChatForFolder) c.folderId = id;
      }
    }
    newFolderOpen = false;
    newFolderName = '';
    _pendingChatForFolder = null;
    foldersNavOpen = true;
    notify();
  }

  void moveChatToFolder(int chatId, String folderId) {
    for (final c in chats) {
      if (c.id == chatId) {
        c.folderId = c.folderId == folderId ? null : folderId;
      }
    }
    for (final f in folders) {
      if (f.id == folderId) f.open = true;
    }
    foldersNavOpen = true;
    notify();
  }

  void removeChatFromFolder(int chatId) {
    for (final c in chats) {
      if (c.id == chatId) c.folderId = null;
    }
    notify();
  }

  // ── Chat item actions ─────────────────────────────────────────────────────
  void togglePinChat(int id) {
    for (final c in chats) {
      if (c.id == id) c.pinned = !c.pinned;
    }
    notify();
  }

  void deleteChat(int id) {
    chats = chats.where((c) => c.id != id).toList();
    notify();
  }

  void startRename(int id) {
    final c = chats.firstWhere((x) => x.id == id);
    renamingId = id;
    renameDraft = c.title;
    notify();
  }

  void onRenameDraft(String v) {
    renameDraft = v;
    notify();
  }

  void cancelRename() {
    renamingId = null;
    notify();
  }

  void commitRename() {
    final draftText = renameDraft.trim();
    if (draftText.isNotEmpty) {
      for (final c in chats) {
        if (c.id == renamingId) c.title = draftText;
      }
    }
    renamingId = null;
    notify();
  }
}
