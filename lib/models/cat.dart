class Cat{
  final int cat_id;
  final String cat_name;
  final String created_at;
  final String? updated_at;

  Cat({
    required this.cat_id,
    required this.cat_name,
    required this.created_at,
    this.updated_at,
  });

  factory Cat.fromSqfliteDatabase(Map<String,dynamic> map) => Cat(
    cat_id: map['cat_id']?.toInt() ?? 0,
    cat_name: map['cat_name']??'',
    created_at: DateTime.fromMillisecondsSinceEpoch(map['created_at']).toIso8601String(),
    updated_at: map['updated_at'] == null?null: DateTime.fromMillisecondsSinceEpoch(map['created_at']).toIso8601String()
  );
}