import 'package:flutter/material.dart';
import 'package:folder_structure/controller/auth/login_screen_controller.dart';
import 'package:folder_structure/utils/color.dart';
import 'package:folder_structure/utils/custom_text_styles.dart';
import 'package:folder_structure/utils/validator.dart';
import 'package:folder_structure/view/auth/register_screen.dart';
import 'package:folder_structure/widget/custom/custom_password_textfield.dart';
import 'package:folder_structure/widget/custom/custom_textfield.dart';
import 'package:folder_structure/widget/custom/elevated_button.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  final c = Get.put(LoginScreenController());

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    image: DecorationImage(
                      image: AssetImage("assets/images/image.png"),
                      fit:
                          BoxFit.cover, // Ensures the image fills the container
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Welcome Text
                Text(
                  "Welcome Back!",
                  style:
                      CustomTextStyles.f14W600(color: AppColors.primaryColor),
                ),
                const SizedBox(height: 8),
                Text(
                  "Login to continue",
                  style: CustomTextStyles.f16W400(
                      color: AppColors.secondaryTextColor),
                ),

                const SizedBox(height: 30),

                Form(
                  key: c.keys,
                  child: Column(
                    children: [
                      // Email Input
                      CustomTextField(
                        controller: c.emailController,
                        validator: Validators.checkEmailField,
                        textCapitalization: TextCapitalization.none,
                        hint: "Enter your Email",
                        textInputAction: TextInputAction.next,
                        textInputType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),

                      // Password Input
                      Obx(() => CustomPasswordField(
                            validator: Validators.checkPasswordField,
                            hint: "Password",
                            eye: c.passwordObscure.value,
                            onEyeClick: c.onEyeClick,
                            controller: c.passwordController,
                            textInputAction: TextInputAction.done,
                          )),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Login Button
                CustomElevatedButton(
                  title: "Log in",
                  onTap: () {
                    c.onSubmit();
                  },
                ),

                const SizedBox(height: 10),

                // Register Link
                TextButton(
                  onPressed: () {
                    Get.to(() => RegisterScreen());
                  },
                  child: Text(
                    "Don't have an account? Register",
                    style:
                        CustomTextStyles.f14W400(color: AppColors.primaryColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
