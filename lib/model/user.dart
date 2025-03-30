class Users {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? gender;
  String? role;
  String? branchId;
  String? branchName;
  String? image;
  String? token;

  Users(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.phoneNumber,
      this.gender,
      this.role,
      this.branchId,
      this.branchName,
      this.image,
      this.token});

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    gender = json['gender'];
    role = json['role'];
    branchId = json['branch_id'];
    branchName = json['branch_name'];
    image = json['image'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone_number'] = phoneNumber;
    data['gender'] = gender;
    data['role'] = role;
    data['branch_id'] = branchId;
    data['branch_name'] = branchName;
    data['image'] = image;
    data['token'] = token;
    return data;
  }
}
