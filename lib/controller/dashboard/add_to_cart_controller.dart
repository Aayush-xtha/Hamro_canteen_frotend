import 'package:get/get.dart';

class CartItem {
  final int id;
  final String name;
  final String description;
  final double price;
  RxInt quantity;
  final String image;

  CartItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required int quantity,
    this.image = "",
  }) : quantity = quantity.obs;
}

class AddToCartController extends GetxController {
  // Sample data for cart items
  final RxList<CartItem> cartItems = <CartItem>[
    CartItem(
      id: 1,
      name: "Chicken Burger",
      description: "Juicy chicken patty with fresh vegetables",
      price: 250.00,
      quantity: 1,
      image:
          "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
    ),
    CartItem(
      id: 2,
      name: "Veggie Pizza",
      description: "Loaded with fresh vegetables and cheese",
      price: 450.00,
      quantity: 1,
      image:
          "https://images.unsplash.com/photo-1513104890138-7c749659a591?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
    ),
    CartItem(
      id: 3,
      name: "Chocolate Milkshake",
      description: "Rich and creamy chocolate milkshake",
      price: 150.00,
      quantity: 1,
      image:
          "https://images.unsplash.com/photo-1572490122747-3968b75cc699?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
    ),
  ].obs;

  // Set to track selected items
  final RxSet<int> selectedItems = <int>{}.obs;

  // Toggle selection of an item
  void toggleSelection(int id) {
    if (selectedItems.contains(id)) {
      selectedItems.remove(id);
    } else {
      selectedItems.add(id);
    }
  }

  // Select or deselect all items
  void toggleSelectAll() {
    if (selectedItems.length == cartItems.length) {
      // If all are selected, deselect all
      selectedItems.clear();
    } else {
      // Otherwise, select all
      selectedItems.clear();
      for (var item in cartItems) {
        selectedItems.add(item.id);
      }
    }
  }

  // Calculate total for selected items
  double get selectedTotal {
    double total = 0;
    for (var item in cartItems) {
      if (selectedItems.contains(item.id)) {
        total += item.price * item.quantity.value;
      }
    }
    return total;
  }

  // Increase quantity
  void increaseQuantity(int id) {
    final index = cartItems.indexWhere((item) => item.id == id);
    if (index != -1) {
      cartItems[index].quantity++;
    }
  }

  // Decrease quantity
  void decreaseQuantity(int id) {
    final index = cartItems.indexWhere((item) => item.id == id);
    if (index != -1 && cartItems[index].quantity.value > 1) {
      cartItems[index].quantity--;
    }
  }

  // Remove item from cart
  void removeItem(int id) {
    cartItems.removeWhere((item) => item.id == id);
    selectedItems.remove(id);
  }

  // Remove selected items
  void removeSelectedItems() {
    cartItems.removeWhere((item) => selectedItems.contains(item.id));
    selectedItems.clear();
  }

  // Check if cart is empty
  bool get isCartEmpty => cartItems.isEmpty;

  // Check if checkout is possible
  bool get canCheckout => selectedItems.isNotEmpty;
}
