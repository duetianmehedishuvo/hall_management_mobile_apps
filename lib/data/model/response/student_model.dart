class StudentModel {
  String? studentID;
  String? name;
  String? department;
  String? phoneNumber;
  String? bloodGroup;
  String? fingerID;
  String? rfID;
  String? password;
  int? allowableMeal;
  int? roomNO;

  StudentModel(
      {this.studentID,
        this.name,
        this.department,
        this.phoneNumber,
        this.bloodGroup,
        this.fingerID,
        this.rfID,
        this.password,
        this.roomNO,
        this.allowableMeal});

  StudentModel.fromMap(final map) {
    studentID = map['studentID'];
    name = map['name'];
    department = map['department'];
    phoneNumber = map['phone'];
    bloodGroup = map['bloodGroup'];
    fingerID = map['finger_ID'];
    rfID = map['rf_ID'];
    password = map['password'];
    roomNO = map['roomNO'];
    allowableMeal = map['allowableMeal'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['studentID'] = studentID;
    map['name'] = name;
    map['department'] = department;
    map['phone'] = phoneNumber;
    map['bloodGroup'] = bloodGroup;
    map['finger_ID'] = fingerID;
    map['rf_ID'] = rfID;
    map['password'] = password;
    map['roomNO'] = roomNO;
    map['allowableMeal'] = allowableMeal;
    return map;
  }
}
