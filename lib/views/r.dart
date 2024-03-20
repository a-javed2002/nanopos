import 'package:flutter/material.dart';

class Item {
  final int id;
  final String name;

  Item(this.id, this.name);
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Checkbox List',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: CheckboxListScreen(),
//     );
//   }
// }

// class CheckboxListScreen extends StatefulWidget {
//   @override
//   _CheckboxListScreenState createState() => _CheckboxListScreenState();
// }

// class _CheckboxListScreenState extends State<CheckboxListScreen> {
//   List<Item> items = [
//     Item(1, "Item 1"),
//     Item(2, "Item 2"),
//     Item(3, "Item 3"),
//     Item(4, "Item 4"),
//     Item(5, "Item 5"),
//   ];
//   List<int> selectedIds = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Checkbox List"),
//       ),
//       body: ListView.builder(
//         itemCount: items.length,
//         itemBuilder: (context, index) {
//           Item item = items[index];
//           return CheckboxListTile(
//             title: Text(item.name),
//             value: selectedIds.contains(item.id),
//             onChanged: (bool? value) {
//               setState(() {
//                 if (value != null && value) {
//                   selectedIds.add(item.id);
//                 } else {
//                   selectedIds.remove(item.id);
//                 }
//               });
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           print("Selected IDs: $selectedIds");
//         },
//         child: Icon(Icons.print),
//       ),
//     );
//   }
// }


class CheckboxListScreen extends StatefulWidget {
  @override
  _CheckboxListScreenState createState() => _CheckboxListScreenState();
}

class _CheckboxListScreenState extends State<CheckboxListScreen> {
  List<Item> items = [
    Item(1, "Item 1"),
    Item(2, "Item 2"),
    Item(3, "Item 3"),
    Item(4, "Item 4"),
    Item(5, "Item 5"),
  ];
  List<int> selectedIds = [];
  bool selectAll = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Checkbox List"),
      ),
      body: Column(
        children: [
          CheckboxListTile(
            activeColor: Colors.red,
            controlAffinity: ListTileControlAffinity.leading,
            title: Text("Select/Unselect All"),
            value: selectAll,
            onChanged: (value) {
              setState(() {
                selectAll = value!;
                if (selectAll) {
                  selectedIds = List.from(List.generate(items.length, (index) => items[index].id));
                } else {
                  selectedIds.clear();
                }
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                Item item = items[index];
                return CheckboxListTile(
                  title: ListTile(title:  Text(item.name)),
                  value: selectedIds.contains(item.id),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value != null && value) {
                        selectedIds.add(item.id);
                      } else {
                        selectedIds.remove(item.id);
                      }
                      selectAll = selectedIds.length == items.length;
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("Selected IDs: $selectedIds");
        },
        child: Icon(Icons.print),
      ),
    );
  }
}