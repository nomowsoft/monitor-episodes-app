class Verse
{
  int id,originalSurahOrder,pageNo,surahId,startLineAya,endLineAya;
  String verse;

  Verse.fromJson(Map<String, dynamic> json):
    id = json['id'] ?? 0,
    verse = json['verse'] ?? '',
    originalSurahOrder = json['original_surah_order'] ?? 0,
    pageNo =json['page_no'] ?? 0,
    startLineAya = json['start_line_aya'] ?? 0,
    endLineAya = json['end_line_aya'] ?? 0,
    surahId =json['surah_id'] ?? 0;

  Verse.fromJsonV1(Map<String, dynamic> json,int newStartLineAya,newEndLineAya):
    id = json['id'] ?? 0,
    verse = json['verse'] ?? '',
    originalSurahOrder = json['original_surah_order'] ?? 0,
    pageNo =json['page_no'] ?? 0,
    startLineAya = newStartLineAya,
    endLineAya = newEndLineAya ,
    surahId =json['surah_id'] ?? 0;

   Map<String, dynamic> toJson() => {
        "id": id,
        "verse": verse,
        "original_surah_order": originalSurahOrder,
        "page_no": pageNo,
        "start_line_aya": startLineAya,
        "end_line_aya": endLineAya,
        "surah_id": surahId,
      };
}