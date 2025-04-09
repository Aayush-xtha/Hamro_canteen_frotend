class CartItem {
  final int id;
  final int foodId;
  final int quantity;
  final String foodName;
  final double foodPrice;
  final String foodImage;

  CartItem({
    required this.id,
    required this.foodId,
    required this.quantity,
    required this.foodName,
    required this.foodPrice,
    required this.foodImage,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      foodId: json['food_id'],
      quantity: json['quantity'],
      foodName: json['food']['name'],
      foodPrice: double.parse(json['food']['price'].toString()),
      foodImage: json['food']['image'],
    );
  }
}