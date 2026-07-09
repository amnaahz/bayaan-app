/// Accent tone for an agent tile / avatar, mapped to theme colors by the UI.
enum AgentTone { blue, purple, green, amber }

/// A specialised assistant ("Agent") grounded in official SCAD statistics.
///
/// Mirrors the design's agent object: a coloured monogram tile, a short tag
/// used in lists, a longer profile description, capability chips and
/// conversation starters shown on the profile screen.
class Agent {
  const Agent({
    required this.id,
    required this.name,
    required this.initials,
    required this.tone,
    required this.tag,
    required this.by,
    required this.description,
    required this.capabilities,
    required this.starters,
    this.featured = false,
    this.private = false,
  });

  final String id;
  final String name;
  final String initials;
  final AgentTone tone;

  /// One-line summary shown in list rows and the slash picker.
  final String tag;

  /// Author label, e.g. `SCAD` or `You`.
  final String by;

  /// Longer description shown on the profile screen.
  final String description;

  /// Capability chips shown on the profile screen.
  final List<String> capabilities;

  /// Conversation starters offered on the profile screen.
  final List<String> starters;

  /// Featured (curated by SCAD) vs created by the user.
  final bool featured;

  /// Private (user-created) agents show a "Private" badge.
  final bool private;
}
