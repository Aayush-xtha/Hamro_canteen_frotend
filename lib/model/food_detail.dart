List<FoodDetails> foodFromJson(List<dynamic> foodJson) =>
    List<FoodDetails>.from(
        foodJson.map((foodListJson) => FoodDetails.fromJson(foodListJson)));

class FoodDetails {
  String? categoryId;
  String? categoryName;
  List<Foods>? foods;

  FoodDetails({this.categoryId, this.categoryName, this.foods});

  FoodDetails.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    if (json['foods'] != null) {
      foods = <Foods>[];
      json['foods'].forEach((v) {
        foods!.add(Foods.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category_id'] = categoryId;
    data['category_name'] = categoryName;
    if (foods != null) {
      data['foods'] = foods!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Foods {
  String? foodId;
  String? foodName;
  String? price;
  String? description;
  String? foodImage;
  String? branchId;

  Foods({
    this.foodId,
    this.foodName,
    this.price,
    this.description,
    this.foodImage,
    this.branchId,
  });

  Foods.fromJson(Map<String, dynamic> json) {
    foodId = json['food_id'];
    foodName = json['food_name'];
    price = json['price'];
    description = json['description'];
    foodImage = json['food_image'];
    branchId = json['branch_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['food_id'] = foodId;
    data['food_name'] = foodName;
    data['price'] = price;
    data['description'] = description;
    data['food_image'] = foodImage;
    data['branch_id'] = branchId;
    return data;
  }
}
