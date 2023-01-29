class Surah
{
  int id,surahOrder;
  String name;

  Surah.fromJson(Map<String, dynamic> json):
    id = int.parse(json['id']) ,
    name = json['name'] ?? '',
    surahOrder =json['order'] ?? 0;
}