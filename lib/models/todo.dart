class Todo{
  final int id;
  final String title;
  final String created_at;
  final String? updated_at;

  Todo({
    required this.id,
    required this.title,
    required this.created_at,
    this.updated_at,
  });

  factory Todo.fromSqfliteDatabase(Map<String,dynamic> map) => Todo(
    id: map['id']?.toInt() ?? 0,
    title: map['title']??'',
    created_at: DateTime.fromMillisecondsSinceEpoch(map['created_at']).toIso8601String(),
    updated_at: map['updated_at'] == null?null: DateTime.fromMillisecondsSinceEpoch(map['created_at']).toIso8601String()
  );
}