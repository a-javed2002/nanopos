import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nanopos/views/detail.dart';
import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:nanopos/views/login.dart';
import 'package:nanopos/main.dart';

class SideBarScreen extends StatefulWidget {
  final loginUser user;
  const SideBarScreen({
    Key? key,
    required this.user
  }) : super(key: key);
  @override
  State<SideBarScreen> createState() => _SideBarScreenState();
}

class _SideBarScreenState extends State<SideBarScreen> {
  // We can detect the location of the cart by this  GlobalKey<CartIconKey>
  GlobalKey<CartIconKey> cartKey = GlobalKey<CartIconKey>();
  late Function(GlobalKey) runAddToCartAnimation;
  var _cartQuantityItems = 0;
  String _searchQuery = '';

  void listClick(GlobalKey widgetKey) async {
    await runAddToCartAnimation(widgetKey);
    await cartKey.currentState!
        .runCartAnimation((++_cartQuantityItems).toString());
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
                  child: ListView(
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
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.black,
                              width: 1.0, // Adjust the width as needed
                            ),
                          ),
                        ),
                        child: ListTile(
                          title: IconButton(
                            icon: const Icon(Icons.cleaning_services),
                            onPressed: () {
                              _cartQuantityItems = 0;
                              cartKey.currentState!.runClearCartAnimation();
                            },
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
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
                          title: Text(
                            'Brew Bar',
                            style: TextStyle(fontSize: 8), // Adjusted font size
                          ),
                          onTap: () {
                            // Navigate to home page
                          },
                        ),
                      ),
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
                          title: Text(
                            'Spanish Lattes',
                            style: TextStyle(fontSize: 8), // Adjusted font size
                          ),
                          onTap: () {
                            // Navigate to home page
                          },
                        ),
                      ),
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
                          title: Text(
                            'Hot coffees',
                            style: TextStyle(fontSize: 8), // Adjusted font size
                          ),
                          onTap: () {
                            // Navigate to home page
                          },
                        ),
                      ),
                      ExpansionTile(
                        backgroundColor: Color(0xFFF0C5A3),
                        trailing: SizedBox.shrink(),
                        leading: Text(
                          "Biryani",
                          style: TextStyle(fontSize: 8),
                        ),
                        title: Text(
                          '',
                          // style: TextStyle(fontSize: 8),
                          // overflow: TextOverflow.ellipsis,
                          // maxLines: 2,
                        ),
                        children: [
                          ExpansionTile(
                            backgroundColor: Color(0xFFEBCFB9),
                            trailing: SizedBox.shrink(),
                            title: Text('',),
                            leading: Text(
                              'Beef',
                              style: TextStyle(fontSize: 8),
                            ),
                            children: [
                              ListTile(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 20),
                                title: Text(
                                  'Plain',
                                  style: TextStyle(fontSize: 8),
                                ),
                                onTap: () {
                                  // Handle Beef Kebab tap
                                },
                              ),
                              ListTile(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 20),
                                title: Text(
                                  'Masala',
                                  style: TextStyle(fontSize: 8),
                                ),
                                onTap: () {
                                  // Handle Beef Pulao tap
                                },
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color(0xFF000000),
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: ExpansionTile(
                              backgroundColor: Color(0xFFEBCFB9),
                              trailing: SizedBox.shrink(),
                              title: Text('',),
                              leading: Text(
                                'Chicken',
                                style: TextStyle(fontSize: 8),
                              ),
                              children: [
                                ListTile(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 20),
                                  title: Text(
                                    'Plain',
                                    style: TextStyle(fontSize: 8),
                                  ),
                                  onTap: () {
                                    // Handle Chicken Biryani tap
                                  },
                                ),
                                ListTile(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 20),
                                  title: Text(
                                    'Masala',
                                    style: TextStyle(fontSize: 8),
                                  ),
                                  onTap: () {
                                    // Handle Chicken Tikka tap
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Main Body
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
                        // IconButton(
                        //   onPressed: () {},
                        //   icon: Icon(Icons.favorite),
                        // ),
                        // IconButton(
                        //   onPressed: () {},
                        //   icon: Icon(Icons.shopping_bag),
                        // ),
                        AddToCartIcon(
                          key: cartKey,
                          icon: const Icon(Icons.shopping_bag),
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
                        // InkWell(
                        //   onTap: () {
                        //     _showLogoutDialog();
                        //   },
                        //   child: Padding(
                        //     padding: const EdgeInsets.only(right: 10.0),
                        //     child: CircleAvatar(
                        //       backgroundImage: NetworkImage(widget.image),
                        //     ),
                        //   ),
                        // ),
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
                                  setState(() {
                                    _searchQuery = value;
                                  });
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
                                  suffixIcon: _searchQuery.isNotEmpty
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
                                              _searchQuery = '';
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
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            // Card.outlined(
                            //   surfaceTintColor: Colors.white,
                            //   shadowColor: Colors.black,
                            //   elevation: 4,
                            //   child: Padding(
                            //     padding: const EdgeInsets.all(8.0),
                            //     child: ListTile(
                            //       onTap: () {
                            //         Navigator.push(
                            //           context,
                            //           MaterialPageRoute(
                            //               builder: (context) => ProductDetail()),
                            //         );
                            //       },
                            //       title: Text(
                            //         "Thai Basil Chicken",
                            //         style: TextStyle(
                            //             fontSize: 10,
                            //             fontWeight: FontWeight.bold),
                            //       ),
                            //       subtitle: Text(
                            //         "Served with fries and soya sauce",
                            //         style: TextStyle(fontSize: 10),
                            //       ),
                            //       leading: Image.asset("assets/images/pic-1.png"),
                            //       trailing: Container(
                            //         decoration: BoxDecoration(
                            //           color: Colors.black,
                            //         ),
                            //         child: Icon(
                            //           Icons.add,
                            //           color: Colors.white,
                            //           size: 20,
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            MyAppListItem(
                              name: "Thai Basil Chicken",
                              desc: "Served with fries and soya sauce",
                              img: "assets/images/pic-3.png",
                              onClick: listClick,
                              index: 0,
                            ),
                            MyAppListItem(
                              name: "Thai Basil Chicken",
                              desc: "Served with fries and soya sauce",
                              img: "assets/images/pic-2.png",
                              onClick: listClick,
                              index: 1,
                            ),
                            MyAppListItem(
                              name: "Thai Basil Chicken",
                              desc: "Served with fries and soya sauce",
                              img: "assets/images/pic-1.png",
                              onClick: listClick,
                              index: 1,
                            ),
                            MyAppListItem(
                              name: "Thai Basil Chicken",
                              desc: "Served with fries and soya sauce",
                              img: "assets/images/pic-3.png",
                              onClick: listClick,
                              index: 0,
                            ),
                            MyAppListItem(
                              name: "Thai Basil Chicken",
                              desc: "Served with fries and soya sauce",
                              img: "assets/images/pic-2.png",
                              onClick: listClick,
                              index: 1,
                            ),
                            MyAppListItem(
                              name: "Thai Basil Chicken",
                              desc: "Served with fries and soya sauce",
                              img: "assets/images/pic-1.png",
                              onClick: listClick,
                              index: 1,
                            ),
                            MyAppListItem(
                              name: "Thai Basil Chicken",
                              desc: "Served with fries and soya sauce",
                              img: "assets/images/pic-3.png",
                              onClick: listClick,
                              index: 0,
                            ),
                            MyAppListItem(
                              name: "Thai Basil Chicken",
                              desc: "Served with fries and soya sauce",
                              img: "assets/images/pic-2.png",
                              onClick: listClick,
                              index: 1,
                            ),
                            MyAppListItem(
                              name: "Thai Basil Chicken",
                              desc: "Served with fries and soya sauce",
                              img: "assets/images/pic-1.png",
                              onClick: listClick,
                              index: 1,
                            ),
                          ],
                        ),
                      ),
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

class MyAppListItem extends StatelessWidget {
  final GlobalKey widgetKey = GlobalKey();
  final int index;
  final String name;
  final String desc;
  final String img;
  final void Function(GlobalKey) onClick;

  MyAppListItem(
      {super.key,
      required this.onClick,
      required this.index,
      required this.name,
      required this.desc,
      required this.img});
  @override
  Widget build(BuildContext context) {
    //  Container is mandatory. It can hold images or whatever you want
    Container mandatoryContainer = Container(
      key: widgetKey,
      width: 60,
      height: 60,
      color: Colors.transparent,
      child: Image.asset(
        img,
        width: 60,
        height: 60,
      ),
    );

    return Card.outlined(
      surfaceTintColor: Colors.white,
      shadowColor: Colors.black,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProductDetail()),
            );
          },
          title: Text(
            name,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            desc,
            style: TextStyle(fontSize: 10),
          ),
          leading: mandatoryContainer,
          trailing: InkWell(
            onTap: () {
              print("printiiing");
              onClick(widgetKey);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xffa14716),
              ),
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
