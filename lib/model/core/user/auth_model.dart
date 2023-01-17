class TeacherModel {
  int? id;
  String name, gender, phone, address;

  TeacherModel(
      {this.id,
      required this.name,
      required this.gender,
      required this.phone,
      required this.address});

  TeacherModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        gender = json['gender'],
        phone = json['phone'],
        address = json['address'];

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "gender": gender,
        "phone": phone,
        "address": address,
      };
}
