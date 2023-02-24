class HallFeeDetailsModel {
  HallFeeDetailsModel.fromJson(dynamic json) {
    id = json['id'];
    hallFeeID = json['hallfeeID'];
    createdDate = json['created_date'];
    money = json['money'];
    purpose = json['purpose'];
  }

  num? id;
  num? hallFeeID;
  String? createdDate;
  num? money;
  String? purpose;
}
