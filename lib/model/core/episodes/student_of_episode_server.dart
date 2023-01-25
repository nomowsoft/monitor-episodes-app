// ignore_for_file: public_member_api_docs, sort_constructors_first
class StudentOfEpisodeSever {
  String name, id, halaqaId, mobile, gender;
  int countryId;
  int? idMobile;
  bool? isHifz, isTilawa, isSmallReview, isBigReview;
  StudentOfEpisodeSever({
    required this.id,
    required this.name,
    required this.gender,
    required this.mobile,
    required this.halaqaId,
    required this.countryId,
    this.isHifz,
    this.isTilawa,
    this.isSmallReview,
    this.isBigReview,
  });

  StudentOfEpisodeSever.fromJson(Map<String, dynamic> json)
      : name = json['name'].runtimeType == bool ? '' : json['name'] ?? '',
        id = json['id'].toString(),
        idMobile = json['id_mobile'],
        gender = json['gender'].runtimeType == bool ? '' : json['gender'] ?? '',
        isHifz = json['is_hifz'],
        isTilawa = json['is_tilawa'],
        isBigReview = json['is_big_review'],
        isSmallReview = json['is_small_review'],
        halaqaId = '',
        mobile = '',
        countryId = 0;
}
