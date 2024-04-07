import 'package:flutter/material.dart';
import 'package:nanopos/views/Auth/login.dart';
import 'package:nanopos/views/Home/order.dart';

class CardPayment extends StatelessWidget {
  final loginUser user;
  final String table;
  final String id;
  final double total;
  final String orderId;
  final Order order;

  CardPayment({
    Key? key,
    required this.id,
    required this.user,
    required this.table,
    required this.total,
    required this.orderId,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("Debit/Credit"),
      ),
      body: Column(
        children: [
          Center(
            child: ElevatedButton(onPressed: () {}, child: Text("Scan Card")),
          )
        ],
      ),
    ));
  }
}
