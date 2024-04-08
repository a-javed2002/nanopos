import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nanopos/controller/printController.dart';
import 'package:nanopos/views/Home/home.dart';
import 'package:nanopos/views/Auth/login.dart';
import 'package:nanopos/consts/consts.dart';
import 'package:http/http.dart' as http;
import 'package:nanopos/views/Print/testprint.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:nanopos/views/Home/order.dart';

class PaymentPaidScreen extends StatefulWidget {
  final loginUser user;
  final Order order;
  const PaymentPaidScreen({Key? key, required this.user, required this.order})
      : super(key: key);

  @override
  State<PaymentPaidScreen> createState() => _PaymentPaidScreenState();
}

class _PaymentPaidScreenState extends State<PaymentPaidScreen> {
  final PrintController printController = Get.find();

  @override
  void initState() {
    super.initState();
    printController.initPlatformState();
    Timer(Duration(seconds: 3), () {
      // _redirectHome();
    });
  }

  void _redirectHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MyHomePage(
          user: widget.user,
        ),
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
          Image.asset("assets/gifs/payment.gif"),
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
                style: TextStyle(color: whiteColor),
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
                printController.printDialog(context: context,order: widget.order,user: widget.user);
              },
              child: Text(
                "Print",
                style: TextStyle(color: whiteColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
