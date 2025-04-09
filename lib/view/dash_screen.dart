import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:folder_structure/controller/dash_screen_controller.dart';
import 'package:folder_structure/utils/color.dart';
import 'package:folder_structure/utils/image_path.dart';
import 'package:get/get.dart';

class DashScreen extends StatelessWidget {
  final c = Get.put(DashScreenController());
  DashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Stack(
        children: [
          // Main content
          Obx(() => c.pages[c.currentIndex.value]),

          // Bottom navigation bar shadow (separate from the bar for better effect)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColor.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // Floating action button
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Add your action here
      //   },
      //   backgroundColor: AppColors.primaryColor,
      //   elevation: 4,
      //   child: const Icon(
      //     Icons.shopping_cart,
      //     color: Colors.white,
      //   ),
      // ),

      // // Floating action button position
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // Bottom navigation bar
      bottomNavigationBar: Obx(
        () => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: BottomAppBar(
              height: 70,
              padding: EdgeInsets.zero,
              notchMargin: 8,
              elevation: 0,
              shape: const CircularNotchedRectangle(),
              color: AppColors.whiteColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(0, ImagePath.home, 'Home'),
                  _buildNavItem(1, ImagePath.menu, 'Menu'),
                  // Empty space for FAB
                  const SizedBox(width: 10),
                  _buildNavItem(2, ImagePath.history, 'History'),
                  _buildNavItem(3, ImagePath.userprofile, 'Profile'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String iconPath, String label) {
    final isSelected = c.currentIndex.value == index;

    return Expanded(
      child: InkWell(
        onTap: () => c.onItemTapped(index),
        customBorder: const CircleBorder(),
        splashColor: AppColors.primaryColor.withOpacity(0.1),
        highlightColor: AppColors.primaryColor.withOpacity(0.05),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated container for the icon
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryColor.withOpacity(0.1)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                iconPath,
                color: isSelected ? AppColors.primaryColor : AppColors.lGrey,
                height: 22,
              ),
            ),

            // Label
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? AppColors.primaryColor : AppColors.lGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
