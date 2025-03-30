import 'package:flutter/material.dart';
import 'package:folder_structure/controller/core_controller.dart';
import 'package:folder_structure/controller/dashboard/history_screen_controller.dart';
import 'package:folder_structure/model/order_history.dart';
import 'package:folder_structure/utils/color.dart';
import 'package:folder_structure/utils/custom_text_styles.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final coreController = Get.put(CoreController());
  final c = Get.put(HistoryScreenController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        title: Text("Home Page", style: CustomTextStyles.f16W600()),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${coreController.currentUser.value!.firstName}"),
            Text("${coreController.currentUser.value!.lastName}"),
            Text("${coreController.currentUser.value!.role}"),
            Text("${coreController.currentUser.value!.email}"),
            const SizedBox(height: 16),

            // Check User Type and Render UI Accordingly
            Obx(() {
              if (coreController.userType.value == "user") {
                return const Column(
                  children: [
                    PromotionCard(
                      imageUrl:
                          "https://www.indiafilings.com/learn/wp-content/uploads/2024/08/How-to-Start-Food-Business.jpg",
                      title: "20% off on Non-veg Platter",
                      description:
                          "Include a variety of meat items like chicken, lamb, fish, or prawns, and the details can vary widely depending on the menu.",
                    ),
                    PromotionCard(
                      imageUrl:
                          "https://www.indiafilings.com/learn/wp-content/uploads/2024/08/How-to-Start-Food-Business.jpg",
                      title: "Buy 1 Get 1 Free - Special Weekend Offer!",
                      description:
                          "Enjoy your favorite meals with a special deal this weekend. Offer available on selected items.",
                    ),
                  ],
                );
              } else {
                // Order History for staff
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order History",
                      style: CustomTextStyles.f16W600(),
                    ),
                    const SizedBox(height: 10),
                    Obx(() {
                      return (c.loadings.value)
                          ? const Center(child: CircularProgressIndicator())
                          : c.allOrderHistory.isEmpty
                              ? Center(
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: AppColors.whiteColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      "No orders",
                                      style: CustomTextStyles.f14W400(
                                          color: AppColors.lOrange),
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: c.allOrderHistory.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    final OrderHistory orderHistory =
                                        c.allOrderHistory[index];
                                    return OrderCard(orders: orderHistory);
                                  },
                                );
                    }),
                  ],
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}

// Promotion Card Widget
class PromotionCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;

  const PromotionCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.whiteColor,
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 6,
              spreadRadius: 2),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              imageUrl,
              height: 230,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          Text(title, style: CustomTextStyles.f14W600()),
          const SizedBox(height: 6),
          Text(description,
              style: CustomTextStyles.f12W400(), textAlign: TextAlign.justify),
        ],
      ),
    );
  }
}

// Order Card Widget
class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.orders,
  });
  final OrderHistory orders;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      color: AppColors.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("#ORD00${orders.orderId}", style: CustomTextStyles.f14W600()),
            const SizedBox(height: 4),
            Text(
                "Items: ${orders.items?.map((item) => item.foodName).join(',') ?? "No items"}",
                style: CustomTextStyles.f12W400()),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total: \RS ${orders.totalAmount}",
                    style: CustomTextStyles.f14W600(color: AppColors.green)),
                Text(
                  orders.orderStatus ?? "",
                  style: CustomTextStyles.f12W600(
                    color: orders.orderStatus == "confirmed"
                        ? Colors.green
                        : Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
