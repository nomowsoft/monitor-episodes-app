import 'package:monitor_episodes/model/core/countries/countries.dart';
import 'package:monitor_episodes/model/core/countries/country.dart';
import 'package:monitor_episodes/model/core/quran/surah.dart';
import 'package:monitor_episodes/model/core/quran/verse.dart';
import 'package:monitor_episodes/model/core/quran/verse_v1.dart';
import 'package:monitor_episodes/model/offline_quran/surahs.dart';
import 'package:monitor_episodes/model/offline_quran/verses.dart';
import 'package:monitor_episodes/model/offline_quran/verses_v1.dart';

class Constants {
static late List<Surah> listSurah;
static late List<Verse> listVerse;
static late List<Country> listCountries;
getConstants(){
  listSurah = surahs.map((e) => Surah.fromJson(e)).toList(); 
  List<VerseV1> list = versesV1.map((e) => VerseV1.fromJson(e)).toList(); 
  listVerse = verses.map((e) => Verse.fromJsonV1(e,list.where((element) => element.verse == e['verse'] && element.originalSurahOrder == e['original_surah_order']).first.startLineAya ,list.where((element) => element.verse == e['verse'] && element.originalSurahOrder == e['original_surah_order']).first.endLineAya)).toList(); 
  listCountries = countries.map((e) => Country.fromJson(e)).toList();
}
}


