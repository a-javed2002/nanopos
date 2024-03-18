import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nanopos/controller/cartController.dart';
import 'package:nanopos/views/detail.dart';
import 'package:nanopos/views/login.dart';
import 'package:nanopos/views/order_placed.dart';

class CartScreen extends StatelessWidget {
  final loginUser user;
  final String id;
  final String table;

  const CartScreen({
    Key? key,
    required this.user,
    required this.id,
    required this.table,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final CartController cartController = Get.put(CartController());
    final CartController cartController = Get.find();

    return SafeArea(
      child: Scaffold(
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
                print("Place Order");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderPlaced(
                      user: user,
                    ),
                  ),
                );
              }
            },
            child: const Text(
              'Place Order',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        appBar: AppBar(
          title: Text("Cart"),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
            onPressed: () {
              // cartController.clearCart();
              cartController.clearCartForTable();
            }),
        body: Obx(() {
          final cartItems =
              cartController.cartMap[cartController.tableId.value];
          if (cartItems == null || cartItems.isEmpty) {
            return Center(
              child: Text('No items in the cart for table $table.'),
            );
          } else {
            return ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                print("--asd--- $cartItems");
                print("--asd2--- $item");
                // Convert item to CartObject
                return Text("dsajk");
                // final cartObject = CartObject(
                //   itemId: item['id'],
                //   name: item['name'],
                //   desc: item['desc'],
                //   image: item['image'],
                //   price: item['price'],
                //   qty: item['qty'],
                // );
                // return Card(
                //   child: ListTile(
                //     onTap: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => ProductDetail(),
                //         ),
                //       );
                //     },
                //     title: Text(
                //       cartObject.name,
                //       style:
                //           TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                //     ),
                //     subtitle: Text(
                //       cartObject.desc,
                //       style: TextStyle(fontSize: 10),
                //     ),
                //     leading: Image.asset(
                //       cartObject.image,
                //       width: 60,
                //       height: 60,
                //     ),
                //     trailing: Row(
                //       mainAxisSize: MainAxisSize.min,
                //       children: [
                //         IconButton(
                //           icon: Icon(Icons.remove),
                //           onPressed: () {
                //             cartController.decreaseQty(cartObject);
                //           },
                //         ),
                //         Text(
                //           cartObject.qty.toString(),
                //           style: TextStyle(fontWeight: FontWeight.bold),
                //         ),
                //         IconButton(
                //           icon: Icon(Icons.add),
                //           onPressed: () {
                //             cartController.increaseQty(cartObject);
                //           },
                //         ),
                //       ],
                //     ),
                //   ),
                // );
              },
            );
          }
        }),
      ),
    );
  }
}
