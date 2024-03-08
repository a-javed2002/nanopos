import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nanopos/forgetPassword.dart';
import 'dart:convert';
import 'package:nanopos/home.dart';
import 'package:nanopos/loader.dart';
import 'package:nanopos/sidebar.dart';
import 'package:nanopos/signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _showPassword = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController =
        TextEditingController(text: 'Waiter@example.co');
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
                      fillColor: Colors.white.withOpacity(0.5),
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
                      Checkbox(
                        value: false, // Add logic for handling remember me
                        onChanged: (value) {
                          // Add logic for handling remember me
                        },
                      ),
                      const Text('Remember me'),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          // Add logic for forgot password
                          Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ForgetPasswordScreen()
                                    ),
                                  );
                        },
                        child: const Text('Forgot Password?',style: TextStyle(color: Colors.black),),
                      ),
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
                            onPressed: () async {
                              setState(() {
                                isLoading =
                                    true; // Set isLoading to true before signup
                              });
                              // Your logic to get the token and make the HTTP request
                              if (kDebugMode) {
                                print("Logging in");
                              }
                              var data = {
                                "email": emailController.text,
                                "password": passwordController.text
                              };
                              var response = await http.post(
                                Uri.parse(
                                    'https://restaurant.nanosystems.com.pk/api/auth/login'),
                                body: jsonEncode(data),
                                headers: {
                                  'Content-Type':
                                      'application/json; charset=UTF-8',
                                  'X-Api-Key':
                                      'b6d68vy2-m7g5-20r0-5275-h103w73453q120'
                                },
                              );
                              if (kDebugMode) {
                                print(response.statusCode);
                              }

                              if (response.statusCode == 200 ||
                                  response.statusCode == 201) {
                                // Extract response body
                                var responseBody = jsonDecode(response.body);
                                if (kDebugMode) {
                                  print(responseBody);
                                }
                                var user = responseBody['user'];
                                var username = user['username'];
                                var email = user['email'];
                                var image = user['image'];
                                var token = responseBody['token'];
                                int role =
                                    int.parse(user['role_id'].toString());

                                    setState(() {
                                    isLoading =
                                        false; // Set isLoading to true before signup
                                  });

                                if (role == 7 || role == 6) {
                                  // Navigate to the next page
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => SideBarScreen(
                                  //       name: username,
                                  //       email: email,
                                  //       image: image,
                                  //     )
                                  //   ),
                                  // );
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MyHomePage(
                                        name: username,
                                        email: email,
                                        image: image,
                                        token: token,
                                        roleId: role,
                                      ),
                                    ),
                                  );
                                } else {
                                  setState(() {
                                    isLoading =
                                        false; // Set isLoading to true before signup
                                  });
                                  _showDialog();
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => MyHomePage(
                                  //       name: username,
                                  //       email: email,
                                  //       image: image,
                                  //       token: token,
                                  //       roleId: role,
                                  //     ),
                                  //   ),
                                  // );
                                }
                              }
                            },
                            child: const Text(
                              "Log in",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 45),
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    12), // Adjust the radius as needed
                              ),
                              backgroundColor: const Color(0xffa14716),
                            ),
                            onPressed: () async {
                              Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SignupScreen()
                                    ),
                                  );
                            },
                            child: const Text(
                              "Sign up",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Warning!"),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Invalid credentials or you are blocked",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "kindly contact Adminitration",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
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
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}
