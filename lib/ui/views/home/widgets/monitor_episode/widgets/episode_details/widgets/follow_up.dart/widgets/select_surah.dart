import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monitor_episodes/model/core/quran/surah.dart';
import 'package:monitor_episodes/model/core/shared/constants.dart';
import 'package:monitor_episodes/model/core/shared/globals/size_config.dart';
class SelectSurah extends StatefulWidget {
  final String? readOnlySurah ;
  const SelectSurah({Key? key, this.readOnlySurah}) : super(key: key);

  @override
  State<SelectSurah> createState() => _SelectSurahState();
}

class _SelectSurahState extends State<SelectSurah> {
  late List<Surah> listSura;
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    listSura = Constants.listSurah;
  }

  @override
  Widget build(BuildContext context) {
    return 
    SingleChildScrollView(
      child: Column(children: [
       ...listSura.map((e) => InkWell(
                onTap: (() {
                  Get.back(result: e);
                }),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                              e.surahOrder.toString() ,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                height: 1.4
                              ),
                              textAlign: TextAlign.center,
                              textScaleFactor: SizeConfig.textScaleFactor,
                            ),
                            SizedBox(width: 10.w,),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              e.name ,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                height: 1.4
                              ),
                              textAlign: TextAlign.start,
                              textScaleFactor: SizeConfig.textScaleFactor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.black,
                      height: 10.h,
                    )
                  ],
                ),
              ))
      ],),
    )
        ;
  }
 
}
