import 'package:flutter/material.dart';
import 'package:folder_structure/model/food_detail.dart';
import 'package:folder_structure/utils/custom_text_styles.dart';
import 'package:folder_structure/utils/color.dart';
import 'package:folder_structure/view/dashboard/cart_screen.dart';
import 'package:folder_structure/view/dashboard/order_detail_screen.dart';
import 'package:folder_structure/widget/custom/elevated_button.dart';
import 'package:get/get.dart';

class FoodDescriptionScreen extends StatelessWidget {
  final Foods food;

  const FoodDescriptionScreen({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        title: Text(
          food.foodName ?? "Food Description",
          style: CustomTextStyles.f16W600(color: AppColors.textColor),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Food Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                food.foodImage ?? "",
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Image.network(
                  "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png",
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Food Name
            Text(
              food.foodName ?? "Unknown Food",
              style: CustomTextStyles.f18W600(color: AppColors.textColor),
            ),
            const SizedBox(height: 8),
            // Description
            Text(
              food.description ?? "No description available",
              style:
                  CustomTextStyles.f14W400(color: AppColors.secondaryTextColor),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 16),
            // Price
            Text(
              "Price: \RS ${food.price ?? "0.00"}",
              style: CustomTextStyles.f16W600(color: AppColors.green),
            ),
            const SizedBox(height: 16),
            // Add to Cart Button
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CustomElevatedButton(
                title: "Order",
                onTap: () {
                  showOrderForm(context, food.price.toString());
                },
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: ElevatedButton(
                  onPressed: () {
                    Get.off(AddToCartPage());
                  },
                  child: const Text("add to cart")),
              // child: Container(
              //   height: 50,
              //   decoration: BoxDecoration(
              //       color: AppColors.whiteColor,
              //       border: Border.all(width: 1, color: AppColors.primaryColor),
              //       borderRadius: BorderRadius.circular(25)),
              //   child: Center(
              //     child: Text(
              //       "Add to Cart",
              //       style: CustomTextStyles.f14W600(),
              //     ),
              //   ),
              // ),
            ),
          ],
        ),
      ),
    );
  }

  void showOrderForm(BuildContext context, String productPrice) {
    final RxInt quantity = 1.obs;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Center(
                    child:
                        Text("Order Form", style: CustomTextStyles.f18W600()),
                  ),
                  const SizedBox(height: 15),

                  // Rate (Food Price)
                  Text("Rate", style: CustomTextStyles.f16W400()),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.lGrey),
                    ),
                    child: Text("\RS$productPrice",
                        style: CustomTextStyles.f16W600()),
                  ),
                  const SizedBox(height: 15),

                  // Quantity Input
                  Text("Quantity", style: CustomTextStyles.f16W400()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline,
                            color: Colors.red),
                        onPressed: () {
                          if (quantity.value > 1) quantity.value--;
                        },
                      ),
                      Obx(
                        () => Text(
                          quantity.value.toString(),
                          style: CustomTextStyles.f18W600(),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline,
                            color: Colors.green),
                        onPressed: () {
                          quantity.value++;
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // Buy Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () {
                      Get.to(() => OrderDetailScreen(
                          foods: food, quantity: quantity.value.toString()));
                    },
                    child: Text("Buy",
                        style: CustomTextStyles.f16W600(color: Colors.white)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
