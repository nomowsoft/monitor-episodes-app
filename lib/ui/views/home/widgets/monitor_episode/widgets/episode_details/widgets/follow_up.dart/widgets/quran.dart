import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monitor_episodes/model/core/plan_lines/plan_line.dart';
import 'package:monitor_episodes/model/core/quran/verse.dart';
import 'package:monitor_episodes/model/core/shared/constants.dart';
import 'package:monitor_episodes/model/core/shared/globals/size_config.dart';
import 'package:monitor_episodes/model/services/quran_service.dart';

class Quran extends StatefulWidget {
  final PlanLine planLine;
  const Quran({Key? key, required this.planLine}) : super(key: key);

  @override
  State<Quran> createState() => _QuranState();
}

class _QuranState extends State<Quran> {
  Map<int, List<Verse>> verses = {};
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
     List<Verse>? listVerses ;
    if (Constants.listSurah
            .firstWhere(
                (element) => element.name == widget.planLine.fromSuraName)
            .surahOrder <=
        Constants.listSurah
            .firstWhere((element) => element.name == widget.planLine.toSuraName)
            .surahOrder) {
      listVerses = QuranService().getVerses(
      fromSurah: widget.planLine.fromSuraName,
      fromAya: widget.planLine.fromAya,
      toSurah: widget.planLine.toSuraName,
      toAya: widget.planLine.toAya,
    );
    } else {
        listVerses = QuranService().getVerses(
      fromSurah: widget.planLine.toSuraName,
      fromAya: widget.planLine.toAya,
      toSurah: widget.planLine.fromSuraName,
      toAya: widget.planLine.fromAya,
    );
    }
    
    setState(() {
      verses = listVerses!.groupBy((p) => p.surahId);
    });

  //  int firstPageNo = verses.entries.first.value.first.pageNo;
  //  int lastPageNo = verses.entries.last.value.last.pageNo;
  //   print('this count pages is :  ${lastPageNo - firstPageNo}');
    // for(var surah in verses.entries){
    //     for(var ayat in surah.value){

    //     }
    // }
    // versesTextSpan = QuranService().getVersesSurah(listVerses);
    // versesTextSpan = QuranService().getVersesTextSpan(listVerses);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.theme.primaryColor,
        title: Text(
          'quran'.tr,
          style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.w800),
          textScaleFactor: SizeConfig.textScaleFactor,
        ),
        titleSpacing: 2,
        centerTitle: true,
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        SizeConfig('initialSize').init(originalWidth: 428, originalHeight: 926);
        return SafeArea(
            child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: .5,
                child: Image.asset(
                  'images/bgR2.png',
                  repeat: ImageRepeat.repeat,
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                margin: EdgeInsets.all(5.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Get.theme.primaryColor.withOpacity(0.5),
                    width: 5.w,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: ListView.separated(
                    itemBuilder: (_, index) => Column(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 6.h, horizontal: 10.w),
                              padding: EdgeInsets.symmetric(
                                  vertical: 6.h, horizontal: 10.w),
                              decoration: BoxDecoration(
                                color: Get.theme.secondaryHeaderColor
                                    .withOpacity(0.4),
                                //  shape: BoxShape.circle,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '  ﴿ ${QuranService().getSurahNane((verses[verses.keys.toList()[index]] ?? []).first.surahId)} ﴾  ',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              color: Colors.white,
                                              fontSize: 22.sp),
                                          textScaleFactor:
                                              SizeConfig.textScaleFactor,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              color: Colors.white,
                                              fontSize: 20.sp),
                                          textScaleFactor:
                                              SizeConfig.textScaleFactor,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            RichText(
                              softWrap: true,
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    height: 1.5,
                                    fontSize: 24.sp),
                                children: QuranService().getVersesTextSpan(
                                    verses[verses.keys.toList()[index]] ?? []),
                              ),
                              textScaleFactor: SizeConfig.textScaleFactor,
                            ),
                          ],
                        ),
                    separatorBuilder: (_, __) => SizedBox(
                          height: 10.h,
                        ),
                    itemCount: verses.length),
              ),
            ),
          ],
        ));
      }),
    );
  }
}

// extension Iterables<E> on Iterable<E> {
//   Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(
//       <K, List<E>>{},
//       (Map<K, List<E>> map, E element) =>
//           map..putIfAbsent(keyFunction(element), () => <E>[]).add(element));
// }
