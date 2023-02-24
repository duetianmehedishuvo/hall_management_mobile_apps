class ComplainModel {
  ComplainModel.fromJson(dynamic json) {
    id = json['id'];
    studentID = json['studentID'];
    subject = json['subject'];
    complain = json['complain'];
    reply = json['reply'];
    createAt = json['create_at'];
    updatedAt = json['updated_at'];
    isSolved = json['is_solved'];
  }

  num? id;
  String? studentID;
  String? subject;
  String? complain;
  String? reply;
  String? createAt;
  String? updatedAt;
  num? isSolved;
}
