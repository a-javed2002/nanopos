import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nanopos/controller/cartController.dart';
import 'package:nanopos/views/Home/order.dart';
import 'package:nanopos/views/Auth/login.dart';
import 'package:http/http.dart' as http;
import 'package:nanopos/consts/consts.dart';
import 'package:nanopos/views/StatusScreens/sent_to_kitchen.dart';

class EditOrderScreen extends StatefulWidget {
  final loginUser user;
  final String id;
  final String table;
  final Order order;

  const EditOrderScreen({
    Key? key,
    required this.user,
    required this.id,
    required this.table,
    required this.order,
  }) : super(key: key);

  @override
  State<EditOrderScreen> createState() => _EditOrderScreenState();
}

class _EditOrderScreenState extends State<EditOrderScreen> {
  late Order orderDuplicate;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    orderDuplicate = widget.order;
    print(widget.order.orderItems.length);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    orderDuplicate;
  }

  @override
  Widget build(BuildContext context) {
    // final CartController cartController = Get.put(CartController());
    final CartController cartController = Get.find();
    bool isLoading = false;
    List<Map<String, dynamic>> itemList = [];
    List<Map<String, dynamic>> variationList = [];
    List<Map<String, dynamic>> itemExtrasList = [];

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
                    if (orderDuplicate.orderItems.length > 0) {
                      setState(() {
                        isLoading = true;
                      });
                      if (kDebugMode) {
                        print("Update Order");
                      }

                      int currentTableId = cartController.tableId.value;
                      List<Map<String, dynamic>>? cartItems =
                          cartController.cartMap[currentTableId];
                      // print("cart total items $currentTableId And\n $cartItems");
                      if (orderDuplicate.orderItems == null ||
                          orderDuplicate.orderItems.isEmpty) {
                        print("cart is empty");
                      } else {
                        // Accessing items map directly
                        List<OrderItems> items = orderDuplicate.orderItems;

                        // Constructing the items list dynamically

                        // List<Map<String, dynamic>> variationList = [];
                        double total = 0;
                        for (var item in items) {
                          for (var variation in item.item_variations) {
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
                          for (var itemExtra in item.item_extras) {
                            // Extracting specific fields and creating a new map
                            itemExtrasList.add({
                              'id': itemExtra['id'],
                              'item_id': itemExtra['item_id'],
                              'name': itemExtra['name']
                            });
                          }
                          // print(item['itemExtras']);
                          // print(item['addons']);
                          var x = (item.price).replaceAll("Rs", "");
                          total += (double.parse(x) * item.quantity);
                          itemList.add({
                            "item_id": item.id,
                            "item_price": x,
                            "branch_id": widget.user.bid,
                            "instruction": item.instruction ?? "",
                            "quantity": item.quantity,
                            "discount": 0,
                            "total_price": double.parse(x) * item.quantity,
                            "item_variation_total": double.parse(
                                    (item.item_variation_currency_total)
                                        .replaceAll("Rs", "")) ??
                                0,
                            "item_extra_total": double.parse(
                                    (item.item_extra_currency_total)
                                        .replaceAll("Rs", "")) ??
                                0,
                            "item_variations": variationList,
                            "item_extras": itemExtrasList,
                          });
                        }

                        // var x = {
                        //   "items":
                        //       "[{\"item_variation_total\":0,\"item_extra_total\":0,\"item_variations\":[],\"item_extras\":[]},{\"item_id\":2,\"item_price\":350,\"branch_id\":1,\"instruction\":\"\",\"quantity\":1,\"discount\":0,\"total_price\":350,\"item_variation_total\":0,\"item_extra_total\":0,\"item_variations\":[{\"id\":1,\"item_id\":2,\"item_attribute_id\":\"1\",\"variation_name\":\"Flavours\",\"name\":\"Less Fried Zinger\"}],\"item_extras\":[]}]"
                        // };

                        print(itemList);

                        var data = {
                          "dining_table_id": widget.id,
                          "customer_id": widget.user.id,
                          "status": 4,
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

                          updateStatus(
                              orderId: orderDuplicate.id,
                              CurrentStatus: orderDuplicate.status,
                              newStatus: 19,
                              inputData: {
                                "id": orderDuplicate.id,
                                "reason":
                                    "Order-${orderDuplicate.id} is edited and new is created",
                                "status": 19
                              });

                          setState(() {
                            cartController.clearCartForTable();
                            cartController.cartQuantityItems.value = 0;
                            isLoading = false;
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrdersScreen(
                                id: widget.id,
                                table: widget.table,
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
                    'Update Order',
                    style: TextStyle(
                        color: whiteColor, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Edit Order-${orderDuplicate.orderSerialNo}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              Text(
                "${orderDuplicate.totalCurrencyPrice}",
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
        body: Obx(() {
          int currentTableId = cartController.tableId.value;
          List<Map<String, dynamic>>? cartItems =
              cartController.cartMap[currentTableId];
          // print("cart total $currentTableId items areee $cartItems");
          if (orderDuplicate.orderItems == null ||
              orderDuplicate.orderItems.isEmpty) {
            return Center(
              child: Text('No items to edit on table $currentTableId.'),
            );
          } else {
            // Accessing items map directly
            return ListView.builder(
              itemCount: orderDuplicate.orderItems.length,
              itemBuilder: (context, index) {
                final item = orderDuplicate.orderItems[index];
                final cartObject = CartObject(
                    itemId: item.id,
                    name: item.itemName,
                    desc: "",
                    image: item.itemImage,
                    price: item.price,
                    qty: item.quantity,
                    addons: [],
                    itemExtras: [],
                    itemVariations: [],
                    instruction: item.instruction ?? "");

                // print(item);

                return Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.startToEnd,
                    background: Container(
                      color: redColor,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Icon(
                        Icons.delete,
                        color: whiteColor,
                      ),
                    ),
                    onDismissed: (direction) {
                      setState(() {
                        // Extracting the ID of the cartObject
                        final itemIdToRemove = cartObject.itemId;

                        // Remove the item from the orderItems list based on its ID
                        orderDuplicate.orderItems
                            .removeWhere((item) => item.id == itemIdToRemove);
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
                                  // cartController.decreaseQty(cartObject);
                                  var q = cartObject.qty.value;
                                  if (q > 1) {
                                    cartObject.qty.value = q - 1;
                                  }
                                  print(
                                      "Quantity decreeased ${cartObject.qty.value}");
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
                                  // cartController.increaseQty(cartObject);
                                  var q = cartObject.qty.value;
                                  cartObject.qty.value = q + 1;
                                  print(
                                      "Quantity increeased ${cartObject.qty.value}");
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

  void updateStatus(
      {required String orderId,
      required int CurrentStatus,
      required int newStatus,
      required Map<String, dynamic> inputData}) async {
    if (kDebugMode) {
      print("Approve $CurrentStatus");
    }
    // var data = {"id": orderId, "status": newStatus};
    var response = await http.post(
      Uri.parse('$domain/api/admin/table-order/change-status/${orderId}'),
      body: jsonEncode(inputData),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': xApi,
        'Authorization': 'Bearer ${widget.user.token}',
      },
    );
    if (kDebugMode) {
      print(response.statusCode);
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Extract response body
      var responseBody = jsonDecode(response.body);
      if (kDebugMode) {
        print(responseBody);
      }
      if (newStatus == 4) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SentToKitchen(
              user: widget.user,
            ),
          ),
        );
      }
    }
  }
}
