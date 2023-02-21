class MealModel {
  MealModel({
    this.id,
    this.studentID,
    this.createdAt,
    this.updatedAt,
    this.totalMeal,
  });

  MealModel.fromJson(dynamic json) {
    id = json['id'];
    studentID = json['studentID'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    totalMeal = json['total_meal'];
  }

  num? id;
  num? studentID;
  String? createdAt;
  String? updatedAt;
  num? totalMeal;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['studentID'] = studentID;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['total_meal'] = totalMeal;
    return map;
  }
}
