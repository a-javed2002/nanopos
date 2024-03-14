import 'package:flutter/material.dart';
import 'package:nanopos/views/login.dart';
import 'package:nanopos/views/order_placed.dart';
import 'package:nanopos/views/payment_done.dart';

class CashPayment extends StatefulWidget {
  final loginUser user;
  final String table;
  final String id;
  final double total;

  CashPayment({
    Key? key,
    required this.id,
    required this.user,
    required this.table,
    required this.total,
  }) : super(key: key);

  @override
  _CashPaymentState createState() => _CashPaymentState();
}

class _CashPaymentState extends State<CashPayment> {
  final _paidController = TextEditingController();

  double _paidAmount = 0;
  double _amountToReturn = 0;

  @override
  void initState() {
    super.initState();
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

  void _handlePaidButtonPressed() {
    if (_paidAmount >= widget.total) {
      _showThanksgivingScreen();
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
        title: Text('Cashier Screen'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              enabled: false,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Total Amount',
                suffixText: '${widget.total}',
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
