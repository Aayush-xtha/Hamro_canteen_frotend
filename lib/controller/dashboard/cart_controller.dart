import 'package:folder_structure/repo/cart_repo.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  // Observable list of cart items
  var cartItems = <CartItem>[].obs;
  var isLoading = false.obs;

  // Get cart count
  int get cartCount => cartItems.length;

  @override
  void onInit() {
    super.onInit();
    fetchCartItems();
  }

  // Fetch cart items from API or local storage
  Future<void> fetchCartItems() async {
    isLoading.value = true;

    try {
      // Simulate API call with dummy data for now
      // In a real app, you would fetch this from your API
      await Future.delayed(const Duration(seconds: 1));

      // Example cart items
      final List<CartItem> fetchedItems = [
        CartItem(
          id: 1,
          foodId: 1,
          name: "Vegetable Burger",
          price: 250.0,
          quantity: 1,
          image: "https://via.placeholder.com/150",
        ),
        CartItem(
          id: 2,
          foodId: 3,
          name: "Chicken Pizza",
          price: 450.0,
          quantity: 2,
          image: "https://via.placeholder.com/150",
        ),
      ];

      cartItems.assignAll(fetchedItems);
    } catch (e) {
      print("Error fetching cart items: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Add item to cart using CartRepo
  void addToCart({
    required int foodId,
    required int quantity,
    required Function(String) onSuccess,
    required Function(String) onError,
  }) {
    isLoading.value = true;

    CartRepo.addToCart(
      foodId: foodId,
      quantity: quantity,
      onSuccess: (message) {
        // After successful API call, update local cart
        // In a real app, you would fetch the updated cart from the API
        // For now, we'll add a dummy item
        final newItem = CartItem(
          id: DateTime.now().millisecondsSinceEpoch,
          foodId: foodId,
          name: "Food Item #$foodId",
          price: 250.0,
          quantity: quantity,
          image: "https://via.placeholder.com/150",
        );

        cartItems.add(newItem);
        isLoading.value = false;
        onSuccess(message);
      },
      onError: (message) {
        isLoading.value = false;
        onError(message);
      },
    );
  }

  // Remove item from cart
  void removeFromCart(int itemId) {
    cartItems.removeWhere((item) => item.id == itemId);
  }

  // Update item quantity
  void updateQuantity(int itemId, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(itemId);
      return;
    }

    final index = cartItems.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      cartItems[index].quantity = newQuantity;
    }
  }

  // Calculate total price
  double get totalPrice {
    return cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  // Clear cart
  void clearCart() {
    cartItems.clear();
  }
}

// Cart item model
class CartItem {
  final int id;
  final int foodId;
  final String name;
  final double price;
  int quantity;
  final String image;

  CartItem({
    required this.id,
    required this.foodId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.image,
  });
}
