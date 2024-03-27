class Item {
  final int item_id;
  final String item_name;
  final String item_price;
  final String item_image;
  final String created_at;
  final String? updated_at;

  Item({
    required this.item_id,
    required this.item_name,
    required this.item_price,
    required this.item_image,
    required this.created_at,
    this.updated_at,
  });

  factory Item.fromSqfliteDatabase(Map<String,dynamic> map) => Item(
    item_id: map['item_id']?.toInt() ?? 0,
    item_name: map['item_name']??'',
    item_price: map['item_price']??'',
    item_image: map['item_image']??'',
    created_at: DateTime.fromMillisecondsSinceEpoch(map['created_at']).toIso8601String(),
    updated_at: map['updated_at'] == null?null: DateTime.fromMillisecondsSinceEpoch(map['created_at']).toIso8601String()
  );
}