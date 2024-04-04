import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:nanopos/controller/cartController.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nanopos/consts/consts.dart';

class AddToCartDialog extends StatefulWidget {
  final Map<String, dynamic> item;
  const AddToCartDialog({Key? key, required this.item}) : super(key: key);

  @override
  State<AddToCartDialog> createState() => _AddToCartDialogState();
}

class _AddToCartDialogState extends State<AddToCartDialog> {
  final CartController cartController = Get.find();
  List<Map<String, dynamic>> selectedExtras = [];
  List<Map<String, dynamic>> selectedAddons = [];
  var _special = TextEditingController();
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
          color: whiteColor,
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
                                          ? Color(0xffa14716)
                                          : Color(0xfff3b98a),
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                    color: attribute['selected'] == variation
                                        ? Color(0xffa14716)
                                        : Color(0xfff3b98a),
                                  ),
                                  child: Text(
                                    "${variation['name']} +${double.parse(variation['price']).toStringAsFixed(2)}",
                                    style: TextStyle(
                                      color: attribute['selected'] == variation
                                          ? Color(0xffffffff)
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
                (widget.item['extras'] != null &&
                        widget.item['extras'].isNotEmpty)
                    ? Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            Text(
                              "Extras",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Column(
                              children:
                                  widget.item['extras'].map<Widget>((extra) {
                                return CheckboxListTile(
                                  // tileColor: Color(0xfff3b98a),
                                  activeColor: Color(0xffa14716),
                                  // controlAffinity: ListTileControlAffinity.leading,
                                  title: Text(
                                    extra['name'],
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    "Price: ${extra['currency_price']}",
                                    style: TextStyle(fontSize: 10),
                                  ),
                                  value: selectedExtras.contains(extra),
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (value ?? false) {
                                        selectedExtras.add(extra);
                                      } else {
                                        selectedExtras.remove(extra);
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                            const Divider(),
                          ],
                        ),
                      )
                    : Container(),
                (widget.item['addons'] != null &&
                        widget.item['addons'].isNotEmpty)
                    ? Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            Text(
                              "Addons",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Column(
                              children:
                                  widget.item['addons'].map<Widget>((addon) {
                                bool isChecked = selectedAddons.contains(addon);
                                

                                return CheckboxListTile(
                                  activeColor: Color(0xffa14716),
                                  title: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          addon['addon_item_name'],
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.remove),
                                        onPressed: () {
                                          if (addon['qty'] > 1) {
                                            setState(() {
                                              addon['qty'] -= 1;
                                              print(
                                                  "name: ${addon['addon_item_name']} & qty: ${addon['qty']}");
                                            });
                                          }
                                        },
                                      ),
                                      Text(
                                        "${addon['qty']}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.add),
                                        onPressed: () {
                                          setState(() {
                                            addon['qty'] += 1;
                                            print(
                                                "name: ${addon['addon_item_name']} & qty: ${addon['qty']}");
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  subtitle: Text(
                                    "Price: ${addon['addon_item_currency_price']}",
                                    style: TextStyle(fontSize: 10),
                                  ),
                                  value: isChecked,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (value ?? false) {
                                        selectedAddons.add(addon);
                                      } else {
                                        selectedAddons.remove(addon);
                                      }
                                    });
                                  },
                                  // secondary: Image.network(
                                  //   addon[
                                  //       'thumb'], // Assuming there's an image URL for each addon
                                  //   width: 50,
                                  //   height: 50,
                                  // ),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                );
                              }).toList(),
                            ),
                            const Divider(),
                          ],
                        ),
                      )
                    : Container(),
                Text(
                  "Special Intructions",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                  child: Text(
                      "Please let us know if you are allergic to anything on if we need to avid anything"),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                  child: TextField(
                    controller: _special,
                    maxLines: null, // Allows for unlimited lines of input
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: 'e.g  no mayo', // Placeholder text
                      border: OutlineInputBorder(), // Border style
                      filled: true, // Fill the background color
                      fillColor: Color(0xfff3b98a), // Background color
                      contentPadding:
                          EdgeInsets.all(10), // Padding inside the TextField
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: const Color(0xffa14716),
                          backgroundColor: whiteColor,
                          padding: const EdgeInsets.symmetric(
                              vertical: 14.0, horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                12), // Adjust the radius as needed
                            side: BorderSide(
                                color: const Color(0xffa14716),
                                width: 2), // Add this line for colored border
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(false); // Return false
                        },
                        child: Text('Cancel'),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: whiteColor,
                          padding: const EdgeInsets.symmetric(
                              vertical: 14.0, horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                12), // Adjust the radius as needed
                          ),
                          backgroundColor: const Color(0xffa14716),
                        ),
                        onPressed: () async {
                          // for (var attribute in widget.item['itemAttributes']) {
                          //   print(
                          //       '${attribute['name']} (ID: ${attribute['selected']['id']}): ${attribute['selected']['name']}');
                          // }
                          List<Map<String, dynamic>> selectedVariationsList =
                              [];

                          for (var attribute in widget.item['itemAttributes']) {
                            Map<String, dynamic> variationInfo = {
                              'attribute_name': attribute['name'],
                              'attribute_id': attribute['selected']['id'],
                              'variation_name': attribute['selected']['name'],
                            };
                            selectedVariationsList.add(variationInfo);
                          }

                          print(selectedVariationsList);
                          print("------------------------------");
                          print("Extra ${selectedExtras}");
                          print("Addons ${selectedAddons}");
                          print("Instructions ${_special.text}");
                          final newItem = CartObject(
                            itemId: widget.item['id'].toString(),
                            name: widget.item['name'],
                            desc: widget.item['description'] ?? '',
                            image: widget.item['cover'],
                            price: double.parse(widget.item['price'])
                                .toStringAsFixed(2),
                            qty: 1,
                            itemVariations: selectedVariationsList,
                            itemExtras: selectedExtras,
                            addons: selectedAddons,
                            instruction: _special.text,
                          );
                          cartController.addToCart(newItem);
                          print("new item is ${newItem.instruction}");
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          String? cartData = prefs.getString('cartItems');
                          if (cartData != null) {
                            Map<String, dynamic> cartJson =
                                json.decode(cartData);
                            Navigator.of(context).pop(true); // Return true
                            setState(() {});
                            // print(cartJson);
                          } else {
                            print("Error");
                          }
                        },
                        child: Text('Add to Cart'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
