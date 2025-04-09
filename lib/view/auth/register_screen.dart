import 'package:flutter/material.dart';
import 'package:folder_structure/controller/auth/register_screen_controller.dart';
import 'package:folder_structure/model/branch.dart';
import 'package:folder_structure/utils/color.dart';
import 'package:folder_structure/utils/validator.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatelessWidget {
  final RegisterScreenController controller =
      Get.put(RegisterScreenController());

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Top curved background
          _buildTopBackground(size),

          // Main content
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 16),
                    child: _buildBackButton(),
                  ),

                  SizedBox(height: size.height * 0.08),

                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildHeader(),
                  ),

                  const SizedBox(height: 30),

                  // Registration form
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildRegistrationForm(),
                  ),

                  const SizedBox(height: 30),

                  // Register button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildRegisterButton(),
                  ),

                  const SizedBox(height: 24),

                  // Login link
                  _buildLoginLink(),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBackground(Size size) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: size.height * 0.3,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryColor,
              AppColors.primaryColor.withOpacity(0.8),
            ],
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(60),
            bottomRight: Radius.circular(60),
          ),
        ),
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              top: 50,
              left: 20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              top: 100,
              right: 40,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              left: 100,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, size: 18),
        onPressed: () => Get.back(),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Create Account",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),

        const SizedBox(height: 12),

        Text(
          "Fill in your details to get started",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),

        const SizedBox(height: 24),

        // Profile image selection
        Center(
          child: GestureDetector(
            onTap: controller.pickImage,
            child: Obx(() => Column(
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[100],
                        border:
                            Border.all(color: AppColors.primaryColor, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 10,
                            spreadRadius: 0,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          ClipOval(
                            child: controller.selectedImage.value != null
                                ? Image.file(
                                    controller.selectedImage.value!,
                                    fit: BoxFit.cover,
                                    height: 100,
                                    width: 100,
                                  )
                                : Center(
                                    child: Icon(
                                      Icons.person,
                                      size: 50,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Add Profile Photo",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ],
    );
  }

  Widget _buildRegistrationForm() {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Personal Information Section
          _buildSectionTitle("Personal Information"),
          const SizedBox(height: 16),

          // First Name and Last Name
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputLabel("First Name"),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: controller.firstNameController,
                      hintText: "First name",
                      prefixIcon: Icons.person_outline,
                      validator: Validators.checkFieldEmpty,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputLabel("Last Name"),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: controller.lastNameController,
                      hintText: "Last name",
                      prefixIcon: Icons.person_outline,
                      validator: Validators.checkFieldEmpty,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Gender
          _buildInputLabel("Gender"),
          const SizedBox(height: 8),
          _buildDropdown(
            items: const [
              DropdownMenuItem(value: 'male', child: Text('Male')),
              DropdownMenuItem(value: 'female', child: Text('Female')),
            ],
            onChanged: (value) {
              controller.genderSelectedValue.value = value.toString();
            },
            hint: "Select Gender",
          ),

          const SizedBox(height: 24),

          // Contact Information Section
          _buildSectionTitle("Contact Information"),
          const SizedBox(height: 16),

          // Email
          _buildInputLabel("Email Address"),
          const SizedBox(height: 8),
          _buildTextField(
            controller: controller.emailController,
            hintText: "Enter your email",
            prefixIcon: Icons.email_outlined,
            validator: Validators.checkEmailField,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),

          const SizedBox(height: 20),

          // Phone
          _buildInputLabel("Phone Number"),
          const SizedBox(height: 8),
          _buildTextField(
            controller: controller.phoneNumberController,
            hintText: "Enter your phone number",
            prefixIcon: Icons.phone_outlined,
            validator: Validators.checkFieldEmpty,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
          ),

          const SizedBox(height: 24),

          // Account Information Section
          _buildSectionTitle("Account Information"),
          const SizedBox(height: 16),

          // Password
          _buildInputLabel("Password"),
          const SizedBox(height: 8),
          Obx(() => _buildPasswordField(
                controller: controller.passwordController,
                hintText: "Create password",
                isObscured: controller.passwordObscure.value,
                onToggleVisibility: controller.onEyeClick,
                validator: Validators.checkPasswordField,
                textInputAction: TextInputAction.next,
              )),

          const SizedBox(height: 20),

          // Confirm Password
          _buildInputLabel("Confirm Password"),
          const SizedBox(height: 8),
          Obx(() => _buildPasswordField(
                controller: controller.cPasswordController,
                hintText: "Confirm password",
                isObscured: controller.cpasswordObscure.value,
                onToggleVisibility: controller.onEyeClick2,
                validator: Validators.checkPasswordField,
                textInputAction: TextInputAction.next,
              )),

          const SizedBox(height: 24),

          // Branch Information Section
          _buildSectionTitle("Branch Information"),
          const SizedBox(height: 16),

          // Branch
          _buildInputLabel("Select Branch"),
          const SizedBox(height: 8),
          Obx(() => _buildBranchDropdown()),

          const SizedBox(height: 24),

          // Terms and Conditions
          Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: true,
                  activeColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  onChanged: (value) {
                    // Handle terms acceptance
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "I agree to the Terms of Service and Privacy Policy",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 2,
          width: 40,
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildInputLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    required String? Function(String?)? validator,
    required TextInputType keyboardType,
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
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: Icon(prefixIcon, color: AppColors.primaryColor),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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

  Widget _buildDropdown({
    required List<DropdownMenuItem> items,
    required Function(dynamic) onChanged,
    required String hint,
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
      child: DropdownButtonFormField(
        items: items,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon:
              const Icon(Icons.person_outline, color: AppColors.primaryColor),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
        icon: const Icon(Icons.arrow_drop_down, color: AppColors.primaryColor),
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  Widget _buildBranchDropdown() {
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
      child: DropdownButtonFormField<BranchDetail>(
        decoration: InputDecoration(
          hintText: "Select Branch",
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: const Icon(Icons.business, color: AppColors.primaryColor),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
        value: controller.allBranches.isNotEmpty
            ? controller.allBranches.first
            : null,
        items: controller.allBranches
            .map((branch) => DropdownMenuItem(
                  value: branch,
                  child: Text(branch.branchName!),
                ))
            .toList(),
        onChanged: (selectedBranch) {
          controller.setSelectedTable(selectedBranch!);
        },
        icon: const Icon(Icons.arrow_drop_down, color: AppColors.primaryColor),
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor,
            AppColors.primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            controller.onSubmit();
          },
          borderRadius: BorderRadius.circular(16),
          child: const Center(
            child: Text(
              "Create Account",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Already have an account? ",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          GestureDetector(
            onTap: () => Get.back(),
            child: Text(
              "Sign In",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
