class VerseV1
{
  int originalSurahOrder,startLineAya,endLineAya;
  String verse;

  VerseV1.fromJson(Map<String, dynamic> json):
    verse = json['verse'] ?? '',
    originalSurahOrder = json['original_surah_order'] ?? 0,
    startLineAya = json['start_line_aya'] ?? 0,
    endLineAya = json['end_line_aya'] ?? 0;
}