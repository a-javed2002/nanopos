import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nanopos/views/Auth/forgetPassword.dart';
import 'dart:convert';
import 'package:nanopos/views/Home/home.dart';
import 'package:nanopos/views/common/loader.dart';
import 'package:nanopos/views/Menu/menu.dart';
import 'package:nanopos/views/Auth/signup.dart';
import 'package:nanopos/controller/apiController.dart';
import 'package:nanopos/consts/consts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final ApiController _apiController = Get.find();
  bool _showPassword = false;
  bool isLoading = false;

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
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
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
                        borderSide: BorderSide(
                          color: Colors.black, // Border color
                          width: 4.0, // Border width
                        ),
                      ),
                    ),
                    obscureText: !_showPassword,
                  ),
                  Row(
                    children: [
                      // Checkbox(
                      //   value: false, // Add logic for handling remember me
                      //   onChanged: (value) {
                      //     // Add logic for handling remember me
                      //   },
                      // ),
                      // const Text('Remember me'),
                      const Spacer(),
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
                  isLoading
                      ? CustomLoader()
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
                            onPressed: () {
                              if (emailController.text == '' &&
                                  passwordController.text == '') {
                                _showDialog("Warning",
                                    "Email & Password is Required", "");
                              } else if (emailController.text == '') {
                                _showDialog("Warning", "Email is Required", "");
                              } else if (passwordController.text == '') {
                                _showDialog(
                                    "Warning", "Password is Required", "");
                              } else {
                                login(emailController.text,
                                    passwordController.text);
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
                        ),
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

  void login(String email, String password) async {
    setState(() {
      isLoading = true; // Set isLoading to true before signup
    });
    // Your logic to get the token and make the HTTP request
    if (kDebugMode) {
      print("Logging in");
    }
    var data = {"email": email, "password": password};
    var response = await http.post(
      Uri.parse('$domain/api/auth/login'),
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Api-Key': xApi,
      },
    );
    if (kDebugMode) {
      print(response.statusCode);
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        isLoading = false; // Set isLoading to true before signup
      });
      // Extract response body
      var responseBody = jsonDecode(response.body);
      if (kDebugMode) {
        print("Login response $responseBody");
      }
      var user = responseBody['user'];
      var id = user['id'];
      var bid = responseBody['branch_id'];
      var username = user['username'];
      var email = user['email'];
      var image = user['image'];
      var firstName = user['first_name'];
      var lastName = user['last_name'];
      var phone = user['phone'];
      var token = responseBody['token'];
      int role = int.parse(user['role_id'].toString());

      if (role == 7 || role == 6) {
        var obj = new loginUser(
            id: id.toString(),
            bid: bid.toString(),
            email: email,
            image: image,
            name: firstName,
            username: username,
            lastName: lastName,
            phone: phone,
            roleId: role,
            token: token);
        // Save logged-in status and token to shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('id', id.toString());
        await prefs.setString('bid', bid.toString());
        await prefs.setString('email', email);
        await prefs.setString('image', image);
        await prefs.setString('username', username);
        await prefs.setString('firstName', username);
        await prefs.setString('lastName', username);
        await prefs.setString('phone', username);
        await prefs.setString('roleId', role.toString());
        await prefs.setString('token', token);

        var xyz = await loadData(token);
        Get.offAll(
          MyHomePage(user: obj),
        );
      } else {
        setState(() {
          isLoading = false; // Set isLoading to true before signup
        });
        var responseBody = jsonDecode(response.body);
        print(responseBody);
        _showDialog("Fail", "Technical Issue", "kindly contact Adminitration");
      }
      // _showDialog(
      //     "Fail", responseBody.toString(), "kindly contact Adminitration");
    } else {
      setState(() {
        isLoading = false; // Set isLoading to true before signup
      });
      var responseBody = jsonDecode(response.body);
      if (kDebugMode) {
        print("Failed Login response $responseBody");
      }
      if (responseBody.containsKey('errors')) {
        var errorMap = responseBody['errors'];
        if (errorMap.containsKey('validation')) {
          var errorMessage = errorMap['validation'];
          if (kDebugMode) {
            print('Error Message: $errorMessage');
          }
          _showDialog("Fail", "$errorMessage", "kindly contact Adminitration");
        }
      } else {
        _showDialog(
            "Fail", "Invalid Credentials", "kindly contact Adminitration");
      }
    }
  }

  Future<void> loadData(userToken) async {
    String catUrl = '$domain/api/admin/setting/item-category?order_type=desc';
    String itemUrl = '$domain/api/admin/item?order_type=desc';

    await _apiController.fetchData(catUrl, userToken, _apiController.cat,
        x: true);
    await _apiController.fetchData(itemUrl, userToken, _apiController.item);
  }

  void _showDialog(String title, String x, String sub) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  x,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  sub,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(12), // Adjust the radius as needed
                ),
                foregroundColor: const Color(0xff2a407c),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                // Perform logout action here
              },
              child: const Text("Ok"),
            ),
          ],
        );
      },
    );
  }
}

class loginUser {
  final String id;
  final String bid;
  final String email;
  final String image;
  final String name;
  final String username;
  final String lastName;
  final String phone;
  final int roleId;
  final String token;

  loginUser({
    required this.id,
    required this.bid,
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
  factory loginUser.fromJson(Map<String, dynamic> json) {
    return loginUser(
      id: json['id'],
      bid: json['bid'],
      email: json['email'],
      image: json['image'],
      name: json['first_name'],
      roleId: json['roleId'],
      token: json['token'],
      lastName: json['last_name'],
      phone: json['phone'],
      username: json['username']
    );
  }
}
