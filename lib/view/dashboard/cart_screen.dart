import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:folder_structure/controller/dashboard/cart_controller.dart';
import 'package:folder_structure/model/cart_item.dart';
import 'package:folder_structure/utils/color.dart';
import 'package:folder_structure/view/dashboard/menu_list.dart';
import 'package:folder_structure/view/dashboard/order_detail_screen.dart';
import 'package:get/get.dart';

class AddToCartPage extends StatelessWidget {
  AddToCartPage({super.key});

  final c = Get.put(AddToCartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(),
      body: Obx(() {
        if (c.loadings.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return c.isCartEmpty
            ? _buildEmptyCart()
            : Column(
                children: [
                  _buildSelectAllHeader(),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(15),
                      itemCount: c.allCartItems.length,
                      itemBuilder: (context, index) {
                        final item = c.allCartItems[index];
                        return CartItemCard(
                          item: item,
                          isSelected: c.selectedItems.contains(item.cartId),
                          onToggleSelection: () => c.toggleSelection(item.cartId.toString()),
                          onIncreaseQuantity: () => c.increaseQuantity(item.cartId.toString()),
                          onDecreaseQuantity: () => c.decreaseQuantity(item.cartId.toString()),
                          onRemove: () => c.removeItem(item.cartId.toString()),
                        );
                      },
                    ),
                  ),
                ],
              );
      }),
      // Floating action button to proceed to checkout
      floatingActionButton: Obx(() {
        if (c.selectedItems.isEmpty) return const SizedBox.shrink();
        
        return FloatingActionButton.extended(
          onPressed: () {
            _showCheckoutSheet(context);
          },
          backgroundColor: AppColors.primaryColor,
          icon: const Icon(Icons.shopping_bag_outlined),
          label: const Text("Checkout"),
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
              onPressed: c.selectedItems.isEmpty
                  ? null
                  : () => c.removeSelectedItems(),
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
              Theme(
                data: ThemeData(
                  checkboxTheme: CheckboxThemeData(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                child: Checkbox(
                  value: c.selectedItems.length == c.allCartItems.length &&
                      c.allCartItems.isNotEmpty,
                  onChanged: (_) => c.toggleSelectAll(),
                  activeColor: AppColors.primaryColor,
                ),
              ),
              const Text(
                "Select All Items",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${c.selectedItems.length}/${c.allCartItems.length}",
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

  void _showCheckoutSheet(BuildContext context) {
    // Get only the selected items
    final selectedCartItems = c.allCartItems
        .where((item) => c.selectedItems.contains(item.cartId))
        .toList();
        
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              
              // Title
              Center(
                child: Text(
                  "Order Summary",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Selected items summary
              Text(
                "Selected Items (${selectedCartItems.length})",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              
              // List of selected items (limited to 3 with "more" indicator)
              ...selectedCartItems
                  .take(3)
                  .map((item) => 
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: item.foodImage ?? "",
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                width: 40,
                                height: 40,
                                color: Colors.grey[200],
                                child: const Center(child: CircularProgressIndicator()),
                              ),
                              errorWidget: (context, url, error) => Container(
                                width: 40,
                                height: 40,
                                color: Colors.grey[200],
                                child: const Icon(Icons.fastfood, color: Colors.grey, size: 20),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "${item.foodName} x${item.quantity}",
                              style: const TextStyle(fontSize: 14),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            "₹${(double.parse(item.unitPrice ?? "0") * int.parse(item.quantity ?? "1")).toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  ).toList(),
              
              // Show "more items" if there are more than 3 selected items
              if (selectedCartItems.length > 3)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    "and ${selectedCartItems.length - 3} more items...",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              
              // Total amount
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total Amount",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "₹${c.selectedTotal.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Proceed to checkout button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Get.back(); // Close the bottom sheet
                    Get.to(() => OrderDetailScreen(
                      selectedItems: selectedCartItems,
                      totalAmount: c.selectedTotal,
                      isFromCart: true,
                    ));
                  },
                  child: const Text(
                    "Proceed to Checkout",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
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
                      child: Theme(
                        data: ThemeData(
                          checkboxTheme: CheckboxThemeData(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        child: Checkbox(
                          value: isSelected,
                          onChanged: (_) => onToggleSelection(),
                          activeColor: AppColors.primaryColor,
                        ),
                      ),
                    ),
                    // Food image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: item.foodImage ?? "",
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey[200],
                          child: const Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey[300],
                          child: const Icon(Icons.fastfood, size: 40, color: Colors.orange),
                        ),
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
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.description ?? "",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12),
                          // Price and quantity controls
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Price
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "₹${item.unitPrice}",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                  int.parse(item.quantity ?? "0") > 1
                                      ? Text(
                                          "Total: ₹${(double.parse(item.unitPrice ?? "0") * int.parse(item.quantity ?? "1")).toStringAsFixed(2)}",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                ],
                              ),
                              // Quantity controls
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.grey[300]!,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Decrease button
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: onDecreaseQuantity,
                                        borderRadius: BorderRadius.circular(20),
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          child: Icon(
                                            Icons.remove,
                                            color: int.parse(item.quantity ?? "0") > 1
                                                ? AppColors.primaryColor
                                                : Colors.grey,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Quantity display
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      child: Text(
                                        item.quantity ?? "0",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    // Increase button
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: onIncreaseQuantity,
                                        borderRadius: BorderRadius.circular(20),
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          child: Icon(
                                            Icons.add,
                                            color: AppColors.primaryColor,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
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
