class StudentModel1 {
  StudentModel1({
    this.id,
    this.studentID,
    this.role,
    this.name,
    this.department,
    this.phoneNumber,
    this.whatssApp,
    this.email,
    this.bloodGroup,
    this.fingerID,
    this.rfID,
    this.password,
    this.balance,
    this.details,
    this.homeTown,
    this.researchArea,
    this.jobPosition,
    this.futureGoal,
    this.motive,
    this.createAt,
    this.updatedAt,
  });

  StudentModel1.fromJson(dynamic json) {
    id = json['id'];
    studentID = json['studentID'];
    role = json['role'];
    name = json['name'];
    department = json['department'];
    phoneNumber = json['phoneNumber'];
    whatssApp = json['whatssApp'];
    email = json['email'];
    bloodGroup = json['bloodGroup'];
    fingerID = json['fingerID'];
    rfID = json['rfID'];
    password = json['password'];
    balance = json['balance'];
    details = json['details'];
    homeTown = json['homeTown'];
    researchArea = json['researchArea'];
    jobPosition = json['jobPosition'];
    futureGoal = json['futureGoal'];
    motive = json['motive'];
    createAt = json['create_at'];
    updatedAt = json['updated_at'];
  }

  num? id;
  num? studentID;
  num? role;
  String? name;
  String? department;
  String? phoneNumber;
  String? whatssApp;
  String? email;
  String? bloodGroup;
  String? fingerID;
  String? rfID;
  String? password;
  num? balance;
  String? details;
  String? homeTown;
  String? researchArea;
  String? jobPosition;
  String? futureGoal;
  String? motive;
  String? createAt;
  String? updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['studentID'] = studentID;
    map['role'] = role;
    map['name'] = name;
    map['department'] = department;
    map['phoneNumber'] = phoneNumber;
    map['whatssApp'] = whatssApp;
    map['email'] = email;
    map['bloodGroup'] = bloodGroup;
    map['fingerID'] = fingerID;
    map['rfID'] = rfID;
    map['password'] = password;
    map['balance'] = balance;
    map['details'] = details;
    map['homeTown'] = homeTown;
    map['researchArea'] = researchArea;
    map['jobPosition'] = jobPosition;
    map['futureGoal'] = futureGoal;
    map['motive'] = motive;
    map['create_at'] = createAt;
    map['updated_at'] = updatedAt;
    return map;
  }
}

class StudentSubModel {
  StudentSubModel({this.studentID, this.name, this.department});

  StudentSubModel.fromJson(dynamic json) {
    studentID = json['studentID'];
    name = json['name'];
    department = json['department'];
  }

  num? studentID;
  String? name;
  String? department;
}
