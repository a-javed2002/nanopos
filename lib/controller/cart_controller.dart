import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Define CartObject class

class CartObject {
  final String itemId;
  final String name;
  final String desc;
  final String image;
  final String price;
  RxInt qty;
  List<Map<String, dynamic>>? itemVariations;
  List<Map<String, dynamic>>? itemExtras;
  List<Map<String, dynamic>>? addons;
  final String instruction;

  CartObject({
    required this.itemId,
    required this.name,
    required this.desc,
    required this.image,
    required this.price,
    required this.instruction,
    required int qty,
    this.itemVariations,
    this.itemExtras,
    this.addons,
  }) : qty = qty.obs;

  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'name': name,
      'desc': desc,
      'image': image,
      'price': price,
      'qty': qty.value,
      'instruction': instruction,
      'itemVariations': itemVariations,
      'itemExtras': itemExtras,
      'addons': addons,
    };
  }
}

class CartController extends GetxController {
  static const String cartKey = 'cartItems';
  var cartMap = <int, List<Map<String, dynamic>>?>{}.obs;
  var tableId = RxInt(0);
  var cartQuantityItems = RxInt(0);

  @override
  void onInit() {
    super.onInit();
    loadCartData();
    getTotalItemsForTable();
  }

  // Future<void> loadCartData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? cartData = prefs.getString(cartKey);
  //   if (cartData != null) {
  //     Map<String, dynamic> cartJson = json.decode(cartData);
  //     cartJson.forEach((key, value) {
  //       cartMap[int.parse(key)] = List<Map<String, dynamic>>.from(value).obs;
  //     });
  //   }
  // }

  Future<void> loadCartData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartData = prefs.getString(cartKey);
    if (cartData != null) {
      Map<String, dynamic> cartJson = json.decode(cartData);
      int currentTableId = tableId.value;
      if (cartJson.containsKey(currentTableId.toString())) {
        List<Map<String, dynamic>> itemsList = List<Map<String, dynamic>>.from(
            cartJson[currentTableId.toString()]['items']);
        cartMap[currentTableId] = itemsList.obs;
      }
    }
  }

  Future<void> addToCart(CartObject newItem) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int currentTableId = tableId.value;
    List<Map<String, dynamic>>? cartItems = cartMap[currentTableId];

    if (cartItems != null) {
      bool foundCart = false;
      bool foundItem = false;
      for (var cart in cartItems) {
        if (cart['table_id'] == currentTableId) {
          // Add the new item to an existing cart
          List<Map<String, dynamic>> items = cart['items'];
          for (var item in items) {
            if (item['itemId'] == newItem.itemId &&
                item['instruction'] == newItem.instruction &&
                listEquals(item['itemVariations'], newItem.itemVariations) &&
                listEquals(item['itemExtras'], newItem.itemExtras) &&
                listEquals(item['addons'], newItem.addons)) {
              // Item already exists, increase its count
              item['qty'] += newItem.qty.value;
              foundItem = true;
              break;
            }
          }
          if (foundItem) {
            break;
          } else {
            cart['items'].add(newItem.toJson());
            foundCart = true;
            break;
          }
        }
      }

      if (!foundCart) {
        // Create a new cart for the item
        cartItems.add({
          'table_id': currentTableId,
          'items': [newItem.toJson()],
        });
      }
    } else {
      cartItems = [
        {
          'table_id': currentTableId,
          'items': [newItem.toJson()],
        }
      ];
    }

    cartMap[currentTableId] = cartItems;

    // Save the updated cart data to shared preferences
    Map<String, dynamic> cartJson = {};
    cartMap.forEach((key, value) {
      cartJson[key.toString()] = value;
    });
    prefs.setString(cartKey, json.encode(cartJson));
  }

  void increaseQty(CartObject item) {
    item.qty.value++;
    updateCartData(item);
  }

  void decreaseQty(CartObject item) {
    if (item.qty.value > 0) {
      item.qty.value--;
      if (item.qty.value == 0) {
        removeItemById(item);
      } else {
        updateCartData(item);
      }
    }
  }

  void updateCartData(CartObject item) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> cartJson = {};
    cartMap.forEach((key, value) {
      List<Map<String, dynamic>> updatedItems = [];
      value?.forEach((cart) {
        List<Map<String, dynamic>> items = cart['items'];
        for (var innerItem in items) {
          // if (innerItem['itemId'] == item.itemId && innerItem['instruction'] == item.instruction && innerItem['itemVariations'] == item.itemVariations && innerItem['itemExtras'] == item.itemExtras && innerItem['addons'] == item.addons) {
          if (innerItem['itemId'] == item.itemId &&
              innerItem['instruction'] == item.instruction &&
              listEquals(innerItem['itemVariations'], item.itemVariations) &&
              listEquals(innerItem['itemExtras'], item.itemExtras) &&
              listEquals(innerItem['addons'], item.addons)) {
            innerItem['qty'] = item.qty.value;
          }
          updatedItems.add(innerItem);
        }
      });
      cartJson[key.toString()] = {'items': updatedItems};
    });
    prefs.setString(cartKey, json.encode(cartJson));
  }

  // void removeItemById(String itemId) async {
  //   int currentTableId = tableId.value;
  //   List<Map<String, dynamic>>? cartItems = cartMap[currentTableId];

  //   if (cartItems != null) {
  //     for (var cart in cartItems) {
  //       List<Map<String, dynamic>> items = cart['items'];

  //       // Check if only one item is present
  //       if (items.length == 1) {
  //         // Ensure the item being removed matches the itemId
  //         if (items[0]['itemId'] == itemId) {
  //           items.removeAt(0); // Remove the item
  //         }
  //       } else {
  //         // If multiple items are present, remove the item with the specified itemId
  //         items.removeWhere((item) => item['itemId'] == itemId);
  //       }
  //     }

  //     // Update cartMap
  //     cartMap[currentTableId] = cartItems;

  //     // Update shared preferences
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     Map<String, dynamic> cartJson = {};
  //     cartMap.forEach((key, value) {
  //       cartJson[key.toString()] = {'items': value};
  //     });
  //     prefs.setString(cartKey, json.encode(cartJson));
  //   }
  // }

  void removeItemById(CartObject itemCart) async {
    int currentTableId = tableId.value;
    List<Map<String, dynamic>>? cartItems = cartMap[currentTableId];

    if (cartItems != null) {
      for (var cart in cartItems) {
        List<Map<String, dynamic>> items = cart['items'];

        // Check if only one item is present
        if (items.length == 1) {
          // Clear the cart for the table and return
          clearCartForTable();
          return;
        } else {
          // If multiple items are present, remove the item with the specified itemId
          // items.removeWhere((item) => item['itemId'] == itemCart.itemId && item['instruction'] == itemCart.instruction && item['itemVariations'] == itemCart.itemVariations && item['itemExtras'] == itemCart.itemExtras && item['addons'] == itemCart.addons);
          items.removeWhere((item) =>
              item['itemId'] == itemCart.itemId &&
              item['instruction'] == itemCart.instruction &&
              listEquals(item['itemVariations'], itemCart.itemVariations) &&
              listEquals(item['itemExtras'], itemCart.itemExtras) &&
              listEquals(item['addons'], itemCart.addons));
        }
      }

      // Update cartMap
      cartMap[currentTableId] = cartItems;

      // Update shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Map<String, dynamic> cartJson = {};
      cartMap.forEach((key, value) {
        cartJson[key.toString()] = {'items': value};
      });
      prefs.setString(cartKey, json.encode(cartJson));
    }
  }

  void clearCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartMap.clear();
    prefs.remove(cartKey);
    getTotalItemsForTable();
  }

  void clearCartForTable() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartMap.remove(tableId);
    Map<String, dynamic> cartJson = {};
    cartMap.forEach((key, value) {
      cartJson[key.toString()] = value;
    });
    prefs.setString(cartKey, json.encode(cartJson));
    getTotalItemsForTable();
  }

  bool checkItemIdExists(String itemId) {
    int currentTableId = tableId.value;
    List<Map<String, dynamic>>? cartItems = cartMap[currentTableId];
    if (cartItems != null) {
      for (var cart in cartItems) {
        List<Map<String, dynamic>> items = cart['items'];
        for (var item in items) {
          // print(itemId);
          // print(item);
          if (item['itemId'] == itemId) {
            return true;
          }
        }
      }
    }
    return false;
  }

  void getTotalItemsForTable() {
    int currentTableId = tableId.value;
    List<Map<String, dynamic>>? cartItems = cartMap[currentTableId];
    if (kDebugMode) {
      print("cart total $currentTableId items are $cartItems");
    }
    if (cartItems != null) {
      cartQuantityItems.value = cartItems.length;
    }
    if (kDebugMode) {
      print("total values are ${cartQuantityItems.value}");
    }
  }
}
