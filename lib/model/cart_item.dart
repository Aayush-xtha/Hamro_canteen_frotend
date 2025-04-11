List<CartItems> cartItemsFromJson(List<dynamic> cartJson) =>
    List<CartItems>.from(
        cartJson.map((cartListJson) => CartItems.fromJson(cartListJson)));

class CartItems {
  String? cartId;
  String? userId;
  String? branchId;
  String? cartTotal;
  String? createdAt;
  String? cartItemId;
  String? foodId;
  String? quantity;
  String? itemTotalPrice;
  String? foodName;
  String? unitPrice;
  String? foodImage;
  String? description;

  CartItems(
      {this.cartId,
      this.userId,
      this.branchId,
      this.cartTotal,
      this.createdAt,
      this.cartItemId,
      this.foodId,
      this.quantity,
      this.itemTotalPrice,
      this.foodName,
      this.unitPrice,
      this.foodImage,
      this.description});

  CartItems.fromJson(Map<String, dynamic> json) {
    cartId = json['cart_id'];
    userId = json['user_id'];
    branchId = json['branch_id'];
    cartTotal = json['cart_total'];
    createdAt = json['created_at'];
    cartItemId = json['cart_item_id'];
    foodId = json['food_id'];
    quantity = json['quantity'];
    itemTotalPrice = json['item_total_price'];
    foodName = json['food_name'];
    unitPrice = json['unit_price'];
    foodImage = json['food_image'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cart_id'] = cartId;
    data['user_id'] = userId;
    data['branch_id'] = branchId;
    data['cart_total'] = cartTotal;
    data['created_at'] = createdAt;
    data['cart_item_id'] = cartItemId;
    data['food_id'] = foodId;
    data['quantity'] = quantity;
    data['item_total_price'] = itemTotalPrice;
    data['food_name'] = foodName;
    data['unit_price'] = unitPrice;
    data['food_image'] = foodImage;
    data['description'] = description;
    return data;
  }
}
