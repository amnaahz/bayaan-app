/// Source document type shown as a badge in a notebook.
enum SourceKind { txt, pdf, url }

/// Kind of generated library output.
enum OutputKind { report, audio }

/// A notebook (grounded workspace) in the Spaces / Studio view.
class Notebook {
  const Notebook({
    required this.name,
    required this.initials,
    required this.meta,
    required this.outputs,
    required this.hasOutputs,
    required this.accent,
  });

  final String name;
  final String initials;
  final String meta;
  final String outputs;
  final bool hasOutputs;

  /// Whether the tile is highlighted (most-recent / newly created).
  final bool accent;

  Notebook copyWith({
    String? name,
    String? initials,
    String? meta,
    String? outputs,
    bool? hasOutputs,
    bool? accent,
  }) {
    return Notebook(
      name: name ?? this.name,
      initials: initials ?? this.initials,
      meta: meta ?? this.meta,
      outputs: outputs ?? this.outputs,
      hasOutputs: hasOutputs ?? this.hasOutputs,
      accent: accent ?? this.accent,
    );
  }
}

/// A source attached to a notebook.
class NotebookSource {
  NotebookSource({
    required this.kind,
    required this.name,
    required this.meta,
    this.checked = true,
  });

  final SourceKind kind;
  final String name;
  final String meta;
  bool checked;

  String get badge => switch (kind) {
    SourceKind.txt => 'TXT',
    SourceKind.pdf => 'PDF',
    SourceKind.url => 'URL',
  };
}

/// A generated output in a notebook's library (report or audio).
class LibraryItem {
  const LibraryItem({
    required this.kind,
    required this.title,
    required this.meta,
    this.isNew = false,
  });

  final OutputKind kind;
  final String title;
  final String meta;
  final bool isNew;
}

/// A notebook message (simplified chat inside a notebook).
class NotebookMessage {
  NotebookMessage({
    required this.id,
    required this.isUser,
    this.text = '',
    this.thinking = false,
  });

  final int id;
  final bool isUser;
  String text;
  bool thinking;
}

/// In-flight generation state for a report / audio output.
class GenerationState {
  const GenerationState({
    required this.kind,
    required this.title,
    required this.step,
  });

  final OutputKind kind;
  final String title;

  /// 0..2 step index across "Reading sources", "Drafting", "Adding citations".
  final int step;

  GenerationState copyWith({int? step}) => GenerationState(
    kind: kind,
    title: title,
    step: step ?? this.step,
  );
}
