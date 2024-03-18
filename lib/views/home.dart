// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'package:nanopos/order.dart';

// class MyHomePage extends StatefulWidget {
//   final String name;
//   final String email;
//   final String image;
//   final String token;

//   MyHomePage(
//       {Key? key,
//       required this.name,
//       required this.email,
//       required this.image,
//       required this.token})
//       : super(key: key);

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   late Stream<List<dynamic>> _tablesStream;

//   @override
//   void initState() {
//     super.initState();
//     _tablesStream = _fetchActiveTables();
//   }

//   Stream<List<dynamic>> _fetchActiveTables() async* {
//     print("Fetching Tables ${widget.user.token}");
//     print(widget.user.token);
//     while (true) {
//       final response = await http.get(
//         Uri.parse(
//             'https://restaurant.nanosystems.com.pk/api/admin/dining-table?order_column=id&order_type=desc'),
//         headers: {
//           'Content-Type': 'application/json; charset=UTF-8',
//           'X-Api-Key': 'b6d68vy2-m7g5-20r0-5275-h103w73453q120',
//           'Authorization': 'Bearer ${widget.user.token}',
//         },
//       );

//       print(response.statusCode);

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final Map<String, dynamic> responseData = jsonDecode(response.body);
//         final List<dynamic>? tablesData =
//             responseData['data']; // Extracting the list of tables
//         if (tablesData != null) {
//           yield tablesData;
//         } else {
//           throw Exception('Failed to parse table data');
//         }
//       } else {
//         throw Exception('Failed to load active tables');
//       }

//       // Delay before fetching tables again
//       await Future.delayed(Duration(seconds: 5));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text("Dashboard"),
//           actions: [
//             Padding(
//               padding: const EdgeInsets.only(right: 10.0),
//               child: CircleAvatar(
//                 backgroundImage: NetworkImage(widget.user.image),
//               ),
//             ),
//           ],
//         ),
//         body: StreamBuilder<List<dynamic>>(
//           stream: _tablesStream, // The stream to listen to for data updates
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               // Show a loading indicator if data is still being fetched
//               return Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               // Show an error message if an error occurs
//               print(snapshot.error); // Log the error for debugging
//               return Center(child: Text('Error: ${snapshot.error}'));
//             } else {
//               // If data is successfully loaded
//               final List<dynamic> tables = snapshot.data ??
//                   []; // Extract the list of tables from the snapshot
//               return GridView.builder(
//                 // Use GridView to display tables in a grid layout
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2, // Display two tables in each row
//                   crossAxisSpacing: 10.0, // Set spacing between columns
//                   mainAxisSpacing: 10.0, // Set spacing between rows
//                 ),
//                 itemCount: tables.length, // Total number of tables
//                 itemBuilder: (context, index) {
//                   // Build each table item
//                   final table = tables[index]; // Get data for the current table
//                   print(table);
//                   return InkWell(
//                     onTap: () {
//                       Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => OrdersScreen(
//                               id: table['id'].toString(),
//                               token: widget.user.token,
//                               image: widget.user.image,
//                             )),
//                   );
//                     },
//                     child: Card(
//                       // Use Card widget to display table information
//                       child: ListTile(
//                         // Use ListTile for consistent layout and styling
//                         title: Text(table['name']), // Display table name
//                         subtitle: Text(
//                             table['branch_name']), // Display table description
//                       ),
//                     ),
//                   );
//                 },
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nanopos/views/Todo/todos_Screen.dart';
import 'package:nanopos/views/cashier.dart';
import 'package:nanopos/views/login.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

import 'package:nanopos/views/order.dart';
import 'package:nanopos/views/ringtones.dart';
import 'package:vibration/vibration.dart';

class MyHomePage extends StatefulWidget {
  final loginUser user;

  MyHomePage({Key? key, required this.user}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Stream<List<dynamic>> _tablesStream;

  @override
  void initState() {
    super.initState();
    _tablesStream = _fetchActiveTables();
  }

  Stream<List<dynamic>> _fetchActiveTables() async* {
    if (kDebugMode) {
      print("Fetching Tables ${widget.user.token}");
      print(widget.user.token);
    }
    while (true) {
      final response = await http.get(
        Uri.parse(
            'https://restaurant.nanosystems.com.pk/api/admin/dining-table?order_column=id&order_type=desc'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'X-Api-Key': 'b6d68vy2-m7g5-20r0-5275-h103w73453q120',
          'Authorization': 'Bearer ${widget.user.token}',
        },
      );

      if (kDebugMode) {
        print(response.statusCode);
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic>? tablesData =
            responseData['data']; // Extracting the list of tables
        if (tablesData != null) {
          yield tablesData;
        } else {
          throw Exception('Failed to parse table data');
        }
      } else {
        throw Exception('Failed to load active tables');
      }
      break;
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
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            InkWell(
              onTap: () {
                _showLogoutDialog();
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(widget.user.image),
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
                    print(table);
                  } // Log the error for debugging
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      onTap: () {
                        if (widget.user.roleId == 7) {
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
                              builder: (context) => CashierScreen(
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
                        color: table['isActive'] == true
                            ? Color(0xfff3b98a)
                            : Color(0xffffffff),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10.0), // Adjust the border radius as needed
                          side: BorderSide(
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
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xffa14716),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Text(
                                          "${table['newOrders']}",
                                          style: TextStyle(color: Colors.white),
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
                                  table['isActive'] == true
                                      ? Text(
                                          table['name'].toString(),
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        )
                                      : Text(
                                          table['name'].toString(),
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xfff3b98a)),
                                        ),
                                  table['isActive'] == true
                                      ? Text(
                                          "${table['size']} Persons",
                                          style: const TextStyle(
                                              fontSize: 10,
                                              color: Colors.white),
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
                                  //             color: Colors.white),
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
      ),
    );
  }

  void _showLogoutDialog() {
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
                backgroundImage: NetworkImage(widget.user.image),
                radius: 40,
              ),
              const SizedBox(height: 20),
              Text(
                widget.user.name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                widget.user.email,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.logout, size: 40, color: Colors.red),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TodosScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add, size: 40, color: Colors.brown),
                  ),
                  IconButton(
                    onPressed: () {
                      HapticFeedback.vibrate();
                    },
                    icon: const Icon(Icons.calculate_outlined,
                        size: 40, color: Colors.yellow),
                  ),
                  IconButton(
                    onPressed: () {
                      Vibration.vibrate(duration: 2000);
                    },
                    icon:
                        const Icon(Icons.soap, size: 40, color: Colors.yellow),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RingTonee(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.g_translate,
                        size: 40, color: Colors.pink),
                  ),
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
