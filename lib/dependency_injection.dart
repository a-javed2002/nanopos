import 'package:get/get.dart';
import 'package:nanopos/controller/network_controller.dart';


class DependencyInjection {
  
  static void init() {
    Get.put<NetworkController>(NetworkController(),permanent:true);
  }
}