class TeacherModel {
  int? id;
  String login, name, password, gender, mobile, country;
  int countryID;

  TeacherModel(
      {this.id,
      required this.login,
      required this.name,
      required this.password,
      required this.gender,
      required this.mobile,
      required this.country,
      required this.countryID});

  TeacherModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        login = json['login'],
        password = json['password'],
        gender = json['gender'],
        mobile = json['mobile'],
        country = json['country'],
        countryID = json['country_id'];

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "login": login,
        "password": password,
        "gender": gender,
        "mobile": mobile,
        "country": country,
        "country_id": countryID,
      };
}
