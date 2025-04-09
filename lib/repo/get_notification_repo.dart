import 'dart:convert';
import 'package:folder_structure/model/notification.dart';
import 'package:folder_structure/utils/api.dart';
import 'package:http/http.dart' as http;

class GetNotificationRepo {
  static Future<void> getNotificationRepo({
    required String userId,
    required String branchId,
    required Function(List<GetNotification> notifications) onSuccess,
    required Function(String message) onError,
  }) async {
    try {
      var headers = {
        "Accept": "application/json",
        "Content-Type": "application/json",
      };

      // 👇 Attach query parameters here
      final uri = Uri.parse(
        "${Api.getNotificationUrl}?user_id=$userId&branch_id=$branchId",
      );

      http.Response response = await http.get(uri, headers: headers);
      print("RESPONSE: ${response.body}");

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        List<GetNotification> notifications = (data['data'] as List)
            .map((e) => GetNotification.fromJson(e))
            .toList();
        onSuccess(notifications);
      } else {
        onError(data['message']);
      }
    } catch (e) {
      print("ERROR: $e");
      onError("Sorry! Something went wrong");
    }
  }
}

