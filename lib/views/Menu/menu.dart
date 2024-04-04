import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:nanopos/consts/consts.dart';
import 'package:nanopos/controller/apiController.dart';
import 'package:nanopos/controller/cartController.dart';
import 'package:nanopos/views/Menu/cart.dart';
import 'package:nanopos/views/Menu/dialogDetail.dart';
import 'package:nanopos/views/common/highlight_text.dart';
import 'package:nanopos/views/Menu/detail.dart';
import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:nanopos/views/Auth/login.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MenuScreen extends StatefulWidget {
  final loginUser user;
  final String id;
  final String table;
  const MenuScreen(
      {Key? key, required this.user, required this.id, required this.table})
      : super(key: key);
  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  // We can detect the location of the cart by this  GlobalKey<CartIconKey>
  GlobalKey<CartIconKey> cartKey = GlobalKey<CartIconKey>();
  final CartController cartController = Get.find();
  final ApiController _apiController = Get.find();
  late Function(GlobalKey) runAddToCartAnimation;

  void listClick(GlobalKey widgetKey) async {
    await runAddToCartAnimation(widgetKey);
    await cartKey.currentState!.runCartAnimation(
        (++cartController.cartQuantityItems.value).toString());
  }

  void fetchData() {
    String catUrl =
        '$domain/api/admin/setting/item-category?order_type=desc';
    String itemUrl =
        '$domain/api/admin/item?order_type=desc';
    String userToken = widget.user.token; // Replace with your user token

    _apiController.fetchData(catUrl, userToken, _apiController.cat, x: true);
    _apiController.fetchData(itemUrl, userToken, _apiController.item);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiController.getLocal();
    // _apiController.token = widget.user.token;
    _apiController.selectedCatId.value = 0;
    cartController.tableId.value = int.parse(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AddToCartAnimation(
        // To send the library the location of the Cart icon
        cartKey: cartKey,
        height: 30,
        width: 30,
        opacity: 0.85,
        dragAnimation: const DragToCartAnimationOptions(
            rotation: false,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeIn),
        jumpAnimation:
            const JumpAnimationOptions(active: false, curve: Curves.linear),
        createAddToCartAnimation: (runAddToCartAnimation) {
          // You can run the animation by addToCartAnimationMethod, just pass trough the the global key of  the image as parameter
          this.runAddToCartAnimation = runAddToCartAnimation;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Row(
            children: [
              // Sidebar
              Expanded(
                flex: 1,
                child: Container(
                  color: Color(0xfff3b98a),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.black,
                              width: 1.0, // Adjust the width as needed
                            ),
                          ),
                        ),
                        child: ListTile(
                          title: Icon(Icons.arrow_back),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: _apiController.selectedCatId.value == 0
                              ? Color(0xffa14716)
                              : Colors.transparent,
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.black,
                              width: 1.0, // Adjust the width as needed
                            ),
                          ),
                        ),
                        child: ListTile(
                          title: Text(
                            'All',
                            style: TextStyle(
                                fontSize: 8,
                                color: _apiController.selectedCatId.value == 0
                                    ? whiteColor
                                    : Colors.black), // Adjusted font size
                          ),
                          onTap: () {
                            print("0 === 0");
                            _apiController.selectedCatId.value = 0;
                            _apiController.filterItem();
                            setState(() {
                              _apiController.cat;
                            });
                          },
                        ),
                      ),
                      // Container(
                      //   decoration: BoxDecoration(
                      //     border: Border(
                      //       bottom: BorderSide(
                      //         color: Colors.black,
                      //         width: 1.0, // Adjust the width as needed
                      //       ),
                      //     ),
                      //   ),
                      //   child: ListTile(
                      //     title: IconButton(
                      //       icon: const Icon(Icons.cleaning_services),
                      //       onPressed: () {
                      //         _cartQuantityItems = 0;
                      //         cartKey.currentState!.runClearCartAnimation();
                      //       },
                      //     ),
                      //     onTap: () {
                      //       Navigator.pop(context);
                      //     },
                      //   ),
                      // ),
                      Obx(() {
                        if (_apiController.cat.isEmpty) {
                          return Center(
                            // child: CircularProgressIndicator(),
                            child: Text("No Cats Available"),
                          );
                        } else {
                          return Expanded(
                            child: ListView.builder(
                              itemCount: _apiController.cat.length,
                              itemBuilder: (context, index) {
                                final cat = _apiController.cat[index];
                                // print("cat is $cat");
                                return Container(
                                  decoration: BoxDecoration(
                                    color: _apiController.selectedCatId.value ==
                                            cat['id']
                                        ? Color(0xffa14716)
                                        : Colors.transparent,
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.black,
                                        width:
                                            1.0, // Adjust the width as needed
                                      ),
                                    ),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      '${cat['name']}',
                                      style: TextStyle(
                                          fontSize: 8,
                                          color: _apiController
                                                      .selectedCatId.value ==
                                                  cat['id']
                                              ? whiteColor
                                              : Colors
                                                  .black), // Adjusted font size
                                    ),
                                    onTap: () {
                                      print("${cat['id']} === ${cat['name']}");
                                      _apiController.selectedCatId.value =
                                          cat['id'];
                                      _apiController.filterItem();
                                      setState(() {
                                        _apiController.cat;
                                      });
                                    },
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      }),
                      // ExpansionTile(
                      //   backgroundColor: Color(0xFFF0C5A3),
                      //   trailing: SizedBox.shrink(),
                      //   leading: Text(
                      //     "Biryani",
                      //     style: TextStyle(fontSize: 8),
                      //   ),
                      //   title: Text(
                      //     '',
                      //     // style: TextStyle(fontSize: 8),
                      //     // overflow: TextOverflow.ellipsis,
                      //     // maxLines: 2,
                      //   ),
                      //   children: [
                      //     ExpansionTile(
                      //       backgroundColor: Color(0xFFEBCFB9),
                      //       trailing: SizedBox.shrink(),
                      //       title: Text(
                      //         '',
                      //       ),
                      //       leading: Text(
                      //         'Beef',
                      //         style: TextStyle(fontSize: 8),
                      //       ),
                      //       children: [
                      //         ListTile(
                      //           contentPadding:
                      //               EdgeInsets.symmetric(horizontal: 20),
                      //           title: Text(
                      //             'Plain',
                      //             style: TextStyle(fontSize: 8),
                      //           ),
                      //           onTap: () {
                      //             // Handle Beef Kebab tap
                      //           },
                      //         ),
                      //         ListTile(
                      //           contentPadding:
                      //               EdgeInsets.symmetric(horizontal: 20),
                      //           title: Text(
                      //             'Masala',
                      //             style: TextStyle(fontSize: 8),
                      //           ),
                      //           onTap: () {
                      //             // Handle Beef Pulao tap
                      //           },
                      //         ),
                      //       ],
                      //     ),
                      //     Container(
                      //       decoration: BoxDecoration(
                      //         border: Border(
                      //           bottom: BorderSide(
                      //             color: Color(0xFF000000),
                      //             width: 1.0,
                      //           ),
                      //         ),
                      //       ),
                      //       child: ExpansionTile(
                      //         backgroundColor: Color(0xFFEBCFB9),
                      //         trailing: SizedBox.shrink(),
                      //         title: Text(
                      //           '',
                      //         ),
                      //         leading: Text(
                      //           'Chicken',
                      //           style: TextStyle(fontSize: 8),
                      //         ),
                      //         children: [
                      //           ListTile(
                      //             contentPadding:
                      //                 EdgeInsets.symmetric(horizontal: 20),
                      //             title: Text(
                      //               'Plain',
                      //               style: TextStyle(fontSize: 8),
                      //             ),
                      //             onTap: () {
                      //               // Handle Chicken Biryani tap
                      //             },
                      //           ),
                      //           ListTile(
                      //             contentPadding:
                      //                 EdgeInsets.symmetric(horizontal: 20),
                      //             title: Text(
                      //               'Masala',
                      //               style: TextStyle(fontSize: 8),
                      //             ),
                      //             onTap: () {
                      //               // Handle Chicken Tikka tap
                      //             },
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          "assets/images/logo.png",
                          width: 75,
                          height: 75,
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.home),
                        ),
                        AddToCartIcon(
                          key: cartKey,
                          icon: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CartScreen(
                                            user: widget.user,
                                            id: widget.id,
                                            table: widget.table,
                                          )),
                                );
                              },
                              child: const Icon(Icons.shopping_bag)),
                          badgeOptions: const BadgeOptions(
                            active: true,
                            backgroundColor: Color(0xfff3b98a),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _showLogoutDialog();
                          },
                          icon: Icon(Icons.person),
                        )
                      ],
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: TextField(
                                onChanged: (value) {
                                  _apiController.searchQuery.value = value;
                                  _apiController.searchItem();
                                  // print(_apiController.filItem);
                                },
                                decoration: InputDecoration(
                                  hintText: 'Search',
                                  hintStyle: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color,
                                  ),
                                  icon: Icon(
                                    Icons.search,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color,
                                  ),
                                  border: InputBorder.none,
                                  suffixIcon: _apiController
                                          .searchQuery.isNotEmpty
                                      ? IconButton(
                                          icon: Icon(
                                            Icons.clear,
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .color,
                                          ),
                                          onPressed: () {
                                            print("clearing");
                                            setState(() {
                                              _apiController.searchQuery.value =
                                                  '';
                                            });
                                          },
                                        )
                                      : null,
                                ),
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // Expanded(
                    //   child: SingleChildScrollView(
                    //     physics: const BouncingScrollPhysics(),
                    //     child: Column(
                    //       children: [
                    //         MyAppListItem(
                    //           name: "Thai Basil Chicken",
                    //           desc: "Served with fries and soya sauce",
                    //           img: "assets/images/pic-3.png",
                    //           onClick: listClick,
                    //           index: 0,
                    //         ),
                    //         Obx(() {
                    //           if (_apiController.item.isEmpty) {
                    //             return Center(
                    //               child: CircularProgressIndicator(),
                    //             );
                    //           } else {
                    //             return ListView.builder(
                    //               itemCount: _apiController.item.length,
                    //               itemBuilder: (context, index) {
                    //                 final item = _apiController.item[index];
                    //                 print("item is $item");
                    //                 return Text("${item['name']}");
                    //               },
                    //             );
                    //           }
                    //         }),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    Expanded(
                      child: Obx(() {
                        if (_apiController.item.isEmpty) {
                          return Center(
                            // child: CircularProgressIndicator(),
                            child: Text("No Items Available"),
                          );
                        } else {
                          if (_apiController.filItem.isEmpty) {
                            return Center(
                              child: Text("No Items Available"),
                            );
                          } else {
                            return ListView.builder(
                              itemCount: _apiController.filItem.length,
                              itemBuilder: (context, index) {
                                final item = _apiController.filItem[index];
                                for (var addon in item['addons']) {
                                  addon['qty'] = 1;
                                }
                                // print(
                                //     "Item exists ${cartController.checkItemIdExists(item['id'].toString())}");
                                // print("item is $item");
                                return MyAppListItem(
                                  name: item['name'],
                                  desc: item['description'],
                                  img: item['cover'],
                                  onClick: listClick,
                                  index: item['id'],
                                  price: double.parse(item['price'])
                                      .toStringAsFixed(2),
                                  chk: cartController
                                      .checkItemIdExists(item['id'].toString()),
                                  item: item,
                                );
                              },
                            );
                          }
                        }
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const LoginScreen(),
                  //   ),
                  // );
                  Get.offAll(
                    LoginScreen(),
                  );
                },
                icon: const Icon(Icons.logout, size: 40, color: Colors.red),
              ),
              IconButton(
                onPressed: () {
                  fetchData();
                  setState(() {});
                },
                icon: const Icon(Icons.add, size: 40, color: Colors.pink),
              ),
              // IconButton(
              //   onPressed: () {
              //     _apiController.sqlCatInsertion();
              //   },
              //   icon: const Icon(Icons.add, size: 40, color: Colors.pink),
              // ),
              // IconButton(
              //   onPressed: () {
              //     _apiController.sqlItemInsertion();
              //   },
              //   icon: const Icon(Icons.add, size: 40, color: Colors.blue),
              // ),
              // IconButton(
              //   onPressed: () {
              //     _apiController.sqlInsertion();
              //   },
              //   icon: const Icon(Icons.add, size: 40, color: Colors.blue),
              // ),
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

  
  void sessionExpire(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Failed"),
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
                message,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: (){
                Get.offAll(
                    LoginScreen(),
                  );
              }, child: Text("Log In Again"))
            ],
          ),
        );
      },
    );
  }
}

class MyAppListItem extends StatefulWidget {
  final int index;
  final String name;
  final String price;
  final String desc;
  final String img;
  final bool chk;
  final Map<String, dynamic> item;
  final void Function(GlobalKey) onClick;

  MyAppListItem(
      {super.key,
      required this.onClick,
      required this.index,
      required this.name,
      required this.desc,
      required this.img,
      required this.price,
      required this.item,
      required this.chk});

  @override
  State<MyAppListItem> createState() => _MyAppListItemState();
}

class _MyAppListItemState extends State<MyAppListItem> {
  final GlobalKey widgetKey = GlobalKey();

  final ApiController apiController = Get.find();

  final CartController cartController = Get.find();

  @override
  Widget build(BuildContext context) {
    //  Container is mandatory. It can hold images or whatever you want
    Container mandatoryContainer = Container(
      key: widgetKey,
      width: 60,
      height: 60,
      color: Colors.transparent,
      child: Image.network(
        widget.img,
        width: 60,
        height: 60,
      ),
    );

    // final newItem = CartObject(
    //   itemId: widget.index.toString(),
    //   name: widget.name,
    //   desc: widget.desc,
    //   image: widget.img,
    //   price: double.parse(widget.price).toStringAsFixed(2),
    //   qty: 1,
    // );

    return Card.outlined(
      surfaceTintColor: whiteColor,
      shadowColor: Colors.black,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          onTap: () async {
            // print("printiiing");

            bool addToCart = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AddToCartDialog(
                  item: widget.item,
                );
              },
            );
            if (addToCart != null) {
              if (addToCart) {
                print('Item added to cart');
                Future.delayed(Duration(milliseconds: 500), () {
                  widget.onClick(widgetKey);
                });
              } else {
                print('Canceled');
              }
            }
          },
          // title: HighlightedText(text: name, query: apiController.searchQuery.value),
          title: Text(
            widget.name,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            widget.price,
            style: TextStyle(fontSize: 10),
          ),
          leading: mandatoryContainer,
          // trailing: widget.chk
          //     ? Row(
          //         mainAxisSize: MainAxisSize.min,
          //         children: [
          //           IconButton(
          //             icon: Icon(Icons.remove),
          //             onPressed: () {
          //               // cartController.decreaseQty(cartObject);
          //               print("quantity decreasing by 1");
          //             },
          //           ),
          //           Text(
          //             "1",
          //             style: TextStyle(fontWeight: FontWeight.bold),
          //           ),
          //           IconButton(
          //             icon: Icon(Icons.add),
          //             onPressed: () {
          //               // cartController.increaseQty(cartObject);
          //               print("quantity increasing by 1");
          //             },
          //           ),
          //         ],
          //       )
          // : InkWell(
          //     onTap: () async {
          //       // print("printiiing");
          //       widget.onClick(widgetKey);

          //       final newItem = CartObject(
          //         itemId: widget.index.toString(),
          //         name: widget.name,
          //         desc: widget.desc,
          //         image: widget.img,
          //         price: double.parse(widget.price).toStringAsFixed(2),
          //         qty: 1,
          //       );
          //       cartController.addToCart(newItem);
          //       SharedPreferences prefs =
          //           await SharedPreferences.getInstance();
          //       String? cartData = prefs.getString('cartItems');
          //       if (cartData != null) {
          //         Map<String, dynamic> cartJson = json.decode(cartData);
          //         setState(() {});
          //         // print(cartJson);
          //       } else {
          //         print("Error");
          //       }
          //     },
          //     child: Container(
          //       decoration: BoxDecoration(
          //         color: Color(0xffa14716),
          //       ),
          //       child: Icon(
          //         Icons.add,
          //         color: whiteColor,
          //         size: 20,
          //       ),
          //     ),
          //   ),
          trailing: Container(
            decoration: BoxDecoration(
              color: Color(0xffa14716),
            ),
            child: Icon(
              Icons.add,
              color: whiteColor,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
