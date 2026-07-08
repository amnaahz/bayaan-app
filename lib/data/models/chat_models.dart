import 'package:bayaan/data/models/answer_models.dart';

enum MessageRole { user, bot }

/// Lifecycle of a bot message as it streams in.
enum MessagePhase { thinking, streaming, done }

enum MessageVote { up, down }

/// A message in the main chat transcript.
class ChatMessage {
  ChatMessage({
    required this.id,
    required this.role,
    this.text = '',
    this.fullText = '',
    this.phase = MessagePhase.done,
    this.shownWords = 0,
    this.thinkingLabel = '',
    this.chartTitle = '',
    this.chartUnit = '',
    this.bars = const [],
    this.stats = const [],
    this.sources = '',
    this.followups = const [],
    this.vote,
    this.answerKey,
  });

  final int id;
  final MessageRole role;

  /// User message text.
  final String text;

  /// Full bot answer text (revealed progressively via [shownWords]).
  final String fullText;
  MessagePhase phase;
  int shownWords;
  final String thinkingLabel;
  final String chartTitle;
  final String chartUnit;
  final List<ChartBar> bars;
  final List<StatCard> stats;
  final String sources;
  final List<String> followups;
  MessageVote? vote;

  /// The answer key this bot message was generated from (for regenerate).
  final String? answerKey;

  bool get isUser => role == MessageRole.user;
  bool get isBot => role == MessageRole.bot;

  /// The words revealed so far (during streaming), or the full text when done.
  String get shownText {
    if (role == MessageRole.user) return text;
    final words = fullText.split(' ');
    return words.take(shownWords).join(' ');
  }
}

/// Grouping label for a chat in the drawer history.
enum ChatGroup {
  today('Today'),
  previous7('Previous 7 days');

  const ChatGroup(this.label);
  final String label;
}

/// A saved conversation shown in the navigation drawer.
class ChatThread {
  ChatThread({
    required this.id,
    required this.title,
    required this.group,
    this.pinned = false,
    this.folderId,
  });

  final int id;
  String title;
  final ChatGroup group;
  bool pinned;
  String? folderId;
}

/// A folder that groups chats in the drawer.
class ChatFolder {
  ChatFolder({
    required this.id,
    required this.name,
    this.open = false,
  });

  final String id;
  String name;
  bool open;
}
