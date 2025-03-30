import 'dart:convert';
import 'dart:developer';
import 'package:folder_structure/utils/api.dart';
import 'package:folder_structure/utils/http_request.dart';
import 'package:http/http.dart' as http;

class RegisterUserRepo {
  static Future<void> register({
    required String branchId,
    required String email,
    required String firstName,
    required String gender,
    required String lastName,
    required String phoneNumber,
    required String password,
    required String confirmPassword,
    required Function(String successMessage) onSuccess,
    required Function(String message) onError,
  }) async {
    try {
      var headers = {
        "Accept": "application/json",
      };
      var body = {
        "branch_id": branchId,
        "role": "user",
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "gender": gender,
        "phone_number": phoneNumber,
        "password": password,
        "confirm_password": confirmPassword,
      };
      http.Response response = await HttpRequest.post(
          Uri.parse(Api.registerUrl),
          headers: headers,
          body: body);
      log("response $body");
      dynamic data = jsonDecode(response.body);
      if (data["status"] == "success") {
        onSuccess(data["message"]);
      } else {
        onError(data["message"]);
      }
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      onError("Sorry something went wrong!!");
    }
  }
}
