import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nanopos/OnBoarding/onBoarding.dart';
import 'package:nanopos/controller/apiController.dart';
import 'package:nanopos/controller/cartController.dart';
import 'package:nanopos/dependency_injection.dart';
import 'package:nanopos/views/Auth/login.dart';
import 'package:nanopos/views/Menu/menu.dart';
import 'package:nanopos/views/channel.dart';
import 'package:add_to_cart_animation/add_to_cart_animation.dart';

void main() {
  runApp(const MyApp());
  DependencyInjection.init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nano Pos',
      // theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        // useMaterial3: true,
      // ),
      home: OnBoardingScreen(),
      initialBinding: BindingsBuilder(() {
      Get.put(CartController());
      Get.put(ApiController());
    }),
    );
  }
}


// class MyAnimationScreen extends StatefulWidget {
//   const MyAnimationScreen({Key? key, required this.title}) : super(key: key);
//   final String title;

//   @override
//   MyAnimationScreenState createState() => MyAnimationScreenState();
// }

// class MyAnimationScreenState extends State<MyAnimationScreen> {
//   // We can detect the location of the cart by this  GlobalKey<CartIconKey>
//   GlobalKey<CartIconKey> cartKey = GlobalKey<CartIconKey>();
//   late Function(GlobalKey) runAddToCartAnimation;
//   var _cartQuantityItems = 0;

//   @override
//   Widget build(BuildContext context) {
//     return AddToCartAnimation(
//       // To send the library the location of the Cart icon
//       cartKey: cartKey,
//       height: 30,
//       width: 30,
//       opacity: 0.85,
//       dragAnimation: const DragToCartAnimationOptions(
//         rotation: true,
//       ),
//       jumpAnimation: const JumpAnimationOptions(),
//       createAddToCartAnimation: (runAddToCartAnimation) {
//         // You can run the animation by addToCartAnimationMethod, just pass trough the the global key of  the image as parameter
//         this.runAddToCartAnimation = runAddToCartAnimation;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(widget.title),
//           centerTitle: false,
//           actions: [
//             //  Adding 'clear-cart-button'
//             IconButton(
//               icon: const Icon(Icons.cleaning_services),
//               onPressed: () {
//                 _cartQuantityItems = 0;
//                 cartKey.currentState!.runClearCartAnimation();
//               },
//             ),
//             const SizedBox(width: 16),
//             AddToCartIcon(
//               key: cartKey,
//               icon: const Icon(Icons.shopping_cart),
//               badgeOptions: const BadgeOptions(
//                 active: true,
//                 backgroundColor: Colors.red,
//               ),
//             ),
//             const SizedBox(
//               width: 16,
//             )
//           ],
//         ),
//         body: ListView(
//           children: List.generate(
//             15,
//             (index) => AppListItem(
//               onClick: listClick,
//               index: index,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void listClick(GlobalKey widgetKey) async {
//     await runAddToCartAnimation(widgetKey);
//     await cartKey.currentState!
//         .runCartAnimation((++_cartQuantityItems).toString());
//   }
// }

// class AppListItem extends StatelessWidget {
//   final GlobalKey widgetKey = GlobalKey();
//   final int index;
//   final void Function(GlobalKey) onClick;

//   AppListItem({super.key, required this.onClick, required this.index});
//   @override
//   Widget build(BuildContext context) {
//     //  Container is mandatory. It can hold images or whatever you want
//     Container mandatoryContainer = Container(
//       key: widgetKey,
//       width: 60,
//       height: 60,
//       color: Colors.transparent,
//       child: Image.network(
//         "https://cdn.jsdelivr.net/gh/omerbyrk/add_to_cart_animation/example/assets/apple.png",
//         width: 60,
//         height: 60,
//       ),
//     );

//     return ListTile(
//       onTap: () => onClick(widgetKey),
//       leading: mandatoryContainer,
//       title: Text(
//         "Animated Apple Product Image $index",
//       ),
//     );
//   }
// }