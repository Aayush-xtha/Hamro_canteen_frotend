import 'package:flutter/material.dart';
import 'package:folder_structure/controller/core_controller.dart';
import 'package:folder_structure/model/cart_item.dart';
import 'package:folder_structure/model/food_detail.dart';
import 'package:folder_structure/repo/add_cart_repo.dart';
import 'package:folder_structure/repo/get_cart_repo.dart';
import 'package:folder_structure/utils/color.dart';
import 'package:folder_structure/utils/custom_snackbar.dart';
import 'package:get/get.dart';

class AddToCartController extends GetxController {
  final coreController = Get.find<CoreController>();
  // Make sure we use a RxSet for proper reactivity
  final selectedItems = <String>{}.obs;

  bool get isCartEmpty => allCartItems.isEmpty;

  bool get canCheckout => selectedItems.isNotEmpty;

  // Make sure we're using cartId consistently for selection
  double get selectedTotal => allCartItems
      .where((item) => selectedItems.contains(item.cartId))
      .fold(0.0, (sum, item) {
        final price = double.tryParse(item.unitPrice ?? '0') ?? 0.0;
        final qty = int.tryParse(item.quantity ?? '0') ?? 0;
        return sum + (price * qty);
      });

  RxBool loadings = RxBool(false);
  RxList<CartItems> allCartItems = <CartItems>[].obs;
  final selectedPayment = "".obs;

  @override
  void onInit() {
    getAlLCartItems();
    super.onInit();
  }
  
  // Clear and refresh selection state
  void resetSelections() {
    selectedItems.clear();
  }

  addToCart(String foodId, String quantity) async {
    loadings.value = true;
    await AddCartRepo.addToCartRepo(
      foodId: foodId,
      quantity: quantity,
      onSuccess: () {
        loadings.value = false;
        // Refresh cart items after adding to cart
        getAlLCartItems();
        CustomSnackBar.success(
            title: "Add to Cart", message: "Add to Cart successfully");
      },
      onError: (message) {
        loadings.value = false;
        CustomSnackBar.error(title: "Error", message: message);
      }
    );
  }

  getAlLCartItems() async {
    loadings.value = true;
    // Clear existing items before fetching new ones
    allCartItems.clear();
    resetSelections();
    
    await GetCartRepo.getCartRepo(
      onSuccess: (cart) {
        loadings.value = false;
        allCartItems.assignAll(cart); // Use assignAll instead of addAll
      }, 
      onError: (message) {
        loadings.value = false;
        CustomSnackBar.error(title: "cart", message: message);
      }
    );
  }

  void updateSeletedPayment(String payment) {
    selectedPayment.value = payment;
  }

  List<int> getFoodIds() {
    return allCartItems
        .map((item) => int.tryParse(item.foodId ?? '') ?? 0)
        .toList();
  }

  // Fixed selection toggle - make sure we're using the correct ID
  void toggleSelection(String cartId) {
    if (selectedItems.contains(cartId)) {
      selectedItems.remove(cartId);
    } else {
      selectedItems.add(cartId);
    }
    // Force UI update
    selectedItems.refresh();
  }

  // Properly fixed select all function
  void toggleSelectAll() {
    if (selectedItems.length == allCartItems.length && allCartItems.isNotEmpty) {
      // If all are selected, clear selection
      selectedItems.clear();
    } else {
      // Select all by adding all cart IDs
      final allIds = allCartItems.map((item) => item.cartId).toList();
      selectedItems.clear();
      // selectedItems.addAll(allIds);
    }
    // Force UI update
    selectedItems.refresh();
  }

  // Fixed quantity management with proper updates
  void increaseQuantity(String cartId) {
    final index = allCartItems.indexWhere((item) => item.cartId == cartId);
    if (index != -1) {
      final item = allCartItems[index];
      final qty = int.tryParse(item.quantity ?? '0') ?? 0;
      
      // Create a new item with updated quantity to ensure reactivity
      final updatedItem = CartItems(
        cartId: item.cartId,
        foodId: item.foodId,
        foodName: item.foodName,
        description: item.description,
        foodImage: item.foodImage,
        unitPrice: item.unitPrice,
        quantity: (qty + 1).toString(),
      );
      
      // Update the list with the new item
      allCartItems[index] = updatedItem;
      allCartItems.refresh();
    }
  }

  // Fixed quantity management with proper updates
  void decreaseQuantity(String cartId) {
    final index = allCartItems.indexWhere((item) => item.cartId == cartId);
    if (index != -1) {
      final item = allCartItems[index];
      final qty = int.tryParse(item.quantity ?? '0') ?? 0;
      
      if (qty > 1) {
        // Create a new item with updated quantity to ensure reactivity
        final updatedItem = CartItems(
          cartId: item.cartId,
          foodId: item.foodId,
          foodName: item.foodName,
          description: item.description,
          foodImage: item.foodImage,
          unitPrice: item.unitPrice,
          quantity: (qty - 1).toString(),
        );
        
        // Update the list with the new item
        allCartItems[index] = updatedItem;
        allCartItems.refresh();
      }
    }
  }

  void removeItem(String cartId) {
    allCartItems.removeWhere((item) => item.cartId == cartId);
    selectedItems.remove(cartId);
    // Force refresh
    allCartItems.refresh();
    selectedItems.refresh();
  }

  void removeSelectedItems() {
    // Make a copy of the selected items before removing
    final itemsToRemove = [...selectedItems];
    
    allCartItems.removeWhere((item) => itemsToRemove.contains(item.cartId));
    selectedItems.clear();
    
    // Force refresh of both lists
    allCartItems.refresh();
    selectedItems.refresh();
  }

  void showAddToCart(BuildContext context, Foods foods) {
    final RxInt quantity = 1.obs;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
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

                  Text(
                    "Select Quantity",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: const Icon(Icons.remove,
                                color: Colors.red, size: 16),
                          ),
                          onPressed: () {
                            if (quantity.value > 1) quantity.value--;
                          },
                        ),
                        Obx(
                          () => Text(
                            quantity.value.toString(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: const Icon(Icons.add,
                                color: Colors.green, size: 16),
                          ),
                          onPressed: () {
                            quantity.value++;
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      addToCart(foods.foodId.toString(), quantity.value.toString());
                      Get.back();
                    },
                    child: const Text(
                      "Add To Cart",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }
}