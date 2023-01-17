class Surah
{
  int id,surahOrder;
  String name;

  Surah.fromJson(Map<String, dynamic> json):
    id = json['id'] ?? 0,
    name = json['name'] ?? '',
    surahOrder =json['surah_order'] ?? 0;
}