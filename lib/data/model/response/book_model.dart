class BookModel {
  BookModel({
    this.id,
    this.title,
    this.author,
    this.category,
    this.price,
  });

  BookModel.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    author = json['author'];
    category = json['category'];
    price = json['price'];
  }

  num? id;
  String? title;
  String? author;
  String? category;
  String? price;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['author'] = author;
    map['category'] = category;
    map['price'] = price;
    return map;
  }
}
