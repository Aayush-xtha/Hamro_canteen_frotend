import 'package:flutter/material.dart';
import 'package:folder_structure/view/dashboard/history_screen.dart';
import 'package:folder_structure/view/dashboard/home_screen.dart';
import 'package:folder_structure/view/dashboard/menu_list.dart';
import 'package:folder_structure/view/dashboard/profile_screen.dart';
import 'package:folder_structure/view/dashboard/staff_home_page.dart';
import 'package:get/get.dart';
import 'package:folder_structure/controller/core_controller.dart';

class DashScreenController extends GetxController {
  final dashkey = GlobalKey<ScaffoldState>();
  final coreController = Get.put(CoreController());

  RxList<Widget> pages = RxList([
    HomeScreen(),
    MenuList(),
    HistoryScreen(),
    ProfileScreen(),
  ]);

  RxList<Widget> staffPages = RxList([
    StaffHomePage(),
    HistoryScreen(),
    ProfileScreen(),
  ]);

  RxInt currentIndex = RxInt(0);

  void onItemTapped(int index) {
    currentIndex.value = index;
  }

  List<Widget> get activePages =>
      coreController.currentUser.value?.role == 'staff' ? staffPages : pages;
}
