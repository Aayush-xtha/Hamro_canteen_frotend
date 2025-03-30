List<BranchDetail> branchFromJson(List<dynamic> branchJson) =>
    List<BranchDetail>.from(branchJson
        .map((branchListJson) => BranchDetail.fromJson(branchListJson)));

class BranchDetail {
  String? branchId;
  String? branchName;
  String? address;
  String? email;
  String? phoneNumber;
  String? logo;
  String? createdAt;

  BranchDetail(
      {this.branchId,
      this.branchName,
      this.address,
      this.email,
      this.phoneNumber,
      this.logo,
      this.createdAt});

  BranchDetail.fromJson(Map<String, dynamic> json) {
    branchId = json['branch_id'];
    branchName = json['branch_name'];
    address = json['address'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    logo = json['logo'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['branch_id'] = branchId;
    data['branch_name'] = branchName;
    data['address'] = address;
    data['email'] = email;
    data['phone_number'] = phoneNumber;
    data['logo'] = logo;
    data['created_at'] = createdAt;
    return data;
  }
}
