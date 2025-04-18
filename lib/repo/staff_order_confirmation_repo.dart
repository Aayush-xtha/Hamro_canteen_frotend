import 'dart:convert';
import 'dart:developer';
import 'package:folder_structure/controller/core_controller.dart';
import 'package:folder_structure/utils/api.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class StaffOrderConfirmationRepo {
  static Future<void> staffOrderConfirmationRepo({
    required String orderId,
    required String paymentAmount,
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
        "staff_id": userId,
        "order_id": orderId,
        "payment_amount": paymentAmount,
      };

      log("add to staff confirm request: $body");

      http.Response response = await http.post(
        Uri.parse(Api.confirmOrderUrl),
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
