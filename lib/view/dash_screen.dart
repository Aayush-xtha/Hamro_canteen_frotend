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
        body: Obx(() => c.pages[c.currentIndex.value]),
        bottomNavigationBar: Obx(() => Container(
              decoration: const BoxDecoration(boxShadow: [
                BoxShadow(
                  color: AppColors.primaryColor,
                  blurRadius: 7.0,
                  offset: Offset(5, 5),
                )
              ]),
              child: BottomNavigationBar(
                elevation: 3,
                backgroundColor: AppColors.whiteColor,
                selectedItemColor: AppColors.primaryColor,
                unselectedIconTheme: const IconThemeData(color: Colors.white),
                unselectedItemColor: AppColors.lGrey,
                type: BottomNavigationBarType.fixed,
                currentIndex: c.currentIndex.value,
                onTap: c.onItemTapped,
                iconSize: 26,
                items: [
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(
                        top: 9,
                      ),
                      child: SvgPicture.asset(
                        ImagePath.home,
                        color: c.currentIndex.value == 0
                            ? AppColors.primaryColor
                            : AppColors.lGrey,
                        height: 21,
                      ),
                    ),
                    label: "",
                  ),
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(
                        top: 9,
                      ),
                      child: SvgPicture.asset(
                        ImagePath.menu,
                        color: c.currentIndex.value == 1
                            ? AppColors.primaryColor
                            : AppColors.lGrey,
                        height: 21,
                      ),
                    ),
                    label: "",
                  ),
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(
                        top: 9,
                      ),
                      child: SvgPicture.asset(
                        ImagePath.history,
                        color: c.currentIndex.value == 2
                            ? AppColors.primaryColor
                            : AppColors.lGrey,
                        height: 21,
                      ),
                    ),
                    label: "",
                  ),
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(
                        top: 9,
                      ),
                      child: SvgPicture.asset(
                        ImagePath.userprofile,
                        color: c.currentIndex.value == 3
                            ? AppColors.primaryColor
                            : AppColors.lGrey,
                        height: 20,
                        //width: 17,
                      ),
                    ),
                    label: "",
                  ),
                ],
              ),
            )));
  }
}
