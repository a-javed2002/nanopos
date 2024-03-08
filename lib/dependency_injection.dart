import 'package:get/get.dart';
import 'package:nanopos/controller/networkController.dart';


class DependencyInjection {
  
  static void init() {
    Get.put<NetworkController>(NetworkController(),permanent:true);
  }
}