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
//     print("Fetching Tables ${widget.token}");
//     print(widget.token);
//     while (true) {
//       final response = await http.get(
//         Uri.parse(
//             'https://restaurant.nanosystems.com.pk/api/admin/dining-table?order_column=id&order_type=desc'),
//         headers: {
//           'Content-Type': 'application/json; charset=UTF-8',
//           'X-Api-Key': 'b6d68vy2-m7g5-20r0-5275-h103w73453q120',
//           'Authorization': 'Bearer ${widget.token}',
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
//                 backgroundImage: NetworkImage(widget.image),
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
//                               token: widget.token,
//                               image: widget.image,
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
import 'package:nanopos/cashier.dart';
import 'package:nanopos/login.dart';
import 'dart:convert';

import 'package:nanopos/order.dart';

class MyHomePage extends StatefulWidget {
  final String name;
  final String email;
  final String image;
  final int roleId;
  final String token;

  MyHomePage(
      {Key? key,
      required this.name,
      required this.email,
      required this.image,
      required this.roleId,
      required this.token})
      : super(key: key);

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
      print("Fetching Tables ${widget.token}");
      print(widget.token);
    }
    while (true) {
      final response = await http.get(
        Uri.parse(
            'https://restaurant.nanosystems.com.pk/api/admin/dining-table?order_column=id&order_type=desc'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'X-Api-Key': 'b6d68vy2-m7g5-20r0-5275-h103w73453q120',
          'Authorization': 'Bearer ${widget.token}',
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

      // Delay before fetching tables again
      await Future.delayed(const Duration(seconds: 5));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff2a407c),
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
                  backgroundImage: NetworkImage(widget.image),
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
                  crossAxisCount: 2, // Display two tables in each row
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
                        if (widget.roleId == 7) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrdersScreen(
                                id: table['id'].toString(),
                                token: widget.token,
                                image: widget.image,
                                table: table['name'].toString(),
                                name: widget.name,
                                email: widget.email,
                              ),
                            ),
                          );
                        } else if (widget.roleId == 6) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CashierScreen(
                                id: table['id'].toString(),
                                token: widget.token,
                                image: widget.image,
                                table: table['name'].toString(),
                                name: widget.name,
                                email: widget.email,
                              ),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrdersScreen(
                                id: table['id'].toString(),
                                token: widget.token,
                                image: widget.image,
                                table: table['name'].toString(),
                                name: widget.name,
                                email: widget.email,
                              ),
                            ),
                          );
                        }
                      },
                      child: Card(
                        color: table['isActive'] == true
                            ? Color(0xff2a407c)
                            : Color(0xFF6078B9),
                        elevation: 4,
                        child: Stack(
                          children: [
                            // Image at bottom right
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Image.asset(
                                "assets/icons/Restaurant_Table.png",
                                width: 75,
                                height: 75,
                                fit: BoxFit.cover,
                              ),
                            ),
                            // Text aligned to the left according to image
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    table['name'].toString(),
                                    style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "${table['size']} Persons",
                                    style: const TextStyle(fontSize: 18),
                                  ),
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
                backgroundImage: NetworkImage(widget.image),
                radius: 40,
              ),
              const SizedBox(height: 20),
              Text(
                widget.name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                widget.email,
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
