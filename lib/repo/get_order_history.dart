import 'dart:convert';
import 'dart:developer';
import 'package:folder_structure/controller/core_controller.dart';
import 'package:folder_structure/model/order_history.dart';
import 'package:folder_structure/utils/api.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class GetOrderRepo {
  static Future<void> getOrderRepo({
    required Function(List<OrderHistory> order) onSuccess,
    required Function(String message) onError,
  }) async {
    try {
      var coreController = Get.find<CoreController>();
      var userId = coreController.currentUser.value!.id.toString();
      var headers = {"Accept": "application/json"};

      http.Response response = await http.get(
        Uri.parse("${Api.getOrderUrl}?user_id=$userId"),
        headers: headers,
      );


      dynamic data = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (data["data"] != null) {
          List<OrderHistory> order = orderHistoryFromJson(data["data"]);
          onSuccess(order);
        } else {
          onError("No order data found.");
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
