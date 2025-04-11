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
  var selectedItems = <String>{}.obs;

  bool get isCartEmpty => allCartItems.isEmpty;

  bool get canCheckout => selectedItems.isNotEmpty;

  double get selectedTotal => allCartItems
          .where((item) => selectedItems.contains(item.foodId))
          .fold(0.0, (sum, item) {
        final price = double.tryParse(item.unitPrice ?? '0') ?? 0.0;
        final qty = int.tryParse(item.quantity ?? '0') ?? 0;
        return sum + (price * qty);
      });

  RxBool loadings = RxBool(false);

  addToCart(String foodId, String quantity) async {
    loadings.value = true;
    await AddCartRepo.addToCartRepo(
        foodId: foodId,
        quantity: quantity,
        onSuccess: () {
          loadings.value = false;
          CustomSnackBar.success(
              title: "Add to Cart", message: "Add to Cart successfully");
        },
        onError: (message) {});
  }

  @override
  void onInit() {
    getAlLCartItems();
    super.onInit();
  }

  RxList<CartItems> allCartItems = <CartItems>[].obs;
  final selectedPayment = "".obs;
  void updateSeletedPayment(String payment) {
    selectedPayment.value = payment;
  }

  getAlLCartItems() async {
    loadings.value = true;
    await GetCartRepo.getCartRepo(onSuccess: (cart) {
      loadings.value = false;
      allCartItems.addAll(cart);
    }, onError: (message) {
      loadings.value = false;
      CustomSnackBar.error(title: "cart", message: message);
    });
  }

  List<int> getFoodIds() {
    return allCartItems
        .map((item) =>
            int.tryParse(item.foodId ?? '') ?? 0) // Convert foodId to int
        .toList();
  }

  void toggleSelection(String itemId) {
    if (selectedItems.contains(itemId)) {
      selectedItems.remove(itemId);
    } else {
      selectedItems.add(itemId);
    }
  }

  void toggleSelectAll() {
    if (selectedItems.length == allCartItems.length) {
      selectedItems.clear();
    } else {
      selectedItems.addAll(allCartItems.map((e) => e.cartId.toString()));
    }
  }

  void increaseQuantity(String itemId) {
    final item = allCartItems.firstWhereOrNull((e) => e.cartId == itemId);
    if (item != null) {
      final qty = int.tryParse(item.quantity ?? '0') ?? 0;
      item.quantity = (qty + 1).toString();
    }
  }

  void decreaseQuantity(String itemId) {
    final item = allCartItems.firstWhereOrNull((e) => e.cartId == itemId);
    if (item != null) {
      final qty = int.tryParse(item.quantity ?? '0') ?? 0;
      if (qty > 1) {
        item.quantity = (qty - 1).toString();
      }
    }
  }

  void removeItem(String itemId) {
    allCartItems.removeWhere((item) => item.cartId == itemId);
    selectedItems.remove(itemId);
  }

  void removeSelectedItems() {
    allCartItems.removeWhere((item) => selectedItems.contains(item.cartId));
    selectedItems.clear();
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
                      addToCart(foods.foodId.toString(), quantity.toString());
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
