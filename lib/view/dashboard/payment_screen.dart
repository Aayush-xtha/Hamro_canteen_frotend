import 'package:flutter/material.dart';
import 'package:folder_structure/controller/core_controller.dart';
import 'package:folder_structure/controller/dashboard/menu_list_controller.dart';
import 'package:folder_structure/function/esewa_function.dart';
import 'package:folder_structure/utils/color.dart';
import 'package:folder_structure/utils/custom_text_styles.dart';
import 'package:folder_structure/widget/custom/elevated_button.dart';
import 'package:get/get.dart';

class PaymentOptionScreen extends StatelessWidget {
  final c = Get.put(MenuListController());
  PaymentOptionScreen(
      {super.key,
      required this.quantity,
      required this.price,
      required this.foodId});
  final String quantity;
  final String price;
  final String foodId;
  final coreController = Get.put(CoreController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      appBar: AppBar(
        elevation: 2,
        centerTitle: false,
        backgroundColor: AppColors.backGroundColor,
        leading: InkWell(
          onTap: () => Get.back(),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: Text("Select Payment Method",
            style: CustomTextStyles.f16W600(color: AppColors.textColor)),
      ),
      body: Column(
        children: [
          Obx(() => PaymentButton(
              image: "assets/images/esewa.png",
              isSelected: c.selectedPayment.value == 'esewa',
              onTap: () {
                c.updateSeletedPayment("esewa");
              })),
          Obx(() => PaymentButton(
              image: "assets/images/blank_image.png",
              isSelected: c.selectedPayment.value == 'cash',
              onTap: () {
                c.updateSeletedPayment("cash");
              })),
        ],
      ),
      bottomNavigationBar: Padding(
        padding:
            const EdgeInsets.only(left: 18, right: 18, bottom: 12, top: 10),
        child: CustomElevatedButton(
            title: "Submit",
            onTap: () {
              if (c.selectedPayment.value == 'esewa') {
                final Esewa esewa = Esewa();
                esewa.pay(
                    foodId,
                    coreController.currentUser.value!.id.toString(),
                    c.selectedPayment.value,
                    quantity,
                    price);
              }
            }),
      ),
    );
  }
}

class PaymentButton extends StatelessWidget {
  const PaymentButton({
    super.key,
    required this.image,
    required this.isSelected,
    required this.onTap,
  });

  final bool isSelected;
  final String image;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(left: 18, right: 18, top: 14),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : Colors.grey,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      image,
                      height: 30,
                      width: 50,
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? AppColors.primaryColor : Colors.grey,
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryColor : Colors.white,
                      shape: BoxShape.circle,
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
