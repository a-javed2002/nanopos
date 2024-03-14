class Table{
  final int table_id;
  final String name;
  final int size;
  final int order;
  final int active;
  final String created_at;
  final String? updated_at;

  Table({
    required this.table_id,
    required this.name,
    required this.size,
    required this.order,
    required this.active,
    required this.created_at,
    this.updated_at,
  });

  factory Table.fromSqfliteDatabase(Map<String,dynamic> map) => Table(
    table_id: map['table_id']?.toInt() ?? 0,
    name: map['name']??'',
    size: map['size']??'',
    order: map['order']??'',
    active: map['active']??'',
    created_at: DateTime.fromMillisecondsSinceEpoch(map['created_at']).toIso8601String(),
    updated_at: map['updated_at'] == null?null: DateTime.fromMillisecondsSinceEpoch(map['created_at']).toIso8601String()
  );
}