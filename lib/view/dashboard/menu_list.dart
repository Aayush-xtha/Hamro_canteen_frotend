import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:folder_structure/controller/dashboard/menu_list_controller.dart';
import 'package:folder_structure/model/food_detail.dart';
import 'package:folder_structure/utils/color.dart';
import 'package:folder_structure/utils/custom_text_styles.dart';
import 'package:folder_structure/view/dashboard/food_description_screen.dart';
import 'package:get/get.dart';

class MenuList extends StatelessWidget {
  final c = Get.put(MenuListController());
  MenuList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        title: Text("Menu",
            style: CustomTextStyles.f16W600(color: AppColors.whiteColor)),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 22, bottom: 16),
        child: Obx(() {
          log("Food List: ${c.allFoods}");
          return (c.loadings.value)
              ? const Center(child: CircularProgressIndicator())
              : c.allFoods.isEmpty
                  ? Center(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "No Food Available",
                          style: CustomTextStyles.f14W400(
                              color: AppColors.lOrange),
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: c.allFoods.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final FoodDetails food = c.allFoods[index];
                        return FoodCategoryWidget(foodDetails: food);
                      },
                    );
        }),
      ),
    );
  }
}

class FoodCategoryWidget extends StatelessWidget {
  final FoodDetails foodDetails;

  const FoodCategoryWidget({super.key, required this.foodDetails});

  @override
  Widget build(BuildContext context) {
    log("Rendering category: ${foodDetails.categoryName}");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(top: 8, bottom: 8, left: 14),
          width: 370,
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                foodDetails.categoryName ?? "Category",
                style: CustomTextStyles.f16W600(color: AppColors.whiteColor),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // Render Food Items
        Column(
          children: foodDetails.foods
                  ?.map((food) => FoodItemWidget(food: food))
                  .toList() ??
              [],
        ),
      ],
    );
  }
}

class FoodItemWidget extends StatelessWidget {
  final Foods food;

  const FoodItemWidget({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    log("Rendering food: ${food.foodName}");
    return InkWell(
      onTap: () {
        Get.to(() => FoodDescriptionScreen(food: food));
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: CachedNetworkImage(
                  height: 70,
                  width: 70,
                  fit: BoxFit.cover,
                  imageUrl: food.foodImage ?? "",
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
              const SizedBox(width: 12),
              // Food Information in Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.foodName ?? "Unknown Food",
                      style: CustomTextStyles.f14W400(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      food.description ?? "No description available",
                      style: CustomTextStyles.f14W600(
                          color: AppColors.secondaryTextColor),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),

              Text(
                "Price: \RS ${food.price ?? "0.00"}",
                style: CustomTextStyles.f12W600(
                    color: const Color.fromARGB(255, 17, 64, 46)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
