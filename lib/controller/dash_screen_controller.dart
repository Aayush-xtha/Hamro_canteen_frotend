import 'package:flutter/material.dart';
import 'package:folder_structure/view/dashboard/history_screen.dart';
import 'package:folder_structure/view/dashboard/home_screen.dart';
import 'package:folder_structure/view/dashboard/menu_list.dart';
import 'package:folder_structure/view/dashboard/profile_screen.dart';
import 'package:get/get.dart';

class DashScreenController extends GetxController {
  final dashkey = GlobalKey<ScaffoldState>();

  RxList<Widget> pages = RxList([
    HomeScreen(),
    MenuList(),
    HistoryScreen(),
    ProfileScreen(),
  ]);
  RxInt currentIndex = RxInt(0);
  void onItemTapped(int index) {
    currentIndex.value = index;
  }
}
