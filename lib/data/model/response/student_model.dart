import 'package:duetstahall/helper/database/table_column.dart';

class StudentModel {
  int? id;
  int? userRoll;
  int? studentID;
  String? password;
  String? name;
  String? image;
  String? department;
  String? phoneNo;
  String? address;
  String? jobPosition;
  String? admissionDate;
  String? aboutMe;
  String? bloodGroup;

  StudentModel(
      {this.id,
      this.userRoll,
      this.studentID,
      this.password,
      this.name,
      this.image,
      this.department,
      this.phoneNo,
      this.address,
      this.jobPosition,
      this.admissionDate,
      this.bloodGroup,
      this.aboutMe});

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map[columnUserRoll] = userRoll;
    map[columnStudentID] = studentID;
    map[columnPassword] = password;
    map[columnName] = name;
    map[columnImage] = image;
    map[columnDepartment] = department;
    map[columnAdmissionDate] = admissionDate;
    map[columnPhoneNo] = phoneNo;
    map[columnAddress] = address;
    map[columnBloodGroup] = bloodGroup;
    map[columnJobPosition] = jobPosition;
    map[columnAboutMe] = aboutMe;
    return map;
  }

  //to be used when converting the row into object
  factory StudentModel.fromMap(Map<String, dynamic> data) => StudentModel(
        id: data[columnID],
        userRoll: data[columnUserRoll],
        studentID: data[columnStudentID],
        password: data[columnPassword],
        name: data[columnName],
        image: data[columnImage],
        department: data[columnDepartment],
        admissionDate: data[columnAdmissionDate],
        phoneNo: data[columnPhoneNo],
        address: data[columnAddress],
        bloodGroup: data[columnBloodGroup],
        jobPosition: data[columnJobPosition],
        aboutMe: data[columnAboutMe],
      );
}
