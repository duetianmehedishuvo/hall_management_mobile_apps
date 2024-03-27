class MedicalServiceDetailsModel {
  MedicalServiceDetailsModel({
    this.id,
    this.studentId,
    this.serviceType,
    this.providerName,
    this.details,
    this.createdAt,
    this.docuemntUrl,
    this.name,
    this.department,
  });

  MedicalServiceDetailsModel.fromJson(dynamic json) {
    id = json['id'];
    studentId = json['student_id'];
    serviceType = json['service_type'];
    providerName = json['provider_name'];
    details = json['details'];
    createdAt = json['created_at'];
    docuemntUrl = json['docuemnt_url'];
    name = json['name'];
    department = json['department'];
  }

  num? id;
  num? studentId;
  String? serviceType;
  String? providerName;
  String? details;
  String? createdAt;
  String? docuemntUrl;
  String? name;
  String? department;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['student_id'] = studentId;
    map['service_type'] = serviceType;
    map['provider_name'] = providerName;
    map['details'] = details;
    map['created_at'] = createdAt;
    map['docuemnt_url'] = docuemntUrl;
    map['name'] = name;
    map['department'] = department;
    return map;
  }
}
