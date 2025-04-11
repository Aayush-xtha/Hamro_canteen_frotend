import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:folder_structure/controller/dashboard/cart_controller.dart';
import 'package:folder_structure/controller/dashboard/menu_list_controller.dart';
import 'package:folder_structure/model/cart_item.dart';
import 'package:folder_structure/utils/color.dart';
import 'package:folder_structure/view/dashboard/menu_list.dart';
import 'package:get/get.dart';

class AddToCartPage extends StatelessWidget {
  AddToCartPage({super.key});

  final AddToCartController controller = Get.put(AddToCartController());
  final orderController = Get.put(MenuListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(),
      body: Obx(() {
        return controller.isCartEmpty
            ? _buildEmptyCart()
            : Column(
                children: [
                  _buildSelectAllHeader(),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(15),
                      itemCount: controller.allCartItems.length,
                      itemBuilder: (context, index) {
                        final item = controller.allCartItems[index];
                        return Obx(() => CartItemCard(
                              item: item,
                              isSelected: controller.selectedItems
                                  .contains(item.cartId),
                              onToggleSelection: () => controller
                                  .toggleSelection(item.cartId.toString()),
                              onIncreaseQuantity: () => controller
                                  .increaseQuantity(item.cartId.toString()),
                              onDecreaseQuantity: () => controller
                                  .decreaseQuantity(item.cartId.toString()),
                              onRemove: () =>
                                  controller.removeItem(item.cartId.toString()),
                            ));
                      },
                    ),
                  ),
                  _buildCheckoutSection(),
                ],
              );
      }),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        "Your Cart",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      backgroundColor: AppColors.primaryColor,
      elevation: 0,
      actions: [
        Obx(() => IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: controller.selectedItems.isEmpty
                  ? null
                  : () => controller.removeSelectedItems(),
              tooltip: "Remove selected items",
            )),
      ],
    );
  }

  Widget _buildEmptyCart() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_cart_outlined,
              size: 80,
              color: AppColors.primaryColor.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "Your cart is empty",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Looks like you haven't added anything to your cart yet",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            icon: const Icon(Icons.restaurant_menu),
            label: const Text("Browse Menu"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Get.offAll(() => MenuList());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSelectAllHeader() {
    return Obx(() => Container(
          margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Checkbox(
                value: controller.selectedItems.length ==
                        controller.allCartItems.length &&
                    controller.allCartItems.isNotEmpty,
                onChanged: (_) => controller.toggleSelectAll(),
                activeColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Text(
                "Select All Items",
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${controller.selectedItems.length}/${controller.allCartItems.length}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildCheckoutSection() {
    return Obx(() {
      final bool canCheckout = controller.canCheckout;
      final double selectedTotal = controller.selectedTotal;

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            // Order summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Selected Items (${controller.selectedItems.length})",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        "₹${selectedTotal.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Delivery Fee",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        controller.selectedItems.isEmpty ? "₹0.00" : "₹40.00",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total Amount",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "₹${(controller.selectedItems.isEmpty ? 0 : selectedTotal + 40).toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Checkout button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
              ),
              onPressed: canCheckout
                  ? () {
                      // orderController.addOrders(, userId, paymentMethod, quantity, rate)
                    }
                  : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_bag_outlined),
                  const SizedBox(width: 8),
                  Text(
                    canCheckout
                        ? "Proceed to Checkout"
                        : "Select Items to Checkout",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

class CartItemCard extends StatelessWidget {
  final CartItems item;
  final bool isSelected;
  final VoidCallback onToggleSelection;
  final VoidCallback onIncreaseQuantity;
  final VoidCallback onDecreaseQuantity;
  final VoidCallback onRemove;

  const CartItemCard({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onToggleSelection,
    required this.onIncreaseQuantity,
    required this.onDecreaseQuantity,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Stack(
        children: [
          Card(
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: isSelected ? AppColors.primaryColor : Colors.transparent,
                width: isSelected ? 2 : 0,
              ),
            ),
            elevation: isSelected ? 4 : 1,
            child: InkWell(
              onTap: onToggleSelection,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Checkbox for selection
                    Padding(
                      padding: const EdgeInsets.only(top: 8, right: 8),
                      child: Checkbox(
                        value: isSelected,
                        onChanged: (_) => onToggleSelection(),
                        activeColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    // Food image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        fit: BoxFit.cover,
                        height: 100,
                        width: 100,
                        imageUrl: item.foodImage ?? "",
                        errorWidget: (context, url, error) => Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.fastfood,
                                size: 40, color: Colors.orange)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Food details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.foodName ?? "",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.description ?? "",
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 14),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     // Price
                          //     Column(
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: [
                          //         Text(
                          //           "₹${item.unitPrice}",
                          //           style: TextStyle(
                          //             fontSize: 18,
                          //             fontWeight: FontWeight.bold,
                          //             color: AppColors.primaryColor,
                          //           ),
                          //         ),
                          //         Obx(
                          //           () {
                          //             final qty =
                          //                 int.tryParse(item.quantity ?? '0') ??
                          //                     0; // Parse quantity
                          //             final price = item.unitPrice ??
                          //                 0.0; // Safe price default

                          //             return qty > 1
                          //                 ? Text(
                          //                     "Total: ₹${(price * qty).toStringAsFixed(2)}", // Calculate total price
                          //                     style: const TextStyle(
                          //                       fontSize: 14,
                          //                       fontWeight: FontWeight.w500,
                          //                     ),
                          //                   )
                          //                 : const SizedBox
                          //                     .shrink(); // Hide if qty <= 1
                          //           },
                          //         ),
                          //       ],
                          //     ),
                          //     // Quantity controls
                          //     Container(
                          //       decoration: BoxDecoration(
                          //         color: Colors.grey[100],
                          //         borderRadius: BorderRadius.circular(20),
                          //         border: Border.all(
                          //           color: Colors.grey[300]!,
                          //           width: 1,
                          //         ),
                          //       ),
                          //       child: Row(
                          //         children: [
                          //           Material(
                          //             color: Colors.transparent,
                          //             child: InkWell(
                          //               onTap: onDecreaseQuantity,
                          //               borderRadius: BorderRadius.circular(20),
                          //               child: Obx(() => Container(
                          //                     padding: const EdgeInsets.all(6),
                          //                     child: Icon(
                          //                       Icons.remove,
                          //                       color: item.quantity.value > 1
                          //                           ? AppColors.primaryColor
                          //                           : Colors.grey,
                          //                       size: 20,
                          //                     ),
                          //                   )),
                          //             ),
                          //           ),
                          //           Obx(() => Container(
                          //                 padding: const EdgeInsets.symmetric(
                          //                     horizontal: 8),
                          //                 child: Text(
                          //                   "${item.quantity.value}",
                          //                   style: const TextStyle(
                          //                       fontSize: 16,
                          //                       fontWeight: FontWeight.bold),
                          //                 ),
                          //               )),
                          //           Material(
                          //             color: Colors.transparent,
                          //             child: InkWell(
                          //               onTap: onIncreaseQuantity,
                          //               borderRadius: BorderRadius.circular(20),
                          //               child: Container(
                          //                 padding: const EdgeInsets.all(6),
                          //                 child: Icon(
                          //                   Icons.add,
                          //                   color: AppColors.primaryColor,
                          //                   size: 20,
                          //                 ),
                          //               ),
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Delete button positioned at top right
          Positioned(
            top: 0,
            right: 0,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onRemove,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
