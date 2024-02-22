class CommunityModel {
  CommunityModel({
    this.id,
    this.studentId,
    this.details,
    this.updatedAt,
    this.name,
    this.department,
    this.commentCount,
  });

  CommunityModel.fromJson(dynamic json) {
    id = json['id'];
    studentId = json['student_id'];
    details = json['details'];
    updatedAt = json['updated_at'];
    name = json['name'];
    department = json['department'];
    commentCount = json['comment_count'];
  }

  num? id;
  num? studentId;
  String? details;
  String? updatedAt;
  String? name;
  String? department;
  num? commentCount;



  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['student_id'] = studentId;
    map['details'] = details;
    map['updated_at'] = updatedAt;
    map['name'] = name;
    map['department'] = department;
    map['comment_count'] = commentCount;
    return map;
  }
}
