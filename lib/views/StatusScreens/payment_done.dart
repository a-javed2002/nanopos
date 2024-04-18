import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nanopos/controller/print_controller.dart';
import 'package:nanopos/views/Home/home.dart';
import 'package:nanopos/views/Auth/login.dart';
import 'package:nanopos/consts/consts.dart';
import 'package:nanopos/views/Home/order.dart';

class PaymentPaidScreen extends StatefulWidget {
  final LoginUser user;
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
    Timer(const Duration(seconds: 3), () {
      // _redirectHome();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("assets/gifs/payment.gif"),
          const Text(
            "THANK YOU!",
            style: TextStyle(
                fontSize: 25,
                color: Color(0xffa14716),
                fontWeight: FontWeight.bold),
          ),
          const Text(
            "PAYMENT DONE SUCCESSFULLY",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: const Center(
              child: Text(
                "You will be redirected to Dashboard shortly or click here to return to the home page",
                textAlign: TextAlign.center, // Align text to center
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 45),
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
                      user: widget.user,isLogin: false,
                    ),
                  ),
                );
              },
              child: const Text(
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
                printController.printDialog(context: context,order: widget.order,user: widget.user,billStatus: "paid");
              },
              child: const Text(
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
