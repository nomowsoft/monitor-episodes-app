import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monitor_episodes/controller/statistics_controller.dart';
import 'package:monitor_episodes/model/core/shared/globals/size_config.dart';
import 'package:monitor_episodes/ui/shared/widgets/color_loader/color_loader.dart';

class Statistics extends StatefulWidget {
  const Statistics({super.key});

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: StatisticsController(),
        builder: (StatisticsController statisticsController) => Scaffold(body:
                SafeArea(
                    child: OrientationBuilder(builder: (context, orientation) {
              SizeConfig('initialSize')
                  .init(originalWidth: 428, originalHeight: 926);
              return Stack(children: [
                Positioned.fill(
                  child: Image.asset(
                    'images/bgR2.png',
                    repeat: ImageRepeat.repeat,
                  ),
                ),
                Positioned.fill(
                    child: Padding(
                        padding: EdgeInsets.only(top: 16.h),
                        child: statisticsController.gettingStatisics
                            ? const Center(
                                child: ColorLoader(),
                              )
                            : SingleChildScrollView(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                      Card(
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            side: const BorderSide(
                                                width: 2, color: Colors.white)),
                                        color: Colors.white,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 12.h, horizontal: 12.w),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'episodes_and_students'.tr,
                                                      style: TextStyle(
                                                          color: Get
                                                              .theme.primaryColor,
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.w800),
                                                      textScaleFactor: SizeConfig
                                                          .textScaleFactor,
                                                    ),
                                                    SizedBox(
                                                      height: 15.h,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                'number_episodes'
                                                                    .tr,
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
                                                              ),
                                                              SizedBox(
                                                                height: 5.h,
                                                              ),
                                                              Text(
                                                                statisticsController
                                                                    .numberEpisodes,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800),
                                                                textScaleFactor:
                                                                    SizeConfig
                                                                        .textScaleFactor,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                'number_students'
                                                                    .tr,
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
                                                              ),
                                                              SizedBox(
                                                                height: 5.h,
                                                              ),
                                                              Text(
                                                                statisticsController
                                                                    .numberStudents,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800),
                                                                textScaleFactor:
                                                                    SizeConfig
                                                                        .textScaleFactor,
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Card(
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            side: const BorderSide(
                                                width: 2, color: Colors.white)),
                                        color: Colors.white,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 12.h, horizontal: 12.w),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'operations'.tr,
                                                      style: TextStyle(
                                                          color: Get
                                                              .theme.primaryColor,
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.w800),
                                                      textScaleFactor: SizeConfig
                                                          .textScaleFactor,
                                                    ),
                                                    SizedBox(
                                                      height: 15.h,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                'listen'.tr,
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
                                                              ),
                                                              SizedBox(
                                                                height: 5.h,
                                                              ),
                                                              Text(
                                                                statisticsController
                                                                    .numberListen,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800),
                                                                textScaleFactor:
                                                                    SizeConfig
                                                                        .textScaleFactor,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                'reviewsmall'.tr,
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
                                                              ),
                                                              SizedBox(
                                                                height: 5.h,
                                                              ),
                                                              Text(
                                                                statisticsController
                                                                    .numberReviewsmall,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800),
                                                                textScaleFactor:
                                                                    SizeConfig
                                                                        .textScaleFactor,
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 15.h,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                'reviewbig'.tr,
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
                                                              ),
                                                              SizedBox(
                                                                height: 5.h,
                                                              ),
                                                              Text(
                                                                statisticsController
                                                                    .numberReviewbig,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800),
                                                                textScaleFactor:
                                                                    SizeConfig
                                                                        .textScaleFactor,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                'tlawa'.tr,
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
                                                              ),
                                                              SizedBox(
                                                                height: 5.h,
                                                              ),
                                                              Text(
                                                                statisticsController
                                                                    .numberTlawa,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800),
                                                                textScaleFactor:
                                                                    SizeConfig
                                                                        .textScaleFactor,
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Card(
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            side: const BorderSide(
                                                width: 2, color: Colors.white)),
                                        color: Colors.white,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 12.h, horizontal: 12.w),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'sum_of_the_faces'.tr,
                                                      style: TextStyle(
                                                          color: Get
                                                              .theme.primaryColor,
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.w800),
                                                      textScaleFactor: SizeConfig
                                                          .textScaleFactor,
                                                    ),
                                                    SizedBox(
                                                      height: 15.h,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                'listen'.tr,
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
                                                              ),
                                                              SizedBox(
                                                                height: 5.h,
                                                              ),
                                                              Text(
                                                                statisticsController
                                                                    .sumListen,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800),
                                                                textScaleFactor:
                                                                    SizeConfig
                                                                        .textScaleFactor,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                'reviewsmall'.tr,
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
                                                              ),
                                                              SizedBox(
                                                                height: 5.h,
                                                              ),
                                                              Text(
                                                                statisticsController
                                                                    .sumReviewsmall,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800),
                                                                textScaleFactor:
                                                                    SizeConfig
                                                                        .textScaleFactor,
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 15.h,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                'reviewbig'.tr,
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
                                                              ),
                                                              SizedBox(
                                                                height: 5.h,
                                                              ),
                                                              Text(
                                                                statisticsController
                                                                    .sumReviewbig,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800),
                                                                textScaleFactor:
                                                                    SizeConfig
                                                                        .textScaleFactor,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                'tlawa'.tr,
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
                                                              ),
                                                              SizedBox(
                                                                height: 5.h,
                                                              ),
                                                              Text(
                                                                statisticsController
                                                                    .sumTlawa,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800),
                                                                textScaleFactor:
                                                                    SizeConfig
                                                                        .textScaleFactor,
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Card(
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            side: const BorderSide(
                                                width: 2, color: Colors.white)),
                                        color: Colors.white,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 12.h, horizontal: 12.w),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'students'.tr,
                                                      style: TextStyle(
                                                          color: Get
                                                              .theme.primaryColor,
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.w800),
                                                      textScaleFactor: SizeConfig
                                                          .textScaleFactor,
                                                    ),
                                                    SizedBox(
                                                      height: 15.h,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                'most_attended_students'
                                                                    .tr,
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
                                                              ),
                                                              SizedBox(
                                                                height: 5.h,
                                                              ),
                                                              statisticsController
                                                                      .listStudentsMostPresent
                                                                      .isEmpty
                                                                  ? Text(
                                                                      'there_is_no'.tr,
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize: 14
                                                                              .sp,
                                                                          fontWeight:
                                                                              FontWeight.w800),
                                                                      textScaleFactor:
                                                                          SizeConfig
                                                                              .textScaleFactor,
                                                                    )
                                                                  : Column(crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        ...statisticsController.listStudentsMostPresent
                                                                            .map((e) => Text(
                                                                                  '${statisticsController.listStudentsMostPresent.indexOf(e)+1} - ${e.nameStudent} - ( ${'episode'.tr} : ${e.nameEpisode} ) - ( ${e.mostNumber} ${'day'.tr} ) ' ,
                                                                                  style: TextStyle(color: Colors.black, fontSize: 12.sp,height: 1.5, fontWeight: FontWeight.w800),
                                                                                  textScaleFactor: SizeConfig.textScaleFactor,
                                                                                ))
                                                                      ],
                                                                    ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 15.h,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                'most_late_students'
                                                                    .tr,
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
                                                              ),
                                                              SizedBox(
                                                                height: 5.h,
                                                              ),
                                                              statisticsController
                                                                      .listStudentsMostDelay
                                                                      .isEmpty
                                                                  ? Text(
                                                                      'there_is_no'.tr,
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize: 14
                                                                              .sp,
                                                                          fontWeight:
                                                                              FontWeight.w800),
                                                                      textScaleFactor:
                                                                          SizeConfig
                                                                              .textScaleFactor,
                                                                    )
                                                                  : Column(crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        ...statisticsController.listStudentsMostDelay
                                                                            .map((e) => Text(
                                                                                  '${statisticsController.listStudentsMostDelay.indexOf(e)+1} - ${e.nameStudent} - ( ${'episode'.tr} : ${e.nameEpisode} ) - ( ${e.mostNumber} ${'day'.tr} ) ' ,
                                                                                  style: TextStyle(color: Colors.black, fontSize: 12.sp,height: 1.5, fontWeight: FontWeight.w800),
                                                                                  textScaleFactor: SizeConfig.textScaleFactor,
                                                                                ))
                                                                      ],
                                                                    ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 15.h,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                'most_absent_students'
                                                                    .tr,
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
                                                              ),
                                                              SizedBox(
                                                                height: 5.h,
                                                              ),
                                                              statisticsController
                                                                      .listStudentsMostAbsent
                                                                      .isEmpty
                                                                  ? Text(
                                                                      'there_is_no'.tr,
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize: 14
                                                                              .sp,
                                                                          fontWeight:
                                                                              FontWeight.w800),
                                                                      textScaleFactor:
                                                                          SizeConfig
                                                                              .textScaleFactor,
                                                                    )
                                                                  : Column(crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        ...statisticsController.listStudentsMostAbsent
                                                                            .map((e) => Text(
                                                                                  '${statisticsController.listStudentsMostAbsent.indexOf(e)+1} - ${e.nameStudent} - ( ${'episode'.tr} : ${e.nameEpisode} ) - ( ${e.mostNumber} ${'day'.tr} ) ' ,
                                                                                  style: TextStyle(color: Colors.black, fontSize: 12.sp,height: 1.5, fontWeight: FontWeight.w800),
                                                                                  textScaleFactor: SizeConfig.textScaleFactor,
                                                                                ))
                                                                      ],
                                                                    ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ]),
                            )))
              ]);
            }))));
  }
}
