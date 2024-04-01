class Item {
  final int item_id;
  final int cat_id_fk;
  final String item_name;
  final String description;
  final String item_price;
  final String cover;
  final String thumb;
  final String preview;
  final String created_at;
  final String? updated_at;

  Item({
    required this.item_id,
    required this.cat_id_fk,
    required this.item_name,
    required this.description,
    required this.item_price,
    required this.cover,
    required this.thumb,
    required this.preview,
    required this.created_at,
    this.updated_at,
  });

  factory Item.fromSqfliteDatabase(Map<String,dynamic> map) => Item(
    item_id: map['item_id']?.toInt() ?? 0,
    cat_id_fk: map['cat_id_fk']?.toInt() ?? 0,
    item_name: map['item_name']??'',
    description: map['description']??'',
    item_price: map['item_price']??'',
    cover: map['cover']??'',
    thumb: map['thumb']??'',
    preview: map['preview']??'',
    created_at: DateTime.fromMillisecondsSinceEpoch(map['created_at']).toIso8601String(),
    updated_at: map['updated_at'] == null?null: DateTime.fromMillisecondsSinceEpoch(map['created_at']).toIso8601String()
  );
}