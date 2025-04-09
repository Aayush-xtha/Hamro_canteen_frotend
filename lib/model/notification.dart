class GetNotification {
  int? id;
  String? message;
  String? createdAt;

  GetNotification({this.id, this.message, this.createdAt});

  GetNotification.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['message'] = message;
    data['created_at'] = createdAt;
    return data;
  }
}
