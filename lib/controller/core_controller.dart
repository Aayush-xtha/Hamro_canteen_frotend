import 'dart:developer';

import 'package:folder_structure/model/user.dart';
import 'package:folder_structure/utils/storage_keys.dart';
import 'package:folder_structure/view/auth/login_screen.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CoreController extends GetxController {
  Rx<Users?> currentUser = Rxn<Users>();
  Rx<String> userToken = "".obs;
  Rx<String> userType = "".obs;

  @override
  void onInit() async {
    
    await loadCurrentUser();
    super.onInit();
  }

  Future<void> loadCurrentUser() async {
    currentUser.value = StorageHelper.getUser();
    userToken.value = StorageHelper.getToken();
    userType.value = StorageHelper.getUserType();
    log("User token--${currentUser.value?.token}");
    log("email-${currentUser.value?.email}");
    log("User Type:${userType.value}");
  }

bool isUserLoggendIn() {
  log("dsfsdfsdfdsfdsfsdfsadas jksdhk");

  return currentUser.value != null;
}

  void logOut() async {
    final box = GetStorage();
    await box.write(StorageKeys.USER, null);
    await box.write(StorageKeys.ACCESS_TOKEN, null);
    Get.offAll(() => LoginScreen());
  }
}
// import 'dart:developer';
// import 'package:folder_structure/model/user.dart';
// import 'package:folder_structure/utils/storage_keys.dart';
// import 'package:folder_structure/view/auth/login_screen.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';

// class CoreController extends GetxController {
//   Rx<Users?> currentUser = Rxn<Users>();
//   Rx<String> userToken = "".obs;
//   Rx<String> userType = "".obs;

//   @override
//   void onInit() {
//     super.onInit();
//     loadCurrentUser();
//   }

//   Future<void> loadCurrentUser() async {
//     final storedUser = StorageHelper.getUser();
//     final storedToken = StorageHelper.getToken();
//     final storedUserType = StorageHelper.getUserType();

//     if (storedUser != null && storedToken.isNotEmpty) {
//       currentUser.value = storedUser;
//       userToken.value = storedToken;
//       userType.value = storedUserType;

//       log("User loaded successfully:");
//       log("User token: ${userToken.value}");
//       log("Email: ${currentUser.value?.email}");
//       log("User Type: ${userType.value}");
//     } else {
//       log("No user found in storage.");
//     }
//   }

//   bool isUserLoggendIn() {
//     log("dsfsdfsdfdsfdsfsdfsadas jksdhk");

//     return currentUser.value != null;
//   }

//   void logOut() async {
//     final box = GetStorage();
//     await box.remove(StorageKeys.USER);
//     await box.remove(StorageKeys.ACCESS_TOKEN);
//     await box.remove(StorageKeys.USER_TYPE);

//     currentUser.value = null;
//     userToken.value = "";
//     userType.value = "";

//     Get.offAll(() => LoginScreen());
//     log("User logged out successfully.");
//   }
// }
