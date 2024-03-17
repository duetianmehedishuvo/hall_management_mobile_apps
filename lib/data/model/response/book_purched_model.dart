class BookPurchedModel {
  BookPurchedModel({
    this.id,
    this.bookId,
    this.studentId,
    this.updatedAt,
    this.createdAt,
    this.status,
    this.title,
    this.author,
    this.price,
    this.category,
  });

  BookPurchedModel.fromJson(dynamic json) {
    id = json['id'];
    bookId = json['book_id'];
    studentId = json['student_id'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    status = json['status'];
    title = json['title'];
    author = json['author'];
    price = json['price'];
    category = json['category'];
  }

  num? id;
  num? bookId;
  num? studentId;
  String? updatedAt;
  String? createdAt;
  num? status;
  String? title;
  String? author;
  String? price;
  String? category;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['book_id'] = bookId;
    map['student_id'] = studentId;
    map['updated_at'] = updatedAt;
    map['created_at'] = createdAt;
    map['status'] = status;
    map['title'] = title;
    map['author'] = author;
    map['price'] = price;
    map['category'] = category;
    return map;
  }
}
