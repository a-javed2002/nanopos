import 'package:flutter/material.dart';
import 'package:nanopos/views/Auth/login.dart';
import 'package:nanopos/consts/consts.dart';
import 'package:nanopos/views/Home/order.dart';

class SentToKitchen extends StatelessWidget {
  final LoginUser user;
  final String table;
  final String id;
  const SentToKitchen({
    Key? key,
    required this.user,
    required this.table,
    required this.id
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("assets/gifs/chef.gif"),
          const Text(
            "Chef Get it!",
            style: TextStyle(
                fontSize: 25,
                color: Color(0xffa14716),
                fontWeight: FontWeight.bold),
          ),
          const Text(
            "Wait Patiently",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: const Center(
              child: Text(
                "You will be redirected to Back shortly or click here to return to the home page",
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
                    builder: (context) => OrdersScreen(
                      user: user,
                      id: id,
                      table: table,
                    ),
                  ),
                );
              },
              child: const Text(
                "Back",
                style: TextStyle(color: whiteColor),
              ),
            ),
          )
        ],
      ),
    );
  }
}
