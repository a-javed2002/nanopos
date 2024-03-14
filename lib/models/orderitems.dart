class OrderItems {
  final int oi_id;
  final int order_id_fk;
  final String itemName;
  final String itemImage;
  int quantity;
  final String price;
  final String instruction;
  final String totalConvertPrice;
  final String created_at;
  final String? updated_at;

  OrderItems({
    required this.oi_id,
    required this.order_id_fk,
    required this.itemName,
    required this.itemImage,
    required this.quantity,
    required this.price,
    required this.instruction,
    required this.totalConvertPrice,
    required this.created_at,
    this.updated_at,
  });

  factory OrderItems.fromSqfliteDatabase(Map<String, dynamic> map) => OrderItems(
      oi_id: map['oi_id']?.toInt() ?? 0,
      order_id_fk: map['order_id_fk']?.toInt() ?? 0,
      itemName: map['itemName'] ?? '',
      itemImage: map['itemImage'] ?? '',
      quantity: map['quantity'] ?? '',
      price: map['price'] ?? '',
      instruction: map['instruction'] ?? '',
      totalConvertPrice: map['prtotalConvertPriceice'] ?? '',
      created_at: DateTime.fromMillisecondsSinceEpoch(map['created_at'])
          .toIso8601String(),
      updated_at: map['updated_at'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(map['created_at'])
              .toIso8601String());
}
