import 'package:flutter/material.dart';
import 'package:folder_structure/controller/core_controller.dart';
import 'package:folder_structure/repo/change_password_repo.dart';
import 'package:folder_structure/utils/custom_snackbar.dart';
import 'package:get/get.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

class ChangePasswordController extends GetxController {
  final coreController = Get.put(CoreController());
  final formKey = GlobalKey<FormState>();
  RxBool currentPasswordObscure = true.obs;
  RxBool newPasswordObscure = true.obs;
  RxBool confirmPasswordObscure = true.obs;
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  void onEyeClick() {
    currentPasswordObscure.value = !currentPasswordObscure.value;
  }

  void onEyeClick2() {
    newPasswordObscure.value = !newPasswordObscure.value;
  }

  void onEyeClick3() {
    confirmPasswordObscure.value = !confirmPasswordObscure.value;
  }

  final loading = SimpleFontelicoProgressDialog(
    context: Get.context!,
    barrierDimisable: false,
  );

  void onSubmit() async {
    if (formKey.currentState!.validate()) {
      loading.show(message: "Changing Password...");

      await ChangePasswordRepo.changePassword(
        currentPassword: currentPasswordController.text,
        newPassword: newPasswordController.text,
        confirmPassword: confirmPasswordController.text,
        onSuccess: () {
          loading.hide();
          Get.back();
          CustomSnackBar.success(
              title: "Change Password", message: "Password Update successful");
        },
        onError: (message) {
          loading.hide();
          CustomSnackBar.error(title: "Change Password", message: message);
        },
      );
    }
  }
}
