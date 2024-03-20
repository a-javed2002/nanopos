import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nanopos/controller/cartController.dart';
import 'package:nanopos/views/detail.dart';
import 'package:nanopos/views/login.dart';
import 'package:nanopos/views/StatusScreens/order_placed.dart';
import 'package:http/http.dart' as http;

class CartScreen extends StatefulWidget {
  final loginUser user;
  final String id;
  final String table;

  const CartScreen({
    Key? key,
    required this.user,
    required this.id,
    required this.table,
  }) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    // final CartController cartController = Get.put(CartController());
    final CartController cartController = Get.find();
    bool isLoading = false;

    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: isLoading
            ? Container()
            : Container(
                color: const Color(0xffa14716),
                width: double.infinity,
                height: 50.0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffa14716),
                  ),
                  onPressed: () async {
                    if (cartController.cartQuantityItems.value > 0) {
                      setState(() {
                        isLoading = true;
                      });
                      if (kDebugMode) {
                        print("Place Order");
                      }

                      int currentTableId = cartController.tableId.value;
                      List<Map<String, dynamic>>? cartItems =
                          cartController.cartMap[currentTableId];
                      // print("cart total items $currentTableId And\n $cartItems");
                      if (cartItems == null || cartItems.isEmpty) {
                        print("cart is empty");
                      } else {
                        // Accessing items map directly
                        List<dynamic> items = cartItems[0]['items'];

                        // Constructing the items list dynamically
                        List<Map<String, dynamic>> itemList = [];
                        double total = 0;
                        for (var item in items) {
                          total+=(double.parse(item['price']) * item['qty']);
                          itemList.add({
                            "item_id": item['itemId'],
                            "item_price": item['price'],
                            "branch_id": widget.user.bid,
                            "instruction": item['instruction'] ?? "",
                            "quantity": item['qty'],
                            "discount": item['discount'] ?? 0,
                            "total_price":
                                double.parse(item['price']) * item['qty'],
                            "item_variation_total":
                                item['itemVariationTotal'] ?? 0,
                            "item_extra_total": item['itemExtraTotal'] ?? 0,
                            "item_variations": item['itemVariations'] ?? [],
                            "item_extras": item['itemExtras'] ?? [],
                          });
                        }

                        print(itemList);

                        var data = {
                          "dining_table_id": widget.id,
                          "customer_id": widget.user.id,
                          "branch_id": widget.user.bid,
                          "subtotal": total,
                          "discount": 0,
                          "delivery_charge": 0,
                          "address_id": null,
                          "delivery_time": null,
                          "is_advance_order": 10,
                          "items": jsonEncode(itemList),
                          "order_type": 20,
                          "source": 5,
                          "total": total,
                        };
                        var response = await http.post(
                          Uri.parse(
                              'https://restaurant.nanosystems.com.pk/api/table/dining-order'),
                          body: jsonEncode(data),
                          headers: {
                            'Content-Type': 'application/json; charset=UTF-8',
                            'X-Api-Key':
                                'b6d68vy2-m7g5-20r0-5275-h103w73453q120',
                            'Authorization': 'Bearer ${widget.user.token}',
                          },
                        );
                        if (kDebugMode) {
                          print(response.statusCode);
                        }

                        if (response.statusCode == 200 ||
                            response.statusCode == 201) {
                          // Extract response body
                          var responseBody = jsonDecode(response.body);
                          if (kDebugMode) {
                            print(responseBody);
                          }
                          setState(() {
                            cartController.clearCartForTable();
                            isLoading = false;
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderPlaced(
                                user: widget.user,
                              ),
                            ),
                          );
                        } else {
                          print("order Not Placed......");
                          setState(() {
                            isLoading = false;
                          });
                        }
                      }
                    }
                    setState(() {
                      isLoading = false;
                    });
                  },
                  child: const Text(
                    'Place Order',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
        appBar: AppBar(
          title: Text("Cart"),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
            onPressed: () {
              // cartController.clearCart();
              cartController.clearCartForTable();
            }),
        body: Obx(() {
          int currentTableId = cartController.tableId.value;
          List<Map<String, dynamic>>? cartItems =
              cartController.cartMap[currentTableId];
          print("cart total $currentTableId items areee $cartItems");
          if (cartItems == null || cartItems.isEmpty) {
            return Center(
              child: Text('No items in the cart for table $currentTableId.'),
            );
          } else {
            // Accessing items map directly
            List<dynamic> items = cartItems[0]['items'];
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final cartObject = CartObject(
                  itemId: item['itemId'],
                  name: item['name'],
                  desc: item['desc'],
                  image: item['image'],
                  price: item['price'],
                  qty: item['qty'],
                );

                return Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.startToEnd,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    onDismissed: (direction) {
                      setState(() {
                        cartController.removeItemById(cartObject.itemId);
                      });
                    },
                    child: Card(
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetail(),
                            ),
                          );
                        },
                        title: Text(
                          cartObject.name,
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          cartObject.price,
                          style: TextStyle(fontSize: 10),
                        ),
                        leading: Image.network(
                          cartObject.image,
                          width: 60,
                          height: 60,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  cartController.decreaseQty(cartObject);
                                });
                              },
                            ),
                            Text(
                              cartObject.qty.toString(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  cartController.increaseQty(cartObject);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ));
              },
            );
          }
        }),
      ),
    );
  }
}
