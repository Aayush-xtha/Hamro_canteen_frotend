import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:folder_structure/controller/core_controller.dart';
import 'package:folder_structure/model/user.dart';
import 'package:folder_structure/repo/edit_profile_repo.dart';
import 'package:folder_structure/utils/custom_snackbar.dart';
import 'package:folder_structure/utils/storage_keys.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

class EditProfileController extends GetxController {
  final coreController = Get.put(CoreController());
  final formKey = GlobalKey<FormState>();

  final userNameController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final branchNameController = TextEditingController();
  final roleController = TextEditingController();
  final genderController = TextEditingController();

  final phoneController = TextEditingController();

  final picker = ImagePicker();

  Rxn<File> image = Rxn<File>();
  Rxn<String> avatarUrl = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    userDetails();
  }

  void userDetails() {
    var user = Get.find<CoreController>().currentUser.value;
    if (user != null) {
      firstNameController.text = user.firstName ?? "";
      lastNameController.text = user.lastName ?? "";
      emailController.text = user.email ?? "";
      genderController.text = user.gender ?? "";
      phoneController.text = user.phoneNumber ?? "";
      avatarUrl.value = user.image ?? "";
      branchNameController.text = user.branchName ?? "";
      roleController.text = user.role ?? "";
    }
  }

  void pickImage() async {
    log("Picking Image");
    final pickedImage = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
        maxHeight: 250,
        maxWidth: 250);

    if (pickedImage != null) {
      log("Image Picked: ${pickedImage.path}");
      image.value = File(pickedImage.path);
    } else {
      log("No image selected");
    }
  }

  final loading = SimpleFontelicoProgressDialog(
      context: Get.context!, barrierDimisable: false);

  void onSubmit() async {
    if (formKey.currentState!.validate()) {
      loading.show(message: "Please Wait...");
      await EditProfileRepo.editProfile(
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          email: emailController.text,
          gender: genderController.text,
          phone: phoneController.text,
          image: image.value,
          onSuccess: (user) async {
            loading.hide();
            final box = GetStorage();
            user.token ??= coreController.currentUser.value?.token;
            user.role ??= coreController.currentUser.value?.role;
            await box.write(StorageKeys.USER, json.encode(user.toJson()));
            coreController.currentUser.value = Users.fromJson(user.toJson());
            avatarUrl.value = user.image;
            userDetails();
            Get.find<CoreController>().loadCurrentUser();

            Get.back();
            CustomSnackBar.success(
                title: "Update Profile", message: "Profile update successful");
          },
          onError: (message) {
            loading.hide();
            CustomSnackBar.error(title: "Update Profile", message: message);
          });
    }
  }
}
