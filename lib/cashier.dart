import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:nanopos/login.dart';
import 'package:nanopos/order.dart';

class CashierScreen extends StatefulWidget {
  final String name;
  final String email;
  final String id;
  final String table;
  final String token;
  final String image;

  CashierScreen({
    Key? key,
    required this.name,
    required this.email,
    required this.id,
    required this.token,
    required this.image,
    required this.table,
  }) : super(key: key);

  @override
  _CashierScreenState createState() => _CashierScreenState();
}

class _CashierScreenState extends State<CashierScreen> {
  late Future<List<Order>> _ordersFuture;
  final int orderType = 10;
  var firstTime = true;
  List<OrderItems> orderItems = [];
  int totalOrders = 0;
  @override
  void initState() {
    super.initState();
    _ordersFuture = _fetchActiveOrders();
  }

  Future<List<Order>> _fetchActiveOrders() async {
    if (kDebugMode) {
      print("Fetching orders ${widget.token}");
    }
    while (true) {
      final response = await http.get(
        Uri.parse(
            'https://restaurant.nanosystems.com.pk/api/admin/table-order?dining_table_id=${widget.id}&payment_status=10'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'X-Api-Key': 'b6d68vy2-m7g5-20r0-5275-h103w73453q120',
          'Authorization': 'Bearer ${widget.token}',
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
            totalOrders++;
            final response2 = await http.get(
              Uri.parse(
                  'https://restaurant.nanosystems.com.pk/api/admin/table-order/show/${orderJson['id']}'),
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'X-Api-Key': 'b6d68vy2-m7g5-20r0-5275-h103w73453q120',
                'Authorization': 'Bearer ${widget.token}',
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
                for (var orderItemJson in orderItemsData) {
                  if (orderItemsData != null && orderItemsData is List) {
                    // Check if orderItemsData is a List
                    for (var orderItemJson in orderItemsData) {
                      OrderItems newOrderItem =
                          OrderItems.fromJson(orderItemJson);

                      // Check if the order item already exists in the list
                      bool itemExists = false;
                      int existingIndex = -1;
                      for (int i = 0; i < orderItems.length; i++) {
                        if (orderItems[i].id == newOrderItem.id) {
                          itemExists = true;
                          existingIndex = i;
                          break;
                        }
                      }

                      if (itemExists) {
                        // If the item exists, increment its quantity
                        orderItems[existingIndex].quantity =
                            orderItems[existingIndex].quantity +
                                newOrderItem.quantity;
                      } else {
                        // If the item doesn't exist, add it to the list
                        orderItems.add(newOrderItem);
                      }
                    }
                  } else {
                    if (kDebugMode) {
                      print('order_items data is not a List or is null');
                    }
                  }
                }
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
          return orders;
        } else {
          throw Exception('Failed to parse order data');
        }
      } else {
        throw Exception('Failed to load active orders');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff2a407c),
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
                  backgroundImage: NetworkImage(widget.image),
                ),
              ),
            ),
          ],
          toolbarHeight: 70, // Increase the height of the AppBar
        ),
        body: FutureBuilder<List<Order>>(
          future: _ordersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              if (kDebugMode) {
                print(snapshot.error);
              }
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              // print(orderItems);
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      8), // Adjust border radius as needed
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Shadow color
                      spreadRadius: 1, // Spread radius
                      blurRadius: 5, // Blur radius
                      offset:const Offset(0, 2), // Offset from the card
                    ),
                  ],
                ),
                child: Card(
                  elevation: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (orderItems != null)
                        ListView.builder(
                          shrinkWrap: true,
                          physics:const  AlwaysScrollableScrollPhysics(),
                          itemCount: orderItems.length,
                          itemBuilder: (context, itemIndex) {
                            final item = orderItems[itemIndex];
                            // print(item);
                            return ListTile(
                              // title: Text("Item Name: ${item.item_name}"),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.itemName.toString(),
                                    style:
                                        const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        "Qty: ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(item.price),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        "Price: ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(item.price),
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
            }
          },
        ),
      ),
    );
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
                backgroundImage: NetworkImage(widget.image),
                radius: 40,
              ),
              const SizedBox(height: 20),
              Text(
                widget.name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                widget.email,
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
                foregroundColor: const Color(0xff2a407c),
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
