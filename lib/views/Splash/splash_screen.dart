import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nanopos/OnBoarding/onBoarding.dart';
import 'package:nanopos/views/Auth/login.dart';
import 'package:nanopos/views/Home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({Key? key}) : super(key: key);

  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    redirectUser();
  }

  Future<void> redirectUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    bool isOnBoard = prefs.getBool('isOnBoard') ?? false;

    print("Redirecting...");

    if (isLoggedIn) {
      // Retrieve user object JSON string from shared preferences
      String id = prefs.getString('id') ?? '';
      String bid = prefs.getString('bid') ?? '';
      String email = prefs.getString('email') ?? '';
      String image = prefs.getString('image') ?? '';
      String username = prefs.getString('username') ?? '';
      String roleId = prefs.getString('roleId') ?? '';
      String token = prefs.getString('token') ?? '';
      String firstName = prefs.getString('firstName') ?? '';
      String lastName = prefs.getString('lastName') ?? '';
      String phone = prefs.getString('phone') ?? '';

      if(id==''||bid==''||email==''||image==''||username==''||roleId==''||token==''){
        Get.off(const LoginScreen());
      }

// Create a new loginUser object from the Map
      loginUser userObj =  loginUser(
          id: id.toString(),
          bid: bid.toString(),
          email: email,
          image: image,
          roleId: int.parse(roleId),
          name: firstName,
          lastName: lastName,
          phone: phone,
          username: username,
          token: token);

      Get.off(MyHomePage(
        user: userObj,
      ));
    } else if (isOnBoard) {
      Get.off(LoginScreen());
    } else {
      Get.off(OnBoardingScreen());
    }

    // Wait for 2 seconds
    // await Future.delayed(Duration(seconds: 2));

    // Redirect to appropriate screen based on login status
    // Navigator.of(context).pushReplacement(
    //   MaterialPageRoute(
    //     builder: (BuildContext context) => isOnBoard
    //         ? isLoggedIn
    //             ? MyHomePage(
    //                 user: userObj,
    //               )
    //             : LoginScreen()
    //         : OnBoardingScreen(), // Replace LoginPage with your login screen widget
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset("assets/images/logo.png"),
      ),
    );
  }
}
