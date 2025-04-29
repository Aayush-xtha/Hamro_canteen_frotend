import 'package:flutter/material.dart';
import 'package:folder_structure/controller/splash_screen_controller.dart';
import 'package:folder_structure/utils/color.dart';
import 'package:folder_structure/utils/image_path.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  final call = Get.put(SplashScreenController());

  final RxDouble pulseValue = 1.0.obs;
  final RxDouble rotateValue = 0.0.obs;
  final RxDouble opacityValue = 0.0.obs;
  final RxDouble progressValue = 0.0.obs;

  SplashScreen({super.key}) {
    _startAnimations();
  }

  void _startAnimations() {
    _animatePulse();

    _animateRotation();

    Future.delayed(Duration(milliseconds: 300), () {
      opacityValue.value = 1.0;
    });

    _animateProgress();
  }

  void _animatePulse() {
    Future.delayed(Duration(milliseconds: 1500), () {
      pulseValue.value = 1.1;
      Future.delayed(Duration(milliseconds: 1500), () {
        pulseValue.value = 1.0;

        _animatePulse();
      });
    });
  }

  void _animateRotation() {
    Future.delayed(Duration(milliseconds: 1500), () {
      rotateValue.value = 0.05;
      Future.delayed(Duration(milliseconds: 1500), () {
        rotateValue.value = 0.0;
        _animateRotation();
      });
    });
  }

  void _animateProgress() {
    for (int i = 1; i <= 20; i++) {
      Future.delayed(Duration(milliseconds: i * 150), () {
        progressValue.value = i / 20;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          _buildAnimatedBackground(context),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() => Transform.rotate(
                        angle: rotateValue.value,
                        child: Transform.scale(
                          scale: pulseValue.value,
                          child: Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      AppColors.primaryColor.withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                ImagePath.logo,
                                height: 200,
                                width: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      )),
                  SizedBox(height: 40),
                  Obx(() => AnimatedOpacity(
                        opacity: opacityValue.value,
                        duration: Duration(milliseconds: 800),
                        child: Text(
                          "Welcome to Hamro Canteen...",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      )),
                  SizedBox(height: 30),
                  Obx(() => Container(
                        width: 200,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Stack(
                          children: [
                            AnimatedContainer(
                              duration: Duration(milliseconds: 150),
                              width: 200 * progressValue.value,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.primaryColor,
                                    AppColors.primaryColor.withOpacity(0.7),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ],
                        ),
                      )),
                  SizedBox(height: 40),
                  DotsLoadingIndicator(color: AppColors.primaryColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground(BuildContext context) {
    return Stack(
      children: [
        // Background color
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white,
                AppColors.primaryColor.withOpacity(0.05),
              ],
            ),
          ),
        ),

        Obx(() => Positioned(
              top: MediaQuery.of(context).size.height * 0.1,
              left: MediaQuery.of(context).size.width * 0.1,
              child: _buildAnimatedCircle(
                size: 100,
                color: AppColors.primaryColor.withOpacity(0.1),
                scale: pulseValue.value,
              ),
            )),

        Obx(() => Positioned(
              bottom: MediaQuery.of(context).size.height * 0.15,
              right: MediaQuery.of(context).size.width * 0.1,
              child: _buildAnimatedCircle(
                size: 120,
                color: AppColors.primaryColor.withOpacity(0.1),
                scale: pulseValue.value * 0.9,
              ),
            )),

        Obx(() => Positioned(
              top: MediaQuery.of(context).size.height * 0.6,
              left: MediaQuery.of(context).size.width * 0.2,
              child: _buildAnimatedCircle(
                size: 80,
                color: AppColors.primaryColor.withOpacity(0.1),
                scale: pulseValue.value * 1.1,
              ),
            )),
      ],
    );
  }

  Widget _buildAnimatedCircle({
    required double size,
    required Color color,
    required double scale,
  }) {
    return AnimatedScale(
      scale: scale,
      duration: Duration(milliseconds: 1500),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}

class DotsLoadingIndicator extends StatelessWidget {
  final Color color;

  DotsLoadingIndicator({
    Key? key,
    required this.color,
  }) : super(key: key);

  final RxDouble dot1Size = 10.0.obs;
  final RxDouble dot2Size = 10.0.obs;
  final RxDouble dot3Size = 10.0.obs;

  @override
  Widget build(BuildContext context) {
    _animateDots();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Obx(() => AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: 4),
              height: dot1Size.value,
              width: dot1Size.value,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            )),
        Obx(() => AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: 4),
              height: dot2Size.value,
              width: dot2Size.value,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            )),
        Obx(() => AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: 4),
              height: dot3Size.value,
              width: dot3Size.value,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            )),
      ],
    );
  }

  void _animateDots() {
    Future.delayed(Duration(milliseconds: 0), () {
      _animateDot(dot1Size);
    });

    Future.delayed(Duration(milliseconds: 180), () {
      _animateDot(dot2Size);
    });

    Future.delayed(Duration(milliseconds: 360), () {
      _animateDot(dot3Size);
    });
  }

  void _animateDot(RxDouble dotSize) {
    dotSize.value = 20.0;
    Future.delayed(Duration(milliseconds: 300), () {
      dotSize.value = 10.0;
      Future.delayed(Duration(milliseconds: 300), () {
        _animateDot(dotSize);
      });
    });
  }
}

class AnimatedScale extends StatelessWidget {
  final Widget child;
  final double scale;
  final Duration duration;

  const AnimatedScale({
    Key? key,
    required this.child,
    required this.scale,
    required this.duration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration,
      transform: Matrix4.identity()..scale(scale),
      transformAlignment: Alignment.center,
      child: child,
    );
  }
}
