import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nanopos/consts/consts.dart';
import 'package:nanopos/controller/adminController.dart';
import 'package:nanopos/views/Auth/login.dart';
import 'package:nanopos/views/StatusScreens/order_placed.dart';
import 'package:nanopos/views/StatusScreens/payment_done.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:nanopos/views/Home/order.dart';

class CashPayment extends StatefulWidget {
  final loginUser user;
  final String table;
  final String id;
  final double total;
  final String orderId;
  final Order order;

  CashPayment({
    Key? key,
    required this.id,
    required this.user,
    required this.table,
    required this.total,
    required this.orderId,
    required this.order,
  }) : super(key: key);

  @override
  _CashPaymentState createState() => _CashPaymentState();
}

class _CashPaymentState extends State<CashPayment> {
  final _paidController = TextEditingController();
  TextEditingController totalAmountController = TextEditingController();
  final AdminController adminController = Get.find();

  double _paidAmount = 0;
  double _amountToReturn = 0;

  @override
  void initState() {
    super.initState();
    totalAmountController.text = widget.total.toString();
    _paidController.addListener(_calculateAmountToReturn);
  }

  @override
  void dispose() {
    _paidController.dispose();
    super.dispose();
  }

  void _calculateAmountToReturn() {
    setState(() {
      _paidAmount = double.tryParse(_paidController.text) ?? 0;
      _amountToReturn =
          (_paidAmount >= widget.total) ? (_paidAmount - widget.total) : 0;
    });
  }

  void _handlePaidButtonPressed() async {
    if (_paidAmount >= widget.total) {
      var data = {"id": widget.orderId, "payment_status": 5};
      var response = await http.post(
        Uri.parse(
            '$domain/api/admin/table-order/change-payment-status/${widget.orderId}'),
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'X-Api-Key': xApi,
          'Authorization': 'Bearer ${widget.user.token}',
        },
      );
      if (kDebugMode) {
        print(response.statusCode);
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("paid");
        adminController.setLocal(widget.order);
        // Extract response body
        var responseBody = jsonDecode(response.body);
        if (kDebugMode) {
          print(responseBody);
          print("Paid");
          _showThanksgivingScreen();
        }
      }
      else if (response.statusCode == 401) {
        var responseBody = jsonDecode(response.body);
        sessionExpire("Session Expired,Please Log In Again");
      }
      else{
        String responseBody = jsonDecode(response.body);
        sessionExpire(responseBody);
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Insufficient Payment'),
            content: Text(
                'The paid amount must be greater than or equal to the total amount.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void sessionExpire(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Failed"),
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
                message,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: (){
                Get.offAll(
                    LoginScreen(),
                  );
              }, child: Text("Log In Again"))
            ],
          ),
        );
      },
    );
  }

  void _showThanksgivingScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPaidScreen(
          user: widget.user,
          order: widget.order,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Cash Payment - ${widget.orderId}'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              enabled: false,
              controller: totalAmountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Total Amount',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _paidController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Paid Amount'),
            ),
            SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 14.0, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        12), // Adjust the radius as needed
                  ),
                  backgroundColor: const Color(0xffa14716),
                  foregroundColor: whiteColor
                ),
                onPressed: (_paidAmount >= widget.total)
                    ? _handlePaidButtonPressed
                    : null,
                child: Text('Paid'),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Amount to return: ${_amountToReturn.toStringAsFixed(2)}',
            ),
          ],
        ),
      ),
    );
  }
}
