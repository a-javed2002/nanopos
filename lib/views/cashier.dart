import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nanopos/views/cashPaymet.dart';
import 'dart:convert';

import 'package:nanopos/views/Auth/login.dart';
import 'package:nanopos/views/order.dart';

class CashierScreen extends StatefulWidget {
  final loginUser user;
  final String table;
  final String id;
  final Order order;

  CashierScreen({
    Key? key,
    required this.id,
    required this.user,
    required this.table,
    required this.order,
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
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Center(
              child: Text(
                "Check out - ${widget.order.id}",
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
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
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
                            SizedBox(width: 10),
                            Text(
                              "Order Summary",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        // Check if orderItems is not null and not empty
                        if (widget.order.orderItems != null &&
                            widget.order.orderItems.isNotEmpty)
                          Column(
                            children: widget.order.orderItems.map((orderItem) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      "${orderItem.quantity}x ${orderItem.itemName}"),
                                  Text("Rs. ${orderItem.price}"),
                                ],
                              );
                            }).toList(),
                          )
                        else
                          Text("No items in order"),
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
                            Text(
                                "${widget.order.subtotal_without_tax_currency_price}"),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Tax"),
                            Text("${widget.order.total_tax_currency_price}"),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Total"),
                            Text("${widget.order.subtotal_currency_price}"),
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
                                      total: 123,
                                      // total: double.parse(widget.order.totalCurrencyPrice),
                                      user: widget.user,
                                      orderId: widget.order.id)),
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
            ),
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
                  Get.offAll(
                    LoginScreen(),
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
