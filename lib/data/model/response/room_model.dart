import 'package:duetstahall/helper/database/table_column.dart';

class RoomModel {
  int? id;
  int? roomID;
  int? year;
  int? floor;
  int? totalStudents;
  String? student1;
  String? student2;
  String? student3;
  String? student4;
  String? student5;
  String? student6;
  String? studentExtra;

  RoomModel(
      {this.id,
      this.roomID,
      this.year,
      this.totalStudents,
      this.floor,
      this.student1,
      this.student2,
      this.student3,
      this.student4,
      this.student5,
      this.student6,
      this.studentExtra});

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map[columnTotalStudents] = totalStudents;
    map[columnRoomID] = roomID;
    map[columnYear] = year;
    map[columnFloorID] = floor;
    map[columnStudent1] = student1;
    map[columnStudent2] = student2;
    map[columnStudent3] = student3;
    map[columnStudent4] = student4;
    map[columnStudent5] = student5;
    map[columnStudent6] = student6;
    map[columnExtraStudent] = studentExtra;
    return map;
  }

  //to be used when converting the row into object
  factory RoomModel.fromMap(Map<String, dynamic> data) => RoomModel(
        id: data[columnID],
        totalStudents: data[columnTotalStudents],
        roomID: data[columnRoomID],
        year: data[columnYear],
        floor: data[columnFloorID],
        student1: data[columnStudent1],
        student2: data[columnStudent2],
        student3: data[columnStudent3],
        student4: data[columnStudent4],
        student5: data[columnStudent5],
        student6: data[columnStudent6],
        studentExtra: data[columnExtraStudent],
      );
}
