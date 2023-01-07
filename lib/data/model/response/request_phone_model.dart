import 'package:duetstahall/helper/database/table_column.dart';

class RequestPhoneModel {
  int? id;
  int? studentID;
  int? studentRequestUser;
  int? studentRequestStatus;

  RequestPhoneModel({this.id, this.studentID, this.studentRequestUser, this.studentRequestStatus});

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map[columnID] = id;
    map[columnStudentID] = studentID;
    map[columnRequestUserID] = studentRequestUser;
    map[columnUserRequestStatus] = studentRequestStatus;
    return map;
  }

  //to be used when converting the row into object
  factory RequestPhoneModel.fromMap(Map<String, dynamic> data) => RequestPhoneModel(
      id: data[columnID],
      studentID: data[columnStudentID],
      studentRequestUser: data[columnRequestUserID],
      studentRequestStatus: data[columnUserRequestStatus]);
}
