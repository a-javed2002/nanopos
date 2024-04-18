import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nanopos/consts/consts.dart';
import 'package:nanopos/views/Home/order.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AdminController extends GetxController {
  var order = [].obs;
  var filOrder = [].obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> fetchData(
      String apiUrl, String userToken, RxList<dynamic> updatedList,
      {bool x = false}) async {
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'X-Api-Key': xApi,
          'Authorization': 'Bearer $userToken',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic>? dataList = responseData['data'];

        if (dataList != null) {
          updatedList.value = dataList;
          filOrder.value = dataList;
          if (kDebugMode) {
          print(dataList);

          }
        } else {
          throw Exception('Failed to parse Admin Order data');
        }
      } else if (response.statusCode == 401) {
        if (kDebugMode) {
        print("Session Expire");

        }
      } else {
        throw Exception('Failed to load Admin Order datat');
      }

      // Delay before fetching cat again
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching cat: $e');
      }
    }
  }

  void filterOrder() {
    filOrder.value = [];
    if (kDebugMode) {
      print("Selected cat id is and items are $order");
    }
    for (var i = 0; i < order.length; i++) {
      if (kDebugMode) {
        print("in here2");
      }
      filOrder.add(order[i]);
    }
  }

  void searchItem() {
    String query =
        searchQuery.value.trim().toLowerCase(); // Trim and convert to lowercase
    // print("query $query");
    if (query.isEmpty) {
      // If the search query is empty, show all items
      filterOrder();
    } else {
      // If the search query is not empty, filter items based on the query
      filOrder.value = [];
      for (var i = 0; i < order.length; i++) {
        if (order[i]['order_serial_no']
                .toString()
                .toLowerCase()
                .contains(query) ||
            order[i]['total_currency_price']
                .toString()
                .toLowerCase()
                .contains(query) ||
            order[i]['order_datetime']
                .toString()
                .toLowerCase()
                .contains(query)) {
          filOrder.add(order[i]);
        }
      }
    }
  }

  // Save Order object to SharedPreferences
  Future<void> setLocal(Order order) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String orderJson = jsonEncode(order.toJson());
    await prefs.setString('lastOrder', orderJson);
  }

// Retrieve Order object from SharedPreferences
  // Future<Order?> getLocal() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? orderJson = prefs.getString('lastOrder');

  //   if (orderJson != null) {
  //     Map<String, dynamic> orderMap = jsonDecode(orderJson);

  //     return Order.fromJson(orderMap);
  //   }

  //   return null;
  // }

  Future<Order?> getLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? orderJson = prefs.getString('lastOrder');

    if (orderJson != null) {
      Map<String, dynamic> orderMap = jsonDecode(orderJson);

      if (orderMap.isNotEmpty) {
        // Extract order items data from the JSON map
        List<dynamic> orderItemsList = orderMap['orderItems'] ?? [];
        List<OrderItems> orderItems = [];

        for (var item in orderItemsList) {
          OrderItems orderItem = OrderItems(
              oId: item['id'].toString(),
              id: item['item_id'].toString(),
              itemName: item['item_name'],
              itemImage: item['item_image'],
              quantity: item['quantity'],
              price: item['price'],
              instruction: item['instruction'],
              totalConvertPrice: item['total_convert_price'],
              taxRate: item['tax_rate'],
              itemVariationCurrencyTotal:
                  item['item_variation_currency_total'],
              itemExtraCurrencyTotal: item['item_extra_currency_total'],
              itemVariations: item['item_variations'],
              itemExtras: item['item_extras']);

          orderItems.add(orderItem);
        }

        Order order = Order(
            id: orderMap['id'].toString(),
            orderSerialNo: orderMap['order_serial_no'],
            status: -1,
            statusName: orderMap['status_name'],
            orderDatetime: orderMap['order_datetime'],
            totalCurrencyPrice: orderMap['total_currency_price'],
            orderItems: orderItems,
            subtotal_currency_price: orderMap['total_currency_price'],
            subtotal_without_tax_currency_price:
                orderMap['total_currency_price'],
            discount_currency_price: orderMap['total_currency_price'],
            total_currency_price: orderMap['total_currency_price'],
            totalTaxCurrencyPrice: orderMap['total_currency_price']);

        return order;
      }
    }

    return null;
  }

// Helper function to parse price string (e.g., "Rs1889.00") to double
  double parsePrice(String priceString) {
    // Remove "Rs" prefix and parse the remaining string as a double
    return double.parse(priceString.replaceAll('Rs', ''));
  }
}
