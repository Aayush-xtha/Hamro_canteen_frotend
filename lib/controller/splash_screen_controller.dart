import 'dart:async';

import 'package:folder_structure/controller/core_controller.dart';
import 'package:folder_structure/view/auth/login_screen.dart';
import 'package:folder_structure/view/dash_screen.dart';
import 'package:get/get.dart';

class SplashScreenController extends GetxController {
  final c = Get.put(CoreController());
  @override
  // void onInit() {
  //   super.onInit();
  //   Timer(const Duration(seconds: 4), () async {
  //     Get.offAll(() => LoginScreen());
  //   });
  // }

  void onInit() {
    super.onInit();
    Timer(const Duration(seconds: 4), () async {
      if (c.isUserLoggendIn()) {
        Get.offAll(() => DashScreen());
      } else {
        Get.offAll(() => LoginScreen());
      }
    });
  }
}
