import 'dart:convert';
import 'dart:developer';
import 'package:folder_structure/controller/core_controller.dart';
import 'package:folder_structure/model/food_detail.dart';
import 'package:folder_structure/utils/api.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class GetFoodRepo {
  static Future<void> getFoodRepo({
    required Function(List<FoodDetails> food) onSuccess,
    required Function(String message) onError,
  }) async {
    try {
      var coreController = Get.find<CoreController>();
      var branchId = coreController.currentUser.value!.branchId.toString();
      var headers = {"Accept": "application/json"};

      http.Response response = await http.get(
        Uri.parse("${Api.getFoodUrl}?branch_id=$branchId"),
        headers: headers,
      );


      dynamic data = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (data["data"] != null) {
          List<FoodDetails> food = foodFromJson(data["data"]);
          onSuccess(food);
        } else {
          onError("No food data found.");
        }
      } else {
        onError(data['message'] ?? "Unknown error occurred");
      }
    } catch (e) {
      log("Error: $e");
      onError("Sorry! Something went wrong: $e");
    }
  }
}
