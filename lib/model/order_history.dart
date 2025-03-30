List<OrderHistory> orderHistoryFromJson(List<dynamic> orderJson) =>
    List<OrderHistory>.from(
        orderJson.map((orderListJson) => OrderHistory.fromJson(orderListJson)));

class OrderHistory {
  String? orderId;
  String? totalAmount;
  String? orderStatus;
  String? orderDate;
  UserDetails? userDetails;
  List<Items>? items;
  Payment? payment;

  OrderHistory(
      {this.orderId,
      this.totalAmount,
      this.orderStatus,
      this.orderDate,
      this.userDetails,
      this.items,
      this.payment});

  OrderHistory.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    totalAmount = json['total_amount'];
    orderStatus = json['order_status'];
    orderDate = json['order_date'];
    userDetails = json['user_details'] != null
        ? UserDetails.fromJson(json['user_details'])
        : null;
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
    payment =
        json['payment'] != null ? Payment.fromJson(json['payment']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['total_amount'] = totalAmount;
    data['order_status'] = orderStatus;
    data['order_date'] = orderDate;
    if (userDetails != null) {
      data['user_details'] = userDetails!.toJson();
    }
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    if (payment != null) {
      data['payment'] = payment!.toJson();
    }
    return data;
  }
}

class UserDetails {
  String? userId;
  String? name;
  String? email;
  String? phoneNumber;
  String? gender;
  String? image;

  UserDetails(
      {this.userId,
      this.name,
      this.email,
      this.phoneNumber,
      this.gender,
      this.image});

  UserDetails.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    gender = json['gender'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['name'] = name;
    data['email'] = email;
    data['phone_number'] = phoneNumber;
    data['gender'] = gender;
    data['image'] = image;
    return data;
  }
}

class Items {
  String? foodId;
  String? foodName;
  String? foodImage;
  String? quantity;
  String? rate;
  String? sumTotal;

  Items(
      {this.foodId,
      this.foodName,
      this.foodImage,
      this.quantity,
      this.rate,
      this.sumTotal});

  Items.fromJson(Map<String, dynamic> json) {
    foodId = json['food_id'];
    foodName = json['food_name'];
    foodImage = json['food_image'];
    quantity = json['quantity'];
    rate = json['rate'];
    sumTotal = json['sum_total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['food_id'] = foodId;
    data['food_name'] = foodName;
    data['food_image'] = foodImage;
    data['quantity'] = quantity;
    data['rate'] = rate;
    data['sum_total'] = sumTotal;
    return data;
  }
}

class Payment {
  String? method;
  String? amount;
  String? paymentDate;

  Payment({this.method, this.amount, this.paymentDate});

  Payment.fromJson(Map<String, dynamic> json) {
    method = json['method'];
    amount = json['amount'];
    paymentDate = json['payment_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['method'] = method;
    data['amount'] = amount;
    data['payment_date'] = paymentDate;
    return data;
  }
}
