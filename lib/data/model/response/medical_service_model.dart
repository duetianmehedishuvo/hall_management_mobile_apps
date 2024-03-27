class MedicalServiceModel {
  MedicalServiceModel({
    this.id,
    this.studentId,
    this.serviceType,
    this.providerName,
    this.name,
    this.department,
  });

  MedicalServiceModel.fromJson(dynamic json) {
    id = json['id'];
    studentId = json['student_id'];
    serviceType = json['service_type'];
    providerName = json['provider_name'];
    name = json['name'];
    department = json['department'];
  }

  num? id;
  num? studentId;
  String? serviceType;
  String? providerName;
  String? name;
  String? department;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['student_id'] = studentId;
    map['service_type'] = serviceType;
    map['provider_name'] = providerName;
    map['name'] = name;
    map['department'] = department;
    return map;
  }
}
