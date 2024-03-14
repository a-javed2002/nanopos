import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nanopos/views/home.dart';
import 'package:nanopos/views/login.dart';

class PaymentPaidScreen extends StatefulWidget {
  final loginUser user;
  const PaymentPaidScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<PaymentPaidScreen> createState() => _PaymentPaidScreenState();
}

class _PaymentPaidScreenState extends State<PaymentPaidScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      _redirectHome();
    });
  }

  void _redirectHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MyHomePage(user: widget.user,),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("assets/images/paid.png"),
          Text(
            "THANK YOU!",
            style: TextStyle(
                fontSize: 25,
                color: Color(0xffa14716),
                fontWeight: FontWeight.bold),
          ),
          Text(
            "PAYMENT DONE SUCCESSFULLY",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Center(
              child: Text(
                "You will be redirected to Dashboard shortly or click here to return to the home page",
                textAlign: TextAlign.center, // Align text to center
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 45),
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(12), // Adjust the radius as needed
                ),
                backgroundColor: const Color(0xffa14716),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(
                      user: widget.user,
                    ),
                  ),
                );
              },
              child: Text(
                "Dashboard",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
