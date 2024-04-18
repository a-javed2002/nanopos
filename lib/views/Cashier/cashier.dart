import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nanopos/controller/auth_controller.dart';
import 'package:nanopos/controller/print_controller.dart';
import 'package:nanopos/views/Cashier/card_payment.dart';
import 'package:nanopos/views/Cashier/cash_paymet.dart';

import 'package:nanopos/views/Auth/login.dart';
import 'package:nanopos/views/Home/order.dart';
import 'package:nanopos/consts/consts.dart';

class CashierScreen extends StatefulWidget {
  final LoginUser user;
  final String table;
  final String id;
  final Order orderrs;

  const CashierScreen({
    Key? key,
    required this.id,
    required this.user,
    required this.table,
    required this.orderrs,
  }) : super(key: key);

  @override
  CashierScreenState createState() => CashierScreenState();
}

class CashierScreenState extends State<CashierScreen> {
  final AuthController _authController = Get.find();
  late Order order;
  final int orderType = 10;
  var firstTime = true;
  List<OrderItems> orderItems = [];
  int totalOrders = 0;

  double total = 0;

  String updatedTotalPrice = '';
  String updatedTaxPrice = '';

  final PrintController printController = Get.find();

  @override
  void initState() {
    super.initState();
    printController.initPlatformState();
    order = widget.orderrs;
    updatedTotalPrice = (order.totalCurrencyPrice).replaceAll("Rs", "");
    updatedTaxPrice = (order.totalTaxCurrencyPrice).replaceAll("Rs", "");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Center(
              child: Text(
                "Payment",
                style: TextStyle(
                  fontWeight: FontWeight.bold, // Make text bolder
                ),
              ),
            ),
            // iconTheme: const IconThemeData(color: whiteColor),
            actions: [
              InkWell(
                onTap: () {
                  _authController.showLogoutDialog(context);
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
                            const SizedBox(width: 10),
                            const Text(
                              "Order Summary",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 40),
                            IconButton(
                                onPressed: () {
                                  printController.printDialog(
                                      context: context,
                                      order: order,
                                      user: widget.user);
                                },
                                icon: const Icon(Icons.print))
                          ],
                        ),
                        const SizedBox(height: 5),
                        // Check if orderItems is not null and not empty
                        if (order.orderItems != null &&
                            order.orderItems.isNotEmpty)
                          Column(
                            children: order.orderItems.map((orderItem) {
                              var p = (orderItem.price).replaceAll("Rs", "");
                              var q = (orderItem.itemVariationCurrencyTotal)
                                  .replaceAll("Rs", "");
                              var r = (orderItem.itemExtraCurrencyTotal)
                                  .replaceAll("Rs", "");
                              var itemtotal = double.parse(p) +
                                  double.parse(q) +
                                  double.parse(r);
                                  total+=itemtotal;
                              if (kDebugMode) {
                                print("$total = ${orderItem.quantity} and $p");
                              }
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
                                    Text(itemtotal.toString()),
                                  ],
                                ),
                              );
                            }).toList(),
                          )
                        else
                          const Text("No items in order"),
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
                            const Text("Subtotal"),
                            Text(
                                "${double.parse(updatedTotalPrice) - double.parse(updatedTaxPrice)}Rs"),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Tax"),
                            Text(order.totalTaxCurrencyPrice),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Total"),
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
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              "Payment method",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        InkWell(
                          onTap: () {
                            // Navigate to the new screen when the card is tapped
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CardPayment(
                                        id: widget.id,
                                        table: widget.table,
                                        // total: 123,
                                        total: total,
                                        user: widget.user,
                                        orderId: order.id, order: order,
                                      )),
                            );
                          },
                          child: Card.outlined(
                            surfaceTintColor: whiteColor,
                            shadowColor: Colors.black,
                            elevation: 4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 8),
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
                                          const Text(
                                            "Card",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Image.asset(
                                              "assets/images/MasterCard.png"),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Text(
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
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        InkWell(
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
                                        orderId: order.id, order: order,
                                      )),
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
                                          const Text(
                                            "Cash",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Image.asset("assets/images/cash.png"),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "${total}Rs",
                                        style: const TextStyle(
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
                icon: const Icon(
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
                    child: const Icon(Icons.remove),
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
                    child: const Text('Cancel'),
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
