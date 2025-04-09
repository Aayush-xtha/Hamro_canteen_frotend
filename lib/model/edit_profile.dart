class EditProfile {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? gender;
  String? image;
  String? branchId;
  String? branchName;

  EditProfile(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.phoneNumber,
      this.gender,
      this.image,
      this.branchId,
      this.branchName});

  EditProfile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    gender = json['gender'];
    image = json['image'];
    branchId = json['branch_id'];
    branchName = json['branch_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone_number'] = phoneNumber;
    data['gender'] = gender;
    data['image'] = image;
    data['branch_id'] = branchId;
    data['branch_name'] = branchName;
    return data;
  }
}