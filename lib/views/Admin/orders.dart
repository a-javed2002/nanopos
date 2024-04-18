import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nanopos/consts/consts.dart';
import 'package:nanopos/controller/admin_controller.dart';
import 'package:nanopos/controller/print_controller.dart';
import 'package:nanopos/views/Auth/login.dart';
import 'package:nanopos/views/Home/order.dart';

class AllOrdersScreen extends StatefulWidget {
  final LoginUser user;

  const AllOrdersScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<AllOrdersScreen> createState() => _AllOrdersScreenState();
}

class _AllOrdersScreenState extends State<AllOrdersScreen> {
  final AdminController adminController = Get.find();
  final PrintController printController = Get.find();

  @override
  void initState() {
    super.initState();
    adminController.fetchData("$domain/api/admin/table-order?payment_status=5",
        widget.user.token, adminController.order);
    printController.initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("All Orders"),
        ),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        onChanged: (value) {
                          adminController.searchQuery.value = value;
                          adminController.searchItem();
                          // print(adminController.filItem);
                        },
                        decoration: const InputDecoration(
                          hintText: 'Search',
                          hintStyle: TextStyle(
                            color: blackColor,
                          ),
                          icon: Icon(
                            Icons.search,
                            color: greyColor,
                          ),
                          border: InputBorder.none,
                          // suffixIcon: adminController.searchQuery.isNotEmpty
                          //     ? IconButton(
                          //         icon: Icon(
                          //           Icons.clear,
                          //           color: Theme.of(context)
                          //               .textTheme
                          //               .bodyText1!
                          //               .color,
                          //         ),
                          //         onPressed: () {
                          //           if (kDebugMode) {
                          //             print("clearing");
                          //           }
                          //           setState(() {
                          //             adminController.searchQuery.value = '';
                          //           });
                          //         },
                          //       )
                          //     : null,
                        ),
                        style: const TextStyle(
                          color: greyColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: Obx(() {
                if (adminController.order.isEmpty) {
                  return const Center(
                      // child: CircularProgressIndicator(),
                      // child: Text("No Orders Available 1"),
                      );
                } else {
                  if (adminController.filOrder.isEmpty) {
                    return const Center(
                      child: Text("No Orders Available"),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: adminController.filOrder.length,
                      itemBuilder: (context, index) {
                        final order = adminController.filOrder[index];
                        //make a list to show all orders
                        return _buildOrderItem(order, context);
                      },
                    );
                  }
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(Map<String, dynamic> orderMap, BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text('Order Serial No: ${orderMap['order_serial_no']}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Total Price: ${orderMap['total_currency_price']}'),
              Text('Date Time: ${orderMap['order_datetime']}'),
            ],
          ),
          trailing: InkWell(
              onTap: () {
                if (orderMap != null) {
                  if (orderMap.isNotEmpty) {
                    // Extract order items data from the JSON map
                    List<dynamic> orderItemsList =
                        orderMap['order_items'] ?? [];
                    List<OrderItems> orderItems = [];

                    for (var item in orderItemsList) {
                      OrderItems orderItem = OrderItems(
                          oId: item['id'].toString(),
                          id: item['item_id'].toString(),
                          itemName: item['item_name'],
                          itemImage: item['item_image'],
                          quantity: item['quantity'],
                          price: item['price'],
                          instruction: item['instruction'],
                          totalConvertPrice:
                              item['total_convert_price']!.toString(),
                          taxRate: item['tax_rate']!.toString(),
                          itemVariationCurrencyTotal:
                              item['item_variation_currency_total']!.toString(),
                          itemExtraCurrencyTotal:
                              item['item_extra_currency_total']!.toString(),
                          itemVariations: item['item_variations'],
                          itemExtras: item['item_extras']);

                      orderItems.add(orderItem);
                    }

                    Order order = Order(
                        id: orderMap['id'].toString(),
                        orderSerialNo: orderMap['order_serial_no'],
                        status: -1,
                        statusName: orderMap['status_name'],
                        orderDatetime: orderMap['order_datetime'],
                        totalCurrencyPrice: orderMap['total_currency_price'],
                        orderItems: orderItems,
                        subtotal_currency_price:
                            orderMap['total_currency_price'],
                        subtotal_without_tax_currency_price:
                            orderMap['total_currency_price'],
                        discount_currency_price:
                            orderMap['total_currency_price'],
                        total_currency_price: orderMap['total_currency_price'],
                        totalTaxCurrencyPrice:
                            orderMap['total_currency_price']);

                    printController.printDialog(
                        context: context, order: order, user: widget.user);
                  }
                } else {
                  printController.showToast(
                      context: context, message: "Order Detail is Empty");
                }
              },
              child: const Icon(Icons.print, color: mainColor)),
          onTap: () {
            _showOrderDetailsDialog(context, orderMap);
          },
        ),
        const Divider(), // Divider widget to add a line between ListTiles
      ],
    );
  }

  void _showOrderDetailsDialog(
      BuildContext context, Map<String, dynamic> orderData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Order Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Order Serial No: ${orderData['order_serial_no']}'),
              const SizedBox(height: 8),
              Text('Total Price: ${orderData['total_currency_price']}'),
              const SizedBox(height: 8),
              // Assuming 'status_name' is present in the response
              Text('Status: ${orderData['status_name'] ?? 'Unknown'}'),
              const SizedBox(height: 16),
              const Text('Order Items:'),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: (orderData['order_items'] as List).map((item) {
                  return Text(
                      '${item['item_name']} - Quantity: ${item['quantity']}');
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
