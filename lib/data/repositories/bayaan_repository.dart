import 'package:bayaan/data/mock/mock_answers.dart';
import 'package:bayaan/data/mock/mock_data.dart';
import 'package:bayaan/data/models/answer_models.dart';
import 'package:bayaan/data/models/chat_models.dart';
import 'package:bayaan/data/models/space_models.dart';

/// The single seam between the UI/state layer and the data source.
///
/// Today this is fulfilled by [MockBayaanRepository] (in-memory design data).
/// To connect the real Bayaan backend / Claude integration later, implement
/// this interface with an HTTP client and swap the binding in `main.dart` —
/// no widget or state-machine code needs to change.
abstract interface class BayaanRepository {
  /// Resolve a canned answer by key (`gdp`, `inflation`, ...).
  Future<Answer> fetchAnswer(String key);

  /// Resolve the best answer for a free-text query.
  Future<Answer> fetchAnswerForQuery(String query);

  /// Seed the chat history shown in the drawer.
  Future<List<ChatThread>> fetchChats();

  /// Seed the folders shown in the drawer.
  Future<List<ChatFolder>> fetchFolders();

  /// Seed the notebooks shown in Spaces.
  Future<List<Notebook>> fetchNotebooks();

  /// Sources for a given notebook.
  Future<List<NotebookSource>> fetchNotebookSources(String notebookName);

  /// A grounded answer to a question asked inside a notebook.
  Future<String> fetchNotebookAnswer(String query);
}

/// In-memory implementation backed by the ported design data.
class MockBayaanRepository implements BayaanRepository {
  const MockBayaanRepository();

  @override
  Future<Answer> fetchAnswer(String key) async =>
      kMockAnswers[key] ?? kMockAnswers['gdp']!;

  @override
  Future<Answer> fetchAnswerForQuery(String query) async =>
      fetchAnswer(pickAnswerFor(query));

  @override
  Future<List<ChatThread>> fetchChats() async => defaultChats();

  @override
  Future<List<ChatFolder>> fetchFolders() async => defaultFolders();

  @override
  Future<List<Notebook>> fetchNotebooks() async => defaultNotebooks();

  @override
  Future<List<NotebookSource>> fetchNotebookSources(String notebookName) async {
    if (notebookName == 'Economic Anomalies') {
      return economicAnomaliesSources();
    }
    return [];
  }

  @override
  Future<String> fetchNotebookAnswer(String query) async => kNotebookAnswer;
}
