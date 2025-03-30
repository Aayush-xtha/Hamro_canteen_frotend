import 'dart:convert';
import 'package:folder_structure/model/branch.dart';
import 'package:folder_structure/utils/api.dart';
import 'package:http/http.dart' as http;

class GetBranchRepo {
  static Future<void> getBranchRepo({
    required Function(List<BranchDetail> branch) onSuccess,
    required Function(String message) onError,
  }) async {
    try {
      var headers = {
        "Accept": "application/json",
        "Content-Type": "application/json",
      };

      http.Response response = await http.get(
        Uri.parse(Api.getBranchUrl),
        headers: headers,
      );

      dynamic data = json.decode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        List<BranchDetail> branch = branchFromJson(data["data"]);
        onSuccess(branch);
      } else {
        onError(data['message']);
      }
    } catch (e) {
      onError("Sorry! something went wrong");
      print(e);
    }
  }
}
