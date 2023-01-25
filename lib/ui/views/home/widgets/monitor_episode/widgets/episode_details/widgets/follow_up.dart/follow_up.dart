import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:monitor_episodes/controller/home_controller.dart';
import 'package:monitor_episodes/model/core/episodes/episode.dart';
import 'package:monitor_episodes/model/core/quran/surah.dart';
import 'package:monitor_episodes/model/core/shared/constants.dart';
import 'package:monitor_episodes/model/core/shared/globals/size_config.dart';
import 'package:monitor_episodes/model/core/shared/status_and_types.dart';
import 'package:monitor_episodes/ui/shared/utils/custom_dailogs.dart';
import 'package:monitor_episodes/ui/shared/utils/waitting_dialog.dart';
import 'package:monitor_episodes/ui/shared/widgets/color_loader/color_loader.dart';
import '../../../../../../../../../model/core/shared/response_content.dart';
import 'widgets/add_note.dart';
import 'widgets/quran.dart';
import 'widgets/select_aya.dart';
import 'widgets/select_surah.dart';

class FollowUp extends StatefulWidget {
  final Episode episode;
  final int id;
  final int planId;
  const FollowUp(
      {Key? key,
      required this.episode,
      required this.planId,
      required this.id})
      : super(key: key);

  @override
  State<FollowUp> createState() => _FollowUpState();
}

class _FollowUpState extends State<FollowUp> {
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    HomeController homeController = Get.find<HomeController>();
    if (homeController.planLines == null) {
      homeController.loadPlanLines(
          widget.episode.id!, widget.id,
          isInit: true); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      SizeConfig('initialSize').init(originalWidth: 428, originalHeight: 926);
      return GetBuilder(
        builder: (HomeController homeController) =>
            homeController.gettingPlanLines
                ? const Center(
                    child: ColorLoader(),
                  )
                : SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            homeController.planLines?.listen != null
                                ? listen()
                                : const SizedBox(),
                            homeController.planLines?.reviewsmall != null
                                ? reviewsmall()
                                : const SizedBox(),
                            homeController.planLines?.reviewbig != null
                                ? reviewbig()
                                : const SizedBox(),
                            homeController.planLines?.tlawa != null
                                ? tlawa()
                                : const SizedBox(),
                          ],
                        ),
                      ),
      );
    });
  }

  Card listen() {
    HomeController homeController = Get.find<HomeController>();
    return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: const BorderSide(width: 2, color: Colors.white)),
        margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 8.h, bottom: 8.h),
        color: Colors.white,
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 12.w,
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'listen'.tr,
                                      style: TextStyle(
                                          color: Get.theme.primaryColor,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w800),
                                      textScaleFactor:
                                          SizeConfig.textScaleFactor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            homeController.planLines?.listen != null
                                ? InkWell(
                                    onTap: () {
                                      if (homeController.planLines?.listen
                                              ?.toSuraName.isNotEmpty ??
                                          false) {
                                        Get.to(() => Quran(
                                              planLine: homeController
                                                  .planLines!.listen!,
                                            ));
                                      } else {
                                        CostomDailogs.warringDialogWithGet(
                                            msg:
                                                'complete_the_selection_of_the_course_first_to_display_it_in_the_quran'
                                                    .tr);
                                      }
                                    },
                                    child: Column(
                                      children: [
                                        SvgPicture.asset(
                                          'images/quran.svg',
                                          height: 30.h,
                                          color: Get.theme.primaryColor,
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        Text(
                                          'quran'.tr,
                                          style: TextStyle(
                                              color: Get
                                                  .theme.secondaryHeaderColor,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w500),
                                          textScaleFactor:
                                              SizeConfig.textScaleFactor,
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox(),
                            SizedBox(
                              width: 12.w,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        homeController.planLines?.listen != null
                            ? Container(
                                margin: EdgeInsets.symmetric(horizontal: 12.w),
                                padding: EdgeInsets.symmetric(
                                    vertical: 6.h, horizontal: 10.w),
                                decoration: BoxDecoration(
                                  color: Get.theme.secondaryHeaderColor
                                      .withOpacity(0.6),
                                  //  shape: BoxShape.circle,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'course'.tr,
                                      style: TextStyle(
                                          color: Get.theme.primaryColor,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w800),
                                      textScaleFactor:
                                          SizeConfig.textScaleFactor,
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    '${'from_sura'.tr} : ',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    textScaleFactor: SizeConfig
                                                        .textScaleFactor,
                                                  ),
                                                  SizedBox(
                                                    width: 2.w,
                                                  ),
                                                  Expanded(
                                                    child: InkWell(
                                                      onTap: () async {
                                                        Surah? sura =
                                                            await showDialog(
                                                          context: context,
                                                          builder: (contextDialog) => AlertDialog(
                                                              shape: const RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              15.0))),
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                      .all(15),
                                                              content: SelectSurah(
                                                                  readOnlySurah:
                                                                      homeController
                                                                          .planLines
                                                                          ?.listen
                                                                          ?.fromSuraName)),
                                                        );
                                                        if (sura != null &&
                                                            homeController
                                                                    .planLines
                                                                    ?.listen
                                                                    ?.fromSuraName !=
                                                                sura.name) {
                                                          
                                                          // if (homeController
                                                          //         .planLines
                                                          //         ?.listen
                                                          //         ?.toSuraName
                                                          //         .isNotEmpty ??
                                                          //     false) {
                                                          //   if (Constants
                                                          //       .listSurah
                                                          //       .any((element) =>
                                                          //           element
                                                          //               .name ==
                                                          //           homeController
                                                          //               .planLines
                                                          //               ?.listen
                                                          //               ?.toSuraName)) {
                                                          //     if (sura.surahOrder <=
                                                          //         Constants
                                                          //             .listSurah
                                                          //             .firstWhere((element) =>
                                                          //                 element
                                                          //                     .name ==
                                                          //                 homeController
                                                          //                     .planLines
                                                          //                     ?.listen
                                                          //                     ?.toSuraName)
                                                          //             .surahOrder) {
                                                          //       homeController
                                                          //           .changeFromSuraPlanLine(
                                                          //               sura,
                                                          //               PlanLinesType
                                                          //                   .listen);
                                                          //     } else {
                                                          //       CostomDailogs
                                                          //           .warringDialogWithGet(
                                                          //               msg: 'can_not_yong_surh'
                                                          //                   .tr);
                                                          //     }
                                                          //   }
                                                          // } else {
                                                            homeController
                                                                .changeFromSuraPlanLine(
                                                                    sura,
                                                                    PlanLinesType
                                                                        .listen);
                                                         // }
                                                        }
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 5.h,
                                                                horizontal:
                                                                    5.w),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white
                                                              .withOpacity(0.4),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                homeController
                                                                        .planLines
                                                                        ?.listen
                                                                        ?.fromSuraName ??
                                                                    '',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                                textScaleFactor:
                                                                    SizeConfig
                                                                        .textScaleFactor,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 1,
                                                              ),
                                                            ),
                                                            const Icon(Icons
                                                                .keyboard_arrow_down_outlined)
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    '${'to_sura'.tr} : ',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    textScaleFactor: SizeConfig
                                                        .textScaleFactor,
                                                  ),
                                                  SizedBox(
                                                    width: 2.w,
                                                  ),
                                                  Expanded(
                                                    child: InkWell(
                                                      onTap: () async {
                                                        Surah? sura =
                                                            await showDialog(
                                                          context: context,
                                                          builder: (contextDialog) => AlertDialog(
                                                             shape: const RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              15.0))),
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                      .all(15),
                                                              content: SelectSurah(
                                                                  readOnlySurah:
                                                                      homeController
                                                                          .planLines
                                                                          ?.listen
                                                                          ?.toSuraName)),
                                                        );
                                                        if (sura != null &&
                                                            homeController
                                                                    .planLines
                                                                    ?.listen
                                                                    ?.toSuraName !=
                                                                sura.name) {
                                                          // if (sura.surahOrder >=
                                                          //     Constants
                                                          //         .listSurah
                                                          //         .firstWhere((element) =>
                                                          //             element
                                                          //                 .name ==
                                                          //             homeController
                                                          //                 .planLines
                                                          //                 ?.listen
                                                          //                 ?.fromSuraName)
                                                          //         .surahOrder) {
                                                          //   homeController
                                                          //       .changeToSuraPlanLine(
                                                          //           sura,
                                                          //           PlanLinesType
                                                          //               .listen);
                                                          // } else {
                                                          //   CostomDailogs
                                                          //       .warringDialogWithGet(
                                                          //           msg: 'can_not_up_surh'
                                                          //               .tr);
                                                          // }
                                                          homeController
                                                                .changeToSuraPlanLine(
                                                                    sura,
                                                                    PlanLinesType
                                                                        .listen);
                                                        }
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 5.h,
                                                                horizontal:
                                                                    5.w),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white
                                                              .withOpacity(0.4),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                homeController
                                                                        .planLines
                                                                        ?.listen
                                                                        ?.toSuraName ??
                                                                    '',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                                textScaleFactor:
                                                                    SizeConfig
                                                                        .textScaleFactor,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 1,
                                                              ),
                                                            ),
                                                            const Icon(Icons
                                                                .keyboard_arrow_down_outlined)
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  '${'from_aya'.tr} : ',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  textScaleFactor: SizeConfig
                                                      .textScaleFactor,
                                                ),
                                                SizedBox(
                                                  width: 2.w,
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    if (Constants.listSurah.any(
                                                        (element) =>
                                                            element.name ==
                                                            homeController
                                                                .planLines
                                                                ?.listen
                                                                ?.fromSuraName)) {
                                                      int? aya =
                                                          await showDialog(
                                                        context: context,
                                                        builder: (contextDialog) => AlertDialog(
                                                           shape: const RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              15.0))),
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                      .all(15),
                                                            content: SelectAya(
                                                                surahId: Constants
                                                                    .listSurah
                                                                    .firstWhere((element) =>
                                                                        element
                                                                            .name ==
                                                                        homeController
                                                                            .planLines
                                                                            ?.listen
                                                                            ?.fromSuraName)
                                                                    .id)),
                                                      );
                                                      if (aya != null &&
                                                          homeController
                                                                  .planLines
                                                                  ?.listen
                                                                  ?.fromAya !=
                                                              aya ) {
                                                        if ((homeController
                                                                .planLines
                                                                ?.listen
                                                                ?.toSuraName
                                                                .isNotEmpty ??
                                                            false) && homeController
                                                                  .planLines
                                                                  ?.listen?.fromSuraName == homeController
                                                                  .planLines
                                                                  ?.listen?.toSuraName) {
                                                          if (homeController
                                                                      .planLines
                                                                      ?.listen
                                                                      ?.toAya !=
                                                                  null &&
                                                              aya >
                                                                  (homeController
                                                                      .planLines!
                                                                      .listen!
                                                                      .toAya)) {
                                                            CostomDailogs
                                                                .warringDialogWithGet(
                                                                    msg: 'can_not_bottom_aya'
                                                                        .tr);
                                                          } else {
                                                            homeController
                                                                .changeFromAyaPlanLine(
                                                                    aya,
                                                                    PlanLinesType
                                                                        .listen);
                                                          }
                                                        } else {
                                                          homeController
                                                              .changeFromAyaPlanLine(
                                                                  aya,
                                                                  PlanLinesType
                                                                      .listen);
                                                        }
                                                      }
                                                    }
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5.h,
                                                            horizontal: 10.w),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white
                                                          .withOpacity(0.4),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          homeController
                                                                  .planLines
                                                                  ?.listen
                                                                  ?.fromAya
                                                                  .toString() ??
                                                              '',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                          textScaleFactor:
                                                              SizeConfig
                                                                  .textScaleFactor,
                                                        ),
                                                        SizedBox(
                                                          width: 10.w,
                                                        ),
                                                        const Icon(Icons
                                                            .keyboard_arrow_down_outlined)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  '${'to_aya'.tr} : ',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  textScaleFactor: SizeConfig
                                                      .textScaleFactor,
                                                ),
                                                SizedBox(
                                                  width: 2.w,
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    if (Constants.listSurah.any(
                                                        (element) =>
                                                            element.name ==
                                                            homeController
                                                                .planLines
                                                                ?.listen
                                                                ?.toSuraName)) {
                                                      int? aya =
                                                          await showDialog(
                                                        context: context,
                                                        builder: (contextDialog) => AlertDialog(
                                                           shape: const RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              15.0))),
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                      .all(15),
                                                            content: SelectAya(
                                                                surahId: Constants
                                                                    .listSurah
                                                                    .firstWhere((element) =>
                                                                        element
                                                                            .name ==
                                                                        homeController
                                                                            .planLines
                                                                            ?.listen
                                                                            ?.toSuraName)
                                                                    .id)),
                                                      );
                                                      if (aya != null &&
                                                          homeController
                                                                  .planLines
                                                                  ?.listen
                                                                  ?.toAya !=
                                                              aya) {
                                                        if (homeController
                                                                    .planLines
                                                                    ?.listen
                                                                    ?.fromAya !=
                                                                null &&
                                                            aya <
                                                                (homeController
                                                                    .planLines!
                                                                    .listen!
                                                                    .fromAya) && homeController
                                                                  .planLines
                                                                  ?.listen?.fromSuraName == homeController
                                                                  .planLines
                                                                  ?.listen?.toSuraName) {
                                                          CostomDailogs
                                                              .warringDialogWithGet(
                                                                  msg:
                                                                      'can_not_up_aya'
                                                                          .tr);
                                                        } else {
                                                          homeController
                                                              .changeToAyaPlanLine(
                                                                  aya,
                                                                  PlanLinesType
                                                                      .listen);
                                                        }
                                                      }
                                                    }
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5.h,
                                                            horizontal: 10.w),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white
                                                          .withOpacity(0.4),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          homeController
                                                                      .planLines
                                                                      ?.listen
                                                                      ?.toAya !=
                                                                  0
                                                              ? homeController
                                                                      .planLines
                                                                      ?.listen
                                                                      ?.toAya
                                                                      .toString() ??
                                                                  ''
                                                              : '',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                          textScaleFactor:
                                                              SizeConfig
                                                                  .textScaleFactor,
                                                        ),
                                                        SizedBox(
                                                          width: 10.w,
                                                        ),
                                                        const Icon(Icons
                                                            .keyboard_arrow_down_outlined)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                margin: EdgeInsets.symmetric(horizontal: 12.w),
                                padding: EdgeInsets.symmetric(
                                    vertical: 6.h, horizontal: 10.w),
                                decoration: BoxDecoration(
                                  color: Get.theme.secondaryHeaderColor
                                      .withOpacity(0.6),
                                  //  shape: BoxShape.circle,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'course'.tr,
                                      style: TextStyle(
                                          color: Get.theme.primaryColor,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w800),
                                      textScaleFactor:
                                          SizeConfig.textScaleFactor,
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: (() async {}),
                                          child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.w,
                                                  vertical: 5.h),
                                              decoration: BoxDecoration(
                                                color: Colors.white
                                                    .withOpacity(0.5),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons.add,
                                                    color: Colors.black,
                                                    size: 25,
                                                  ),
                                                  SizedBox(
                                                    width: 5.w,
                                                  ),
                                                  Text(
                                                    'add'.tr,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    textScaleFactor: SizeConfig
                                                        .textScaleFactor,
                                                  ),
                                                ],
                                              )),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                        SizedBox(
                          height: (homeController.planLines?.listen?.toSuraName
                                      .isNotEmpty ??
                                  false)
                              ? 5.h
                              : 0,
                        ),
                        homeController.planLines?.listen != null &&
                                (homeController.planLines?.listen?.toSuraName
                                        .isNotEmpty ??
                                    false)
                            ? homeController.planLines?.listen?.mistakes != null
                                ? Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 12.w),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 6.h, horizontal: 10.w),
                                    decoration: BoxDecoration(
                                      color: Get.theme.secondaryHeaderColor
                                          .withOpacity(0.6),
                                      //  shape: BoxShape.circle,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Notes'.tr,
                                          style: TextStyle(
                                              color: Get.theme.primaryColor,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w800),
                                          textScaleFactor:
                                              SizeConfig.textScaleFactor,
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'save_errors'.tr,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    textScaleFactor: SizeConfig
                                                        .textScaleFactor,
                                                  ),
                                                  SizedBox(
                                                    height: 5.h,
                                                  ),
                                                  Text(
                                                    homeController
                                                            .planLines
                                                            ?.listen
                                                            ?.mistakes
                                                            ?.totalMstkQty
                                                            .toString() ??
                                                        '',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    textScaleFactor: SizeConfig
                                                        .textScaleFactor,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5.w,
                                            ),
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'intonation_errors'.tr,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    textScaleFactor: SizeConfig
                                                        .textScaleFactor,
                                                  ),
                                                  SizedBox(
                                                    height: 5.h,
                                                  ),
                                                  Text(
                                                    homeController
                                                            .planLines
                                                            ?.listen
                                                            ?.mistakes
                                                            ?.totalMstkRead
                                                            .toString() ??
                                                        '',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    textScaleFactor: SizeConfig
                                                        .textScaleFactor,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 12.w),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 6.h, horizontal: 10.w),
                                    decoration: BoxDecoration(
                                      color: Get.theme.secondaryHeaderColor
                                          .withOpacity(0.6),
                                      //  shape: BoxShape.circle,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Notes'.tr,
                                          style: TextStyle(
                                              color: Get.theme.primaryColor,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w800),
                                          textScaleFactor:
                                              SizeConfig.textScaleFactor,
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: (() async {
                                                 await showDialog(
                                                  context: context,
                                                  builder: (contextDialog) =>
                                                      AddNote(
                                                          planLine:
                                                              PlanLinesType
                                                                  .listen),
                                                );
                                              }),
                                              child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10.w,
                                                      vertical: 5.h),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withOpacity(0.5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.add,
                                                        color: Colors.black,
                                                        size: 25,
                                                      ),
                                                      SizedBox(
                                                        width: 5.w,
                                                      ),
                                                      Text(
                                                        'add'.tr,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                        textScaleFactor:
                                                            SizeConfig
                                                                .textScaleFactor,
                                                      ),
                                                    ],
                                                  )),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                            : const SizedBox(),
                        SizedBox(
                          height: (homeController.planLines?.listen?.toSuraName
                                      .isNotEmpty ??
                                  false)
                              ? 5.h
                              : 0,
                        ),
                        (homeController
                                    .planLines?.listen?.toSuraName.isNotEmpty ??
                                false)
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        ResponseContent response =
                                            await showCupertinoDialog(
                                                context: context,
                                                builder: (BuildContext
                                                    dialogContext) {
                                                  addListenLine(
                                                      PlanLinesType.listen,
                                                      widget.id);
                                                  return WillPopScope(
                                                    // ignore: missing_return
                                                    onWillPop: () async {
                                                      return false;
                                                    },
                                                    child:
                                                        const CupertinoAlertDialog(
                                                      content: WaitingDialog(),
                                                    ),
                                                  );
                                                });
                                        if (response.isSuccess) {
                                          response.message =
                                              'ok_add_listen_line'.tr;
                                        } else if (!response
                                            .isErrorConnection) {
                                          response.message =
                                              'error_add_listen_line'.tr;
                                        }
                                      await CostomDailogs.snackBar(
                                            response: response);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 30.w, vertical: 10.h),
                                        margin: EdgeInsets.symmetric(
                                          horizontal: 10.w,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Get.theme.secondaryHeaderColor
                                                  .withOpacity(.5),
                                              Get.theme.secondaryHeaderColor,
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(6),
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
                                            'save'.tr,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textScaleFactor:
                                                SizeConfig.textScaleFactor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                      ]),
                ),
              ],
            )));
  }

  Card reviewsmall() {
    HomeController homeController = Get.find<HomeController>();
    return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: const BorderSide(width: 2, color: Colors.white)),
        margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 8.h, bottom: 8.h),
        color: Colors.white,
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 12.w,
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'reviewsmall'.tr,
                                      style: TextStyle(
                                          color: Get.theme.primaryColor,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w800),
                                      textScaleFactor:
                                          SizeConfig.textScaleFactor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            homeController.planLines?.reviewsmall != null
                                ? InkWell(
                                    onTap: () {
                                      if (homeController.planLines?.reviewsmall
                                              ?.toSuraName.isNotEmpty ??
                                          false) {
                                        Get.to(() => Quran(
                                              planLine: homeController
                                                  .planLines!.reviewsmall!,
                                            ));
                                      } else {
                                        CostomDailogs.warringDialogWithGet(
                                            msg:
                                                'complete_the_selection_of_the_course_first_to_display_it_in_the_quran'
                                                    .tr);
                                      }
                                    },
                                    child: Column(
                                      children: [
                                        SvgPicture.asset(
                                          'images/quran.svg',
                                          height: 30.h,
                                          color: Get.theme.primaryColor,
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        Text(
                                          'quran'.tr,
                                          style: TextStyle(
                                              color: Get
                                                  .theme.secondaryHeaderColor,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w500),
                                          textScaleFactor:
                                              SizeConfig.textScaleFactor,
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox(),
                            SizedBox(
                              width: 12.w,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        homeController.planLines?.reviewsmall != null
                            ? Container(
                                margin: EdgeInsets.symmetric(horizontal: 12.w),
                                padding: EdgeInsets.symmetric(
                                    vertical: 6.h, horizontal: 10.w),
                                decoration: BoxDecoration(
                                  color: Get.theme.secondaryHeaderColor
                                      .withOpacity(0.6),
                                  //  shape: BoxShape.circle,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'course'.tr,
                                      style: TextStyle(
                                          color: Get.theme.primaryColor,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w800),
                                      textScaleFactor:
                                          SizeConfig.textScaleFactor,
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    '${'from_sura'.tr} : ',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    textScaleFactor: SizeConfig
                                                        .textScaleFactor,
                                                  ),
                                                  SizedBox(
                                                    width: 2.w,
                                                  ),
                                                  Expanded(
                                                    child: InkWell(
                                                      onTap: () async {
                                                        Surah? sura =
                                                            await showDialog(
                                                          context: context,
                                                          builder: (contextDialog) => AlertDialog(
                                                             shape: const RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              15.0))),
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                      .all(15),
                                                              content: SelectSurah(
                                                                  readOnlySurah: homeController
                                                                      .planLines
                                                                      ?.reviewsmall
                                                                      ?.fromSuraName)),
                                                        );
                                                        if (sura != null &&
                                                            homeController
                                                                    .planLines
                                                                    ?.reviewsmall
                                                                    ?.fromSuraName !=
                                                                sura.name) {
                                                          // if (homeController
                                                          //         .planLines
                                                          //         ?.reviewsmall
                                                          //         ?.toSuraName
                                                          //         .isNotEmpty ??
                                                          //     false) {
                                                          //   if (Constants
                                                          //       .listSurah
                                                          //       .any((element) =>
                                                          //           element
                                                          //               .name ==
                                                          //           homeController
                                                          //               .planLines
                                                          //               ?.reviewsmall
                                                          //               ?.toSuraName)) {
                                                          //     if (sura.surahOrder <=
                                                          //         Constants
                                                          //             .listSurah
                                                          //             .firstWhere((element) =>
                                                          //                 element
                                                          //                     .name ==
                                                          //                 homeController
                                                          //                     .planLines
                                                          //                     ?.reviewsmall
                                                          //                     ?.toSuraName)
                                                          //             .surahOrder) {
                                                          //       homeController
                                                          //           .changeFromSuraPlanLine(
                                                          //               sura,
                                                          //               PlanLinesType
                                                          //                   .reviewsmall);
                                                          //     } else {
                                                          //       CostomDailogs
                                                          //           .warringDialogWithGet(
                                                          //               msg: 'can_not_yong_surh'
                                                          //                   .tr);
                                                          //     }
                                                          //   }
                                                          // } else {
                                                            homeController
                                                                .changeFromSuraPlanLine(
                                                                    sura,
                                                                    PlanLinesType
                                                                        .reviewsmall);
                                                        //  }
                                                        }
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 5.h,
                                                                horizontal:
                                                                    5.w),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white
                                                              .withOpacity(0.4),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                homeController
                                                                        .planLines
                                                                        ?.reviewsmall
                                                                        ?.fromSuraName ??
                                                                    '',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                                textScaleFactor:
                                                                    SizeConfig
                                                                        .textScaleFactor,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 1,
                                                              ),
                                                            ),
                                                            const Icon(Icons
                                                                .keyboard_arrow_down_outlined)
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    '${'to_sura'.tr} : ',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    textScaleFactor: SizeConfig
                                                        .textScaleFactor,
                                                  ),
                                                  SizedBox(
                                                    width: 2.w,
                                                  ),
                                                  Expanded(
                                                    child: InkWell(
                                                      onTap: () async {
                                                        Surah? sura =
                                                            await showDialog(
                                                          context: context,
                                                          builder: (contextDialog) => AlertDialog(
                                                             shape: const RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              15.0))),
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                      .all(15),
                                                              content: SelectSurah(
                                                                  readOnlySurah: homeController
                                                                      .planLines
                                                                      ?.reviewsmall
                                                                      ?.toSuraName)),
                                                        );
                                                        if (sura != null &&
                                                            homeController
                                                                    .planLines
                                                                    ?.reviewsmall
                                                                    ?.toSuraName !=
                                                                sura.name) {
                                                          // if (sura.surahOrder >=
                                                          //     Constants
                                                          //         .listSurah
                                                          //         .firstWhere((element) =>
                                                          //             element
                                                          //                 .name ==
                                                          //             homeController
                                                          //                 .planLines
                                                          //                 ?.reviewsmall
                                                          //                 ?.fromSuraName)
                                                          //         .surahOrder) {
                                                            homeController
                                                                .changeToSuraPlanLine(
                                                                    sura,
                                                                    PlanLinesType
                                                                        .reviewsmall);
                                                          // } else {
                                                          //   CostomDailogs
                                                          //       .warringDialogWithGet(
                                                          //           msg: 'can_not_up_surh'
                                                          //               .tr);
                                                          // }
                                                        }
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 5.h,
                                                                horizontal:
                                                                    5.w),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white
                                                              .withOpacity(0.4),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                homeController
                                                                        .planLines
                                                                        ?.reviewsmall
                                                                        ?.toSuraName ??
                                                                    '',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                                textScaleFactor:
                                                                    SizeConfig
                                                                        .textScaleFactor,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 1,
                                                              ),
                                                            ),
                                                            const Icon(Icons
                                                                .keyboard_arrow_down_outlined)
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  '${'from_aya'.tr} : ',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  textScaleFactor: SizeConfig
                                                      .textScaleFactor,
                                                ),
                                                SizedBox(
                                                  width: 2.w,
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    if (Constants.listSurah.any(
                                                        (element) =>
                                                            element.name ==
                                                            homeController
                                                                .planLines
                                                                ?.reviewsmall
                                                                ?.fromSuraName)) {
                                                      int? aya =
                                                          await showDialog(
                                                        context: context,
                                                        builder: (contextDialog) => AlertDialog(
                                                           shape: const RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              15.0))),
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                      .all(15),
                                                            content: SelectAya(
                                                                surahId: Constants
                                                                    .listSurah
                                                                    .firstWhere((element) =>
                                                                        element
                                                                            .name ==
                                                                        homeController
                                                                            .planLines
                                                                            ?.reviewsmall
                                                                            ?.fromSuraName)
                                                                    .id)),
                                                      );
                                                      if (aya != null &&
                                                          homeController
                                                                  .planLines
                                                                  ?.reviewsmall
                                                                  ?.fromAya !=
                                                              aya) {
                                                        if ((homeController
                                                                .planLines
                                                                ?.reviewsmall
                                                                ?.toSuraName
                                                                .isNotEmpty ??
                                                            false) && homeController
                                                                  .planLines
                                                                  ?.reviewsmall?.fromSuraName == homeController
                                                                  .planLines
                                                                  ?.reviewsmall?.toSuraName) {
                                                          if (homeController
                                                                      .planLines
                                                                      ?.reviewsmall
                                                                      ?.toAya !=
                                                                  null &&
                                                              aya >
                                                                  (homeController
                                                                      .planLines!
                                                                      .reviewsmall!
                                                                      .toAya)) {
                                                            CostomDailogs
                                                                .warringDialogWithGet(
                                                                    msg: 'can_not_bottom_aya'
                                                                        .tr);
                                                          } else {
                                                            homeController
                                                                .changeFromAyaPlanLine(
                                                                    aya,
                                                                    PlanLinesType
                                                                        .reviewsmall);
                                                          }
                                                        } else {
                                                          homeController
                                                              .changeFromAyaPlanLine(
                                                                  aya,
                                                                  PlanLinesType
                                                                      .reviewsmall);
                                                        }
                                                      }
                                                    }
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5.h,
                                                            horizontal: 10.w),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white
                                                          .withOpacity(0.4),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          homeController
                                                                  .planLines
                                                                  ?.reviewsmall
                                                                  ?.fromAya
                                                                  .toString() ??
                                                              '',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                          textScaleFactor:
                                                              SizeConfig
                                                                  .textScaleFactor,
                                                        ),
                                                        SizedBox(
                                                          width: 10.w,
                                                        ),
                                                        const Icon(Icons
                                                            .keyboard_arrow_down_outlined)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  '${'to_aya'.tr} : ',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  textScaleFactor: SizeConfig
                                                      .textScaleFactor,
                                                ),
                                                SizedBox(
                                                  width: 2.w,
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    if (Constants.listSurah.any(
                                                        (element) =>
                                                            element.name ==
                                                            homeController
                                                                .planLines
                                                                ?.reviewsmall
                                                                ?.toSuraName)) {
                                                      int? aya =
                                                          await showDialog(
                                                        context: context,
                                                        builder: (contextDialog) => AlertDialog(
                                                           shape: const RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              15.0))),
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                      .all(15),
                                                            content: SelectAya(
                                                                surahId: Constants
                                                                    .listSurah
                                                                    .firstWhere((element) =>
                                                                        element
                                                                            .name ==
                                                                        homeController
                                                                            .planLines
                                                                            ?.reviewsmall
                                                                            ?.toSuraName)
                                                                    .id)),
                                                      );
                                                      if (aya != null &&
                                                          homeController
                                                                  .planLines
                                                                  ?.reviewsmall
                                                                  ?.toAya !=
                                                              aya) {
                                                        if (homeController
                                                                    .planLines
                                                                    ?.reviewsmall
                                                                    ?.fromAya !=
                                                                null &&
                                                            aya <
                                                                (homeController
                                                                    .planLines!
                                                                    .reviewsmall!
                                                                    .fromAya)&& homeController
                                                                  .planLines
                                                                  ?.reviewsmall?.fromSuraName == homeController
                                                                  .planLines
                                                                  ?.reviewsmall?.toSuraName) {
                                                          CostomDailogs
                                                              .warringDialogWithGet(
                                                                  msg:
                                                                      'can_not_up_aya'
                                                                          .tr);
                                                        } else {
                                                          homeController
                                                              .changeToAyaPlanLine(
                                                                  aya,
                                                                  PlanLinesType
                                                                      .reviewsmall);
                                                        }
                                                      }
                                                    }
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5.h,
                                                            horizontal: 10.w),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white
                                                          .withOpacity(0.4),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          homeController
                                                                      .planLines
                                                                      ?.reviewsmall
                                                                      ?.toAya !=
                                                                  0
                                                              ? homeController
                                                                      .planLines
                                                                      ?.reviewsmall
                                                                      ?.toAya
                                                                      .toString() ??
                                                                  ''
                                                              : '',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                          textScaleFactor:
                                                              SizeConfig
                                                                  .textScaleFactor,
                                                        ),
                                                        SizedBox(
                                                          width: 10.w,
                                                        ),
                                                        const Icon(Icons
                                                            .keyboard_arrow_down_outlined)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                margin: EdgeInsets.symmetric(horizontal: 12.w),
                                padding: EdgeInsets.symmetric(
                                    vertical: 6.h, horizontal: 10.w),
                                decoration: BoxDecoration(
                                  color: Get.theme.secondaryHeaderColor
                                      .withOpacity(0.6),
                                  //  shape: BoxShape.circle,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'course'.tr,
                                      style: TextStyle(
                                          color: Get.theme.primaryColor,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w800),
                                      textScaleFactor:
                                          SizeConfig.textScaleFactor,
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: (() async {}),
                                          child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.w,
                                                  vertical: 5.h),
                                              decoration: BoxDecoration(
                                                color: Colors.white
                                                    .withOpacity(0.5),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons.add,
                                                    color: Colors.black,
                                                    size: 25,
                                                  ),
                                                  SizedBox(
                                                    width: 5.w,
                                                  ),
                                                  Text(
                                                    'add'.tr,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    textScaleFactor: SizeConfig
                                                        .textScaleFactor,
                                                  ),
                                                ],
                                              )),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                        SizedBox(
                          height: (homeController.planLines?.reviewsmall
                                      ?.toSuraName.isNotEmpty ??
                                  false)
                              ? 5.h
                              : 0,
                        ),
                        homeController.planLines?.reviewsmall != null &&
                                (homeController.planLines?.reviewsmall
                                        ?.toSuraName.isNotEmpty ??
                                    false)
                            ? homeController.planLines?.reviewsmall?.mistakes !=
                                    null
                                ? Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 12.w),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 6.h, horizontal: 10.w),
                                    decoration: BoxDecoration(
                                      color: Get.theme.secondaryHeaderColor
                                          .withOpacity(0.6),
                                      //  shape: BoxShape.circle,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Notes'.tr,
                                          style: TextStyle(
                                              color: Get.theme.primaryColor,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w800),
                                          textScaleFactor:
                                              SizeConfig.textScaleFactor,
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'save_errors'.tr,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    textScaleFactor: SizeConfig
                                                        .textScaleFactor,
                                                  ),
                                                  SizedBox(
                                                    height: 5.h,
                                                  ),
                                                  Text(
                                                    homeController
                                                            .planLines
                                                            ?.reviewsmall
                                                            ?.mistakes
                                                            ?.totalMstkQty
                                                            .toString() ??
                                                        '',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    textScaleFactor: SizeConfig
                                                        .textScaleFactor,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5.w,
                                            ),
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'intonation_errors'.tr,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    textScaleFactor: SizeConfig
                                                        .textScaleFactor,
                                                  ),
                                                  SizedBox(
                                                    height: 5.h,
                                                  ),
                                                  Text(
                                                    homeController
                                                            .planLines
                                                            ?.reviewsmall
                                                            ?.mistakes
                                                            ?.totalMstkRead
                                                            .toString() ??
                                                        '',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    textScaleFactor: SizeConfig
                                                        .textScaleFactor,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 12.w),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 6.h, horizontal: 10.w),
                                    decoration: BoxDecoration(
                                      color: Get.theme.secondaryHeaderColor
                                          .withOpacity(0.6),
                                      //  shape: BoxShape.circle,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Notes'.tr,
                                          style: TextStyle(
                                              color: Get.theme.primaryColor,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w800),
                                          textScaleFactor:
                                              SizeConfig.textScaleFactor,
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: (() async {
                                                await showDialog(
                                                  context: context,
                                                  builder: (contextDialog) =>
                                                      AddNote(
                                                          planLine:
                                                              PlanLinesType
                                                                  .reviewsmall),
                                                );
                                              }),
                                              child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10.w,
                                                      vertical: 5.h),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withOpacity(0.5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.add,
                                                        color: Colors.black,
                                                        size: 25,
                                                      ),
                                                      SizedBox(
                                                        width: 5.w,
                                                      ),
                                                      Text(
                                                        'add'.tr,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                        textScaleFactor:
                                                            SizeConfig
                                                                .textScaleFactor,
                                                      ),
                                                    ],
                                                  )),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                            : const SizedBox(),
                        SizedBox(
                          height: (homeController.planLines?.reviewsmall
                                      ?.toSuraName.isNotEmpty ??
                                  false)
                              ? 5.h
                              : 0,
                        ),
                        (homeController.planLines?.reviewsmall?.toSuraName
                                    .isNotEmpty ??
                                false)
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        ResponseContent response =
                                            await showCupertinoDialog(
                                                context: context,
                                                builder: (BuildContext
                                                    dialogContext) {
                                                  addListenLine(
                                                      PlanLinesType.reviewsmall,
                                                      widget.id);
                                                  return WillPopScope(
                                                    // ignore: missing_return
                                                    onWillPop: () async {
                                                      return false;
                                                    },
                                                    child:
                                                        const CupertinoAlertDialog(
                                                      content: WaitingDialog(),
                                                    ),
                                                  );
                                                });
                                        if (response.isSuccess) {
                                          response.message =
                                              'ok_add_listen_line'.tr;
                                        } else if (!response
                                            .isErrorConnection) {
                                          response.message =
                                              'error_add_listen_line'.tr;
                                        }
                                       await CostomDailogs.snackBar(
                                            response: response);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 30.w, vertical: 10.h),
                                        margin: EdgeInsets.symmetric(
                                          horizontal: 10.w,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Get.theme.secondaryHeaderColor
                                                  .withOpacity(.5),
                                              Get.theme.secondaryHeaderColor,
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(6),
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
                                            'save'.tr,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textScaleFactor:
                                                SizeConfig.textScaleFactor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                      ]),
                ),
              ],
            )));

  }

  Card reviewbig() {
    HomeController homeController = Get.find<HomeController>();
    return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: const BorderSide(width: 2, color: Colors.white)),
        margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 8.h, bottom: 8.h),
        color: Colors.white,
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 12.w,
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'reviewbig'.tr,
                                      style: TextStyle(
                                          color: Get.theme.primaryColor,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w800),
                                      textScaleFactor:
                                          SizeConfig.textScaleFactor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            homeController.planLines?.reviewbig != null
                                ? InkWell(
                                    onTap: () {
                                      if (homeController.planLines?.reviewbig
                                              ?.toSuraName.isNotEmpty ??
                                          false) {
                                        Get.to(() => Quran(
                                              planLine: homeController
                                                  .planLines!.reviewbig!,
                                            ));
                                      } else {
                                        CostomDailogs.warringDialogWithGet(
                                            msg:
                                                'complete_the_selection_of_the_course_first_to_display_it_in_the_quran'
                                                    .tr);
                                      }
                                    },
                                    child: Column(
                                      children: [
                                        SvgPicture.asset(
                                          'images/quran.svg',
                                          height: 30.h,
                                          color: Get.theme.primaryColor,
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        Text(
                                          'quran'.tr,
                                          style: TextStyle(
                                              color: Get
                                                  .theme.secondaryHeaderColor,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w500),
                                          textScaleFactor:
                                              SizeConfig.textScaleFactor,
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox(),
                            SizedBox(
                              width: 12.w,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        homeController.planLines?.reviewbig != null
                            ? Container(
                                margin: EdgeInsets.symmetric(horizontal: 12.w),
                                padding: EdgeInsets.symmetric(
                                    vertical: 6.h, horizontal: 10.w),
                                decoration: BoxDecoration(
                                  color: Get.theme.secondaryHeaderColor
                                      .withOpacity(0.6),
                                  //  shape: BoxShape.circle,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'course'.tr,
                                      style: TextStyle(
                                          color: Get.theme.primaryColor,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w800),
                                      textScaleFactor:
                                          SizeConfig.textScaleFactor,
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    '${'from_sura'.tr} : ',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    textScaleFactor: SizeConfig
                                                        .textScaleFactor,
                                                  ),
                                                  SizedBox(
                                                    width: 2.w,
                                                  ),
                                                  Expanded(
                                                    child: InkWell(
                                                      onTap: () async {
                                                        Surah? sura =
                                                            await showDialog(
                                                          context: context,
                                                          builder: (contextDialog) => AlertDialog(
                                                             shape: const RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              15.0))),
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                      .all(15),
                                                              content: SelectSurah(
                                                                  readOnlySurah: homeController
                                                                      .planLines
                                                                      ?.reviewbig
                                                                      ?.fromSuraName)),
                                                        );
                                                        if (sura != null &&
                                                            homeController
                                                                    .planLines
                                                                    ?.reviewbig
                                                                    ?.fromSuraName !=
                                                                sura.name) {
                                                          // if (homeController
                                                          //         .planLines
                                                          //         ?.reviewbig
                                                          //         ?.toSuraName
                                                          //         .isNotEmpty ??
                                                          //     false) {
                                                          //   if (Constants
                                                          //       .listSurah
                                                          //       .any((element) =>
                                                          //           element
                                                          //               .name ==
                                                          //           homeController
                                                          //               .planLines
                                                          //               ?.reviewbig
                                                          //               ?.toSuraName)) {
                                                          //     if (sura.surahOrder <=
                                                          //         Constants
                                                          //             .listSurah
                                                          //             .firstWhere((element) =>
                                                          //                 element
                                                          //                     .name ==
                                                          //                 homeController
                                                          //                     .planLines
                                                          //                     ?.reviewbig
                                                          //                     ?.toSuraName)
                                                          //             .surahOrder) {
                                                          //       homeController
                                                          //           .changeFromSuraPlanLine(
                                                          //               sura,
                                                          //               PlanLinesType
                                                          //                   .reviewbig);
                                                          //     } else {
                                                          //       CostomDailogs
                                                          //           .warringDialogWithGet(
                                                          //               msg: 'can_not_yong_surh'
                                                          //                   .tr);
                                                          //     }
                                                          //   }
                                                          // } else {
                                                            homeController
                                                                .changeFromSuraPlanLine(
                                                                    sura,
                                                                    PlanLinesType
                                                                        .reviewbig);
                                                        //  }
                                                        }
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 5.h,
                                                                horizontal:
                                                                    5.w),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white
                                                              .withOpacity(0.4),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                homeController
                                                                        .planLines
                                                                        ?.reviewbig
                                                                        ?.fromSuraName ??
                                                                    '',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                                textScaleFactor:
                                                                    SizeConfig
                                                                        .textScaleFactor,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 1,
                                                              ),
                                                            ),
                                                            const Icon(Icons
                                                                .keyboard_arrow_down_outlined)
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    '${'to_sura'.tr} : ',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    textScaleFactor: SizeConfig
                                                        .textScaleFactor,
                                                  ),
                                                  SizedBox(
                                                    width: 2.w,
                                                  ),
                                                  Expanded(
                                                    child: InkWell(
                                                      onTap: () async {
                                                        Surah? sura =
                                                            await showDialog(
                                                          context: context,
                                                          builder: (contextDialog) => AlertDialog(
                                                             shape: const RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              15.0))),
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                      .all(15),
                                                              content: SelectSurah(
                                                                  readOnlySurah: homeController
                                                                      .planLines
                                                                      ?.reviewbig
                                                                      ?.toSuraName)),
                                                        );
                                                        if (sura != null &&
                                                            homeController
                                                                    .planLines
                                                                    ?.reviewbig
                                                                    ?.toSuraName !=
                                                                sura.name) {
                                                          // if (sura.surahOrder >=
                                                          //     Constants
                                                          //         .listSurah
                                                          //         .firstWhere((element) =>
                                                          //             element
                                                          //                 .name ==
                                                          //             homeController
                                                          //                 .planLines
                                                          //                 ?.reviewbig
                                                          //                 ?.fromSuraName)
                                                          //         .surahOrder) {
                                                            homeController
                                                                .changeToSuraPlanLine(
                                                                    sura,
                                                                    PlanLinesType
                                                                        .reviewbig);
                                                          // } else {
                                                          //   CostomDailogs
                                                          //       .warringDialogWithGet(
                                                          //           msg: 'can_not_up_surh'
                                                          //               .tr);
                                                          // }
                                                        }
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 5.h,
                                                                horizontal:
                                                                    5.w),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white
                                                              .withOpacity(0.4),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                homeController
                                                                        .planLines
                                                                        ?.reviewbig
                                                                        ?.toSuraName ??
                                                                    '',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                                textScaleFactor:
                                                                    SizeConfig
                                                                        .textScaleFactor,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 1,
                                                              ),
                                                            ),
                                                            const Icon(Icons
                                                                .keyboard_arrow_down_outlined)
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  '${'from_aya'.tr} : ',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  textScaleFactor: SizeConfig
                                                      .textScaleFactor,
                                                ),
                                                SizedBox(
                                                  width: 2.w,
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    if (Constants.listSurah.any(
                                                        (element) =>
                                                            element.name ==
                                                            homeController
                                                                .planLines
                                                                ?.reviewbig
                                                                ?.fromSuraName)) {
                                                      int? aya =
                                                          await showDialog(
                                                        context: context,
                                                        builder: (contextDialog) => AlertDialog(
                                                           shape: const RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              15.0))),
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                      .all(15),
                                                            content: SelectAya(
                                                                surahId: Constants
                                                                    .listSurah
                                                                    .firstWhere((element) =>
                                                                        element
                                                                            .name ==
                                                                        homeController
                                                                            .planLines
                                                                            ?.reviewbig
                                                                            ?.fromSuraName)
                                                                    .id)),
                                                      );
                                                      if (aya != null &&
                                                          homeController
                                                                  .planLines
                                                                  ?.reviewbig
                                                                  ?.fromAya !=
                                                              aya) {
                                                        if ((homeController
                                                                .planLines
                                                                ?.reviewbig
                                                                ?.toSuraName
                                                                .isNotEmpty ??
                                                            false) && homeController
                                                                  .planLines
                                                                  ?.reviewbig?.fromSuraName == homeController
                                                                  .planLines
                                                                  ?.reviewbig?.toSuraName) {
                                                          if (homeController
                                                                      .planLines
                                                                      ?.reviewbig
                                                                      ?.toAya !=
                                                                  null &&
                                                              aya >
                                                                  (homeController
                                                                      .planLines!
                                                                      .reviewbig!
                                                                      .toAya)) {
                                                            CostomDailogs
                                                                .warringDialogWithGet(
                                                                    msg: 'can_not_bottom_aya'
                                                                        .tr);
                                                          } else {
                                                            homeController
                                                                .changeFromAyaPlanLine(
                                                                    aya,
                                                                    PlanLinesType
                                                                        .reviewbig);
                                                          }
                                                        } else {
                                                          homeController
                                                              .changeFromAyaPlanLine(
                                                                  aya,
                                                                  PlanLinesType
                                                                      .reviewbig);
                                                        }
                                                      }
                                                    }
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5.h,
                                                            horizontal: 10.w),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white
                                                          .withOpacity(0.4),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          homeController
                                                                  .planLines
                                                                  ?.reviewbig
                                                                  ?.fromAya
                                                                  .toString() ??
                                                              '',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                          textScaleFactor:
                                                              SizeConfig
                                                                  .textScaleFactor,
                                                        ),
                                                        SizedBox(
                                                          width: 10.w,
                                                        ),
                                                        const Icon(Icons
                                                            .keyboard_arrow_down_outlined)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  '${'to_aya'.tr} : ',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  textScaleFactor: SizeConfig
                                                      .textScaleFactor,
                                                ),
                                                SizedBox(
                                                  width: 2.w,
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    if (Constants.listSurah.any(
                                                        (element) =>
                                                            element.name ==
                                                            homeController
                                                                .planLines
                                                                ?.reviewbig
                                                                ?.toSuraName)) {
                                                      int? aya =
                                                          await showDialog(
                                                        context: context,
                                                        builder: (contextDialog) => AlertDialog(
                                                           shape: const RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              15.0))),
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                      .all(15),
                                                            content: SelectAya(
                                                                surahId: Constants
                                                                    .listSurah
                                                                    .firstWhere((element) =>
                                                                        element
                                                                            .name ==
                                                                        homeController
                                                                            .planLines
                                                                            ?.reviewbig
                                                                            ?.toSuraName)
                                                                    .id)),
                                                      );
                                                      if (aya != null &&
                                                          homeController
                                                                  .planLines
                                                                  ?.reviewbig
                                                                  ?.toAya !=
                                                              aya) {
                                                        if (homeController
                                                                    .planLines
                                                                    ?.reviewbig
                                                                    ?.fromAya !=
                                                                null &&
                                                            aya <
                                                                (homeController
                                                                    .planLines!
                                                                    .reviewbig!
                                                                    .fromAya) && homeController
                                                                  .planLines
                                                                  ?.reviewbig?.fromSuraName == homeController
                                                                  .planLines
                                                                  ?.reviewbig?.toSuraName) {
                                                          CostomDailogs
                                                              .warringDialogWithGet(
                                                                  msg:
                                                                      'can_not_up_aya'
                                                                          .tr);
                                                        } else {
                                                          homeController
                                                              .changeToAyaPlanLine(
                                                                  aya,
                                                                  PlanLinesType
                                                                      .reviewbig);
                                                        }
                                                      }
                                                    }
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5.h,
                                                            horizontal: 10.w),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white
                                                          .withOpacity(0.4),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          homeController
                                                                      .planLines
                                                                      ?.reviewbig
                                                                      ?.toAya !=
                                                                  0
                                                              ? homeController
                                                                      .planLines
                                                                      ?.reviewbig
                                                                      ?.toAya
                                                                      .toString() ??
                                                                  ''
                                                              : '',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                          textScaleFactor:
                                                              SizeConfig
                                                                  .textScaleFactor,
                                                        ),
                                                        SizedBox(
                                                          width: 10.w,
                                                        ),
                                                        const Icon(Icons
                                                            .keyboard_arrow_down_outlined)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                margin: EdgeInsets.symmetric(horizontal: 12.w),
                                padding: EdgeInsets.symmetric(
                                    vertical: 6.h, horizontal: 10.w),
                                decoration: BoxDecoration(
                                  color: Get.theme.secondaryHeaderColor
                                      .withOpacity(0.6),
                                  //  shape: BoxShape.circle,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'course'.tr,
                                      style: TextStyle(
                                          color: Get.theme.primaryColor,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w800),
                                      textScaleFactor:
                                          SizeConfig.textScaleFactor,
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: (() async {}),
                                          child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.w,
                                                  vertical: 5.h),
                                              decoration: BoxDecoration(
                                                color: Colors.white
                                                    .withOpacity(0.5),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons.add,
                                                    color: Colors.black,
                                                    size: 25,
                                                  ),
                                                  SizedBox(
                                                    width: 5.w,
                                                  ),
                                                  Text(
                                                    'add'.tr,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    textScaleFactor: SizeConfig
                                                        .textScaleFactor,
                                                  ),
                                                ],
                                              )),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                        SizedBox(
                          height: (homeController.planLines?.reviewbig
                                      ?.toSuraName.isNotEmpty ??
                                  false)
                              ? 5.h
                              : 0,
                        ),
                        homeController.planLines?.reviewbig != null &&
                                (homeController.planLines?.reviewbig?.toSuraName
                                        .isNotEmpty ??
                                    false)
                            ? homeController.planLines?.reviewbig?.mistakes !=
                                    null
                                ? Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 12.w),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 6.h, horizontal: 10.w),
                                    decoration: BoxDecoration(
                                      color: Get.theme.secondaryHeaderColor
                                          .withOpacity(0.6),
                                      //  shape: BoxShape.circle,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Notes'.tr,
                                          style: TextStyle(
                                              color: Get.theme.primaryColor,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w800),
                                          textScaleFactor:
                                              SizeConfig.textScaleFactor,
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'save_errors'.tr,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    textScaleFactor: SizeConfig
                                                        .textScaleFactor,
                                                  ),
                                                  SizedBox(
                                                    height: 5.h,
                                                  ),
                                                  Text(
                                                    homeController
                                                            .planLines
                                                            ?.reviewbig
                                                            ?.mistakes
                                                            ?.totalMstkQty
                                                            .toString() ??
                                                        '',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    textScaleFactor: SizeConfig
                                                        .textScaleFactor,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5.w,
                                            ),
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'intonation_errors'.tr,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    textScaleFactor: SizeConfig
                                                        .textScaleFactor,
                                                  ),
                                                  SizedBox(
                                                    height: 5.h,
                                                  ),
                                                  Text(
                                                    homeController
                                                            .planLines
                                                            ?.reviewbig
                                                            ?.mistakes
                                                            ?.totalMstkRead
                                                            .toString() ??
                                                        '',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    textScaleFactor: SizeConfig
                                                        .textScaleFactor,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 12.w),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 6.h, horizontal: 10.w),
                                    decoration: BoxDecoration(
                                      color: Get.theme.secondaryHeaderColor
                                          .withOpacity(0.6),
                                      //  shape: BoxShape.circle,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Notes'.tr,
                                          style: TextStyle(
                                              color: Get.theme.primaryColor,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w800),
                                          textScaleFactor:
                                              SizeConfig.textScaleFactor,
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: (() async {
                                                await showDialog(
                                                  context: context,
                                                  builder: (contextDialog) =>
                                                      AddNote(
                                                          planLine:
                                                              PlanLinesType
                                                                  .reviewbig),
                                                );
                                              }),
                                              child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10.w,
                                                      vertical: 5.h),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withOpacity(0.5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.add,
                                                        color: Colors.black,
                                                        size: 25,
                                                      ),
                                                      SizedBox(
                                                        width: 5.w,
                                                      ),
                                                      Text(
                                                        'add'.tr,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                        textScaleFactor:
                                                            SizeConfig
                                                                .textScaleFactor,
                                                      ),
                                                    ],
                                                  )),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                            : const SizedBox(),
                        SizedBox(
                          height: (homeController.planLines?.reviewbig
                                      ?.toSuraName.isNotEmpty ??
                                  false)
                              ? 5.h
                              : 0,
                        ),
                        (homeController.planLines?.reviewbig?.toSuraName
                                    .isNotEmpty ??
                                false)
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        ResponseContent response =
                                            await showCupertinoDialog(
                                                context: context,
                                                builder: (BuildContext
                                                    dialogContext) {
                                                  addListenLine(
                                                      PlanLinesType.reviewbig,
                                                      widget.id);
                                                  return WillPopScope(
                                                    // ignore: missing_return
                                                    onWillPop: () async {
                                                      return false;
                                                    },
                                                    child:
                                                        const CupertinoAlertDialog(
                                                      content: WaitingDialog(),
                                                    ),
                                                  );
                                                });
                                        if (response.isSuccess) {
                                          response.message =
                                              'ok_add_listen_line'.tr;
                                        } else if (!response
                                            .isErrorConnection) {
                                          response.message =
                                              'error_add_listen_line'.tr;
                                        }
                                       await CostomDailogs.snackBar(
                                            response: response);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 30.w, vertical: 10.h),
                                        margin: EdgeInsets.symmetric(
                                          horizontal: 10.w,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Get.theme.secondaryHeaderColor
                                                  .withOpacity(.5),
                                              Get.theme.secondaryHeaderColor,
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(6),
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
                                            'save'.tr,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textScaleFactor:
                                                SizeConfig.textScaleFactor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                      ]),
                ),
              ],
            )));
  }

  Card tlawa() {
    HomeController homeController = Get.find<HomeController>();
    return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: const BorderSide(width: 2, color: Colors.white)),
        margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 8.h, bottom: 8.h),
        color: Colors.white,
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 12.w,
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'tlawa'.tr,
                                      style: TextStyle(
                                          color: Get.theme.primaryColor,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w800),
                                      textScaleFactor:
                                          SizeConfig.textScaleFactor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            homeController.planLines?.tlawa != null
                                ? InkWell(
                                    onTap: () {
                                      if (homeController.planLines?.tlawa
                                              ?.toSuraName.isNotEmpty ??
                                          false) {
                                        Get.to(() => Quran(
                                              planLine: homeController
                                                  .planLines!.tlawa!,
                                            ));
                                      } else {
                                        CostomDailogs.warringDialogWithGet(
                                            msg:
                                                'complete_the_selection_of_the_course_first_to_display_it_in_the_quran'
                                                    .tr);
                                      }
                                    },
                                    child: Column(
                                      children: [
                                        SvgPicture.asset(
                                          'images/quran.svg',
                                          height: 30.h,
                                          color: Get.theme.primaryColor,
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        Text(
                                          'quran'.tr,
                                          style: TextStyle(
                                              color: Get
                                                  .theme.secondaryHeaderColor,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w500),
                                          textScaleFactor:
                                              SizeConfig.textScaleFactor,
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox(),
                            SizedBox(
                              width: 12.w,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        homeController.planLines?.tlawa != null
                            ? Container(
                                margin: EdgeInsets.symmetric(horizontal: 12.w),
                                padding: EdgeInsets.symmetric(
                                    vertical: 6.h, horizontal: 10.w),
                                decoration: BoxDecoration(
                                  color: Get.theme.secondaryHeaderColor
                                      .withOpacity(0.6),
                                  //  shape: BoxShape.circle,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'course'.tr,
                                      style: TextStyle(
                                          color: Get.theme.primaryColor,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w800),
                                      textScaleFactor:
                                          SizeConfig.textScaleFactor,
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    '${'from_sura'.tr} : ',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    textScaleFactor: SizeConfig
                                                        .textScaleFactor,
                                                  ),
                                                  SizedBox(
                                                    width: 2.w,
                                                  ),
                                                  Expanded(
                                                    child: InkWell(
                                                      onTap: () async {
                                                        Surah? sura =
                                                            await showDialog(
                                                          context: context,
                                                          builder: (contextDialog) => AlertDialog(
                                                             shape: const RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              15.0))),
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                      .all(15),
                                                              content: SelectSurah(
                                                                  readOnlySurah:
                                                                      homeController
                                                                          .planLines
                                                                          ?.tlawa
                                                                          ?.fromSuraName)),
                                                        );
                                                        if (sura != null &&
                                                            homeController
                                                                    .planLines
                                                                    ?.tlawa
                                                                    ?.fromSuraName !=
                                                                sura.name) {
                                                          // if (homeController
                                                          //         .planLines
                                                          //         ?.tlawa
                                                          //         ?.toSuraName
                                                          //         .isNotEmpty ??
                                                          //     false) {
                                                          //   if (Constants
                                                          //       .listSurah
                                                          //       .any((element) =>
                                                          //           element
                                                          //               .name ==
                                                          //           homeController
                                                          //               .planLines
                                                          //               ?.tlawa
                                                          //               ?.toSuraName)) {
                                                          //     if (sura.surahOrder <=
                                                          //         Constants
                                                          //             .listSurah
                                                          //             .firstWhere((element) =>
                                                          //                 element
                                                          //                     .name ==
                                                          //                 homeController
                                                          //                     .planLines
                                                          //                     ?.tlawa
                                                          //                     ?.toSuraName)
                                                          //             .surahOrder) {
                                                          //       homeController
                                                          //           .changeFromSuraPlanLine(
                                                          //               sura,
                                                          //               PlanLinesType
                                                          //                   .tlawa);
                                                          //     } else {
                                                          //       CostomDailogs
                                                          //           .warringDialogWithGet(
                                                          //               msg: 'can_not_yong_surh'
                                                          //                   .tr);
                                                          //     }
                                                          //   }
                                                          // } else {
                                                            homeController
                                                                .changeFromSuraPlanLine(
                                                                    sura,
                                                                    PlanLinesType
                                                                        .tlawa);
                                                        //  }
                                                        }
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 5.h,
                                                                horizontal:
                                                                    5.w),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white
                                                              .withOpacity(0.4),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                homeController
                                                                        .planLines
                                                                        ?.tlawa
                                                                        ?.fromSuraName ??
                                                                    '',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                                textScaleFactor:
                                                                    SizeConfig
                                                                        .textScaleFactor,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 1,
                                                              ),
                                                            ),
                                                            const Icon(Icons
                                                                .keyboard_arrow_down_outlined)
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    '${'to_sura'.tr} : ',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    textScaleFactor: SizeConfig
                                                        .textScaleFactor,
                                                  ),
                                                  SizedBox(
                                                    width: 2.w,
                                                  ),
                                                  Expanded(
                                                    child: InkWell(
                                                      onTap: () async {
                                                        Surah? sura =
                                                            await showDialog(
                                                          context: context,
                                                          builder: (contextDialog) => AlertDialog(
                                                             shape: const RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              15.0))),
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                      .all(15),
                                                              content: SelectSurah(
                                                                  readOnlySurah:
                                                                      homeController
                                                                          .planLines
                                                                          ?.tlawa
                                                                          ?.toSuraName)),
                                                        );
                                                        if (sura != null &&
                                                            homeController
                                                                    .planLines
                                                                    ?.tlawa
                                                                    ?.toSuraName !=
                                                                sura.name) {
                                                          // if (sura.surahOrder >=
                                                          //     Constants
                                                          //         .listSurah
                                                          //         .firstWhere((element) =>
                                                          //             element
                                                          //                 .name ==
                                                          //             homeController
                                                          //                 .planLines
                                                          //                 ?.tlawa
                                                          //                 ?.fromSuraName)
                                                          //         .surahOrder) {
                                                            homeController
                                                                .changeToSuraPlanLine(
                                                                    sura,
                                                                    PlanLinesType
                                                                        .tlawa);
                                                          // } else {
                                                          //   CostomDailogs
                                                          //       .warringDialogWithGet(
                                                          //           msg: 'can_not_up_surh'
                                                          //               .tr);
                                                          // }
                                                        }
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 5.h,
                                                                horizontal:
                                                                    5.w),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white
                                                              .withOpacity(0.4),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                homeController
                                                                        .planLines
                                                                        ?.tlawa
                                                                        ?.toSuraName ??
                                                                    '',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                                textScaleFactor:
                                                                    SizeConfig
                                                                        .textScaleFactor,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 1,
                                                              ),
                                                            ),
                                                            const Icon(Icons
                                                                .keyboard_arrow_down_outlined)
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  '${'from_aya'.tr} : ',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  textScaleFactor: SizeConfig
                                                      .textScaleFactor,
                                                ),
                                                SizedBox(
                                                  width: 2.w,
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    if (Constants.listSurah.any(
                                                        (element) =>
                                                            element.name ==
                                                            homeController
                                                                .planLines
                                                                ?.tlawa
                                                                ?.fromSuraName)) {
                                                      int? aya =
                                                          await showDialog(
                                                        context: context,
                                                        builder: (contextDialog) => AlertDialog(
                                                           shape: const RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              15.0))),
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                      .all(15),
                                                            content: SelectAya(
                                                                surahId: Constants
                                                                    .listSurah
                                                                    .firstWhere((element) =>
                                                                        element
                                                                            .name ==
                                                                        homeController
                                                                            .planLines
                                                                            ?.tlawa
                                                                            ?.fromSuraName)
                                                                    .id)),
                                                      );
                                                      if (aya != null &&
                                                          homeController
                                                                  .planLines
                                                                  ?.tlawa
                                                                  ?.fromAya !=
                                                              aya) {
                                                        if ((homeController
                                                                .planLines
                                                                ?.tlawa
                                                                ?.toSuraName
                                                                .isNotEmpty ??
                                                            false) && homeController
                                                                  .planLines
                                                                  ?.tlawa?.fromSuraName == homeController
                                                                  .planLines
                                                                  ?.tlawa?.toSuraName) {
                                                          if (homeController
                                                                      .planLines
                                                                      ?.tlawa
                                                                      ?.toAya !=
                                                                  null &&
                                                              aya >
                                                                  (homeController
                                                                      .planLines!
                                                                      .tlawa!
                                                                      .toAya)) {
                                                            CostomDailogs
                                                                .warringDialogWithGet(
                                                                    msg: 'can_not_bottom_aya'
                                                                        .tr);
                                                          } else {
                                                            homeController
                                                                .changeFromAyaPlanLine(
                                                                    aya,
                                                                    PlanLinesType
                                                                        .tlawa);
                                                          }
                                                        } else {
                                                          homeController
                                                              .changeFromAyaPlanLine(
                                                                  aya,
                                                                  PlanLinesType
                                                                      .tlawa);
                                                        }
                                                      }
                                                    }
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5.h,
                                                            horizontal: 10.w),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white
                                                          .withOpacity(0.4),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          homeController
                                                                  .planLines
                                                                  ?.tlawa
                                                                  ?.fromAya
                                                                  .toString() ??
                                                              '',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                          textScaleFactor:
                                                              SizeConfig
                                                                  .textScaleFactor,
                                                        ),
                                                        SizedBox(
                                                          width: 10.w,
                                                        ),
                                                        const Icon(Icons
                                                            .keyboard_arrow_down_outlined)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  '${'to_aya'.tr} : ',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  textScaleFactor: SizeConfig
                                                      .textScaleFactor,
                                                ),
                                                SizedBox(
                                                  width: 2.w,
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    if (Constants.listSurah.any(
                                                        (element) =>
                                                            element.name ==
                                                            homeController
                                                                .planLines
                                                                ?.tlawa
                                                                ?.toSuraName)) {
                                                      int? aya =
                                                          await showDialog(
                                                        context: context,
                                                        builder: (contextDialog) => AlertDialog(
                                                           shape: const RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              15.0))),
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                      .all(15),
                                                            content: SelectAya(
                                                                surahId: Constants
                                                                    .listSurah
                                                                    .firstWhere((element) =>
                                                                        element
                                                                            .name ==
                                                                        homeController
                                                                            .planLines
                                                                            ?.tlawa
                                                                            ?.toSuraName)
                                                                    .id)),
                                                      );
                                                      if (aya != null &&
                                                          homeController
                                                                  .planLines
                                                                  ?.tlawa
                                                                  ?.toAya !=
                                                              aya) {
                                                        if (homeController
                                                                    .planLines
                                                                    ?.tlawa
                                                                    ?.fromAya !=
                                                                null &&
                                                            aya <
                                                                (homeController
                                                                    .planLines!
                                                                    .tlawa!
                                                                    .fromAya) && homeController
                                                                  .planLines
                                                                  ?.tlawa?.fromSuraName == homeController
                                                                  .planLines
                                                                  ?.tlawa?.toSuraName) {
                                                          CostomDailogs
                                                              .warringDialogWithGet(
                                                                  msg:
                                                                      'can_not_up_aya'
                                                                          .tr);
                                                        } else {
                                                          homeController
                                                              .changeToAyaPlanLine(
                                                                  aya,
                                                                  PlanLinesType
                                                                      .tlawa);
                                                        }
                                                      }
                                                    }
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5.h,
                                                            horizontal: 10.w),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white
                                                          .withOpacity(0.4),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          homeController
                                                                      .planLines
                                                                      ?.tlawa
                                                                      ?.toAya !=
                                                                  0
                                                              ? homeController
                                                                      .planLines
                                                                      ?.tlawa
                                                                      ?.toAya
                                                                      .toString() ??
                                                                  ''
                                                              : '',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                          textScaleFactor:
                                                              SizeConfig
                                                                  .textScaleFactor,
                                                        ),
                                                        SizedBox(
                                                          width: 10.w,
                                                        ),
                                                        const Icon(Icons
                                                            .keyboard_arrow_down_outlined)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                margin: EdgeInsets.symmetric(horizontal: 12.w),
                                padding: EdgeInsets.symmetric(
                                    vertical: 6.h, horizontal: 10.w),
                                decoration: BoxDecoration(
                                  color: Get.theme.secondaryHeaderColor
                                      .withOpacity(0.6),
                                  //  shape: BoxShape.circle,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'course'.tr,
                                      style: TextStyle(
                                          color: Get.theme.primaryColor,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w800),
                                      textScaleFactor:
                                          SizeConfig.textScaleFactor,
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: (() async {}),
                                          child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.w,
                                                  vertical: 5.h),
                                              decoration: BoxDecoration(
                                                color: Colors.white
                                                    .withOpacity(0.5),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons.add,
                                                    color: Colors.black,
                                                    size: 25,
                                                  ),
                                                  SizedBox(
                                                    width: 5.w,
                                                  ),
                                                  Text(
                                                    'add'.tr,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    textScaleFactor: SizeConfig
                                                        .textScaleFactor,
                                                  ),
                                                ],
                                              )),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                        SizedBox(
                          height: (homeController.planLines?.tlawa?.toSuraName
                                      .isNotEmpty ??
                                  false)
                              ? 5.h
                              : 0,
                        ),
                        homeController.planLines?.tlawa != null &&
                                (homeController.planLines?.tlawa?.toSuraName
                                        .isNotEmpty ??
                                    false)
                            ? homeController.planLines?.tlawa?.mistakes != null
                                ? Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 12.w),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 6.h, horizontal: 10.w),
                                    decoration: BoxDecoration(
                                      color: Get.theme.secondaryHeaderColor
                                          .withOpacity(0.6),
                                      //  shape: BoxShape.circle,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Notes'.tr,
                                          style: TextStyle(
                                              color: Get.theme.primaryColor,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w800),
                                          textScaleFactor:
                                              SizeConfig.textScaleFactor,
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        Row(
                                          children: [
                                            // Expanded(
                                            //   child: Column(
                                            //     children: [
                                            //       Text(
                                            //         'save_errors'.tr,
                                            //         style: TextStyle(
                                            //             color: Colors.black,
                                            //             fontSize: 14.sp,
                                            //             fontWeight:
                                            //                 FontWeight.w500),
                                            //         textScaleFactor: SizeConfig
                                            //             .textScaleFactor,
                                            //       ),
                                            //       SizedBox(
                                            //         height: 5.h,
                                            //       ),
                                            //       Text(
                                            //         homeController
                                            //                 .planLines
                                            //                 ?.tlawa
                                            //                 ?.mistakes
                                            //                 ?.totalMstkQty
                                            //                 .toString() ??
                                            //             '',
                                            //         style: TextStyle(
                                            //             color: Colors.white,
                                            //             fontSize: 14.sp,
                                            //             fontWeight:
                                            //                 FontWeight.w500),
                                            //         textScaleFactor: SizeConfig
                                            //             .textScaleFactor,
                                            //       ),
                                            //     ],
                                            //   ),
                                            // ),
                                            // SizedBox(
                                            //   width: 5.w,
                                            // ),
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'intonation_errors'.tr,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    textScaleFactor: SizeConfig
                                                        .textScaleFactor,
                                                  ),
                                                  SizedBox(
                                                    height: 5.h,
                                                  ),
                                                  Text(
                                                    homeController
                                                            .planLines
                                                            ?.tlawa
                                                            ?.mistakes
                                                            ?.totalMstkRead
                                                            .toString() ??
                                                        '',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    textScaleFactor: SizeConfig
                                                        .textScaleFactor,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 12.w),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 6.h, horizontal: 10.w),
                                    decoration: BoxDecoration(
                                      color: Get.theme.secondaryHeaderColor
                                          .withOpacity(0.6),
                                      //  shape: BoxShape.circle,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Notes'.tr,
                                          style: TextStyle(
                                              color: Get.theme.primaryColor,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w800),
                                          textScaleFactor:
                                              SizeConfig.textScaleFactor,
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: (() async {
                                                await showDialog(
                                                  context: context,
                                                  builder: (contextDialog) =>
                                                      AddNote(
                                                        isTlawa:true,
                                                          planLine:
                                                              PlanLinesType
                                                                  .tlawa),
                                                );
                                              }),
                                              child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10.w,
                                                      vertical: 5.h),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withOpacity(0.5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.add,
                                                        color: Colors.black,
                                                        size: 25,
                                                      ),
                                                      SizedBox(
                                                        width: 5.w,
                                                      ),
                                                      Text(
                                                        'add'.tr,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                        textScaleFactor:
                                                            SizeConfig
                                                                .textScaleFactor,
                                                      ),
                                                    ],
                                                  )),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                            : const SizedBox(),
                        SizedBox(
                          height: (homeController.planLines?.tlawa?.toSuraName
                                      .isNotEmpty ??
                                  false)
                              ? 5.h
                              : 0,
                        ),
                        (homeController
                                    .planLines?.tlawa?.toSuraName.isNotEmpty ??
                                false)
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        ResponseContent response =
                                            await showCupertinoDialog(
                                                context: context,
                                                builder: (BuildContext
                                                    dialogContext) {
                                                  addListenLine(
                                                      PlanLinesType.tlawa,
                                                      widget.id);
                                                  return WillPopScope(
                                                    // ignore: missing_return
                                                    onWillPop: () async {
                                                      return false;
                                                    },
                                                    child:
                                                        const CupertinoAlertDialog(
                                                      content: WaitingDialog(),
                                                    ),
                                                  );
                                                });
                                        if (response.isSuccess) {
                                          response.message =
                                              'ok_add_listen_line'.tr;
                                        } else if (!response
                                            .isErrorConnection) {
                                          response.message =
                                              'error_add_listen_line'.tr;
                                        }
                                       await CostomDailogs.snackBar(
                                            response: response);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 30.w, vertical: 10.h),
                                        margin: EdgeInsets.symmetric(
                                          horizontal: 10.w,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Get.theme.secondaryHeaderColor
                                                  .withOpacity(.5),
                                              Get.theme.secondaryHeaderColor,
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(6),
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
                                            'save'.tr,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textScaleFactor:
                                                SizeConfig.textScaleFactor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                      ]),
                ),
              ],
            )));
  }

  void addListenLine(String type, int id) async {
    HomeController homeController = Get.find<HomeController>();
    ResponseContent responseContent = await homeController.addListenLine(
      type,
      id,
      widget.episode.id!,
    );
    Get.back(result: responseContent);
  }
}
