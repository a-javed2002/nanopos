import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:nanopos/views/cashPaymet.dart';
import 'dart:convert';

import 'package:nanopos/views/login.dart';
import 'package:nanopos/views/order.dart';

class CashierScreen extends StatefulWidget {
  final loginUser user;
  final String table;
  final String id;

  CashierScreen({
    Key? key,
    required this.id,
    required this.user,
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
            totalOrders++;
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
            backgroundColor: Colors.transparent,
            title: Center(
              child: Text(
                "Check out",
                style: const TextStyle(
                  fontWeight: FontWeight.bold, // Make text bolder
                ),
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
          body: Column(
            children: [
              Card.outlined(
                surfaceTintColor: Colors.white,
                shadowColor: Colors.black,
                elevation: 4,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Image.asset("assets/images/receipt.png"),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Order Summary",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("1x Dumplings"),
                          Text("Rs. 500"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("1x Ham Sandwich"),
                          Text("Rs. 1500"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("1x Nigri Sushi"),
                          Text("Rs. 2500"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Card.outlined(
                surfaceTintColor: Colors.white,
                shadowColor: Colors.black,
                elevation: 4,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Subtotal"),
                          Text("Rs. 4750"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Tax"),
                          Text("Rs. 7.99"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total"),
                          Text("Rs. 4757.99"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Card.outlined(
                surfaceTintColor: Colors.white,
                shadowColor: Colors.black,
                elevation: 4,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Image.asset("assets/images/credit_card.png"),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Payment method",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Card.outlined(
                        surfaceTintColor: Colors.white,
                        shadowColor: Colors.black,
                        elevation: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        "Card",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Image.asset(
                                          "assets/images/MasterCard.png"),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "**** **** 3356",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigate to the new screen when the card is tapped
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CashPayment(
                                      id: widget.id,
                                      table: widget.table,
                                      total: 2345,
                                      user: widget.user,
                                    )),
                          );
                        },
                        child: Card.outlined(
                          surfaceTintColor: Colors.white,
                          shadowColor: Colors.black,
                          elevation: 4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          "Cash",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Image.asset("assets/images/cash.png"),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Rs.4757",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
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
