import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nanopos/views/Auth/login.dart';
import 'package:nanopos/views/StatusScreens/order_placed.dart';
import 'package:nanopos/views/StatusScreens/payment_done.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CashPayment extends StatefulWidget {
  final loginUser user;
  final String table;
  final String id;
  final double total;
  final String orderId;

  CashPayment({
    Key? key,
    required this.id,
    required this.user,
    required this.table,
    required this.total,
    required this.orderId,
  }) : super(key: key);

  @override
  _CashPaymentState createState() => _CashPaymentState();
}

class _CashPaymentState extends State<CashPayment> {
  final _paidController = TextEditingController();
  TextEditingController totalAmountController = TextEditingController();

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
            'http://restaurant.nanosystems.com.pk/api/admin/table-order/change-payment-status/${widget.orderId}'),
        body: jsonEncode(data),
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
        print("paid");
        // Extract response body
        var responseBody = jsonDecode(response.body);
        if (kDebugMode) {
          print(responseBody);
          print("Paid");
          _showThanksgivingScreen();
        }
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

  void _showThanksgivingScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPaidScreen(
          user: widget.user,
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
          mainAxisAlignment: MainAxisAlignment.center,
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
            ElevatedButton(
              onPressed: (_paidAmount >= widget.total)
                  ? _handlePaidButtonPressed
                  : null,
              child: Text('Paid'),
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
