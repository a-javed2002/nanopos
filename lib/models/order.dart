class Order {
  final int order_id;
  final int table_id_fk;
  final String orderSerialNo;
  final String orderDatetime;
  final int status;
  final String totalCurrencyPrice;
  final String statusName;
  final String created_at;
  final String? updated_at;

  Order({
    required this.order_id,
    required this.table_id_fk,
    required this.orderSerialNo,
    required this.status,
    required this.statusName,
    required this.orderDatetime,
    required this.totalCurrencyPrice,
    required this.created_at,
    this.updated_at,
  });

  factory Order.fromSqfliteDatabase(Map<String,dynamic> map) => Order(
    order_id: map['order_id']?.toInt() ?? 0,
    table_id_fk: map['table_id_fk']?.toInt() ?? 0,
    orderSerialNo: map['orderSerialNo']??'',
    status: map['status']??'',
    statusName: map['statusName']??'',
    orderDatetime: map['orderDatetime']??'',
    totalCurrencyPrice: map['totalCurrencyPrice']??'',
    created_at: DateTime.fromMillisecondsSinceEpoch(map['created_at']).toIso8601String(),
    updated_at: map['updated_at'] == null?null: DateTime.fromMillisecondsSinceEpoch(map['created_at']).toIso8601String()
  );
}