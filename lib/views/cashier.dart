import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nanopos/views/cashPaymet.dart';
import 'dart:convert';

import 'package:nanopos/views/Auth/login.dart';
import 'package:nanopos/views/order.dart';
import 'package:nanopos/consts/consts.dart';

class CashierScreen extends StatefulWidget {
  final loginUser user;
  final String table;
  final String id;
  final Order orderrs;

  CashierScreen({
    Key? key,
    required this.id,
    required this.user,
    required this.table,
    required this.orderrs,
  }) : super(key: key);

  @override
  _CashierScreenState createState() => _CashierScreenState();
}

class _CashierScreenState extends State<CashierScreen> {
  late Order order;
  final int orderType = 10;
  var firstTime = true;
  List<OrderItems> orderItems = [];
  int totalOrders = 0;

  double total = 0;

  String updatedTotalPrice = '';
  String updatedTaxPrice = '';

  @override
  void initState() {
    super.initState();
    order = widget.orderrs;
    updatedTotalPrice = (order.totalCurrencyPrice).replaceAll("Rs", "");
    updatedTaxPrice = (order.total_tax_currency_price).replaceAll("Rs", "");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Center(
              child: Text(
                "Check out - ${order.id}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold, // Make text bolder
                ),
              ),
            ),
            // iconTheme: const IconThemeData(color: whiteColor),
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
                  surfaceTintColor: whiteColor,
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
                            SizedBox(width: 68),
                            IconButton(onPressed: (){}, icon: const Icon(Icons.print))
                          ],
                        ),
                        SizedBox(height: 5),
                        // Check if orderItems is not null and not empty
                        if (order.orderItems != null &&
                            order.orderItems.isNotEmpty)
                          Column(
                            children: order.orderItems.map((orderItem) {
                              var x = (orderItem.price).replaceAll("Rs", "");
                              total += orderItem.quantity * double.parse(x);
                              print("$total = ${orderItem.quantity} and ${x}");
                              return GestureDetector(
                                onTap: () {
                                  _showItemDialog(context, orderItem);
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        "${orderItem.quantity}x ${orderItem.itemName}"),
                                    Text("${orderItem.price}"),
                                  ],
                                ),
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
                  surfaceTintColor: whiteColor,
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
                                "${double.parse(updatedTotalPrice) - double.parse(updatedTaxPrice)}Rs"),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Tax"),
                            Text("${order.total_tax_currency_price}"),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Total"),
                            Text("${total}Rs"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Card.outlined(
                  surfaceTintColor: whiteColor,
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
                          surfaceTintColor: whiteColor,
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
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
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
                                      // total: 123,
                                      total: total,
                                      user: widget.user,
                                      orderId: order.id)),
                            );
                          },
                          child: Card.outlined(
                            surfaceTintColor: whiteColor,
                            shadowColor: Colors.black,
                            elevation: 4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 15),
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
                                        "${total}Rs",
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

  // Function to update the total amount
  void updateTotal() {
    double newTotal = 0;
    for (var orderItem in order.orderItems) {
      var x = (orderItem.price).replaceAll("Rs", "");
      newTotal += orderItem.quantity * double.parse(x);
    }
    setState(() {
      total = newTotal;
    });
  }

// Function to show the dialog box
  void _showItemDialog(BuildContext context, OrderItems orderItem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int quantity = orderItem.quantity;
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(orderItem.itemName),
              IconButton(
                onPressed: () {
                  setState(() {
                    // Remove item from order
                    order.orderItems.remove(orderItem);
                  });
                  updateTotal();
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Quantity: $quantity'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (quantity > 1) {
                        setState(() {
                          quantity--;
                          orderItem.quantity = quantity;
                        });
                        updateTotal();
                      }
                    },
                    child: Icon(Icons.remove),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // setState(() {
                      //   // Decrease quantity of item in order
                      //   orderItem.quantity = quantity;
                      // });
                      // updateTotal();
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // void _showItemDialog(BuildContext context, OrderItems orderItem) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       int quantity = orderItem.quantity;
  //       return AlertDialog(
  //         title: Text(orderItem.itemName),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Text('Quantity: $quantity'),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //               children: [
  //                 ElevatedButton(
  //                   onPressed: () {
  //                     if (quantity > 1) {
  //                       setState(() {
  //                         quantity--;
  //                       });
  //                     }
  //                   },
  //                   child: Text('-'),
  //                 ),
  //                 ElevatedButton(
  //                   onPressed: () {
  //                     setState(() {
  //                       // Remove item from order
  //                       order.orderItems.remove(orderItem);
  //                     });
  //                     Navigator.of(context).pop();
  //                   },
  //                   child: Text('Remove'),
  //                 ),
  //                 ElevatedButton(
  //                   onPressed: () {
  //                     setState(() {
  //                       // Decrease quantity of item in order
  //                       orderItem.quantity = quantity;
  //                     });
  //                     Navigator.of(context).pop();
  //                   },
  //                   child: Text('Done'),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
}
