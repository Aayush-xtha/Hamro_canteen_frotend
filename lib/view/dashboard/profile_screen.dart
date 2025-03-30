import 'package:flutter/material.dart';
import 'package:folder_structure/controller/core_controller.dart';
import 'package:folder_structure/utils/color.dart';
import 'package:folder_structure/view/dashboard/edit_profile_screen.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  final coreController = Get.put(CoreController());

  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
      ),
      body: Obx(() {
        final user = coreController.currentUser.value;

        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              children: [
                // Profile Picture
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.deepPurple.shade100,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              user.image != null && user.image!.isNotEmpty
                                  ? NetworkImage(user.image!)
                                  : const AssetImage(
                                          "assets/images/default_user.png")
                                      as ImageProvider,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Profile Details Card
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        ProfileDetailRow(
                            title: "First Name", value: user.firstName ?? ""),
                        ProfileDetailRow(
                            title: "Last Name", value: user.lastName ?? ""),
                        ProfileDetailRow(
                            title: "Email", value: user.email ?? ""),
                        ProfileDetailRow(
                            title: "Phone", value: user.phoneNumber ?? ""),
                        ProfileDetailRow(
                            title: "Gender", value: user.gender ?? ""),
                        ProfileDetailRow(title: "Role", value: user.role ?? ""),
                        if (user.role != "admin")
                          ProfileDetailRow(
                              title: "Branch", value: user.branchName ?? ""),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Edit Profile Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Get.to(() => EditProfileScreen(user: user));
                    },
                    icon: const Icon(Icons.edit, color: Colors.white),
                    label: const Text("Edit Profile",
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Logout Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      coreController.logOut();
                    },
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text("Log Out",
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 12),
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
      }),
    );
  }
}

// Profile Details UI Component
class ProfileDetailRow extends StatelessWidget {
  final String title;
  final String value;

  const ProfileDetailRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87)),
          Text(value,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54)),
        ],
      ),
    );
  }
}
