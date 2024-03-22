import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiController extends GetxController {
  var cat = [].obs;
  var item = [].obs;
  var filItem = [].obs;
  RxInt selectedCatId = RxInt(0);
  var searchQuery = ''.obs;

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
}
