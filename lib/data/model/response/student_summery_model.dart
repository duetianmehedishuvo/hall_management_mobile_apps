class StudentSummeryModel {
  StudentSummeryModel({
      this.studentID, 
      this.name, 
      this.department,});

  StudentSummeryModel.fromJson(dynamic json) {
    studentID = json['studentID'];
    name = json['name'];
    department = json['department'];
  }
  num? studentID;
  String? name;
  String? department;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['studentID'] = studentID;
    map['name'] = name;
    map['department'] = department;
    return map;
  }

}