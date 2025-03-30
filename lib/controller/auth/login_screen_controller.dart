import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:folder_structure/controller/core_controller.dart';
import 'package:folder_structure/repo/login_user_repo.dart';
import 'package:folder_structure/utils/custom_snackbar.dart';
import 'package:folder_structure/utils/storage_keys.dart';
import 'package:folder_structure/view/dash_screen.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

class LoginScreenController extends GetxController {
  final keys = GlobalKey<FormState>();
  final emailController = TextEditingController();
  RxBool passwordObscure = true.obs;
  final passwordController = TextEditingController();

  void onEyeClick() {
    passwordObscure.value = !passwordObscure.value;
  }

  final loading = SimpleFontelicoProgressDialog(
      context: Get.context!, barrierDimisable: false);

  void onSubmit() async {
    if (keys.currentState!.validate()) {
      loading.show(message: "Logging in...");

      await LoginRepo.login(
        email: emailController.text,
        password: passwordController.text,
        onSuccess: (user, token, userType) async {
          loading.hide();
          final box = GetStorage();
          await box.write(StorageKeys.USER, json.encode(user.toJson()));
          await box.write(StorageKeys.ACCESS_TOKEN, token.toString());
          await box.write(StorageKeys.USER_TYPE, userType);
          Get.find<CoreController>().loadCurrentUser();
          Get.offAll(() => DashScreen());
          CustomSnackBar.success(
              title: "Login", message: "Login in successful");
        },
        onError: (message) {
          loading.hide();
          CustomSnackBar.error(title: "Login", message: message);
        },
      );
    }
  }
}
