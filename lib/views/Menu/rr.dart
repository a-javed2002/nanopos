import 'package:flutter/foundation.dart';

void main() {
  Map<String, dynamic> requestBody = {
    "dining_table_id": 22,
    "customer_id": 2,
    "branch_id": 1,
    "subtotal": 211,
    "discount": 0,
    "delivery_charge": 0,
    // Add other fields here
    "items":
        '[{"item_id":7,"item_price":95,"branch_id":1,"instruction":"no thing","quantity":2,"discount":0,"total_price":190,"item_variation_total":0,"item_extra_total":0,"item_variations":[],"item_extras":[]},{"item_id":28,"item_price":3,"branch_id":1,"instruction":"no thing","quantity":1,"discount":0,"total_price":16,"item_variation_total":9,"item_extra_total":4,"item_variations":[{"id":17,"item_id":28,"item_attribute_id":"1","variation_name":"Appearence","name":"Dutch baby small"},{"id":16,"item_id":28,"item_attribute_id":"3","variation_name":"Organic","name":"Organic baby"},{"id":14,"item_id":28,"item_attribute_id":"4","variation_name":"Flavours","name":"less spicy"}],"item_extras":[{"id":7,"item_id":28,"name":"with cheese"},{"id":8,"item_id":28,"name":"smoked"}]},{"item_id":3,"item_price":5,"branch_id":1,"instruction":"","quantity":1,"discount":0,"total_price":5,"item_variation_total":0,"item_extra_total":0,"item_variations":[],"item_extras":[]}]',
    "order_type": 20,
    "source": 5,
    "total": "211.00"
  };

  if (kDebugMode) {
    print(requestBody);
  }
}
