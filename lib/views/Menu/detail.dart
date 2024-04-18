import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:nanopos/consts/consts.dart';

class ProductDetail extends StatefulWidget {
  final Map<String, dynamic> item;
  const ProductDetail({Key? key, required this.item}) : super(key: key);

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print("Item Is : ${widget.item}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                      "assets/images/pic-5.png",
                      "assets/images/pic-4.png",
                    ].map((item) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(item),
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Seefood Pasta",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: const Text(
                      "Seafood Trio Pasta: Pan-seared calamari, prawns, and mussels in penne pasta with rich red sauce, served with a side of garlic bread and a generous 250g portion... Read More",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
              const Divider(),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    const Text(
                      "Size",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey, // Background color
                          ),
                          onPressed: () {},
                          child: const Center(
                            child: Text(
                              "S",
                              style: TextStyle(
                                color: whiteColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey, // Background color
                          ),
                          onPressed: () {},
                          child: const Center(
                            child: Text(
                              "M",
                              style: TextStyle(
                                color: whiteColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey, // Background color
                          ),
                          onPressed: () {},
                          child: const Center(
                            child: Text(
                              "L",
                              style: TextStyle(
                                color: whiteColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(),
              ListTile(
                  title: const Text(
                    "Thai Basil Chicken",
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text(
                    "Served with fries and soya sauce",
                    style: TextStyle(fontSize: 10),
                  ),
                  leading: Image.asset("assets/images/pic-2.png"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            color: Colors.grey,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: const Icon(
                          Icons.remove,
                          color: whiteColor,
                          size: 20,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Text(
                          "1",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            color: Colors.grey,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: const Icon(
                          Icons.add,
                          color: whiteColor,
                          size: 20,
                        ),
                      ),
                    ],
                  )),
              ListTile(
                  title: const Text(
                    "Thai Basil Chicken",
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text(
                    "Served with fries and soya sauce",
                    style: TextStyle(fontSize: 10),
                  ),
                  leading: Image.asset("assets/images/pic-2.png"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            color: Colors.grey,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: const Icon(
                          Icons.remove,
                          color: whiteColor,
                          size: 20,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Text(
                          "1",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            color: Colors.grey,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: const Icon(
                          Icons.add,
                          color: whiteColor,
                          size: 20,
                        ),
                      ),
                    ],
                  )),
              const Divider(),
              ListTile(
                title: const Text(
                  "Frequently bought togehter",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "Other cutomers also order these",
                  style: TextStyle(fontSize: 10),
                ),
                trailing: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 161, 161, 161),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: const Text("Optional")),
              ),
              const SizedBox(
                height: 10,
              ),
              ListTile(
                  title: Row(
                    children: [
                      Image.asset("assets/images/pic-2.png"),
                      const SizedBox(
                        width: 5,
                      ),
                      const Text(
                        "Plain Fries",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  leading: Checkbox(value: false, onChanged: (value) {}),
                  trailing: const Text("+ Rs. 450.00")),
              ListTile(
                  title: Row(
                    children: [
                      Image.asset("assets/images/pic-1.png"),
                      const SizedBox(
                        width: 5,
                      ),
                      const Text(
                        "Garlic Bread",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  leading: Checkbox(value: false, onChanged: (value) {}),
                  trailing: const Text("+ Rs. 300.00")),
              ListTile(
                  title: Row(
                    children: [
                      Image.asset("assets/images/pic-2.png"),
                      const SizedBox(
                        width: 5,
                      ),
                      const Text(
                        "Plain Fries",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  leading: Checkbox(value: false, onChanged: (value) {}),
                  trailing: const Text("+ Rs. 450.00")),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.arrow_downward),
                  SizedBox(
                    width: 15,
                  ),
                  Text("View more")
                ],
              ),
              const Divider(),
              const Text(
                "Special Intructions",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text(
                  "Please let us know if you are allergic to anything on if we need to avid anything"),
              TextField(
                maxLines: null, // Allows for unlimited lines of input
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: 'e.g  no mayo', // Placeholder text
                  border: const OutlineInputBorder(), // Border style
                  filled: true, // Fill the background color
                  fillColor: Colors.grey[200], // Background color
                  contentPadding:
                      const EdgeInsets.all(10), // Padding inside the TextField
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("Rs.1,550.00"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
