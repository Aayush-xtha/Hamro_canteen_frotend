import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:folder_structure/controller/splash_screen_controller.dart';
import 'package:folder_structure/utils/color.dart';
import 'package:folder_structure/utils/image_path.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  final call = Get.put(SplashScreenController());
  SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle, // Makes the container circular
                  color: Colors.white, // Background color (can be changed)
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: Offset(0, 4), // Adds a subtle shadow
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    ImagePath.logo,
                    height: 200,
                    width: 200,
                    fit: BoxFit
                        .cover, // Ensures the image fills the circular shape
                  ),
                ),
              ),

              SizedBox(height: 20),

              // CircularProgressIndicator(
              //   color: AppColors.primaryColor,
              //   backgroundColor: AppColors.whiteColor,
              //   strokeWidth: 4,
              // ),
              // SizedBox(height: 10),

              CupertinoActivityIndicator(
                color: AppColors.green,
                radius: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
