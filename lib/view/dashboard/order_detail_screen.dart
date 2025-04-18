import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:folder_structure/controller/core_controller.dart';
import 'package:folder_structure/model/cart_item.dart';
import 'package:folder_structure/model/food_detail.dart';
import 'package:folder_structure/utils/color.dart';
import 'package:folder_structure/utils/custom_text_styles.dart';
import 'package:folder_structure/view/dashboard/payment_screen.dart';
import 'package:get/get.dart';

class OrderDetailScreen extends StatelessWidget {
  OrderDetailScreen({
    super.key,
    this.foods,
    this.quantity = "0",
    this.isFromCart = false,
    this.selectedItems,
    this.totalAmount = 0.0,
  });

  final Foods? foods;
  final String quantity;
  final bool isFromCart;
  final List<CartItems>? selectedItems;
  final double totalAmount;
  final coreController = Get.put(CoreController());
  double get calculatedTotalAmount {
    if (isFromCart && selectedItems != null && selectedItems!.isNotEmpty) {
      return selectedItems!.fold(0.0, (sum, item) {
        final price = double.tryParse(item.unitPrice ?? "0") ?? 0.0;
        final qty = int.tryParse(item.quantity ?? "1") ?? 1;
        return sum + (price * qty);
      });
    } else if (foods != null) {
      final price = double.tryParse(foods!.price.toString()) ?? 0.0;
      final qty = int.tryParse(quantity) ?? 1;
      return price * qty;
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    // Calculate total amount for single food item

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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Show either single food item or multiple selected items
            if (isFromCart &&
                selectedItems != null &&
                selectedItems!.isNotEmpty)
              _buildSelectedItemsList()
            else if (foods != null)
              _buildSingleFoodItem(),

            const SizedBox(height: 20),

            // Bill Container
            Container(
              width: MediaQuery.of(context).size.width -
                  32, // Fix overflow by setting explicit width
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 5,
                    spreadRadius: 2,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Name
                  Text(
                    "User Name: ${coreController.currentUser.value?.firstName ?? ''}  ${coreController.currentUser.value?.lastName ?? ''}",
                    style: CustomTextStyles.f16W600(color: Colors.blueAccent),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Divider(thickness: 1, color: Colors.grey),
                  const SizedBox(height: 5),

                  // Order Details
                  if (isFromCart && selectedItems != null)
                    _buildCartOrderSummary()
                  else
                    _buildSingleItemOrderSummary(),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Proceed Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (isFromCart &&
                      selectedItems != null &&
                      selectedItems!.isNotEmpty) {
                    // Handle multiple items checkout
                    // Create a comma-separated list of quantities
                    final quantities =
                        selectedItems!.map((item) => item.quantity).join(',');
                    final foodIds =
                        selectedItems!.map((item) => item.foodId).join(',');
                    final prices = selectedItems!
                        .map((item) => item.itemTotalPrice)
                        .join(',');

                    Get.to(() => PaymentOptionScreen(
                        quantity: quantities, price: prices, foodId: foodIds
                        // Remove isFromCart parameter as it's not defined in PaymentOptionScreen
                        ));
                  } else if (foods != null) {
                    // Handle single item checkout
                    Get.to(() => PaymentOptionScreen(
                          quantity: quantity,
                          price: foods!.price.toString(),
                          foodId: foods!.foodId.toString(),
                        ));
                  }
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

  // Widget for displaying a single food item
  Widget _buildSingleFoodItem() {
    return Container(
      width: Get.width - 32, // Fix overflow by setting explicit width
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 5,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              height: 80,
              width: 80,
              fit: BoxFit.cover,
              imageUrl: foods?.foodImage ?? "",
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

          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  foods?.foodName ?? "",
                  style: CustomTextStyles.f16W600(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  foods?.description ?? "",
                  style: CustomTextStyles.f14W400(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  "₹${foods?.price ?? 0}",
                  style: CustomTextStyles.f14W400(color: Colors.green),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget for displaying multiple selected items
  Widget _buildSelectedItemsList() {
    return Container(
      width: Get.width - 32, // Fix overflow by setting explicit width
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 5,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Selected Items (${selectedItems?.length ?? 0})",
            style: CustomTextStyles.f16W600(),
          ),
          const SizedBox(height: 10),
          ...List.generate(
            selectedItems?.length ?? 0,
            (index) {
              final item = selectedItems![index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    // Item image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: item.foodImage ?? "",
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: 50,
                          height: 50,
                          color: Colors.grey[200],
                          child:
                              const Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 50,
                          height: 50,
                          color: Colors.grey[200],
                          child: const Icon(Icons.fastfood, color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Item details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.foodName ?? "",
                            style: CustomTextStyles.f14W600(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "Quantity: ${item.quantity}",
                            style: CustomTextStyles.f12W400(),
                          ),
                        ],
                      ),
                    ),
                    // Item price
                    Text(
                      "₹${(double.parse(item.unitPrice ?? "0") * int.parse(item.quantity ?? "1")).toStringAsFixed(2)}",
                      style: CustomTextStyles.f14W600(color: Colors.green),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Widget for displaying order summary for a single item
  Widget _buildSingleItemOrderSummary() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Food Name", style: CustomTextStyles.f14W400()),
            Text(
              foods?.foodName ?? "",
              style: CustomTextStyles.f14W600(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Rate", style: CustomTextStyles.f14W400()),
            Text("₹${foods?.price ?? 0}", style: CustomTextStyles.f14W600()),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Quantity", style: CustomTextStyles.f14W400()),
            Text(quantity, style: CustomTextStyles.f14W600()),
          ],
        ),
        const SizedBox(height: 5),
        const Divider(thickness: 1, color: Colors.grey),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Total Amount", style: CustomTextStyles.f16W600()),
            Text("₹${calculatedTotalAmount.toStringAsFixed(2)}",
                style: CustomTextStyles.f16W600(color: Colors.green)),
          ],
        ),
      ],
    );
  }

  // Widget for displaying order summary for cart items
  Widget _buildCartOrderSummary() {
    return Column(
      children: [
        ...List.generate(
          selectedItems?.length ?? 0,
          (index) {
            final item = selectedItems![index];
            final itemTotal = double.parse(item.unitPrice ?? "0") *
                int.parse(item.quantity ?? "1");

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "${item.foodName} (x${item.quantity})",
                      style: CustomTextStyles.f14W400(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    "₹${itemTotal.toStringAsFixed(2)}",
                    style: CustomTextStyles.f14W600(),
                  ),
                ],
              ),
            );
          },
        ),
        const Divider(thickness: 1, color: Colors.grey),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Total Amount", style: CustomTextStyles.f16W600()),
            Text("₹${totalAmount.toStringAsFixed(2)}",
                style: CustomTextStyles.f16W600(color: Colors.green)),
          ],
        ),
      ],
    );
  }
}
