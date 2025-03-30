import 'dart:io';

import 'package:flutter/material.dart';
import 'package:folder_structure/model/branch.dart';
import 'package:folder_structure/repo/get_branch_repo.dart';
import 'package:folder_structure/repo/register_user_repo.dart';
import 'package:folder_structure/utils/custom_snackbar.dart';
import 'package:folder_structure/view/auth/login_screen.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

class RegisterScreenController extends GetxController {
  final formKey = GlobalKey<FormState>();
  RxBool passwordObscure = true.obs;
  RxBool cpasswordObscure = true.obs;
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  RxString genderSelectedValue = ''.obs;
  final passwordController = TextEditingController();
  final cPasswordController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  Rx<File?> selectedImage = Rx<File?>(null);
  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  @override
  void onInit() {
    getAllBranches();
    super.onInit();
  }

  void onEyeClick() {
    passwordObscure.value = !passwordObscure.value;
  }

  void onEyeClick2() {
    cpasswordObscure.value = !cpasswordObscure.value;
  }

  final loading = SimpleFontelicoProgressDialog(
      context: Get.context!, barrierDimisable: false);
  void onSubmit() async {
    if (formKey.currentState!.validate()) {
      loading.show(message: "Please wait..");
      await RegisterUserRepo.register(
          branchId: selectedTable.value.branchId.toString(),
          email: emailController.text,
          firstName: firstNameController.text,
          gender: genderSelectedValue.value,
          lastName: lastNameController.text,
          phoneNumber: phoneNumberController.text,
          password: passwordController.text,
          confirmPassword: cPasswordController.text,
          onSuccess: (message) {
            loading.hide();
            Get.offAll(() => LoginScreen());
            CustomSnackBar.success(
                title: "Register", message: "register successfull");
          },
          onError: (message) {
            loading.hide();
            CustomSnackBar.error(title: "Register", message: message);
          });
    }
  }

  final selectedTable = BranchDetail().obs;
  void setSelectedTable(BranchDetail table) {
    selectedTable.value = table;
  }

  RxList<BranchDetail> allBranches = <BranchDetail>[].obs;
  RxBool loadings = RxBool(false);
  getAllBranches() async {
    loadings.value = true;
    await GetBranchRepo.getBranchRepo(onSuccess: (branch) {
      loadings.value = false;
      allBranches.addAll(branch);
    }, onError: (message) {
      loadings.value = false;
      CustomSnackBar.error(title: "branch", message: message);
    });
  }
}
