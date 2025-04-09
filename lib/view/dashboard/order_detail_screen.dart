import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:folder_structure/controller/core_controller.dart';
import 'package:folder_structure/model/food_detail.dart';
import 'package:folder_structure/utils/color.dart';
import 'package:folder_structure/utils/custom_text_styles.dart';
import 'package:folder_structure/view/dashboard/payment_screen.dart';
import 'package:get/get.dart';

class OrderDetailScreen extends StatelessWidget {
  OrderDetailScreen({super.key, required this.foods, required this.quantity});

  final Foods foods;
  final String quantity;
  final coreController = Get.put(CoreController());
  @override
  Widget build(BuildContext context) {
    final double totalAmount =
        double.parse(foods.price.toString()) * int.parse(quantity);

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        title: Text(
          "Order Details",
          style: CustomTextStyles.f18W600(color: Colors.white),
        ),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📌 Product Info Container
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 5,
                    spreadRadius: 2,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // 📌 Product Image
                  ClipRRect(
                    child: CachedNetworkImage(
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                      imageUrl: foods.foodImage ?? "",
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Image.network(
                        "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png",
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),

                  // 📌 Product Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(foods.foodName ?? "",
                            style: CustomTextStyles.f16W600()),
                        const SizedBox(height: 5),
                        Text(
                          foods.description ?? "",
                          style: CustomTextStyles.f14W400(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Text("\RS ${foods.price}",
                            style:
                                CustomTextStyles.f14W400(color: Colors.green)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 📌 Bill Container
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 5,
                    spreadRadius: 2,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 📌 Order Number
                  Text(
                    "User Name: ${coreController.currentUser.value!.firstName}  ${coreController.currentUser.value!.lastName}",
                    style: CustomTextStyles.f16W600(color: Colors.blueAccent),
                  ),
                  const Divider(thickness: 1, color: Colors.grey),
                  const SizedBox(height: 5),

                  // 📌 Order Details
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Food Name", style: CustomTextStyles.f14W400()),
                      Text(foods.foodName ?? "",
                          style: CustomTextStyles.f14W600()),
                    ],
                  ),
                  const SizedBox(height: 5),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Rate", style: CustomTextStyles.f14W400()),
                      Text("\RS ${foods.price}",
                          style: CustomTextStyles.f14W600()),
                    ],
                  ),
                  const SizedBox(height: 5),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Quantity", style: CustomTextStyles.f14W400()),
                      Text(quantity.toString(),
                          style: CustomTextStyles.f14W600()),
                    ],
                  ),
                  const SizedBox(height: 5),

                  const Divider(thickness: 1, color: Colors.grey),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total Amount", style: CustomTextStyles.f16W600()),
                      Text("\RS $totalAmount",
                          style: CustomTextStyles.f16W600(color: Colors.green)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // 📌 Proceed Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.to(() => PaymentOptionScreen(
                      quantity: quantity,
                      price: foods.price.toString(),
                      foodId: foods.foodId.toString()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  "Proceed to Checkout",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
