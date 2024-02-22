class CommendModel {
  CommendModel({
    this.id,
    this.communityId,
    this.studentId,
    this.comment,
    this.createdAt,
    this.name,
    this.department,
  });

  CommendModel.fromJson(dynamic json) {
    id = json['id'];
    communityId = json['community_id'];
    studentId = json['student_id'];
    comment = json['comment'];
    createdAt = json['created_at'];
    name = json['name'];
    department = json['department'];
  }

  num? id;
  num? communityId;
  num? studentId;
  String? comment;
  String? createdAt;
  String? name;
  String? department;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['community_id'] = communityId;
    map['student_id'] = studentId;
    map['comment'] = comment;
    map['created_at'] = createdAt;
    map['name'] = name;
    map['department'] = department;
    return map;
  }
}
