class Country {
 late String code,name,dialCode; 
 Country({required this.code,required this.name,required this.dialCode});
 Country.fromJson(Map<String,dynamic> map):
   code = map['code'],
   name = map['name'],
   dialCode = map['dialCode'];

}