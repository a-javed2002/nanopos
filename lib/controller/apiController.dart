import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nanopos/database/cat_db.dart';
import 'package:nanopos/database/item_db.dart';
import 'dart:convert';

import 'package:nanopos/models/cat.dart';
import 'package:nanopos/models/item.dart';

class ApiController extends GetxController {
  var cat = [].obs;
  var item = [].obs;
  var filItem = [].obs;
  RxInt selectedCatId = RxInt(0);
  var searchQuery = ''.obs;

  String token = "";

  Future<List<Item>>? futureItems;
  final itemDB = ItemDB();

  Future<List<Cat>>? futureCats;
  final catDB = CatDB();

  @override
  void onInit() {
    super.onInit();
    selectedCatId.value = 0;
  }

  void fetchData(String apiUrl, String userToken, RxList<dynamic> updatedList,
      {bool x = false}) async {
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'X-Api-Key': 'b6d68vy2-m7g5-20r0-5275-h103w73453q120',
          'Authorization': 'Bearer $userToken',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic>? dataList = responseData['data'];

        if (dataList != null) {
          updatedList.value = dataList;
          // if (x) {
          //   selectedCatId.value = cat[0]['id'];
          //   print("${selectedCatId.value}");
          // }
          // print("asd $item");
        } else {
          throw Exception('Failed to parse table data');
        }
      } else {
        throw Exception('Failed to load active cat');
      }

      // Delay before fetching cat again
    } catch (e) {
      print('Error fetching cat: $e');
    }
  }

  void filterItem() {
    filItem.value = [];
    print("Selected cat id is ${selectedCatId.value} and items are $item");
    if (selectedCatId.value == 0) {
      filItem = item;
    } else {
      for (var i = 0; i < item.length; i++) {
        print("in here");
        if (item[i]['item_category_id'] == selectedCatId.value) {
          filItem.add(item[i]);
        }
      }
    }
  }

  void searchItem() {
    String query =
        searchQuery.value.trim().toLowerCase(); // Trim and convert to lowercase
    // print("query $query");
    if (query.isEmpty) {
      // If the search query is empty, show all items
      filterItem();
    } else {
      // If the search query is not empty, filter items based on the query
      filItem.value = [];
      for (var i = 0; i < item.length; i++) {
        if (item[i]['name'].toString().toLowerCase().contains(query)) {
          filItem.add(item[i]);
        }
      }
    }
  }

  void sqlCatInsertion() async {
    print("Selected cat id is ${selectedCatId.value} and items are $item");
    futureCats = catDB.fetchAll() as Future<List<Cat>>?;
    print("futureItems $futureCats");
    if (futureCats != null) {
      List<Cat> catt = await futureCats!;
      for (var i = 0; i < catt.length; i++) {
        print("id: ${catt[i].cat_id},name: ${catt[i].cat_name}");
      }
    }
    print(
        "----------------------------Clear item table & insert N Chk---------------------------------------");
    if (cat.isNotEmpty) {
      catDB.truncateTable();
      for (var i = 0; i < cat.length; i++) {
        // print("--> ${cat[i]}");
        await catDB.create(
          cat_id: cat[i]['id'],
          cat_name: cat[i]['name'],
        );
      }
    }
    print(
        "-------------------------------------------------------------------");
    futureCats = catDB.fetchAll() as Future<List<Cat>>?;
    print("futureItems $futureCats");
    if (futureCats != null) {
      List<Cat> catt = await futureCats!;
      for (var i = 0; i < catt.length; i++) {
        print("id: ${catt[i].cat_id},name: ${catt[i].cat_name}");
      }
    }
  }

  void sqlItemInsertion() async {
    print("Selected cat id is ${selectedCatId.value} and items are $item");
    futureItems = itemDB.fetchAll() as Future<List<Item>>?;
    print("futureItems $futureItems");
    if (futureItems != null) {
      List<Item> items = await futureItems!;
      for (var i = 0; i < items.length; i++) {
        print(
            "id: ${items[i].item_id},name: ${items[i].item_name},image: ${items[i].item_image},name: ${items[i].item_price}");
      }
    }
    print(
        "----------------------------Clear item table & insert N Chk---------------------------------------");
    if (item.isNotEmpty) {
      itemDB.truncateTable();
      for (var i = 0; i < item.length; i++) {
        await itemDB.create(
            item_id: item[i]['id'],
            item_image: item[i]['cover'],
            item_name: item[i]['name'],
            item_price: item[i]['price']);
      }
    }
    print(
        "-------------------------------------------------------------------");
    futureItems = itemDB.fetchAll() as Future<List<Item>>?;
    print("futureItems $futureItems");
    if (futureItems != null) {
      List<Item> items = await futureItems!;
      for (var i = 0; i < items.length; i++) {
        print(
            "id: ${items[i].item_id},name: ${items[i].item_name},image: ${items[i].item_image},name: ${items[i].item_price}");
      }
    }
  }

  void sqlInsertion() async {
    String catUrl =
        'https://restaurant.nanosystems.com.pk/api/admin/setting/item-category?order_type=desc';
    String itemUrl =
        'https://restaurant.nanosystems.com.pk/api/admin/item?order_type=desc';

    fetchData(catUrl, token, cat, x: true);
    fetchData(itemUrl, token, item);
    sqlCatInsertion();
    sqlItemInsertion();
  }
}
