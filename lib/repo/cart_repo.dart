import 'dart:convert';
import 'dart:developer';
import 'package:folder_structure/utils/api.dart';
import 'package:http/http.dart' as http;

class CartRepo {
  static Future<void> addToCart({
    // required int userId,
    required int foodId,
    required int quantity,
    // required int branchId,
    required Function(String message) onSuccess,
    required Function(String message) onError,
  }) async {
    try {
      var headers = {
        "Accept": "application/json",
      };
      var body = {
        // "user_id": userId.toString(),
        "food_id": foodId.toString(),
        "quantity": quantity.toString(),
        // "branch_id": branchId.toString(),
      };

      http.Response response = await http.post(Uri.parse(Api.addToCartUrl),
          headers: headers, body: body);
      dynamic data = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        onSuccess(data["message"]);
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
