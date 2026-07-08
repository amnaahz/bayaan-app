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
