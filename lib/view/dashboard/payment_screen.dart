import 'package:flutter/material.dart';
import 'package:folder_structure/controller/core_controller.dart';
import 'package:folder_structure/controller/dashboard/menu_list_controller.dart';
import 'package:folder_structure/function/esewa_function.dart';
import 'package:folder_structure/utils/color.dart';
import 'package:folder_structure/utils/custom_text_styles.dart';
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
    final double totalAmount = double.parse(price) * int.parse(quantity);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Payment Method",
          style: CustomTextStyles.f18W600(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          // Order summary card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Order Summary",
                      style: CustomTextStyles.f16W600(),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.green.shade300),
                      ),
                      child: Text(
                        "Qty: $quantity",
                        style: CustomTextStyles.f12W600(color: Colors.green),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSummaryRow("Item Price", "RS $price"),
                const SizedBox(height: 8),
                _buildSummaryRow("Quantity", quantity),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Amount",
                      style: CustomTextStyles.f16W600(),
                    ),
                    Text(
                      "RS ${totalAmount.toStringAsFixed(2)}",
                      style: CustomTextStyles.f18W600(
                          color: AppColors.primaryColor),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Payment methods title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Icon(
                  Icons.payment,
                  size: 20,
                  color: AppColors.primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  "Select Payment Method",
                  style: CustomTextStyles.f16W600(color: Colors.grey[800]!),
                ),
              ],
            ),
          ),

          // Payment methods
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                Obx(() => PaymentButton(
                      image: "assets/images/esewa.png",
                      title: "eSewa",
                      subtitle: "Pay securely with your eSewa account",
                      isSelected: c.selectedPayment.value == 'esewa',
                      icon: Icons.account_balance_wallet,
                      iconColor: Colors.green,
                      onTap: () {
                        c.updateSeletedPayment("esewa");
                      },
                    )),
                Obx(() => PaymentButton(
                      image: "assets/images/blank_image.png",
                      title: "Cash on Delivery",
                      subtitle: "Pay when you receive your order",
                      isSelected: c.selectedPayment.value == 'cash',
                      icon: Icons.money,
                      iconColor: Colors.blue,
                      onTap: () {
                        c.updateSeletedPayment("cash");
                      },
                    )),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 0,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Obx(() => ElevatedButton(
                onPressed: c.selectedPayment.value.isEmpty
                    ? null
                    : () {
                        if (c.selectedPayment.value == 'esewa') {
                          final Esewa esewa = Esewa();
                          esewa.pay(
                              foodId,
                              coreController.currentUser.value!.id.toString(),
                              c.selectedPayment.value,
                              quantity,
                              price);
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey[300],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      c.selectedPayment.value == 'esewa'
                          ? Icons.account_balance_wallet
                          : c.selectedPayment.value == 'cash'
                              ? Icons.money
                              : Icons.payment,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      c.selectedPayment.value.isEmpty
                          ? "Select a Payment Method"
                          : "Pay RS ${totalAmount.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class PaymentButton extends StatelessWidget {
  const PaymentButton({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  final bool isSelected;
  final String image;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AppColors.primaryColor : Colors.grey.shade200,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 0,
                  offset: const Offset(0, 2),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Payment method icon
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),

                // Payment method details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),

                // Selection indicator
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryColor
                          : Colors.grey.shade400,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: isSelected ? 12 : 0,
                      height: isSelected ? 12 : 0,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
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
