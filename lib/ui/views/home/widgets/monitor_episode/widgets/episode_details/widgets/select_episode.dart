import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monitor_episodes/model/core/episodes/episode.dart';
import 'package:monitor_episodes/model/core/shared/globals/size_config.dart';

class SelectEpisode extends StatefulWidget {
  final String? readOnlyEpisode;
  final List<Episode> listEpisode;
  const SelectEpisode({Key? key, this.readOnlyEpisode, required this.listEpisode}) : super(key: key);

  @override
  State<SelectEpisode> createState() => _SelectEpisodeState();
}

class _SelectEpisodeState extends State<SelectEpisode> {
  late List<Episode> listEpisode;
  String searchText = '';

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    searchText = '';
    listEpisode = List.from(widget.listEpisode);
    super.initState();
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    searchText = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mqDataNew = Get.mediaQuery.copyWith(textScaleFactor: SizeConfig.textScaleFactor );
    return Column(
      children: [
        MediaQuery(
          data: mqDataNew,
          child: TextField(
            autofocus: true,
            onChanged: (val) {
              setState(() {
                searchText = val.toLowerCase().trim();
              });
            },
            style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                height: 1.4),
            textAlign: TextAlign.start,
            cursorColor: Colors.white,
            decoration: InputDecoration(
              hintText: 'search_here'.tr,
              hintStyle: const TextStyle(color: Colors.black),
              contentPadding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
            ),
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        Expanded(
            child: listEpisodeForShow.isNotEmpty
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        ...listEpisodeForShow.map((e) => InkWell(
                              onTap: (() {
                                Get.back(result: e);
                              }),
                              child: Column(
                                children: [
                                  Text(
                                    e.name.toString(),
                                    style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        height: 1.4),
                                    textAlign: TextAlign.center,
                                    textScaleFactor: SizeConfig.textScaleFactor,
                                  ),
                                  Divider(
                                    color: Colors.black,
                                    height: 10.h,
                                  )
                                ],
                              ),
                            ))
                      ],
                    ),
                  )
                : Center(
                    child: Text(
                      'there_are_no'.tr,
                      style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          height: 1.4),
                      textAlign: TextAlign.center,
                      textScaleFactor: SizeConfig.textScaleFactor,
                    ),
                  )),
      ],
    );
  }

  List<Episode> get listEpisodeForShow {
    return listEpisode
        .where((element) => (searchText.isNotEmpty)
            ? (element.name.toLowerCase().contains(searchText))
            : true)
        .toList();
  }
}
