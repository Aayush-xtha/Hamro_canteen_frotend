import 'package:flutter/material.dart';
import 'package:folder_structure/controller/core_controller.dart';
import 'package:folder_structure/model/user.dart';
import 'package:folder_structure/utils/color.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatelessWidget {
  final Users user;
  final coreController = Get.find<CoreController>();

  EditProfileScreen({super.key, required this.user});

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    firstNameController.text = user.firstName ?? "";
    lastNameController.text = user.lastName ?? "";
    phoneController.text = user.phoneNumber ?? "";
    emailController.text = user.email ?? "";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Picture
            Center(
              child: CircleAvatar(
                radius: 55,
                backgroundColor: Colors.deepPurple.shade100,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: user.image != null && user.image!.isNotEmpty
                      ? NetworkImage(user.image!)
                      : const AssetImage("assets/images/default_user.png")
                          as ImageProvider,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Form Fields in a Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    CustomTextField(
                      controller: firstNameController,
                      label: "First Name",
                      icon: Icons.person,
                    ),
                    CustomTextField(
                      controller: lastNameController,
                      label: "Last Name",
                      icon: Icons.person_outline,
                    ),
                    CustomTextField(
                      controller: phoneController,
                      label: "Phone Number",
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                    ),
                    CustomTextField(
                      controller: emailController,
                      label: "Email",
                      icon: Icons.email,
                      readOnly: true,
                      backgroundColor: Colors.grey.shade200,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Save Changes Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Update user info
                  coreController.currentUser.value = Users(
                    id: user.id,
                    firstName: firstNameController.text,
                    lastName: lastNameController.text,
                    email: user.email,
                    phoneNumber: phoneController.text,
                    gender: user.gender,
                    role: user.role,
                    branchId: user.branchId,
                    branchName: user.branchName,
                    image: user.image,
                    token: user.token,
                  );

                  Get.back(); // Go back to ProfileScreen
                },
                icon: const Icon(Icons.save, color: AppColors.whiteColor),
                label: const Text("Save Changes",
                    style: TextStyle(color: AppColors.whiteColor)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom TextField Widget
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool readOnly;
  final TextInputType? keyboardType;
  final Color? backgroundColor;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.readOnly = false,
    this.keyboardType,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          filled: true,
          fillColor: backgroundColor ?? Colors.white,
          labelText: label,
          prefixIcon: Icon(icon, color: AppColors.primaryColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primaryColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primaryColor),
          ),
        ),
      ),
    );
  }
}
