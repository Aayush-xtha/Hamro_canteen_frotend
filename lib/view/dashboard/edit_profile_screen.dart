import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:folder_structure/controller/dashboard/edit_profile_controller.dart';
import 'package:folder_structure/utils/color.dart';
import 'package:folder_structure/utils/custom_text_styles.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});
  final c = Get.put(EditProfileController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: c.formKey,
          child: Column(
            children: [
              Obx(() => ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: (c.image.value != null)
                        ? Image.file(
                            c.image.value!,
                            fit: BoxFit.cover,
                            height: 100,
                            width: 100,
                          )
                        : CachedNetworkImage(
                            placeholder: (context, url) => const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator()),
                            fit: BoxFit.cover,
                            height: 100,
                            width: 100,
                            imageUrl: c.avatarUrl.value!,
                            errorWidget: (context, url, error) => Image.asset(
                              "assets/images/blank_profile.jpg",
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                  )),
              const SizedBox(height: 10),
              InkWell(
                onTap: () {
                  c.pickImage();
                },
                child: Text(
                  "Change Avatar",
                  style:
                      CustomTextStyles.f14W400(color: AppColors.primaryColor),
                ),
              ),

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
                        controller: c.firstNameController,
                        label: "First Name",
                        icon: Icons.person,
                      ),
                      CustomTextField(
                        controller: c.lastNameController,
                        label: "Last Name",
                        icon: Icons.person_outline,
                      ),
                      CustomTextField(
                        controller: c.phoneController,
                        label: "Phone Number",
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                      ),
                      CustomTextField(
                        controller: c.emailController,
                        label: "Email",
                        icon: Icons.email,
                        readOnly: true,
                        backgroundColor: Colors.grey.shade200,
                      ),
                      CustomTextField(
                        controller: c.genderController,
                        label: "Gender",
                        icon: Icons.person,
                        backgroundColor: Colors.grey.shade200,
                      ),
                      CustomTextField(
                        controller: c.roleController,
                        label: "Role",
                        icon: Icons.post_add,
                        readOnly: true,
                        backgroundColor: Colors.grey.shade200,
                      ),
                      CustomTextField(
                        controller: c.branchNameController,
                        label: "Branch Name",
                        icon: Icons.house,
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
                    c.onSubmit();
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
            borderSide: const BorderSide(color: AppColors.primaryColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primaryColor),
          ),
        ),
      ),
    );
  }
}
