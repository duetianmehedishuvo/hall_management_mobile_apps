class HallFeeModel {
  HallFeeModel.fromJson(dynamic json) {
    id = json['id'];
    studentID = json['studentID'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    amount = json['amount'];
    due = json['due'];
    fine = json['fine'];
    lastFineTime = json['lastFineTime'];
    purpose = json['purpose'];
    type = json['type'];
  }

  num? id;
  String? studentID;
  String? createdAt;
  String? updatedAt;
  num? amount;
  num? due;
  num? fine;
  String? lastFineTime;
  String? purpose;
  num? type;
}
