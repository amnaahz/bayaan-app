/// Relative visual weight of a chart bar, mapped to theme colors by the UI.
enum BarTone { faint, mid, strong }

/// Semantic tone for a stat card, mapped to the blue / green token trios.
enum StatTone { blue, green }

/// A single bar in an answer's mini bar-chart.
class ChartBar {
  const ChartBar({
    required this.label,
    required this.heightFactor,
    required this.tone,
  });

  final String label;

  /// 0..1 height relative to the chart area.
  final double heightFactor;
  final BarTone tone;
}

/// A key-figure card shown beneath an answer.
class StatCard {
  const StatCard({
    required this.label,
    required this.value,
    required this.tone,
  });

  final String label;
  final String value;
  final StatTone tone;
}

/// A canned assistant answer with its supporting visualization data.
class Answer {
  const Answer({
    required this.key,
    required this.question,
    required this.thinkingLabel,
    required this.text,
    required this.chartTitle,
    required this.chartUnit,
    required this.bars,
    required this.stats,
    required this.sources,
    required this.followups,
  });

  final String key;
  final String question;
  final String thinkingLabel;
  final String text;
  final String chartTitle;
  final String chartUnit;
  final List<ChartBar> bars;
  final List<StatCard> stats;
  final String sources;
  final List<String> followups;
}
