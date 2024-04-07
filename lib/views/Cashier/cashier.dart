import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nanopos/views/Print/testprint.dart';
import 'package:nanopos/views/Cashier/cardPayment.dart';
import 'package:nanopos/views/Cashier/cashPaymet.dart';

import 'package:nanopos/views/Auth/login.dart';
import 'package:nanopos/views/Home/order.dart';
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

  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _device;
  bool _connected = false;
  TestPrint testPrint = TestPrint();

  @override
  void initState() {
    super.initState();
    initPlatformState();
    order = widget.orderrs;
    updatedTotalPrice = (order.totalCurrencyPrice).replaceAll("Rs", "");
    updatedTaxPrice = (order.total_tax_currency_price).replaceAll("Rs", "");
  }

  Future<void> initPlatformState() async {
    // TODO here add a permission request using permission_handler
    // if permission is not granted, kzaki's thermal print plugin will ask for location permission
    // which will invariably crash the app even if user agrees so we'd better ask it upfront

    // var statusLocation = Permission.location;
    // if (await statusLocation.isGranted != true) {
    //   await Permission.location.request();
    // }
    // if (await statusLocation.isGranted) {
    // ...
    // } else {
    // showDialogSayingThatThisPermissionIsRequired());
    // }
    bool? isConnected = await bluetooth.isConnected;
    List<BluetoothDevice> devices = [];
    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {}

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          setState(() {
            _connected = true;
            print("bluetooth device state: connected");
          });
          break;
        case BlueThermalPrinter.DISCONNECTED:
          setState(() {
            _connected = false;
            print("bluetooth device state: disconnected");
          });
          break;
        case BlueThermalPrinter.DISCONNECT_REQUESTED:
          setState(() {
            _connected = false;
            print("bluetooth device state: disconnect requested");
          });
          break;
        case BlueThermalPrinter.STATE_TURNING_OFF:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth turning off");
          });
          break;
        case BlueThermalPrinter.STATE_OFF:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth off");
          });
          break;
        case BlueThermalPrinter.STATE_ON:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth on");
          });
          break;
        case BlueThermalPrinter.STATE_TURNING_ON:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth turning on");
          });
          break;
        case BlueThermalPrinter.ERROR:
          setState(() {
            _connected = false;
            print("bluetooth device state: error");
          });
          break;
        default:
          print(state);
          break;
      }
    });

    if (!mounted) return;
    setState(() {
      _devices = devices;
    });

    if (isConnected == true) {
      setState(() {
        _connected = true;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Center(
              child: Text(
                "Payment",
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
                            SizedBox(width: 40),
                            IconButton(
                                onPressed: () {
                                  printDialog();
                                }, icon: const Icon(Icons.print))
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
                                      orderId: order.id,order: order,)),
                            );
                          },
                          child: Card.outlined(
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
                        ),
                        SizedBox(
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
                                      orderId: order.id,order: order,)),
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

  void printDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Print"),
            content: ListView(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(width: 10),
                    const Text(
                      'Device:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                      const SizedBox(width: 22),
                    Expanded(
                      child: DropdownButton(
                        items: _getDeviceItems(),
                        onChanged: (BluetoothDevice? value) =>
                            setState(() => _device = value),
                        value: _device,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown),
                      onPressed: () {
                        initPlatformState();
                      },
                      child: const Text(
                        'Refresh',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              _connected ? Colors.red : Colors.green),
                      onPressed: _connected ? _disconnect : _connect,
                      child: Text(
                        _connected ? 'Disconnect' : 'Connect',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, right: 10.0, top: 50),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown),
                    onPressed: () {
                      testPrint.printBill(order: widget.orderrs,status: "Unpaid",user: widget.user);
                    },
                    child: const Text('Print Slip',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          );
        });
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devices.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      _devices.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name ?? ""),
          value: device,
        ));
      });
    }
    return items;
  }

  void _connect() {
    if (_device != null) {
      bluetooth.isConnected.then((isConnected) {
        if (isConnected == false) {
          bluetooth.connect(_device!).catchError((error) {
            setState(() => _connected = false);
          });
          setState(() => _connected = true);
        }
      });
    } else {
      show('No device selected.');
    }
  }

  void _disconnect() {
    bluetooth.disconnect();
    setState(() => _connected = false);
  }

  Future show(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) async {
    await new Future.delayed(new Duration(milliseconds: 100));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        duration: duration,
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
