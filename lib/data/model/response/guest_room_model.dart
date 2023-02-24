class GuestRoomModel {
  GuestRoomModel.fromJson(dynamic json) {
    id = json['id'];
    roomNO = json['roomNO'];
    date = json['date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    studentID = json['studentID'];
    purpose = json['purpose'];
    phoneNo = json['phoneNo'];
    createAt = json['create_at'];
    status = json['status'];
    updatedAt = json['updated_at'];
  }

  num? id;
  num? roomNO;
  String? date;
  String? startTime;
  String? endTime;
  String? studentID;
  String? purpose;
  String? phoneNo;
  String? createAt;
  num? status;
  String? updatedAt;
}
