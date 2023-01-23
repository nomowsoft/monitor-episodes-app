class Country {
  String id;
  late String code, name;
  Country({required this.code, required this.name, required this.id});
  Country.fromJson(Map<String, dynamic> map)
      : id = map['id'],
        code = map['code'],
        name = map['name'];
}
