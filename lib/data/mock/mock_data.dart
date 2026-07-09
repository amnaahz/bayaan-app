import 'package:bayaan/data/models/agent_models.dart';
import 'package:bayaan/data/models/chat_models.dart';
import 'package:bayaan/data/models/research_models.dart';
import 'package:bayaan/data/models/space_models.dart';
import 'package:bayaan/data/models/ui_models.dart';

/// Rotating tagline shown under the greeting on the home screen.
const List<String> kHomeLines = [
  'The Emirate at a glance.',
  'Official statistics, on demand.',
  'Evidence for every decision.',
];

/// Home conversation starters.
const List<Starter> kStarters = [
  Starter(
    num: '01',
    question: 'What is the GDP of Abu Dhabi?',
    tone: StarterTone.blue,
    answerKey: 'gdp',
  ),
  Starter(
    num: '02',
    question: 'Compare inflation across the Emirates',
    tone: StarterTone.purple,
    answerKey: 'inflation',
  ),
  Starter(
    num: '03',
    question: 'How fast is the population growing?',
    tone: StarterTone.green,
    answerKey: 'population',
  ),
];

List<ChatThread> defaultChats() => [
  ChatThread(id: 1, title: 'Abu Dhabi GDP growth 2023', group: ChatGroup.today),
  ChatThread(
    id: 2,
    title: 'HIES income distribution',
    group: ChatGroup.today,
    folderId: 'f1',
  ),
  ChatThread(
    id: 3,
    title: 'Trade & FDI reports',
    group: ChatGroup.previous7,
    folderId: 'f2',
  ),
  ChatThread(
    id: 4,
    title: 'Population by emirate',
    group: ChatGroup.previous7,
  ),
  ChatThread(
    id: 5,
    title: 'CPI basket weights',
    group: ChatGroup.previous7,
  ),
];

List<ChatFolder> defaultFolders() => [
  ChatFolder(id: 'f1', name: 'Labour & income'),
  ChatFolder(id: 'f2', name: 'Trade briefings'),
];

List<Notebook> defaultNotebooks() => const [
  Notebook(
    name: 'Economic Anomalies',
    initials: 'EA',
    meta: '3 sources · 2h ago',
    outputs: '4 outputs',
    hasOutputs: true,
    accent: true,
  ),
  Notebook(
    name: 'Market Dynamics',
    initials: 'MD',
    meta: '2 sources · 1d ago',
    outputs: '',
    hasOutputs: false,
    accent: false,
  ),
  Notebook(
    name: 'Strategic Priorities',
    initials: 'SP',
    meta: '5 sources · 3d ago',
    outputs: '2 outputs',
    hasOutputs: true,
    accent: false,
  ),
  Notebook(
    name: 'Labor Workforce',
    initials: 'LW',
    meta: '1 source · 5d ago',
    outputs: '',
    hasOutputs: false,
    accent: false,
  ),
  Notebook(
    name: 'Regional Competitiveness',
    initials: 'RC',
    meta: '4 sources · 10d ago',
    outputs: '',
    hasOutputs: false,
    accent: false,
  ),
];

// ── Agents ─────────────────────────────────────────────────────────────────

/// Featured (SCAD-curated) agents followed by the user's own agents.
List<Agent> defaultAgents() => const [
  Agent(
    id: 'gdp',
    name: 'GDP Analyst',
    initials: 'GD',
    tone: AgentTone.blue,
    tag: 'Growth, sectors and non-oil economy',
    by: 'SCAD',
    description:
        'Explains Abu Dhabi output — headline and non-oil GDP, sector '
        'contributions and quarterly momentum — grounded in the latest '
        'national accounts releases.',
    capabilities: ['National accounts', 'Sector breakdowns', 'Charts'],
    starters: [
      'What is the latest non-oil GDP growth?',
      'Which sectors contributed most to growth?',
      'How does Q1 compare to a year ago?',
    ],
    featured: true,
  ),
  Agent(
    id: 'inflation',
    name: 'Inflation Tracker',
    initials: 'IN',
    tone: AgentTone.purple,
    tag: 'CPI, basket weights and cost of living',
    by: 'SCAD',
    description:
        'Tracks consumer prices across the CPI basket, compares emirates and '
        'flags divergences between headline inflation and specific groups '
        'such as housing.',
    capabilities: ['CPI basket', 'Emirate comparison', 'Trends'],
    starters: [
      'What is the current headline CPI?',
      'Compare inflation across the Emirates.',
      'Where are rents diverging from CPI?',
    ],
    featured: true,
  ),
  Agent(
    id: 'population',
    name: 'Population Insights',
    initials: 'PO',
    tone: AgentTone.green,
    tag: 'Demographics, growth and distribution',
    by: 'SCAD',
    description:
        'Answers demographic questions — population size, growth rates, and '
        'breakdowns by age, gender and nationality — from census and '
        'mid-year estimates.',
    capabilities: ['Census', 'Growth rates', 'Breakdowns'],
    starters: [
      'How fast is the population growing?',
      'What is the age structure of Abu Dhabi?',
      'Show the Emirati / expat split.',
    ],
    featured: true,
  ),
  Agent(
    id: 'trade',
    name: 'Trade & Tourism',
    initials: 'TT',
    tone: AgentTone.amber,
    tag: 'Non-oil trade, FDI and visitor economy',
    by: 'SCAD',
    description:
        'Covers non-oil foreign trade, FDI flows and tourism performance — '
        'visitor arrivals, hotel occupancy and revenue — with quarterly '
        'context.',
    capabilities: ['Foreign trade', 'FDI', 'Tourism'],
    starters: [
      'How did tourism revenue change last quarter?',
      'What are the top non-oil exports?',
      'Where is FDI coming from?',
    ],
    featured: true,
  ),
  Agent(
    id: 'labour',
    name: 'Labour Market',
    initials: 'LM',
    tone: AgentTone.blue,
    tag: 'Employment, wages and workforce',
    by: 'SCAD',
    description:
        'Explains labour force participation, unemployment and wage trends '
        'across nationality, gender and sector from the labour force survey.',
    capabilities: ['Labour survey', 'Wages', 'Participation'],
    starters: [
      'What is the latest unemployment rate?',
      'How has participation changed over 5 years?',
      'Compare wages by sector.',
    ],
    featured: true,
  ),
  Agent(
    id: 'explainer',
    name: 'Data Explainer',
    initials: 'DE',
    tone: AgentTone.purple,
    tag: 'Plain-language definitions and methods',
    by: 'SCAD',
    description:
        'Explains statistical concepts, definitions and methodology in plain '
        'language — how indicators are measured and what caveats apply.',
    capabilities: ['Definitions', 'Methodology', 'Caveats'],
    starters: [
      'What is the difference between nominal and real GDP?',
      'How is CPI calculated?',
      'What does "non-oil economy" include?',
    ],
    featured: true,
  ),
  Agent(
    id: 'brief',
    name: 'Ministerial Brief Writer',
    initials: 'MB',
    tone: AgentTone.green,
    tag: 'Turns figures into concise briefing notes',
    by: 'You',
    description:
        'Your custom agent: takes a topic and produces a tight, cited '
        'ministerial briefing note in a consistent house style.',
    capabilities: ['Briefing style', 'Citations', 'Concise'],
    starters: [
      'Draft a brief on Q1 housing inflation.',
      'Summarize labour market trends for the minister.',
      'One-page note on non-oil growth.',
    ],
    private: true,
  ),
];

List<NotebookSource> economicAnomaliesSources() => [
  NotebookSource(
    kind: SourceKind.txt,
    name: 'Q1 Anomaly Notes.txt',
    meta: '14 pages · added 2h ago',
  ),
  NotebookSource(
    kind: SourceKind.pdf,
    name: 'SCAD CPI Bulletin — March 2026.pdf',
    meta: '32 pages · added 1d ago',
  ),
  NotebookSource(
    kind: SourceKind.url,
    name: 'Housing market monitor — district rents',
    meta: 'web page · added 3d ago',
  ),
];

const List<LibraryItem> kBaseLibrary = [
  LibraryItem(
    kind: OutputKind.audio,
    title: 'Q1 Housing Inflation — Audio Brief',
    meta: 'Audio · 9:13 · today',
  ),
  LibraryItem(
    kind: OutputKind.report,
    title: 'Economic Anomalies Briefing Report',
    meta: 'Report · v1 · yesterday',
  ),
  LibraryItem(
    kind: OutputKind.report,
    title: 'Rent–CPI Divergence Notes',
    meta: 'Report · Jun 30',
  ),
];

/// Internal (SCAD) statistical indicators cited behind an answer, shown in the
/// Sources panel.
const List<({String title, String tag})> kInternalSources = [
  (
    title: 'Gross Domestic Product at Current Prices — Annually',
    tag: 'economy',
  ),
  (
    title: 'Gross Domestic Product at Constant Prices — Quarterly',
    tag: 'economy',
  ),
  (title: 'GDP Per Capita at Constant Prices — Annually', tag: 'economy'),
  (
    title: 'Gross Domestic Product at Current Prices — Quarterly',
    tag: 'economy',
  ),
];

/// Web sources cited behind an answer, shown in the Sources panel.
const List<({String fav, String title, String url})> kWebSources = [
  (
    fav: 'W',
    title: 'Emirate of Abu Dhabi — Wikipedia',
    url: 'en.wikipedia.org/wiki/Emirate_of_Abu_Dhabi',
  ),
  (
    fav: 'W',
    title: 'Economy of the United Arab Emirates — Wikipedia',
    url: 'en.wikipedia.org/wiki/Economy_of_the_UAE',
  ),
  (
    fav: 'S',
    title: 'Abu Dhabi’s GDP Expands 7.7% and Non-Oil Economy Grows 7.6%',
    url: 'scad.gov.ae/w/abu-dhabi-s-gdp-expands-7-7',
  ),
  (
    fav: 'U',
    title: 'Abu Dhabi | The Official Platform of the UAE Government',
    url: 'u.ae/en/about-the-uae/the-seven-emirates/abu-dhabi',
  ),
  (
    fav: 'in',
    title: 'Abu Dhabi GDP reaches AED 325.7 billion in Q3 2025',
    url: 'linkedin.com/posts/adstatistics_abudhabi',
  ),
];

const List<String> kNotebookChatStarters = [
  'Why did rents diverge from headline CPI in Q1?',
  'Which districts drive the housing anomaly?',
  'Summarize risks to the affordability targets.',
];

const String kNotebookAnswer =
    'Rents in mid-income districts rose 11.2% year-on-year while headline CPI '
    'held at 2.8% — a divergence concentrated in Khalifa City and Al Reef, and '
    'the main risk to the affordability targets if it persists two more '
    'quarters';

/// Report template definitions (label + description).
const List<(String, String)> kReportTemplates = [
  ('Briefing Doc', 'Key insights and important quotes'),
  ('Study Guide', 'Quiz, essay questions and glossary'),
  ('Business Requirement Doc', 'Stakeholders, constraints, cost–benefit'),
  ('Create your own', 'Define structure, style and tone'),
];

/// Audio format definitions (label + description).
const List<(String, String)> kAudioFormats = [
  ('Deep Dive', 'Two hosts unpack and connect the topics'),
  ('Brief', 'Bite-sized overview of the core ideas'),
  ('Critique', 'Expert review with constructive feedback'),
  ('Debate', 'Two perspectives argued thoughtfully'),
];

const List<String> kGenerationStepLabels = [
  'Reading sources',
  'Drafting',
  'Adding citations',
];

// ── Deep Research ──────────────────────────────────────────────────────────

const List<DrQuestion> kDrQuestions = [
  DrQuestion(
    question: 'What time period should the study cover?',
    options: ['Last year', 'Last 5 years', 'Last 10 years', 'Since 2000'],
    multi: false,
  ),
  DrQuestion(
    question: 'Compare Abu Dhabi to the UAE national average?',
    options: ['Yes, compare to UAE average', 'No, focus on Abu Dhabi only'],
    multi: false,
  ),
  DrQuestion(
    question: 'Which breakdowns should be included?',
    options: [
      'Age group',
      'Gender',
      'Nationality (Emirati / expat)',
      'Education level',
    ],
    multi: true,
  ),
];

const List<String> kDrPlanDefault = [
  'What is the most recently reported unemployment rate in Abu Dhabi?',
  'How has the rate changed annually over the past 10 years?',
  'How does unemployment differ between UAE nationals and expatriates?',
  'What are the rates by gender and major age groups?',
  'How does Abu Dhabi compare to the UAE national average over 5 years?',
  'Which policy initiatives targeted unemployment, and with what impact?',
];

const List<String> kDrStatuses = [
  'querying labour force survey…',
  'classifying — running classification',
  'reading statistical yearbook…',
  'cross-checking census tables…',
  'comparing federal releases…',
  'reviewing programme monitors…',
];

const List<DrTrendRow> kDrTrendRows = [
  DrTrendRow(year: '2019', rate: '6.9%', highlight: false),
  DrTrendRow(year: '2021', rate: '5.5%', highlight: false),
  DrTrendRow(year: '2023', rate: '4.6%', highlight: false),
  DrTrendRow(year: '2025', rate: '3.8%', highlight: true),
];

// ── Voice ──────────────────────────────────────────────────────────────────

const String kVoiceQuestion = 'How did tourism revenue change last quarter?';

const List<VoiceChip> kVoiceChips = [
  VoiceChip(atWord: 6, value: 'AED 12.4B', label: 'Q1 tourism revenue'),
  VoiceChip(atWord: 13, value: '+14%', label: 'vs Q1 2025'),
  VoiceChip(atWord: 20, value: '78%', label: 'hotel occupancy'),
];

/// Simulated dictation phrase used by the composer mic.
const String kDictationPhrase =
    'Show me how non-oil GDP growth compares to last year and which sectors '
    'are driving it';

/// Simulated dictation phrase used inside a notebook.
const String kNotebookDictationPhrase =
    'Summarize the rent and CPI divergence for the housing committee';
