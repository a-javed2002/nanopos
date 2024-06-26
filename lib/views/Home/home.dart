import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nanopos/controller/admin_controller.dart';
import 'package:nanopos/controller/auth_controller.dart';
import 'package:nanopos/controller/print_controller.dart';
import 'package:nanopos/views/Admin/Orders.dart';
import 'package:nanopos/views/Auth/login.dart';
import 'dart:convert';
import 'package:nanopos/views/Home/order.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'package:nanopos/consts/consts.dart';

class MyHomePage extends StatefulWidget {
  final LoginUser user;
  final bool isLogin;

  const MyHomePage({Key? key, required this.user, required this.isLogin})
      : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Stream<List<dynamic>> _tablesStream;
  final AdminController adminController = Get.find();
  final AuthController _authController = Get.find();
  int call = 0;

  final PrintController printController = Get.find();
  final Connectivity _connectivity = Connectivity();
  // Define a getter for connectionStatus
  ConnectivityResult get connectionStatus => _connectionStatus;
  ConnectivityResult _connectionStatus = ConnectivityResult.none;

  // Define a getter for isConnected
  bool get isConnected => _connectionStatus != ConnectivityResult.none;

  @override
  void initState() {
    super.initState();
    _tablesStream = _fetchActiveTables();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _colorAnimation =
        ColorTween(begin: const Color(0xffa14716), end: const Color(0xfff3b98a))
            .animate(_controller)
          ..addListener(() {
            setState(() {});
          });

    _controller!.repeat(reverse: true);

    printController.initPlatformState();

    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    _connectionStatus = connectivityResult; // Update connectionStatus
    if (connectivityResult == ConnectivityResult.none) {
      Get.rawSnackbar(
          messageText: const Text('PLEASE CONNECT TO THE INTERNET',
              style: TextStyle(color: whiteColor, fontSize: 14)),
          isDismissible: false,
          duration: const Duration(days: 1),
          backgroundColor: redColorLight,
          icon: const Icon(
            Icons.wifi_off,
            color: whiteColor,
            size: 35,
          ),
          margin: EdgeInsets.zero,
          snackStyle: SnackStyle.GROUNDED);
    } else {
      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }
    }
  }

  Stream<List<dynamic>> _fetchActiveTables() async* {
    if (kDebugMode) {
      print("Fetching Tables ${widget.user.token}");
      print(widget.user.token);
    }
    while (true) {
      final response = await http.get(
        Uri.parse(
            '$domain/api/admin/dining-table?order_column=id&order_type=desc'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'X-Api-Key': xApi,
          'Authorization': 'Bearer ${widget.user.token}',
        },
      );

      if (kDebugMode) {
        // print(response.statusCode);
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic>? tablesData =
            responseData['data']; // Extracting the list of tables
        if (tablesData != null) {
          // Sort tables based on 'is_calling' and then 'isActive'
          tablesData.sort((a, b) {
            // Extract 'is_calling' and 'isActive' properties
            bool isCallingA = a['is_calling'] ?? false;
            bool isCallingB = b['is_calling'] ?? false;
            bool isActiveA = a['isActive'] ?? false;
            bool isActiveB = b['isActive'] ?? false;

            if (isCallingA != isCallingB) {
              // Sort by 'is_calling' first (true before false)
              return isCallingA
                  ? -1
                  : 1; // true (isCallingA) comes before false (isCallingB)
            } else {
              // 'is_calling' values are the same, sort by 'isActive' within false 'is_calling'
              if (!isCallingA) {
                return isActiveA
                    ? -1
                    : 1; // true (isActiveA) comes before false (isActiveB)
              } else {
                return 0; // maintain order for true 'is_calling' (shouldn't happen if different)
              }
            }
          });

          // print("$tablesData");
          int isCallingCount =
              tablesData.where((table) => table['is_calling'] == true).length;
          // print('Total number of is_calling: $isCallingCount');
          // isCallingCount++;
          if (isCallingCount > call) {
            //vibrate
            Vibration.vibrate(duration: 2000);
            call = isCallingCount;
          } else {
            call = isCallingCount;
          }

          yield tablesData;

          if (widget.isLogin) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('tables', json.encode(tablesData));
          }
        } else {
          throw Exception('Failed to parse table data');
        }
      } else {
        throw Exception('Failed to load active tables');
      }
      // break;
      // Delay before fetching tables again
      await Future.delayed(const Duration(seconds: 5));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xffa14716),
          title: const Text(
            "Dashboard",
            style: TextStyle(
              color: whiteColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          iconTheme: const IconThemeData(color: whiteColor),
          actions: [
            InkWell(
              onTap: () {
                _authController.showLogoutDialog(context);
              },
              child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Image.network(
                widget.user.image,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    // If the image is fully loaded, return the CircleAvatar
                    return CircleAvatar(
                      backgroundImage: NetworkImage(
                        widget.user.image,
                      ),
                    );
                  } else {
                    // If the image is still loading, return a CircularProgressIndicator
                    return const CircularProgressIndicator();
                  }
                },
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  // Return a fallback image in case of an error
                  return const CircleAvatar(
                    backgroundImage: AssetImage(
                      'assets/images/profile.png', // Provide the path to your fallback image
                    ),
                  );
                },
              ),
            ),
            ),
          ],
          toolbarHeight: 70,
        ),
        body: StreamBuilder<List<dynamic>>(
          stream: _tablesStream, // The stream to listen to for data updates
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show a loading indicator if data is still being fetched
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // Show an error message if an error occurs
              if (kDebugMode) {
                print(snapshot.error);
              } // Log the error for debugging
              return const Center(child: Text('Error: Connection'));
            } else {
              // If data is successfully loaded
              final List<dynamic> tables = snapshot.data ??
                  []; // Extract the list of tables from the snapshot

              // Sort tables based on the 'is_calling' property
              // tables.sort((a, b) {
              //   // Assuming 'is_calling' is a boolean property
              //   bool isCallingA = a['is_calling'] ?? false;
              //   bool isCallingB = b['is_calling'] ?? false;

              //   // Sort true values before false values
              //   if (isCallingA && !isCallingB) {
              //     return -1; // a should come before b
              //   } else if (!isCallingA && isCallingB) {
              //     return 1; // b should come before a
              //   } else {
              //     return 0; // maintain order if both are true or false
              //   }
              // });

              return GridView.builder(
                // Use GridView to display tables in a grid layout
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Display two tables in each row
                  crossAxisSpacing: 10.0, // Set spacing between columns
                  mainAxisSpacing: 10.0, // Set spacing between rows
                ),
                itemCount: tables.length, // Total number of tables
                itemBuilder: (context, index) {
                  // Build each table item
                  final table = tables[index]; // Get data for the current table
                  // table.sort(
                  //       (a, b) => b['isActive'].compareTo(a['isActive']),
                  //     );
                  if (kDebugMode) {
                    // print(table);
                    // print("${table['is_calling']}");
                  } // Log the error for debugging
                  // table['is_calling'] = table['id'] % 2 == 0 ? true : false;
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      onTap: () async {
                        if (widget.user.roleId == 7) {
                          if (table['is_calling'] == true) {
                            await changeStatus(table['id'].toString());
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrdersScreen(
                                user: widget.user,
                                id: table['id'].toString(),
                                table: table['name'].toString(),
                              ),
                            ),
                          );
                        } else if (widget.user.roleId == 6) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrdersScreen(
                                user: widget.user,
                                id: table['id'].toString(),
                                table: table['name'].toString(),
                              ),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrdersScreen(
                                user: widget.user,
                                id: table['id'].toString(),
                                table: table['name'].toString(),
                              ),
                            ),
                          );
                        }
                      },
                      child: Card(
                        color: table['is_calling'] == true
                            ? (_colorAnimation as Animation<Color?>).value
                            : table['isActive'] == true
                                ? const Color(0xfff3b98a)
                                : const Color(0xffffffff),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10.0), // Adjust the border radius as needed
                          side: const BorderSide(
                              color: Color(0xfff3b98a),
                              width: 1.0), // Add border side color & width
                        ),
                        elevation: 4,
                        child: Stack(
                          children: [
                            // Image at bottom right
                            // Positioned(
                            //   bottom: 0,
                            //   right: 0,
                            //   child: table['newOrders'] != 0
                            //       ? ColorFiltered(
                            //           colorFilter: ColorFilter.matrix(<double>[
                            //             -1, 0, 0, 0, 255, // Red
                            //             0, -1, 0, 0, 255, // Green
                            //             0, 0, -1, 0, 255, // Blue
                            //             0, 0, 0, 1, 0, // Alpha
                            //           ]),
                            //           child: Image.asset(
                            //             "assets/icons/Restaurant_Table.png",
                            //             width: 75,
                            //             height: 75,
                            //             fit: BoxFit.cover,
                            //           ),
                            //         )
                            //       : Image.asset(
                            //           "assets/icons/Restaurant_Table.png",
                            //           width: 75,
                            //           height: 75,
                            //           fit: BoxFit.cover,
                            //         ),
                            // ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Image.asset(
                                "assets/icons/Restaurant_Table.png",
                                width: 45,
                                height: 45,
                                fit: BoxFit.cover,
                              ),
                            ),
                            table['newOrders'] != 0
                                ? Positioned(
                                    top: 0,
                                    right: 5,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xffa14716),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Text(
                                          "${table['newOrders']}",
                                          style: const TextStyle(color: whiteColor),
                                        ),
                                      ),
                                    ))
                                : Container(),
                            // Text aligned to the left according to image
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  table['is_calling'] == true
                                      ? Text(
                                          table['name'].toString(),
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: whiteColor),
                                        )
                                      : table['isActive'] == true
                                          ? Text(
                                              table['name'].toString(),
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: whiteColor),
                                            )
                                          : Text(
                                              table['name'].toString(),
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xfff3b98a)),
                                            ),
                                  table['is_calling'] == true
                                      ? Text(
                                          "${table['size']} Persons",
                                          style: const TextStyle(
                                              fontSize: 10, color: whiteColor),
                                        )
                                      : table['isActive'] == true
                                          ? Text(
                                              "${table['size']} Persons",
                                              style: const TextStyle(
                                                  fontSize: 10,
                                                  color: whiteColor),
                                            )
                                          : Text(
                                              "${table['size']} Persons",
                                              style: const TextStyle(
                                                  fontSize: 10,
                                                  color: Color(0xfff3b98a)),
                                            ),
                                  // table['newOrders'] != 0
                                  //     ? Text(
                                  //         "${table['newOrders']} Orders",
                                  //         style: const TextStyle(
                                  //             fontSize: 18,
                                  //             color: whiteColor),
                                  //       )
                                  //     : Container(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
        drawer: Drawer(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: mainLightColor,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: whiteColor,
                          child: Icon(
                            Icons.filter_list,
                            size: 50,
                            color: mainLightColor,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Admin',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  onTap: () async {
                    if (kDebugMode) {

                    print("Print Last Bill ${printController.connected.value}");
                    }
                    Order? order = await adminController.getLocal();
                    if (order != null) {
                      printController.printDialog(
                          order: order,
                          context: context,
                          user: widget.user,
                          billStatus: "Paid");
                    } else {
                      if (kDebugMode) {

                      print("No Last Order");
                      }
                      printController.showToast(
                          context: context, message: "No Order Yet");
                    }
                  },
                  title: const Text("Print Last Bill"),
                  leading: const Icon(
                    Icons.print,
                    color: mainColor,
                  ),
                ),
                const Divider(),
                ListTile(
                  onTap: () {
                    if (kDebugMode) {

                    print("All Orders");
                    }
                    Get.to(AllOrdersScreen(
                      user: widget.user,
                    ));
                  },
                  title: const Text("See Paid Orders"),
                  leading: const Icon(
                    Icons.document_scanner,
                    color: mainColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> changeStatus(String id) async {
    try {
      var encodedId = Uri.encodeComponent(id);
      var response = await http.get(
        Uri.parse(
            '$domain/api/table/dining-table/reset-call-waiter?dinning_id=$encodedId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'X-Api-Key': xApi,
          'Authorization': 'Bearer ${widget.user.token}',
        },
      );

      if (kDebugMode) {
        // print(response.statusCode);
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseBody = jsonDecode(response.body);
        if (kDebugMode) {
          print(responseBody);
          print("Status changed");
        }
      } else {
        if (kDebugMode) {
          print("Failed to change status: ${response.statusCode}");
        }
        throw Exception('Failed to change status: ${response.statusCode}');
      }
    } catch (error) {
      if (kDebugMode) {
        print("Error: $error");
      }
      throw Exception('Error occurred: $error');
    }
  }
}
