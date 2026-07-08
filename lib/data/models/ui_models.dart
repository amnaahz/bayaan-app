/// Kind of composer attachment, mapped to an icon + accent tone by the UI.
enum AttachmentKind { camera, photo, file, artifact }

/// A composer attachment chip.
class Attachment {
  const Attachment({
    required this.id,
    required this.kind,
    required this.name,
  });

  final int id;
  final AttachmentKind kind;
  final String name;
}

/// Accent tone for a home-screen conversation starter.
enum StarterTone { blue, purple, green }

/// A conversation starter shown on the home screen.
class Starter {
  const Starter({
    required this.num,
    required this.question,
    required this.tone,
    required this.answerKey,
  });

  final String num;
  final String question;
  final StarterTone tone;
  final String answerKey;
}

/// A key figure that surfaces during a voice conversation.
class VoiceChip {
  const VoiceChip({
    required this.atWord,
    required this.value,
    required this.label,
  });

  /// The word index at which this chip appears in the spoken answer.
  final int atWord;
  final String value;
  final String label;
}
