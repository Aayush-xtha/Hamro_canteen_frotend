import 'dart:convert';
import 'dart:developer';
import 'package:folder_structure/controller/core_controller.dart';
import 'package:folder_structure/utils/api.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ChangePasswordRepo {
  static Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
    required Function() onSuccess,
    required Function(String message) onError,
  }) async {
    try {
      var coreController = Get.find<CoreController>();
      var userId = coreController.currentUser.value!.id.toString();
      var headers = {
        "Accept": "application/json",
      };
      var body = {
        "id": userId,
        "old_password": currentPassword,
        "new_password": newPassword,
        "confirm_password": confirmPassword,
      };
      http.Response response = await http.post(Uri.parse(Api.changePasswordUrl),
          headers: headers, body: body);
      dynamic data = jsonDecode(response.body);
      log("$data");
      if (response.statusCode >= 200 && response.statusCode < 300) {
        onSuccess();
      } else {
        onError(data["message"]);
      }
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      onError("Sorry, something went wrong");
    }
  }
}
