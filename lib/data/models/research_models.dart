/// Phases of the Deep Research flow.
enum DrPhase { clarify, plan, approval, research, synth, done }

/// A single clarifying question in the Deep Research flow.
class DrQuestion {
  const DrQuestion({
    required this.question,
    required this.options,
    required this.multi,
  });

  final String question;
  final List<String> options;

  /// Whether multiple options may be selected.
  final bool multi;
}

/// A row in the Deep Research report's trend table.
class DrTrendRow {
  const DrTrendRow({
    required this.year,
    required this.rate,
    required this.highlight,
  });

  final String year;
  final String rate;

  /// Whether the value is emphasized (latest / positive).
  final bool highlight;
}
