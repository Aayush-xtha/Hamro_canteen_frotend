import 'dart:convert';
import 'dart:developer';
import 'package:folder_structure/utils/api.dart';
import 'package:http/http.dart' as http;

class PaymentStatusRepo {
  static Future<void> paymentStatusRepo({
    required String paymentId,
    required Function() onSuccess,
    required Function(String message) onError,
  }) async {
    try {
      var headers = {
        "Accept": "application/json",
      };

      var body = {
        "payment_id": paymentId,
        "status": "1",
      };

      log("add to payment confirm request: $body");

      http.Response response = await http.post(
        Uri.parse(Api.paymentStatusUrl),
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
