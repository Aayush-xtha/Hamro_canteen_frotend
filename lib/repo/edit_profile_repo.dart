import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:folder_structure/controller/core_controller.dart';
import 'package:folder_structure/model/user.dart';
import 'package:folder_structure/utils/api.dart';
import 'package:folder_structure/utils/http_request.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class EditProfileRepo {
  static Future<void> editProfile({
    required String firstName,
    required String lastName,
    required String email,
    required String gender,
    required String phone,
    required File? image,
    required Function(Users user) onSuccess,
    required Function(String message) onError,
  }) async {
    try {
      log("🔄 Starting editProfile...");

      var coreController = Get.find<CoreController>();
      var userId = coreController.currentUser.value!.id.toString();
      var branchId = coreController.currentUser.value!.branchId.toString();

      var headers = {
        'Content-Type': 'application/json', // Fixed header format
        'Accept': 'application/json',
      };
      var url = Uri.parse(Api.editProfileUrl);
      log("🔗 API URL: $url");

      http.MultipartRequest request = http.MultipartRequest("POST", url);
      request.headers.addAll(headers);

      request.fields['user_id'] = userId;
      request.fields['first_name'] = firstName;
      request.fields['last_name'] = lastName;
      request.fields['email'] = email;
      request.fields['gender'] = gender;
      request.fields['phone_number'] = phone;
      request.fields['branch_id'] = branchId;

      if (image != null) {
        log("🖼 Uploading image: ${image.path}");
        request.files.add(
          await http.MultipartFile.fromPath(
            "image",
            image.path,
            contentType: MediaType("image", "*"),
          ),
        );
      } else {
        log("⚠️ No image provided.");
      }

      log("🚀 Sending request...");
      http.StreamedResponse response =
          await HttpRequestHamroCanteen.multiPart(request);

      var responseData = await response.stream.bytesToString();
      log("✅ Response received: $responseData");

      var data = jsonDecode(responseData);
      log("📦 Parsed data: $data");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        Users user = Users.fromJson(data["data"]);
        onSuccess(user);
      } else {
        log("❌ API Error: ${data["message"]}");
        onError(data["message"]);
      }
    } catch (e, s) {
      log("❗ Exception: $e");
      log("📜 StackTrace: $s");
      onError("Sorry, something went wrong");
    }
  }
}
