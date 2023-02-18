class RoomModel1 {
  RoomModel1({
    this.id,
    this.isAvaible,
    this.studentID,
    this.year,
    this.updatedAt,
    this.name,
    this.department,
  });

  RoomModel1.fromJson(dynamic json) {
    id = json['id'];
    isAvaible = json['isAvaible'];
    studentID = json['studentID'];
    year = json['year'];
    updatedAt = json['updated_at'];
    name = json['name'];
    department = json['department'];
  }

  num? id;
  num? isAvaible;
  num? studentID;
  num? year;
  String? updatedAt;
  String? name;
  String? department;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['isAvaible'] = isAvaible;
    map['studentID'] = studentID;
    map['year'] = year;
    map['updated_at'] = updatedAt;
    map['name'] = name;
    map['department'] = department;
    return map;
  }
}
