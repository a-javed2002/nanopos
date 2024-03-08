import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
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
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
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
                  SizedBox(height: 10),
                  Text(
                    "Seefood Pasta",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "Seafood Trio Pasta: Pan-seared calamari, prawns, and mussels in penne pasta with rich red sauce, served with a side of garlic bread and a generous 250g portion... Read More",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
              const Divider(),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    Text(
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
                          child: Center(
                            child: Text(
                              "S",
                              style: TextStyle(
                                color: Colors.white,
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
                          child: Center(
                            child: Text(
                              "M",
                              style: TextStyle(
                                color: Colors.white,
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
                          child: Center(
                            child: Text(
                              "L",
                              style: TextStyle(
                                color: Colors.white,
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
                  title: Text(
                    "Thai Basil Chicken",
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Served with fries and soya sauce",
                    style: TextStyle(fontSize: 10),
                  ),
                  leading: Image.asset("assets/images/pic-2.png"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
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
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  )),
              ListTile(
                  title: Text(
                    "Thai Basil Chicken",
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Served with fries and soya sauce",
                    style: TextStyle(fontSize: 10),
                  ),
                  leading: Image.asset("assets/images/pic-2.png"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
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
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  )),
              const Divider(),
              ListTile(
                title: Text(
                  "Frequently bought togehter",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "Other cutomers also order these",
                  style: TextStyle(fontSize: 10),
                ),
                trailing: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 161, 161, 161),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Text("Optional")),
              ),
              SizedBox(
                height: 10,
              ),
              ListTile(
                  title: Row(
                    children: [
                      Image.asset("assets/images/pic-2.png"),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Plain Fries",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  leading: Checkbox(value: false, onChanged: (value) {}),
                  trailing: Text("+ Rs. 450.00")),
              ListTile(
                  title: Row(
                    children: [
                      Image.asset("assets/images/pic-1.png"),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Garlic Bread",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  leading: Checkbox(value: false, onChanged: (value) {}),
                  trailing: Text("+ Rs. 300.00")),
              ListTile(
                  title: Row(
                    children: [
                      Image.asset("assets/images/pic-2.png"),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Plain Fries",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  leading: Checkbox(value: false, onChanged: (value) {}),
                  trailing: Text("+ Rs. 450.00")),
              Row(
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
                  ElevatedButton(
                    onPressed: () {},
                    child: Text("Rs.1,550.00"),
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
