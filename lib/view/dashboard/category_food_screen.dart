import 'package:flutter/material.dart';
import 'package:folder_structure/controller/dashboard/cart_controller.dart';
import 'package:folder_structure/controller/dashboard/home_screen_controller.dart';

import 'package:folder_structure/model/food_detail.dart';
import 'package:folder_structure/utils/color.dart';
import 'package:folder_structure/view/dashboard/food_description_screen.dart';
import 'package:get/get.dart';

class CategoryFoodScreen extends StatelessWidget {
  final String categoryName;
  final String categoryId;

  CategoryFoodScreen({
    super.key,
    required this.categoryName,
    required this.categoryId,
  });

  final homeController = Get.find<HomeScreenController>();
  final cartController = Get.find<AddToCartController>();

  @override
  Widget build(BuildContext context) {
    // Get foods for this category from your data model
    List<Foods> categoryFoods = [];

    // Find the category in allFoodDetails and get its foods
    for (var foodDetail in homeController.allFoodDetails) {
      if (foodDetail.categoryId == categoryId) {
        categoryFoods = foodDetail.foods ?? [];
        break;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
      ),
      body: categoryFoods.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.no_food_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No food items in this category",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: categoryFoods.length,
              itemBuilder: (context, index) {
                final food = categoryFoods[index];
                return _buildFoodCard(food);
              },
            ),
    );
  }

  Widget _buildFoodCard(Foods food) {
    final bool isVeg = food.foodName?.toLowerCase().contains('veg') ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            Get.to(() => FoodDescriptionScreen(food: food));
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Food Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    food.foodImage ?? "https://via.placeholder.com/80",
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Food Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Veg/Non-veg indicator
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: isVeg
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(
                              Icons.circle,
                              size: 10,
                              color: isVeg ? Colors.green : Colors.red,
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Food name
                          Expanded(
                            child: Text(
                              food.foodName ?? "Food Item",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Description
                      Text(
                        food.description ?? "No description available",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),

                      // Price and Add button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "₹${food.price ?? '0'}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // // Add to cart
                              // final foodId =
                              //     int.tryParse(food.foodId ?? "0") ?? 0;

                              // // Show loading indicator
                              // final loadingOverlay = Get.dialog(
                              //   const Center(
                              //     child: CircularProgressIndicator(
                              //       valueColor: AlwaysStoppedAnimation<Color>(
                              //           AppColors.primaryColor),
                              //     ),
                              //   ),
                              //   barrierDismissible: false,
                              // );

                              // cartController.addToCart(
                              //   foodId: foodId,
                              //   quantity: 1,
                              //   onSuccess: (message) {
                              //     // Close loading indicator
                              //     Get.back();

                              //     // Show success message
                              //     Get.snackbar(
                              //       "Added to Cart",
                              //       message,
                              //       snackPosition: SnackPosition.BOTTOM,
                              //       backgroundColor: Colors.green,
                              //       colorText: Colors.white,
                              //       duration: const Duration(seconds: 2),
                              //       animationDuration:
                              //           const Duration(milliseconds: 500),
                              //       isDismissible: true,
                              //       margin: const EdgeInsets.all(8),
                              //       icon: const Icon(Icons.check_circle,
                              //           color: Colors.white),
                              //     );
                              //   },
                              //   onError: (message) {
                              //     // Close loading indicator
                              //     Get.back();

                              //     // Show error message
                              //     Get.snackbar(
                              //       "Error",
                              //       message,
                              //       snackPosition: SnackPosition.BOTTOM,
                              //       backgroundColor: Colors.red,
                              //       colorText: Colors.white,
                              //       duration: const Duration(seconds: 3),
                              //       isDismissible: true,
                              //       margin: const EdgeInsets.all(8),
                              //       icon: const Icon(Icons.error_outline,
                              //           color: Colors.white),
                              //     );
                              //   },
                              // );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                "Add",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
