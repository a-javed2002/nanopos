import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nanopos/controller/auth_controller.dart';
import 'package:nanopos/views/Home/editOrder.dart';
import 'package:nanopos/views/StatusScreens/sent_to_kitchen.dart';
import 'dart:convert';

import 'package:nanopos/views/Auth/login.dart';
import 'package:nanopos/views/Cashier/cashier.dart';
import 'package:nanopos/views/Menu/menu.dart';
import 'package:nanopos/consts/consts.dart';

class Order {
  final String id;
  final String orderSerialNo;
  final String orderDatetime;
  final int status;
  final String totalCurrencyPrice;
  final List<OrderItems> orderItems; // Change type to dynamic
  final String statusName;
  final String subtotal_currency_price;
  final String subtotal_without_tax_currency_price;
  final String discount_currency_price;
  final String total_currency_price;
  final String totalTaxCurrencyPrice;

  Order({
    required this.id,
    required this.orderSerialNo,
    required this.status,
    required this.statusName,
    required this.orderDatetime,
    required this.totalCurrencyPrice,
    required this.orderItems,
    required this.subtotal_currency_price,
    required this.subtotal_without_tax_currency_price,
    required this.discount_currency_price,
    required this.total_currency_price,
    required this.totalTaxCurrencyPrice,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'].toString(),
      orderSerialNo: json['order_serial_no'].toString(),
      statusName: json['status_name'].toString(),
      orderDatetime: json['order_datetime'].toString(),
      status: json['status'],
      totalCurrencyPrice: json['total_currency_price'].toString(),
      orderItems: json['orderItems'],
      subtotal_currency_price: json['subtotal_currency_price'].toString(),
      subtotal_without_tax_currency_price:
          json['subtotal_without_tax_currency_price'].toString(),
      discount_currency_price: json['discount_currency_price'].toString(),
      total_currency_price: json['total_currency_price'].toString(),
      totalTaxCurrencyPrice: json['total_tax_currency_price'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> itemsJson =
        orderItems.map((item) => item.toJson()).toList();

    return {
      'id': id,
      'order_serial_no': orderSerialNo,
      'status_name': statusName,
      'order_datetime': orderDatetime,
      'status': status,
      'total_currency_price': totalCurrencyPrice,
      'orderItems': itemsJson,
      'subtotal_currency_price': subtotal_currency_price,
      'subtotal_without_tax_currency_price':
          subtotal_without_tax_currency_price,
      'discount_currency_price': discount_currency_price,
      'total_currency_price': total_currency_price,
      'total_tax_currency_price': totalTaxCurrencyPrice,
    };
  }
}

class OrderItems {
  final String oId;
  final String id;
  final String itemName;
  final String itemImage;
  int quantity;
  final String price;
  final String instruction;
  final String totalConvertPrice;
  final String taxRate;
  final String itemVariationCurrencyTotal;
  final String itemExtraCurrencyTotal;
  final List<dynamic> itemVariations;
  final List<dynamic> itemExtras;

  OrderItems({
    required this.oId,
    required this.id,
    required this.itemName,
    required this.itemImage,
    required this.quantity,
    required this.price,
    required this.instruction,
    required this.totalConvertPrice,
    required this.taxRate,
    required this.itemVariationCurrencyTotal,
    required this.itemExtraCurrencyTotal,
    required this.itemVariations,
    required this.itemExtras,
  });

  factory OrderItems.fromJson(Map<String, dynamic> json) {
    return OrderItems(
      oId: json['id'].toString(),
      id: json['item_id'].toString(),
      itemName: json['item_name'].toString(),
      itemImage: json['item_image'].toString(),
      quantity: json['quantity'],
      price: json['price'].toString(),
      instruction: json['instruction'].toString(),
      totalConvertPrice: json['total_convert_price'].toString(),
      taxRate: json['tax_rate'].toString(),
      itemVariationCurrencyTotal:
          json['item_variation_currency_total'].toString(),
      itemExtraCurrencyTotal: json['item_extra_currency_total'].toString(),
      itemVariations: json['item_variations'],
      itemExtras: json['item_extras'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'oId': oId,
      'item_id': id,
      'item_name': itemName,
      'item_image': itemImage,
      'quantity': quantity,
      'price': price,
      'instruction': instruction,
      'total_convert_price': totalConvertPrice,
      'tax_rate': taxRate,
      'item_variation_currency_total': itemVariationCurrencyTotal,
      'item_extra_currency_total': itemExtraCurrencyTotal,
      'item_variations': itemVariations,
      'item_extras': itemExtras,
    };
  }
}

class OrdersScreen extends StatefulWidget {
  final LoginUser user;
  final String table;
  final String id;

  const OrdersScreen({
    Key? key,
    required this.id,
    required this.user,
    required this.table,
  }) : super(key: key);

  @override
  OrdersScreenState createState() => OrdersScreenState();
}

class OrdersScreenState extends State<OrdersScreen> {
  late Stream<List<Order>> _ordersStream;
  final int orderType = 10;
  var firstTime = true;
  bool isLoading = false;
  String activeId = "";
  String _selectedOption = 'No One On Table';

  final AuthController _authController = Get.find();

  List<Order> selectedOrders = [];
  List<int> itemIds = [];
  List<Map<String, dynamic>> allItemIds = [];
  bool selectAll = false;

  @override
  void initState() {
    super.initState();
    _ordersStream = _fetchActiveOrders();
  }

  Stream<List<Order>> _fetchActiveOrders() async* {
    if (kDebugMode) {
      print("Fetching orders ${widget.user.token}");
    }
    while (true) {
      final response = await http.get(
        Uri.parse(
            '$domain/api/admin/table-order?dining_table_id=${widget.id}&payment_status=10&status=1,4,7,13'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'X-Api-Key': xApi,
          'Authorization': 'Bearer ${widget.user.token}',
        },
      );
      if (kDebugMode) {
        print("orders --> ${response.statusCode}");
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic>? ordersData = responseData['data'];
        if (ordersData != null) {
          List<Order> orders = [];
          for (var orderJson in ordersData) {
            if (kDebugMode) {
              print(orderJson['order_items']);
            }
            // final response2 = await http.get(
            //   Uri.parse(
            //       '$domain/api/admin/table-order/show/${orderJson['id']}'),
            //   headers: {
            //     'Content-Type': 'application/json; charset=UTF-8',
            //     'X-Api-Key': xApi,
            //     'Authorization': 'Bearer ${widget.user.token}',
            //   },
            // );
            // if (kDebugMode) {
            //   print("order items --> ${response2.statusCode}");
            // }

            // if (response2.statusCode == 200 || response2.statusCode == 201) {
            //   final Map<String, dynamic> responseData2 =
            //       jsonDecode(response2.body);
            //   final Map<String, dynamic> orderData2 = responseData2['data'];
            final dynamic orderItemsData = orderJson['order_items'];
            // final dynamic orderItemsData = orderData2['order_items'];

            if (orderItemsData != null && orderItemsData is List) {
              // Check if orderItemsData is a List
              List<OrderItems> orderItems = [];
              for (var orderItemJson in orderItemsData) {
                orderItems.add(OrderItems.fromJson(orderItemJson));
                allItemIds.add({
                  "itemId": orderItemJson[''],
                  "orderId": orderItemJson['']
                });
                if (kDebugMode) {
                  print(orderItemJson);
                }
              }
              orders.add(Order.fromJson({
                ...orderJson,
                'orderItems': orderItems,
              }));
            } else {
              if (kDebugMode) {
                print('order_items data is not a List or is null');
              }
            }
            // } else {
            //   if (kDebugMode) {
            //     print(
            //         'Failed to fetch order items. Status code: ${response2.statusCode}');
            //   }
            // }
          }
          yield orders;
        } else {
          throw Exception('Failed to parse order data');
        }
      } else {
        throw Exception('Failed to load active orders');
      }
      break;

      // Delay before fetching tables again
      await Future.delayed(const Duration(seconds: 5));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffa14716),
        title: Text(
          widget.table,
          style: const TextStyle(
              color: whiteColor, // Set text color to white
              fontWeight: FontWeight.bold, // Make text bolder
              fontSize: 16),
        ),
        iconTheme: const IconThemeData(color: whiteColor),
        actions: [
          // InkWell(
          //   onTap: () {
          //     _showLogoutDialog();
          //   },
          //   child: Padding(
          //     padding: const EdgeInsets.only(right: 10.0),
          //     child: CircleAvatar(
          //       backgroundImage: NetworkImage(widget.user.image),
          //     ),
          //   ),
          // ),
          InkWell(
            onTap: () {
              _authController.showLogoutDialog(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Image.network(
                widget.user.image,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    // If the image is fully loaded, return the CircleAvatar
                    return CircleAvatar(
                      backgroundImage: NetworkImage(
                        widget.user.image,
                      ),
                    );
                  } else {
                    // If the image is still loading, return a CircularProgressIndicator
                    return const CircularProgressIndicator();
                  }
                },
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  // Return a fallback image in case of an error
                  return const CircleAvatar(
                    backgroundImage: AssetImage(
                      'assets/images/profile.png', // Provide the path to your fallback image
                    ),
                  );
                },
              ),
            ),
          ),
        ],
        // toolbarHeight: 70, // Increase the height of the AppBar
      ),
      body: StreamBuilder<List<Order>>(
        stream: _ordersStream, // The stream to listen to for data updates
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            if (kDebugMode) {
              print(snapshot.error);
            }
            return const Center(child: Text('Error: Connection'));
          } else {
            final List<Order> orders = snapshot.data ?? [];
            if (orders.isEmpty) {
              return const Center(
                child: Text(
                  "No Order Yet...!",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              );
            }
            bool hasAtLeastTwoStatusNotEqualToOne =
                orders.where((order) => order.status != 1).length >= 2;
            return Column(
              children: [
                (orders.length > 0 && hasAtLeastTwoStatusNotEqualToOne)
                    ? CheckboxListTile(
                        tileColor: const Color(0xfff3b98a),
                        activeColor: const Color(0xffa14716),
                        controlAffinity: ListTileControlAffinity.leading,
                        title: const Text("Merge All"),
                        value: selectAll,
                        onChanged: (value) {
                          setState(() {
                            selectAll = value!;
                            if (selectAll) {
                              // If "Select All" is checked, clear the list first
                              selectedOrders.clear();
                              // Iterate through orders and add IDs where status != 1 to selectedOrders
                              for (var order in orders) {
                                if (order.status != 1) {
                                  selectedOrders.add(order);
                                }
                              }
                            } else {
                              // If "Select All" is unchecked, clear selectedOrders
                              selectedOrders.clear();
                            }
                          });
                        },
                      )
                    : Container(),
                Expanded(
                  child: ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      // print(order.orderItems);
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              8), // Adjust border radius as needed
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.grey.withOpacity(0.5), // Shadow color
                              spreadRadius: 1, // Spread radius
                              blurRadius: 5, // Blur radius
                              offset:
                                  const Offset(0, 2), // Offset from the card
                            ),
                          ],
                        ),
                        child: Card(
                          elevation: 0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              (order.status != 1 &&
                                      orders.length > 0 &&
                                      hasAtLeastTwoStatusNotEqualToOne)
                                  ? CheckboxListTile(
                                      activeColor: const Color(0xffa14716),
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      value: selectedOrders.contains(order),
                                      onChanged: (bool? value) {
                                        setState(() {
                                          if (value != null && value) {
                                            selectedOrders.add(order);
                                          } else {
                                            selectedOrders.remove(order);
                                          }
                                          selectAll = selectedOrders.length ==
                                              orders.length;
                                        });
                                      },
                                      title: ListTile(
                                        title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Order-${index + 1}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "Status: ${order.statusName}",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                        subtitle: Text(
                                          order.orderSerialNo,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    )
                                  : ListTile(
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Order-${index + 1}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Row(
                                            children: [
                                              (isLoading &&
                                                      activeId == order.id)
                                                  ? const CircularProgressIndicator()
                                                  : order.status == 1
                                                      ? Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          14.0,
                                                                      horizontal:
                                                                          20),
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12), // Adjust the radius as needed
                                                                  ),
                                                                  backgroundColor:
                                                                      const Color(
                                                                          0xffa14716),
                                                                ),
                                                                onPressed: () {
                                                                  updateStatus(
                                                                      orderId:
                                                                          order
                                                                              .id,
                                                                      CurrentStatus: order.status,
                                                                      newStatus: 4,
                                                                      inputData: {
                                                                        "id": order
                                                                            .id,
                                                                        "status":
                                                                            4
                                                                      });
                                                                },
                                                                child:
                                                                    const Text(
                                                                  "Approved",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                )),
                                                            const SizedBox(
                                                              width: 4,
                                                            ),
                                                            ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          14.0,
                                                                      horizontal:
                                                                          20),
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12), // Adjust the radius as needed
                                                                  ),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .amber,
                                                                ),
                                                                onPressed: () {
                                                                  MoreBox(
                                                                      order:
                                                                          order,
                                                                      id: widget
                                                                          .id,
                                                                      table: widget
                                                                          .table,
                                                                      user: widget
                                                                          .user);
                                                                },
                                                                child:
                                                                    const Text(
                                                                  "More",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                )),
                                                          ],
                                                        )
                                                      : Text(
                                                          "Status: ${order.statusName}",
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )
                                            ],
                                          ),
                                        ],
                                      ),
                                      subtitle: Text(
                                        order.orderSerialNo,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                              // Order items
                              if (order.orderItems != null)
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: order.orderItems.length,
                                  itemBuilder: (context, itemIndex) {
                                    final item = order.orderItems[itemIndex];
                                    if (kDebugMode) {
                                      print(item);
                                    }
                                    var x = (item.price).replaceAll("Rs", "");
                                    var y = (item.itemVariationCurrencyTotal)
                                        .replaceAll("Rs", "");
                                    var z = (item.itemExtraCurrencyTotal)
                                        .replaceAll("Rs", "");
                                    var itemtotal = double.parse(x) +
                                        double.parse(y) +
                                        double.parse(z);
                                    return ListTile(
                                      // title: Text("Item Name: ${item.item_name}"),
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              _showItemDialog(
                                                  context,
                                                  item,
                                                  double.parse(x),
                                                  double.parse(y),
                                                  double.parse(z));
                                            },
                                            child: Text(
                                              item.itemName.toString(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              const Text(
                                                "Qty: ",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(item.quantity.toString()),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Text(
                                                "Price: ",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(itemtotal.toString()),
                                            ],
                                          ),
                                        ],
                                      ),
                                      trailing: Image.network(
                                        item.itemImage,
                                        loadingBuilder: (BuildContext context,
                                            Widget child,
                                            ImageChunkEvent? loadingProgress) {
                                          if (loadingProgress == null) {
                                            // If the image is fully loaded, return the Image widget
                                            return child;
                                          } else {
                                            // If the image is still loading, return a CircularProgressIndicator
                                            return const CircularProgressIndicator();
                                          }
                                        },
                                        errorBuilder: (BuildContext context,
                                            Object exception,
                                            StackTrace? stackTrace) {
                                          // Return a fallback image in case of an error
                                          return Image.asset(
                                            'assets/images/imageNotFound.png', // Provide the path to your fallback image
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              order.status != 1
                                  ? Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      width: double.infinity,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10.0, horizontal: 10),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  12), // Adjust the radius as needed
                                            ),
                                            backgroundColor:
                                                const Color(0xfff3b98a),
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CashierScreen(
                                                          user: widget.user,
                                                          id: widget.id,
                                                          table: widget.table,
                                                          orderrs: order)),
                                            );
                                          },
                                          child: Text(
                                            "Pay ${order.totalCurrencyPrice}",
                                            style: const TextStyle(
                                                color: whiteColor),
                                          )),
                                    )
                                  : Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      width: double.infinity,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10.0, horizontal: 10),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  12), // Adjust the radius as needed
                                            ),
                                            backgroundColor:
                                                const Color(0xfff3b98a),
                                          ),
                                          onPressed: () {},
                                          child: Text(
                                            "Total Bill: ${order.totalCurrencyPrice}",
                                            style: const TextStyle(
                                                color: whiteColor),
                                          )),
                                    )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
      bottomNavigationBar: Container(
        color: const Color(0xffa14716),
        width: double.infinity,
        height: 50.0,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xffa14716),
          ),
          onPressed: () async {
            if (selectedOrders.isNotEmpty) {
              if (kDebugMode) {
                print("Merge Orders");
              }
              const baseUrl = '$domain/api/admin/table-order/merge-order';

// Extract order IDs from selectedOrders
              final List<String> orderIds =
                  selectedOrders.map((order) => order.id).toList();

// Extract item IDs from orderItems in selectedOrders
              final List<String> itemIds = [];
              selectedOrders.forEach((order) {
                order.orderItems.forEach((item) {
                  itemIds.add(item.oId);
                });
              });

              final url =
                  '$baseUrl?order_ids=${orderIds.join(",")}&item_ids=${itemIds.join(",")}';
              if (kDebugMode) {
                print("url is: $url");
              }

              final response = await http.get(
                Uri.parse(url),
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
                final Map<String, dynamic> responseData =
                    jsonDecode(response.body);
                final List<dynamic>? tablesData =
                    responseData['data']; // Extracting the list of tables
                setState(() {
                  _ordersStream = _fetchActiveOrders();
                });
              } else {
                final Map<String, dynamic> responseData =
                    jsonDecode(response.body);
                if (kDebugMode) {
                  print('Failed to Merge Orders $responseData');
                }
              }
            }
          },
          child: const Text(
            'Merge Orders',
            style: TextStyle(color: whiteColor, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xffa14716),
          foregroundColor: whiteColor,
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MenuScreen(
                        user: widget.user,
                        id: widget.id,
                        table: widget.table,
                      )),
            );
          }),
    ));
  }

  void _showItemDialog(BuildContext context, OrderItems item, double itemPrice,
      double varPrice, double extraPrice) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(item.itemName),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (item.itemVariations != null && item.itemVariations.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Variations:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    for (var variation in item.itemVariations)
                      Text(
                          "- ${variation['variation_name']} ${variation['name']}"),
                    const Divider(),
                  ],
                ),
              if (item.itemExtras != null && item.itemExtras.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Extras:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    for (var extra in item.itemExtras)
                      Text("- ${extra['name']}"),
                    const Divider(),
                  ],
                ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Item:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(itemPrice.toString()),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "extra:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(varPrice.toString()),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "variation:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(extraPrice.toString()),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text("${itemPrice + varPrice + extraPrice}"),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void updateStatus(
      {required String orderId,
      required int CurrentStatus,
      required int newStatus,
      required Map<String, dynamic> inputData}) async {
    setState(() {
      activeId = orderId;
      isLoading = true;
    });
    if (kDebugMode) {
      print("Approve $CurrentStatus");
    }
    var data = {"id": orderId, "status": newStatus};
    var response = await http.post(
      Uri.parse('$domain/api/admin/table-order/change-status/$orderId'),
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
              table: widget.table,
              id: widget.id,
            ),
          ),
        );
      }
    }
    setState(() {
      activeId = "";
      isLoading = false;
    });
  }

  void MoreBox(
      {required Order order,
      required String id,
      required String table,
      required LoginUser user}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select an option'),
          content: Column(
            children: [
              DropdownButton<String>(
                value: _selectedOption,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedOption = newValue!;
                  });
                },
                items: <String>['No One On Table', 'Customer Denied', 'Other']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 14.0, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        12), // Adjust the radius as needed
                  ),
                  foregroundColor: redColor,
                ),
                onPressed: () {
                  if (kDebugMode) {
                    print('Selected option: $_selectedOption');
                  }
                  updateStatus(
                      orderId: order.id,
                      CurrentStatus: order.status,
                      newStatus: 19,
                      inputData: {
                        "id": order.id,
                        "reason": _selectedOption,
                        "status": 19
                      });
                  setState(() {
                    _ordersStream = _fetchActiveOrders();
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('Reject'),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 14.0, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          12), // Adjust the radius as needed
                    ),
                    foregroundColor: const Color(0xffa14716),
                  ),
                  onPressed: () {
                    Get.to(EditOrderScreen(
                      id: id,
                      table: table,
                      user: user,
                      order: order,
                    ));
                  },
                  child: const Text("Edit"))
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(12), // Adjust the radius as needed
                ),
                foregroundColor: const Color(0xffa14716),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                // Perform logout action here
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}
