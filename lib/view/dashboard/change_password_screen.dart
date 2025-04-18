import 'package:flutter/material.dart';
import 'package:folder_structure/controller/dashboard/change_password_controller.dart';
import 'package:folder_structure/utils/color.dart';
import 'package:folder_structure/utils/validator.dart';
import 'package:folder_structure/widget/custom/elevated_button.dart';
import 'package:get/get.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});
  final controller = Get.put(ChangePasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Obx(() => _buildPasswordField(
                    controller: controller.currentPasswordController,
                    hintText: "Old password",
                    isObscured: controller.currentPasswordObscure.value,
                    onToggleVisibility: controller.onEyeClick,
                    validator: Validators.checkPasswordField,
                    textInputAction: TextInputAction.next,
                  )),
              const SizedBox(height: 16),
              Obx(() => _buildPasswordField(
                    controller: controller.newPasswordController,
                    hintText: "New password",
                    isObscured: controller.newPasswordObscure.value,
                    onToggleVisibility: controller.onEyeClick2,
                    validator: Validators.checkPasswordField,
                    textInputAction: TextInputAction.next,
                  )),
              const SizedBox(height: 16),
              Obx(() => _buildPasswordField(
                    controller: controller.confirmPasswordController,
                    hintText: "Confirm password",
                    isObscured: controller.confirmPasswordObscure.value,
                    onToggleVisibility: controller.onEyeClick3,
                    validator: Validators.checkPasswordField,
                    textInputAction: TextInputAction.next,
                  )),
              const SizedBox(height: 24),
              CustomElevatedButton(
                  title: "Update Password",
                  onTap: () {
                    controller.onSubmit();
                  })
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool isObscured,
    required VoidCallback onToggleVisibility,
    required String? Function(String?)? validator,
    required TextInputAction textInputAction,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: isObscured,
        textInputAction: textInputAction,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon:
              const Icon(Icons.lock_outline, color: AppColors.primaryColor),
          suffixIcon: IconButton(
            icon: Icon(
              isObscured ? Icons.visibility_off : Icons.visibility,
              color: AppColors.primaryColor,
            ),
            onPressed: onToggleVisibility,
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
      ),
    );
  }
}
