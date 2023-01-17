import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monitor_episodes/model/core/shared/constants.dart';
import 'package:monitor_episodes/model/core/shared/globals/size_config.dart';
class SelectAya extends StatefulWidget {
  final int surahId ;
  const SelectAya({Key? key,required this.surahId}) : super(key: key);

  @override
  State<SelectAya> createState() => _SelectAyaState();
}

class _SelectAyaState extends State<SelectAya> {
  late List<int> listAya;
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    listAya = Constants.listVerse.where((element) => element.surahId == widget.surahId).map((e) => e.originalSurahOrder).toList();
  }

  @override
  Widget build(BuildContext context) {
    return 
    SingleChildScrollView(
      child: Column(children: [
       ...listAya.map((e) => ListTile(
        onTap: (() {
          Get.back(result: e);
        }),
               contentPadding: EdgeInsets.all(1.w) ,
               title: Text(
          e.toString(),
         style: TextStyle(
           fontSize: 16.sp,
           fontWeight: FontWeight.bold,
           color: Colors.black,
         ),
         maxLines: 1,
         textAlign: TextAlign.center,
         overflow: TextOverflow.ellipsis,
         textScaleFactor: SizeConfig.textScaleFactor,
       ),
       ))
      ],),
    )
        ;
  }
 
}
