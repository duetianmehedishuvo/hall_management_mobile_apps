class BookHistoryModel {
  BookHistoryModel({
    this.id,
    this.bookId,
    this.studentId,
    this.name,
    this.department,
  });

  BookHistoryModel.fromJson(dynamic json) {
    id = json['id'];
    bookId = json['book_id'];
    studentId = json['student_id'];
    name = json['name'];
    department = json['department'];
  }

  num? id;
  num? bookId;
  num? studentId;
  String? name;
  String? department;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['book_id'] = bookId;
    map['student_id'] = studentId;
    map['name'] = name;
    map['department'] = department;
    return map;
  }
}
