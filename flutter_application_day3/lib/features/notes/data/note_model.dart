class Note {
  final int? id;
  final String title;
  final String content;
  final DateTime createdAt;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        // Don't include id - Sembast auto-generates it
        'title': title,
        'content': content,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Note.fromMap(Map<String, dynamic> map) => Note(
        id: map['id'] as int?,
        title: map['title'] as String,
        content: map['content'] as String,
        createdAt: DateTime.parse(map['createdAt'] as String),
      );
}