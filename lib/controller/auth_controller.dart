import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nanopos/consts/consts.dart';
import 'package:nanopos/views/Auth/login.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;

  late LoginUser loggedInUser;

  Future<bool> login(
      String email, String password, BuildContext context) async {
    isLoading.value = true;
    if (kDebugMode) {
      print("Logging in ${isLoading.value}");
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
      isLoading.value = false;
      // Extract response body
      var responseBody = jsonDecode(response.body);
      if (kDebugMode) {
        print("Login response $responseBody");
      }
      var user = responseBody['user'];
      var id = user['id'];
      var bid = responseBody['branch_id'];
      var bName = "Main Branch";
      // var bName = responseBody['branch_name'];
      var username = user['username'];
      var email = user['email'];
      var image = user['image'];
      var firstName = user['first_name'];
      var lastName = user['last_name'];
      var phone = user['phone'];
      var token = responseBody['token'];
      int role = int.parse(user['role_id'].toString());

      if (role == 7 || role == 6) {
        loggedInUser = LoginUser(
            id: id.toString(),
            bid: bid.toString(),
            bName: bName,
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
        await prefs.setString('bName', bName.toString());
        await prefs.setString('email', email);
        await prefs.setString('image', image);
        await prefs.setString('username', username);
        await prefs.setString('firstName', username);
        await prefs.setString('lastName', username);
        await prefs.setString('phone', username);
        await prefs.setString('roleId', role.toString());
        await prefs.setString('token', token);

        return true;
      } else {
        isLoading.value = false;
        var responseBody = jsonDecode(response.body);
        if (kDebugMode) {
          print(responseBody);
        }
        showDialogBox(
            "Fail", "Technical Issue", "kindly contact Adminitration", context);
        return false;
      }
      // _showDialog(
      //     "Fail", responseBody.toString(), "kindly contact Adminitration");
    } else {
      isLoading.value = false;
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
          showDialogBox(
              "Fail", "$errorMessage", "kindly contact Adminitration", context);
        }
      } else {
        showDialogBox("Fail", "Invalid Credentials",
            "kindly contact Adminitration", context);
      }
      return false;
    }
  }

  void showDialogBox(String title, String x, String sub, BuildContext context) {
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
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  sub,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
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

  void showDialogLogin(BuildContext context) {
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

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Profile"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(loggedInUser.image),
                radius: 40,
              ),
              const SizedBox(height: 20),
              Text(
                loggedInUser.name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                loggedInUser.email,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              IconButton(
                onPressed: () {
                  Get.offAll(
                    const LoginScreen(),
                  );
                },
                icon: const Icon(Icons.logout, size: 40, color: redColor),
              ),
              const Row(
                children: [
                  // IconButton(
                  //   onPressed: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => const TodosScreen(),
                  //       ),
                  //     );
                  //   },
                  //   icon: const Icon(Icons.add, size: 40, color: Colors.brown),
                  // ),
                  // IconButton(
                  //   onPressed: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => CheckboxListScreen(),
                  //       ),
                  //     );
                  //   },
                  //   icon: const Icon(Icons.calculate_outlined,
                  //       size: 40, color: Color(0xFFFF2C2C)),
                  // ),
                  // IconButton(
                  //   onPressed: () {
                  //     HapticFeedback.vibrate();
                  //   },
                  //   icon: const Icon(Icons.calculate_outlined,
                  //       size: 40, color: Colors.yellow),
                  // ),
                  // IconButton(
                  //   onPressed: () {
                  //     Vibration.vibrate(duration: 2000);
                  //   },
                  //   icon:
                  //       const Icon(Icons.soap, size: 40, color: Colors.yellow),
                  // ),
                  // IconButton(
                  //   onPressed: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => const RingTonee(),
                  //       ),
                  //     );
                  //   },
                  //   icon: const Icon(Icons.g_translate,
                  //       size: 40, color: Colors.pink),
                  // ),
                ],
              )
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
                foregroundColor: const Color(0xfff3b98a),
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
