import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monitor_episodes/controller/home_controller.dart';
import 'package:monitor_episodes/model/core/episodes/episode.dart';
import 'package:monitor_episodes/model/services/episodes_service.dart';
import 'package:monitor_episodes/ui/shared/utils/validator.dart';

import '../../../../../../model/core/shared/globals/size_config.dart';

class AddEpisode extends StatefulWidget {
  final Episode? episode;
  const AddEpisode({super.key, this.episode});

  @override
  State<AddEpisode> createState() => _AddEpisodeState();
}

class _AddEpisodeState extends State<AddEpisode> {
  TextEditingController name = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool get isEdit => widget.episode != null;
  List<String> typeEpisodes = [
    'learn',
    'learn_review',
    'correction',
    'master',
    'community',
    'excellence',
    'review'
  ];
  String episodeType = '';
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    if (isEdit) {
      name.text = widget.episode!.name;
      episodeType = widget.episode!.epsdType;
    } else {
      episodeType = typeEpisodes[0];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      builder: (HomeController homeController) => Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  side: BorderSide(color: Colors.white)),
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(children: [
                  Text(
                    isEdit ? 'edit_episode'.tr : 'add_episode'.tr,
                    style: TextStyle(
                        color: Get.theme.primaryColor,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800),
                    textScaleFactor: SizeConfig.textScaleFactor,
                  ),
                  SizedBox(
                    height: 30.h,
                  ),

                  /// name
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'name'.tr,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500),
                        textScaleFactor: SizeConfig.textScaleFactor,
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.name,
                        keyboardAppearance: Brightness.light,
                        validator: Validator.nameValidator,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: name,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'enter_name'.tr,
                        ),
                        onChanged: (val) {},
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),

                  /// episode_type
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: PopupMenuButton<String>(
                            padding: EdgeInsets.zero,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'episode_type'.tr,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500),
                                  textScaleFactor: SizeConfig.textScaleFactor,
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        //width: 150.w,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10.h, horizontal: 10.w),
                                        decoration: BoxDecoration(
                                          color: Get.theme.secondaryHeaderColor
                                              .withOpacity(0.8),
                                          //  shape: BoxShape.circle,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                episodeType.tr,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14.sp,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                maxLines: 1,
                                                textScaleFactor:
                                                    SizeConfig.textScaleFactor,
                                              ),
                                            ),
                                            Icon(
                                              Icons.keyboard_arrow_down,
                                              size: 25.sp,
                                              color: Colors.white,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            itemBuilder: (context) => [
                              ...typeEpisodes.map(
                                (e) => PopupMenuItem(
                                  padding: EdgeInsets.zero,
                                  value: e,
                                  height: 50.h,
                                  child: Column(
                                    children: [
                                      Center(
                                        child: Text(
                                          e.tr,
                                          style: const TextStyle(
                                              decoration: TextDecoration.none,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500),
                                          textScaleFactor:
                                              SizeConfig.textScaleFactor,
                                        ),
                                      ),
                                      // Divider(height: 20.h,thickness: 1.5,)
                                    ],
                                  ),
                                ),
                              )
                            ],
                            onSelected: (String value) async {
                              setEpisodeType = value;
                            },
                          ),
                        ),
                      ]),

                  SizedBox(
                    height: 20.h,
                  ),
                  InkWell(
                    onTap: (() async {
                      if (formKey.currentState?.validate() ?? false) {
                        Episode episode;
                        bool result;
                        if (isEdit) {
                          episode = Episode(
                              displayName: name.text,
                              id: widget.episode!.id,
                              name: name.text,
                              epsdType: episodeType);
                          result = await homeController.editEdisode(episode);
                        } else {
                          // int count =
                          //     await EdisodesService().getCountEdisodesLocal();
                          episode = Episode(
                              displayName: name.text,
                              name: name.text,
                              epsdType: episodeType);
                          result = await homeController.addEdisode(episode);
                        }
                        Get.back(result: result);
                      }
                    }),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Get.theme.secondaryHeaderColor.withOpacity(.7),
                            Get.theme.secondaryHeaderColor,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(5, 5),
                            blurRadius: 10,
                          )
                        ],
                      ),
                      child: Center(
                        child: Text(
                          isEdit ? 'save_changed'.tr : 'add'.tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          textScaleFactor: SizeConfig.textScaleFactor,
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  set setEpisodeType(String type) {
    setState(() {
      episodeType = type;
    });
  }
}
