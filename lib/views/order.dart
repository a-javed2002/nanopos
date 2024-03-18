import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:nanopos/views/login.dart';
import 'package:nanopos/views/cashier.dart';
import 'package:nanopos/views/sidebar.dart';

class Order {
  final String id;
  final String orderSerialNo;
  final String orderDatetime;
  final int status;
  final String totalCurrencyPrice;
  final List<OrderItems> orderItems; // Change type to dynamic
  final String statusName;

  Order({
    required this.id,
    required this.orderSerialNo,
    required this.status,
    required this.statusName,
    required this.orderDatetime,
    required this.totalCurrencyPrice,
    required this.orderItems,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'].toString(),
      orderSerialNo: json['order_serial_no'].toString(),
      statusName: json['status_name'].toString(),
      orderDatetime: json['order_datetime'].toString(),
      status: json['status'],
      totalCurrencyPrice: json['total_currency_price'].toString(),
      orderItems: json[
          'orderItems'], // Assign the parsed list or null, // Assign the parsed list or null
    );
  }
}

class OrderItems {
  final String id;
  final String itemName;
  final String itemImage;
  int quantity;
  final String price;
  final String instruction;
  final String totalConvertPrice;

  OrderItems({
    required this.id,
    required this.itemName,
    required this.itemImage,
    required this.quantity,
    required this.price,
    required this.instruction,
    required this.totalConvertPrice,
  });

  factory OrderItems.fromJson(Map<String, dynamic> json) {
    return OrderItems(
      id: json['id'].toString(),
      itemName: json['item_name'].toString(),
      itemImage: json['item_image'].toString(),
      quantity: json['quantity'],
      price: json['price'].toString(),
      instruction: json['instruction'].toString(),
      totalConvertPrice: json['total_convert_price'].toString(),
    );
  }
}

class OrdersScreen extends StatefulWidget {
  final loginUser user;
  final String table;
  final String id;

  const OrdersScreen({
    Key? key,
    required this.id,
    required this.user,
    required this.table,
  }) : super(key: key);

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Stream<List<Order>> _ordersStream;
  final int orderType = 10;
  var firstTime = true;
  bool isLoading = false;
  String activeId = "";

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
            'https://restaurant.nanosystems.com.pk/api/admin/table-order?dining_table_id=${widget.id}&payment_status=10'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'X-Api-Key': 'b6d68vy2-m7g5-20r0-5275-h103w73453q120',
          'Authorization': 'Bearer ${widget.user.token}',
        },
      );
      if (kDebugMode) {
        print(response.statusCode);
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic>? ordersData = responseData['data'];
        if (ordersData != null) {
          List<Order> orders = [];
          for (var orderJson in ordersData) {
            final response2 = await http.get(
              Uri.parse(
                  'https://restaurant.nanosystems.com.pk/api/admin/table-order/show/${orderJson['id']}'),
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'X-Api-Key': 'b6d68vy2-m7g5-20r0-5275-h103w73453q120',
                'Authorization': 'Bearer ${widget.user.token}',
              },
            );
            if (kDebugMode) {
              print(response2.statusCode);
            }

            if (response2.statusCode == 200 || response2.statusCode == 201) {
              final Map<String, dynamic> responseData2 =
                  jsonDecode(response2.body);
              final Map<String, dynamic> orderData2 = responseData2['data'];
              final dynamic orderItemsData = orderData2['order_items'];

              if (orderItemsData != null && orderItemsData is List) {
                // Check if orderItemsData is a List
                List<OrderItems> orderItems = [];
                for (var orderItemJson in orderItemsData) {
                  orderItems.add(OrderItems.fromJson(orderItemJson));
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
            } else {
              if (kDebugMode) {
                print(
                    'Failed to fetch order items. Status code: ${response2.statusCode}');
              }
            }
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
            color: Colors.white, // Set text color to white
            fontWeight: FontWeight.bold, // Make text bolder
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          InkWell(
            onTap: () {
              _showLogoutDialog();
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(widget.user.image),
              ),
            ),
          ),
        ],
        toolbarHeight: 70, // Increase the height of the AppBar
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
            return ListView.builder(
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
                        color: Colors.grey.withOpacity(0.5), // Shadow color
                        spreadRadius: 1, // Spread radius
                        blurRadius: 5, // Blur radius
                        offset: const Offset(0, 2), // Offset from the card
                      ),
                    ],
                  ),
                  child: Card(
                    elevation: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Order-${index + 1}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  (isLoading && activeId == order.id)
                                      ? const CircularProgressIndicator()
                                      : order.status == 1
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 14.0,
                                                          horizontal: 20),
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
                                                    onPressed: () async {
                                                      setState(() {
                                                        activeId = order.id;
                                                        isLoading = true;
                                                      });
                                                      if (kDebugMode) {
                                                        print(
                                                            "Approve ${order.status}");
                                                      }
                                                      var data = {
                                                        "id": order.id,
                                                        "status": 4
                                                      };
                                                      var response =
                                                          await http.post(
                                                        Uri.parse(
                                                            'https://restaurant.nanosystems.com.pk/api/admin/table-order/change-status/${order.id}'),
                                                        body: jsonEncode(data),
                                                        headers: {
                                                          'Content-Type':
                                                              'application/json; charset=UTF-8',
                                                          'X-Api-Key':
                                                              'b6d68vy2-m7g5-20r0-5275-h103w73453q120',
                                                          'Authorization':
                                                              'Bearer ${widget.user.token}',
                                                        },
                                                      );
                                                      if (kDebugMode) {
                                                        print(response
                                                            .statusCode);
                                                      }

                                                      if (response.statusCode ==
                                                              200 ||
                                                          response.statusCode ==
                                                              201) {
                                                        // Extract response body
                                                        var responseBody =
                                                            jsonDecode(
                                                                response.body);
                                                        if (kDebugMode) {
                                                          print(responseBody);
                                                        }
                                                      }
                                                      setState(() {
                                                        activeId = "";
                                                        isLoading = false;
                                                      });
                                                    },
                                                    child: const Text(
                                                      "Approved",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    )),
                                                const SizedBox(
                                                  width: 4,
                                                ),
                                                ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 14.0,
                                                          horizontal: 20),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                12), // Adjust the radius as needed
                                                      ),
                                                      backgroundColor:
                                                          const Color.fromARGB(
                                                              255, 119, 40, 51),
                                                    ),
                                                    onPressed: () async {
                                                      setState(() {
                                                        activeId = order.id;
                                                        isLoading = true;
                                                      });
                                                      if (kDebugMode) {
                                                        print(
                                                            "Approve ${order.status}");
                                                      }
                                                      var data = {
                                                        "id": order.id,
                                                        "reason": "Nhi Dayna",
                                                        "status": 19,
                                                      };
                                                      var response =
                                                          await http.post(
                                                        Uri.parse(
                                                            'https://restaurant.nanosystems.com.pk/api/admin/table-order/change-status/${order.id}'),
                                                        body: jsonEncode(data),
                                                        headers: {
                                                          'Content-Type':
                                                              'application/json; charset=UTF-8',
                                                          'X-Api-Key':
                                                              'b6d68vy2-m7g5-20r0-5275-h103w73453q120',
                                                          'Authorization':
                                                              'Bearer ${widget.user.token}',
                                                        },
                                                      );

                                                      if (kDebugMode) {
                                                        print(response
                                                            .statusCode);
                                                      }

                                                      if (response.statusCode ==
                                                              200 ||
                                                          response.statusCode ==
                                                              201) {
                                                        // Extract response body
                                                        var responseBody =
                                                            jsonDecode(
                                                                response.body);
                                                        if (kDebugMode) {
                                                          print(responseBody);
                                                        }
                                                      }
                                                      setState(() {
                                                        activeId = "";
                                                        isLoading = false;
                                                      });
                                                    },
                                                    child: const Text(
                                                      "Reject",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    )),
                                              ],
                                            )
                                          : Text(
                                              "Status: ${order.statusName}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            )
                                ],
                              ),
                            ],
                          ),
                          subtitle: Text(
                            order.orderSerialNo,
                            style: const TextStyle(fontWeight: FontWeight.bold),
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
                              // print(item);
                              return ListTile(
                                // title: Text("Item Name: ${item.item_name}"),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.itemName.toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Qty: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(item.quantity.toString()),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Price: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(item.price.toString()),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: Image.network(item.itemImage),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                );
              },
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
          onPressed: () {
            if (kDebugMode) {
              print("Merge Orders");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CashierScreen(user: widget.user,id: widget.id,table: widget.table,)),
              );
            }
          },
          child: const Text(
            'Ready To Pay',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SideBarScreen(
                        user: widget.user,
                        id: widget.id,
                        table: widget.table,
                      )),
            );
          }),
    ));
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Profile"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.user.image),
                radius: 40,
              ),
              const SizedBox(height: 20),
              Text(
                widget.user.name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                widget.user.email,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.logout, size: 40, color: Colors.red),
              )
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


// @override
  // Widget build(BuildContext context) {
  //   return SafeArea(
  //     child: Scaffold(
  //       appBar: AppBar(
  //         backgroundColor: Color(0xffa14716),
  //         title: Text(widget.table,
  //           style: TextStyle(
  //             color: Colors.white, // Set text color to white
  //             fontWeight: FontWeight.bold, // Make text bolder
  //           ),
  //         ),
  //         iconTheme: IconThemeData(color: Colors.white),
  //         actions: [
  //           Padding(
  //             padding: const EdgeInsets.only(right: 10.0),
  //             child: CircleAvatar(
  //               backgroundImage: NetworkImage(widget.image),
  //             ),
  //           ),
  //         ],
  //         toolbarHeight: 70, // Increase the height of the AppBar
  //       ),
  //       body: FutureBuilder<List<Order>>(
  //         future: _ordersFuture,
  //         builder: (context, snapshot) {
  //           if (snapshot.connectionState == ConnectionState.waiting) {
  //             return Center(child: CircularProgressIndicator());
  //           } else if (snapshot.hasError) {
  //             print(snapshot.error);
  //             return Center(child: Text('Error: ${snapshot.error}'));
  //           } else {
  //             final List<Order> orders = snapshot.data ?? [];
  //             return GridView.builder(
  //               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //                 crossAxisCount: 1,
  //                 crossAxisSpacing: 10.0,
  //                 mainAxisSpacing: 10.0,
  //               ),
  //               itemCount: orders.length,
  //               itemBuilder: (context, index) {
  //                 final order = orders[index];
  //                 return Card(
  //                   child: ListTile(
  //                     title: Text(order.id),
  //                     subtitle: Text(order.orderSerialNo),
  //                     leading: Text(order.totalCurrencyPrice),
  //                   ),
  //                 );
  //               },
  //             );
  //           }
  //         },
  //       ),
  //     ),
  //   );
  // }