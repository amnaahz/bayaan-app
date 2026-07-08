import 'package:bayaan/data/models/answer_models.dart';

/// Canned assistant answers ported from the design (`answers` object).
/// Bar heights are expressed as 0..1 factors (original px value / 60).
const Map<String, Answer> kMockAnswers = {
  'gdp': Answer(
    key: 'gdp',
    question: 'What is the GDP of Abu Dhabi?',
    thinkingLabel: 'querying SCAD national accounts…',
    text:
        "Abu Dhabi's real GDP reached AED 1.18 trillion in 2023, growing 9.3% "
        'year-on-year — the fastest pace since 2011. Non-oil activities now '
        'account for 53.9% of output, led by manufacturing and finance.',
    chartTitle: 'Real GDP by year',
    chartUnit: 'AED trillion',
    bars: [
      ChartBar(label: '2019', heightFactor: 0.50, tone: BarTone.faint),
      ChartBar(label: '2020', heightFactor: 0.43, tone: BarTone.faint),
      ChartBar(label: '2021', heightFactor: 0.57, tone: BarTone.faint),
      ChartBar(label: '2022', heightFactor: 0.80, tone: BarTone.mid),
      ChartBar(label: '2023', heightFactor: 1.00, tone: BarTone.strong),
    ],
    stats: [
      StatCard(label: '2023 GDP', value: 'AED 1.18T', tone: StatTone.blue),
      StatCard(label: 'YoY growth', value: '+9.3%', tone: StatTone.green),
    ],
    sources: 'SCAD, Statistical Yearbook · 6 sources',
    followups: [
      'Which sectors drove the growth?',
      'How does this compare with Dubai?',
      'What is the outlook to 2030?',
    ],
  ),
  'inflation': Answer(
    key: 'inflation',
    question: 'Compare inflation across the Emirates',
    thinkingLabel: 'querying CPI releases…',
    text:
        'Consumer prices in Abu Dhabi rose 1.9% in the year to May 2026, below '
        'the UAE average of 2.4%. Dubai recorded 3.1%, driven mainly by housing '
        'and transport, while the Northern Emirates averaged 2.0%.',
    chartTitle: 'CPI, year to May 2026',
    chartUnit: '% change',
    bars: [
      ChartBar(label: 'AUH', heightFactor: 0.60, tone: BarTone.strong),
      ChartBar(label: 'DXB', heightFactor: 1.00, tone: BarTone.faint),
      ChartBar(label: 'SHJ', heightFactor: 0.70, tone: BarTone.faint),
      ChartBar(label: 'NE', heightFactor: 0.63, tone: BarTone.faint),
    ],
    stats: [
      StatCard(label: 'Abu Dhabi CPI', value: '+1.9%', tone: StatTone.green),
      StatCard(label: 'UAE average', value: '+2.4%', tone: StatTone.blue),
    ],
    sources: 'SCAD, FCSC · 4 sources',
    followups: [
      'What is driving housing costs?',
      'How is the CPI basket weighted?',
    ],
  ),
  'population': Answer(
    key: 'population',
    question: 'How fast is the population growing?',
    thinkingLabel: 'querying population estimates…',
    text:
        "Abu Dhabi's population reached 3.8 million in mid-2025, up 5.4% on the "
        'previous year. Growth was concentrated in Al Ain and the capital '
        'region, with the working-age share rising to 71%.',
    chartTitle: 'Population by year',
    chartUnit: 'millions',
    bars: [
      ChartBar(label: '2021', heightFactor: 0.57, tone: BarTone.faint),
      ChartBar(label: '2022', heightFactor: 0.67, tone: BarTone.faint),
      ChartBar(label: '2023', heightFactor: 0.77, tone: BarTone.faint),
      ChartBar(label: '2024', heightFactor: 0.87, tone: BarTone.mid),
      ChartBar(label: '2025', heightFactor: 1.00, tone: BarTone.strong),
    ],
    stats: [
      StatCard(label: 'Population 2025', value: '3.8M', tone: StatTone.blue),
      StatCard(label: 'Annual growth', value: '+5.4%', tone: StatTone.green),
    ],
    sources: 'SCAD, Population Estimates · 3 sources',
    followups: [
      'How does growth split by nationality?',
      'Is the working-age share still rising?',
    ],
  ),
  'tourism': Answer(
    key: 'tourism',
    question: 'How did tourism revenue change last quarter?',
    thinkingLabel: 'querying tourism statistics…',
    text:
        'Tourism revenue reached AED 12.4 billion in Q1 2026, up 14% on last '
        'year. Hotel occupancy averaged 78%, the strongest opening quarter on '
        'record, with international guests up 19%.',
    chartTitle: 'Tourism revenue by quarter',
    chartUnit: 'AED billion',
    bars: [
      ChartBar(label: 'Q2 25', heightFactor: 0.60, tone: BarTone.faint),
      ChartBar(label: 'Q3 25', heightFactor: 0.70, tone: BarTone.faint),
      ChartBar(label: 'Q4 25', heightFactor: 0.83, tone: BarTone.mid),
      ChartBar(label: 'Q1 26', heightFactor: 1.00, tone: BarTone.strong),
    ],
    stats: [
      StatCard(label: 'Q1 revenue', value: 'AED 12.4B', tone: StatTone.blue),
      StatCard(label: 'YoY growth', value: '+14%', tone: StatTone.green),
    ],
    sources: 'SCAD, DCT Abu Dhabi · 4 sources',
    followups: [
      'Which areas have the highest occupancy?',
      'Where do most visitors come from?',
    ],
  ),
  'trade': Answer(
    key: 'trade',
    question: 'How did non-oil trade perform in 2025?',
    thinkingLabel: 'querying foreign trade tables…',
    text:
        'Non-oil foreign trade reached AED 312 billion in 2025, up 8.1% on '
        '2024. Exports led the expansion at +11.4%, with machinery and base '
        'metals the largest contributors.',
    chartTitle: 'Non-oil trade by year',
    chartUnit: 'AED billion',
    bars: [
      ChartBar(label: '2022', heightFactor: 0.57, tone: BarTone.faint),
      ChartBar(label: '2023', heightFactor: 0.70, tone: BarTone.faint),
      ChartBar(label: '2024', heightFactor: 0.83, tone: BarTone.mid),
      ChartBar(label: '2025', heightFactor: 1.00, tone: BarTone.strong),
    ],
    stats: [
      StatCard(label: 'Non-oil trade', value: 'AED 312B', tone: StatTone.blue),
      StatCard(label: 'Export growth', value: '+11.4%', tone: StatTone.green),
    ],
    sources: 'SCAD, Foreign Trade · 5 sources',
    followups: [
      'Who are the top trading partners?',
      'What does the import mix look like?',
    ],
  ),
};

/// Picks the best canned answer for a free-text query
/// (ports `pickAnswerFor`).
String pickAnswerFor(String text) {
  final t = text.toLowerCase();
  if (t.contains('gdp') || t.contains('sector') || t.contains('econom')) {
    return 'gdp';
  }
  if (t.contains('inflat') ||
      t.contains('cpi') ||
      t.contains('price') ||
      t.contains('housing')) {
    return 'inflation';
  }
  if (t.contains('popul') ||
      t.contains('nationality') ||
      t.contains('working')) {
    return 'population';
  }
  return 'trade';
}
