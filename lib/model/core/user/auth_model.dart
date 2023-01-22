class TeacherModel {
  int? id;
  String name,password, gender, mobile, country;

  TeacherModel(
      {this.id,
      required this.name,
      required this.password,
      required this.gender,
      required this.mobile,
      required this.country});

  TeacherModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        password =json['password'],
        gender = json['gender'],
        mobile = json['mobile'],
        country = json['country_id'];

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "password":password,
        "gender": gender,
        "mobile": mobile,
        "country": country,
      };
}
