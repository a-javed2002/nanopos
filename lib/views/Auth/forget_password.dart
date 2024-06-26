import 'package:flutter/material.dart';
import 'package:nanopos/views/common/loader.dart';
import 'package:nanopos/views/Auth/login.dart';
import 'package:nanopos/consts/consts.dart';


class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}): super(key: key);

  @override
  ForgetPasswordScreenState createState() => ForgetPasswordScreenState();
}

class ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final bool _showPassword = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController =
        TextEditingController();

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
                    "Forget Password",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  const Center(
                    child: Text(
                      "Enter you email associated with your account  and we'll send an email with instructions to reset your password e",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,),
                    ),
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
                  const SizedBox(
                    height: 10,
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
                              
                            },
                            child: const Text(
                              "Send Link",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20,
                                  color: whiteColor),
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
                                      builder: (context) => const LoginScreen()
                                    ),
                                  );
                            },
                            child: const Text(
                              "Back to Login",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20,
                                  color: whiteColor),
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
}
