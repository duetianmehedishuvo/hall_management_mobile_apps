class BookPurchasedModel {
  BookPurchasedModel({
      this.id, 
      this.bookId, 
      this.studentId, 
      this.createdAt, 
      this.updatedAt, 
      this.status,});

  BookPurchasedModel.fromJson(dynamic json) {
    id = json['id'];
    bookId = json['book_id'];
    studentId = json['student_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
  }
  num? id;
  num? bookId;
  num? studentId;
  String? createdAt;
  String? updatedAt;
  num? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['book_id'] = bookId;
    map['student_id'] = studentId;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['status'] = status;
    return map;
  }

}