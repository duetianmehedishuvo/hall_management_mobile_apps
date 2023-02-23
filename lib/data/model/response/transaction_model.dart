class TransactionModel {
  TransactionModel.fromJson(dynamic json) {
    id = json['id'];
    studentID = json['studentID'];
    createdAt = json['created_at'];
    amount = json['amount'];
    isIn = json['isIn'];
    transactionID = json['transactionID'];
    purpose = json['purpose'];
  }

  num? id;
  num? studentID;
  String? createdAt;
  String? amount;
  num? isIn;
  String? transactionID;
  String? purpose;
}
