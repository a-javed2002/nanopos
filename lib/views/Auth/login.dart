import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nanopos/controller/api_controller.dart';
import 'package:nanopos/controller/auth_controller.dart';
import 'package:nanopos/views/Home/home.dart';
import 'package:nanopos/views/common/loader.dart';
import 'package:nanopos/consts/consts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final AuthController _authController = Get.find();
  final ApiController _apiController = Get.find();
  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController =
        TextEditingController(text: 'w@w.com');
    TextEditingController passwordController =
        TextEditingController(text: '123456');

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                "assets/images/login.png",
                fit: BoxFit.cover,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  Image.asset("assets/images/logo.png"),
                  const Text(
                    "Welcome Back!",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  const Text(
                    "Log in to continue",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color(0xff924B1C)),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email',
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: const BorderSide(
                          color: Colors.black, // Border color
                          width: 4.0, // Border width
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: whiteColor.withOpacity(0.5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: const BorderSide(
                          color: Colors.black, // Border color
                          width: 4.0, // Border width
                        ),
                      ),
                    ),
                    obscureText: !_showPassword,
                  ),
                  const Row(
                    children: [
                      // Checkbox(
                      //   value: false, // Add logic for handling remember me
                      //   onChanged: (value) {
                      //     // Add logic for handling remember me
                      //   },
                      // ),
                      // const Text('Remember me'),
                      Spacer(),
                      // TextButton(
                      //   onPressed: () {
                      //     // Add logic for forgot password
                      //     Navigator.pushReplacement(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => ForgetPasswordScreen()),
                      //     );
                      //   },
                      //   child: const Text(
                      //     'Forgot Password?',
                      //     style: TextStyle(color: Colors.black),
                      //   ),
                      // ),
                    ],
                  ),
                 Obx(() =>  _authController.isLoading.value
                      ? const CustomLoader()
                      : Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 25),
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
                            ),
                            onPressed: () async {
                              if (emailController.text == '' &&
                                  passwordController.text == '') {
                                _authController.showDialogBox(
                                    "Warning",
                                    "Email & Password is Required",
                                    "",
                                    context);
                              } else if (emailController.text == '') {
                                _authController.showDialogBox("Warning",
                                    "Email is Required", "", context);
                              } else if (passwordController.text == '') {
                                _authController.showDialogBox("Warning",
                                    "Password is Required", "", context);
                              } else {
                                bool response = await _authController.login(
                                    emailController.text,
                                    passwordController.text,
                                    context);

                                if (response) {
                                  bool xyz = await loadData(
                                      _authController.loggedInUser.token);
                                  if (xyz) {
                                    if (kDebugMode) {
                                      print("Successfully saved on local");
                                    }
                                  } else {
                                    if (kDebugMode) {
                                      print("Unsuccessfully saved on local");
                                    }
                                  }
                                  Get.offAll(
                                    MyHomePage(
                                      user: _authController.loggedInUser,
                                      isLogin: true,
                                    ),
                                  );
                                } else {
                                  if (kDebugMode) {
                                    print("Login Failed");
                                  }
                                }
                              }
                            },
                            child: const Text(
                              "Log in",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20,
                                  color: whiteColor),
                            ),
                          ),
                        ),)
                  // Container(
                  //   margin: const EdgeInsets.symmetric(
                  //       vertical: 12, horizontal: 45),
                  //   width: double.infinity,
                  //   child: ElevatedButton(
                  //     style: ElevatedButton.styleFrom(
                  //       padding: const EdgeInsets.symmetric(
                  //           vertical: 10.0, horizontal: 10),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(
                  //             12), // Adjust the radius as needed
                  //       ),
                  //       backgroundColor: const Color(0xffa14716),
                  //     ),
                  //     onPressed: () async {
                  //       Navigator.pushReplacement(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => SignupScreen()),
                  //       );
                  //     },
                  //     child: const Text(
                  //       "Sign up",
                  //       style: TextStyle(
                  //           fontWeight: FontWeight.w400,
                  //           fontSize: 20,
                  //           color: whiteColor),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> loadData(userToken) async {
    try {
      String catUrl = '$domain/api/admin/setting/item-category?order_type=desc';
      String itemUrl = '$domain/api/admin/item?order_type=desc';

      await _apiController.fetchData(catUrl, userToken, _apiController.cat,
          x: true);
      await _apiController.fetchData(itemUrl, userToken, _apiController.item);
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
    return true;
  }
}

class LoginUser {
  final String id;
  final String bid;
  final String bName;
  final String email;
  final String image;
  final String name;
  final String username;
  final String lastName;
  final String phone;
  final int roleId;
  final String token;

  LoginUser({
    required this.id,
    required this.bid,
    required this.bName,
    required this.email,
    required this.image,
    required this.name,
    required this.username,
    required this.lastName,
    required this.phone,
    required this.roleId,
    required this.token,
  });

  // Factory method to create a loginUser object from a Map
  factory LoginUser.fromJson(Map<String, dynamic> json) {
    return LoginUser(
        id: json['id'],
        bid: json['bid'],
        bName: json['bName'],
        email: json['email'],
        image: json['image'],
        name: json['first_name'],
        roleId: json['roleId'],
        token: json['token'],
        lastName: json['last_name'],
        phone: json['phone'],
        username: json['username']);
  }
}
