class MealModel {
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
}
