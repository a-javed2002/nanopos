import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nanopos/controller/cartController.dart';
import 'package:nanopos/views/Menu/detail.dart';
import 'package:nanopos/views/Auth/login.dart';
import 'package:nanopos/views/Menu/menu.dart';
import 'package:nanopos/views/StatusScreens/order_placed.dart';
import 'package:http/http.dart' as http;
import 'package:nanopos/consts/consts.dart';

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

    return WillPopScope(
      onWillPop: () async {
        // Navigate to MenuScreen when back button is pressed
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MenuScreen(
                    user: widget.user,
                    id: widget.id,
                    table: widget.table,
                  )),
        );
        return false; // Return false to prevent default back navigation
      },
      child: SafeArea(
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
                          List<Map<String, dynamic>> variationList = [];
                          List<Map<String, dynamic>> itemExtrasList = [];
                          // List<Map<String, dynamic>> variationList = [];
                          double total = 0;
                          for (var item in items) {
                            print(item['addons']);
                            for (var variation in item['itemVariations']) {
                              // Extracting specific fields and creating a new map
                              variationList.add({
                                'id': variation['id'],
                                'item_id': variation['item_id'],
                                'item_attribute_id':
                                    variation['item_attribute_id'],
                                'variation_name': variation['variation_name'],
                                'name': variation['name']
                              });
                            }
                            print("-----------------------");
                            for (var itemExtra in item['itemExtras']) {
                              // Extracting specific fields and creating a new map
                              itemExtrasList.add({
                                'id': itemExtra['id'],
                                'item_id': itemExtra['item_id'],
                                'name': itemExtra['name']
                              });
                            }
                            for (var addon in item['addons']) {
                              // Extracting specific fields and creating a new map
                              itemList.add({
                                'item_id': addon['item_addon_id'],
                                'item_price': addon['addon_item_price'],
                                'branch_id': widget.user.bid,
                                'instruction': '',
                                'quantity': addon['qty'],
                                'discount': 0,
                                'total_price':
                                    double.parse(addon['addon_item_price']) *
                                        addon['qty'],
                                "item_variation_total": 0,
                                "item_extra_total": 0,
                                "item_variations": [],
                                "item_extras": [],
                              });
                            }
                            // print(item['itemExtras']);
                            // print(item['addons']);
                            total +=
                                (double.parse(item['price']) * item['qty']);
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
                              "item_variations": variationList,
                              "item_extras": itemExtrasList,
                            });
                          }

                          var x = {
                            "items":
                                "[{\"item_variation_total\":0,\"item_extra_total\":0,\"item_variations\":[],\"item_extras\":[]},{\"item_id\":2,\"item_price\":350,\"branch_id\":1,\"instruction\":\"\",\"quantity\":1,\"discount\":0,\"total_price\":350,\"item_variation_total\":0,\"item_extra_total\":0,\"item_variations\":[{\"id\":1,\"item_id\":2,\"item_attribute_id\":\"1\",\"variation_name\":\"Flavours\",\"name\":\"Less Fried Zinger\"}],\"item_extras\":[]}]"
                          };

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
                          print(data);

                          var response = await http.post(
                            Uri.parse('$domain/api/table/dining-order'),
                            body: jsonEncode(data),
                            headers: {
                              'Content-Type': 'application/json; charset=UTF-8',
                              'X-Api-Key': xApi,
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
                              cartController.cartQuantityItems.value = 0;
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
                          color: whiteColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
          appBar: AppBar(
            title: Text("Cart"),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MenuScreen(
                            user: widget.user,
                            id: widget.id,
                            table: widget.table,
                          )),
                );
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.red,
              child: Icon(
                Icons.delete,
                color: whiteColor,
              ),
              onPressed: () {
                // cartController.clearCart();
                cartController.clearCartForTable();
              }),
          body: Obx(() {
            int currentTableId = cartController.tableId.value;
            List<Map<String, dynamic>>? cartItems =
                cartController.cartMap[currentTableId];
            // print("cart total $currentTableId items areee $cartItems");
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
                      addons: item['addons'] ?? [],
                      itemExtras: item['itemExtras'] ?? [],
                      itemVariations: item['itemVariations'] ?? [],
                      instruction: item['instruction'] ?? "");

                  print(item);

                  return Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.startToEnd,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Icon(
                          Icons.delete,
                          color: whiteColor,
                        ),
                      ),
                      onDismissed: (direction) {
                        setState(() {
                          cartController.removeItemById(cartObject);
                        });
                      },
                      child: Card(
                        child: ListTile(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => ProductDetail(cart: cartObject,),
                            //   ),
                            // );
                          },
                          title: Text(
                            cartObject.name,
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cartObject.desc,
                                style: TextStyle(fontSize: 12),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Price: ${cartObject.price}',
                                style: TextStyle(fontSize: 12),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Instructions: ${cartObject.instruction}',
                                style: TextStyle(fontSize: 12),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Variations: ${cartObject.itemVariations!.map((v) => v['variation_name']).join(', ')}',
                                style: TextStyle(fontSize: 12),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Extras: ${cartObject.itemExtras!.map((e) => e['name']).join(', ')}',
                                style: TextStyle(fontSize: 12),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Addons: ${cartObject.addons!.map((a) => a['addon_item_name']).join(', ')}',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
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
      ),
    );
  }
}
