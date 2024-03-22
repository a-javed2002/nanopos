import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class AddToCartDialog extends StatefulWidget {
  final Map<String, dynamic> item;
  const AddToCartDialog({Key? key, required this.item}) : super(key: key);

  @override
  State<AddToCartDialog> createState() => _AddToCartDialogState();
}

class _AddToCartDialogState extends State<AddToCartDialog> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("addons Is : ${widget.item['addons']}");
    print("offer Is : ${widget.item['offer']}");
    print("extras Is : ${widget.item['extras']}");
    print("itemAttributes Is : ${widget.item['itemAttributes']}");
    print("variations Is : ${widget.item['variations']}");
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Scaffold(
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Column(
                  children: [
                    CarouselSlider(
                      options: CarouselOptions(
                        autoPlay: true,
                        aspectRatio: 16 / 9,
                        enlargeCenterPage: true,
                      ),
                      items: [
                        widget.item['cover'],
                        widget.item['thumb'],
                        widget.item['preview'],
                      ].map((item) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(item),
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 10),
                    Text(
                      widget.item['name'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        widget.item['description'],
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children:
                        widget.item['itemAttributes'].map<Widget>((attribute) {
                      // Extracting variations corresponding to the attribute
                      var variations =
                          widget.item['variations'][attribute['id'].toString()];

                      // Select the first variation by default if there are variations
                      if (variations.isNotEmpty &&
                          attribute['selected'] == null) {
                        attribute['selected'] = variations[0];
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            attribute['name'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: variations.map<Widget>((variation) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    // Set the selected variation for this attribute
                                    attribute['selected'] = variation;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: attribute['selected'] == variation
                                          ? Colors.blue
                                          : Colors.grey,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    "${variation['name']} +${variation['price']}",
                                    style: TextStyle(
                                      color: attribute['selected'] == variation
                                          ? Colors.blue
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const Divider(),
                        ],
                      );
                    }).toList(),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Text(
                        "Extras",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Column(
                        children: widget.item['extras'].map<Widget>((extra) {
                          return ListTile(
                            title: Text(
                              extra['name'],
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "Price: ${extra['currency_price']}",
                              style: TextStyle(fontSize: 10),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      // Item attributes and variations grid
                      // ... Existing code here

                      // Addons section
                      Text(
                        "Addons",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Column(
                        children: widget.item['addons'].map<Widget>((addon) {
                          return ListTile(
                            title: Text(
                              addon['addon_item_name'],
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "Price: ${addon['addon_item_currency_price']}",
                              style: TextStyle(fontSize: 10),
                            ),
                            leading: Image.network(
                              addon[
                                  'thumb'], // Assuming there's an image URL for each addon
                              width: 50,
                              height: 50,
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    "1",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Text(
                  "Special Intructions",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                    "Please let us know if you are allergic to anything on if we need to avid anything"),
                TextField(
                  maxLines: null, // Allows for unlimited lines of input
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: 'e.g  no mayo', // Placeholder text
                    border: OutlineInputBorder(), // Border style
                    filled: true, // Fill the background color
                    fillColor: Colors.grey[200], // Background color
                    contentPadding:
                        EdgeInsets.all(10), // Padding inside the TextField
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false); // Return false
                      },
                      child: Text('Cancel'),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(true); // Return true
                      },
                      child: Text('Add to Cart'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
