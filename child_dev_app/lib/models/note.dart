class NoteEntry {
  final String id;
  final String text;
  final String? mood; // emoji string
  final String authorUid;
  final DateTime createdAt;

  const NoteEntry({
    required this.id,
    required this.text,
    required this.mood,
    required this.authorUid,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'text': text,
    'mood': mood,
    'authorUid': authorUid,
    'createdAt': createdAt.toIso8601String(),
  };

  factory NoteEntry.fromMap(String id, Map<String, dynamic> map) => NoteEntry(
    id: id,
    text: map['text'] ?? '',
    mood: map['mood'],
    authorUid: map['authorUid'] ?? '',
    createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
  );
}
