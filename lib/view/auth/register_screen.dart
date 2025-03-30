import 'package:flutter/material.dart';
import 'package:folder_structure/controller/auth/register_screen_controller.dart';
import 'package:folder_structure/model/branch.dart';
import 'package:folder_structure/utils/color.dart';
import 'package:folder_structure/utils/custom_text_styles.dart';
import 'package:folder_structure/utils/validator.dart';
import 'package:folder_structure/widget/custom/custom_password_textfield.dart';
import 'package:folder_structure/widget/custom/custom_textfield.dart';
import 'package:folder_structure/widget/custom/elevated_button.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatelessWidget {
  final r = Get.put(RegisterScreenController());
  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Register",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: r.formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: r.pickImage,
                child: Obx(() => Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: AppColors.primaryColor, width: 2),
                      ),
                      child: ClipOval(
                        child: r.selectedImage.value != null
                            ? Image.file(
                                r.selectedImage.value!,
                                fit: BoxFit.cover,
                              )
                            : const Icon(
                                Icons.camera_alt,
                                size: 40,
                                color: Colors.grey,
                              ),
                      ),
                    )),
              ),
              const SizedBox(height: 20),

              CustomTextField(
                controller: r.firstNameController,
                hint: "Enter first name",
                validator: Validators.checkFieldEmpty,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                textInputType: TextInputType.text,
              ),
              const SizedBox(height: 10),

              CustomTextField(
                controller: r.lastNameController,
                validator: Validators.checkFieldEmpty,
                hint: "Enter last name",
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                textInputType: TextInputType.text,
              ),
              const SizedBox(height: 10),

              CustomTextField(
                validator: Validators.checkEmailField,
                controller: r.emailController,
                hint: "Enter your Email",
                textInputAction: TextInputAction.next,
                textInputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),

              Obx(() => CustomPasswordField(
                    validator: Validators.checkPasswordField,
                    hint: "Password",
                    eye: r.passwordObscure.value,
                    onEyeClick: r.onEyeClick,
                    controller: r.passwordController,
                    textInputAction: TextInputAction.next,
                  )),
              const SizedBox(height: 10),

              Obx(() => CustomPasswordField(
                    validator: Validators.checkPasswordField,
                    hint: "Confirm Password",
                    eye: r.cpasswordObscure.value,
                    onEyeClick: r.onEyeClick2,
                    controller: r.cPasswordController,
                    textInputAction: TextInputAction.next,
                  )),
              const SizedBox(height: 10),

              // Branch Dropdown
              Obx(
                () => DropdownButtonFormField<BranchDetail>(
                  decoration: InputDecoration(
                    hintText: "Select Branch",
                    hintStyle: CustomTextStyles.f16W400(
                        color: AppColors.secondaryTextColor),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.lGrey, width: 1),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.primaryColor, width: 1),
                    ),
                  ),
                  value: r.allBranches.isNotEmpty ? r.allBranches.first : null,
                  items: r.allBranches
                      .map((branch) => DropdownMenuItem(
                            value: branch,
                            child: Text(branch.branchName!,
                                style: CustomTextStyles.f16W400()),
                          ))
                      .toList(),
                  onChanged: (selectedBranch) {
                    r.setSelectedTable(selectedBranch!);
                  },
                ),
              ),
              const SizedBox(height: 10),

              CustomTextField(
                controller: r.phoneNumberController,
                validator: Validators.checkFieldEmpty,
                hint: "Enter your phone number",
                textInputAction: TextInputAction.next,
                textInputType: TextInputType.phone,
              ),
              const SizedBox(height: 10),

              // Gender Dropdown
              DropdownButtonFormField(
                onChanged: (value) {
                  r.genderSelectedValue.value = value.toString();
                },
                items: [
                  DropdownMenuItem(
                      value: 'male',
                      child: Text('Male', style: CustomTextStyles.f16W400())),
                  DropdownMenuItem(
                      value: 'female',
                      child: Text('Female', style: CustomTextStyles.f16W400())),
                ],
                decoration: InputDecoration(
                  hintText: "Select Gender",
                  hintStyle: CustomTextStyles.f16W400(
                      color: AppColors.secondaryTextColor),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.lGrey, width: 1),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.primaryColor, width: 1),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              CustomElevatedButton(
                title: "Submit",
                onTap: () {
                  r.onSubmit();
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
