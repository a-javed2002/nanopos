import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nanopos/OnBoarding/onBoarding.dart';
import 'package:nanopos/views/Auth/login.dart';
import 'package:nanopos/views/home.dart';
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

    // Retrieve user object JSON string from shared preferences
    String? userJson = prefs.getString('userObj');

// Convert user object JSON string back to a Map
    Map<String, dynamic>? userMap = jsonDecode(userJson ?? '');

// Create a new loginUser object from the Map
    loginUser userObj = loginUser.fromJson(userMap ?? {});

    // Wait for 2 seconds
    await Future.delayed(Duration(seconds: 2));

    // Redirect to appropriate screen based on login status
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) => isOnBoard
            ? isLoggedIn
                ? MyHomePage(
                    user: userObj,
                  )
                : LoginScreen()
            : OnBoardingScreen(), // Replace LoginPage with your login screen widget
      ),
    );
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
