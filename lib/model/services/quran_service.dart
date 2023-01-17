import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monitor_episodes/model/core/listen_line/listen_line.dart';
import 'package:monitor_episodes/model/core/quran/verse.dart';
import 'package:monitor_episodes/model/core/shared/constants.dart';
import 'package:monitor_episodes/model/core/shared/globals/size_config.dart';
import '../core/quran/surah.dart';

class QuranService {
  getVerses(
      {required String fromSurah,
      required int fromAya,
      required String toSurah,
      required int toAya}) {
    try {
      int indexFromSurah = Constants.listSurah
          .indexWhere((element) => element.name == fromSurah);
      int indexToSurah =
          Constants.listSurah.indexWhere((element) => element.name == toSurah);
      List<Surah> listSurah = Constants.listSurah
          .skip(indexFromSurah)
          .take((indexToSurah + 1) - (indexFromSurah))
          .toList();
      List<Verse> listVerses = Constants.listVerse
          .where((element) =>
              listSurah.map((e) => e.id).toList().contains(element.surahId))
          .toList();
      listVerses.sort((a, b) {
        var compare = a.surahId.compareTo(b.surahId);
        if (compare == 0) {
          return a.originalSurahOrder.compareTo(b.originalSurahOrder);
        } else {
          return compare;
        }
      });
      int indexFromAya = listVerses
          .indexWhere((element) => element.originalSurahOrder == fromAya);
      int indexToAya = listVerses.indexWhere((element) =>
          element.surahId == listVerses.last.surahId &&
          element.originalSurahOrder == toAya);
      return listVerses
          .skip(indexFromAya)
          .take((indexToAya + 1) - indexFromAya)
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  String getSurahNane(int surahId) {
    try {
      return Constants.listSurah
          .firstWhere((element) => element.id == surahId)
          .name;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return '';
    }
  }

  List<TextSpan> getVersesTextSpan(List<Verse> dataVerses) {
    List<TextSpan> verses = [];

    for (var element in dataVerses) {
      if (element.id != 0) {
        verses.add(TextSpan(
          text: element.verse
              .replaceAll('بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ', ''),
          style: TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.black,
            //fontFamily: 'UthmanicDoori',
            fontSize: 24.sp,
          ),
        ));
        verses.add(TextSpan(
          text: ' ﴿ ${element.originalSurahOrder} ﴾ ',
          style: TextStyle(
            fontWeight: FontWeight.normal,
            color: Get.theme.primaryColor,
            //fontFamily: 'UthmanicDoori',
            fontSize: 20.sp,
          ),
        ));
      }
    }
    return verses;
  }

  int sumPages(List<ListenLine> listenList) {
    int sumLines = 0 ;
    for (ListenLine listenLine in listenList) {
      Map<int, List<Verse>> verses = {};
      List<Verse>? listVerses;
      if (Constants.listSurah
              .firstWhere((element) => element.id == listenLine.fromSuraId)
              .surahOrder <=
          Constants.listSurah
              .firstWhere((element) => element.id == listenLine.toSuraId)
              .surahOrder) {
        listVerses = QuranService().getVerses(
          fromSurah: Constants.listSurah
              .firstWhere((element) => element.id == listenLine.fromSuraId)
              .name,
          fromAya: listenLine.fromAya,
          toSurah: Constants.listSurah
              .firstWhere((element) => element.id == listenLine.toSuraId)
              .name,
          toAya: listenLine.toAya,
        );
      } else {
        listVerses = QuranService().getVerses(
          fromSurah: Constants.listSurah
              .firstWhere((element) => element.id == listenLine.toSuraId)
              .name,
          fromAya: listenLine.toAya,
          toSurah: Constants.listSurah
              .firstWhere((element) => element.id == listenLine.fromSuraId)
              .name,
          toAya: listenLine.fromAya,
        );
      }

      verses = listVerses!.groupBy((p) => p.surahId);

      int startLineAya = verses.entries.first.value.first.startLineAya;
      int endLineAya = verses.entries.last.value.last.endLineAya;
      if(endLineAya >= startLineAya){
        sumLines = sumLines + ((endLineAya - startLineAya) + 1);
      }else{
        sumLines = sumLines + ((startLineAya - endLineAya) + 1);
      }
    }

    if (kDebugMode) {
      print('this count Lines is :  $sumLines');
      print('this count pages is :  ${sumLines / 15 }');
    }
    
    return (sumLines ~/15) ;
  }
}

extension Iterables<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(
      <K, List<E>>{},
      (Map<K, List<E>> map, E element) =>
          map..putIfAbsent(keyFunction(element), () => <E>[]).add(element));
}
