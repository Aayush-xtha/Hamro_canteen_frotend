import 'dart:convert';
import 'dart:developer';
import 'package:folder_structure/controller/core_controller.dart';
import 'package:folder_structure/utils/api.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AddOrderRepo {
  static Future<void> orderRepo({
    required String userid,
    required List<Map<String, dynamic>> foodItems,
    required String paymentMethod,
    required Function() onSuccess,
    required Function(String message) onError,
  }) async {
    try {
      var coreController = Get.find<CoreController>();
      var branchId = coreController.currentUser.value!.branchId.toString();
      var headers = {
        "Accept": "application/json",
      };

      var body = {
        "user_id": userid,
        "food_items": jsonEncode(foodItems),
        "branch_id": branchId,
        "method": paymentMethod,
      };

      log("Order food request: $body");

      http.Response response = await http.post(
        Uri.parse(Api.orderFoodUrl),
        headers: headers,
        body: body,
      );

      log("Response: ${response.body}");

      dynamic data = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        onSuccess();
      } else {
        onError(data["message"] ?? "Failed to place order");
      }
    } catch (e, s) {
      log("Error: $e");
      log("Stack Trace: $s");
      onError("Sorry, something went wrong");
    }
  }
}
