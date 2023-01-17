import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monitor_episodes/controller/home_controller.dart';
import 'package:monitor_episodes/model/core/episodes/episode.dart';
import 'package:monitor_episodes/model/core/shared/globals/size_config.dart';
import 'package:monitor_episodes/model/core/shared/status_and_types.dart';
import 'package:monitor_episodes/ui/shared/utils/custom_dailogs.dart';
import 'package:monitor_episodes/ui/shared/utils/waitting_dialog.dart';
import 'package:monitor_episodes/ui/shared/widgets/buttons/custom_list_button_underlined.dart';
import 'package:monitor_episodes/ui/shared/widgets/color_loader/color_loader.dart';
import 'package:monitor_episodes/ui/views/home/widgets/monitor_episode/widgets/episode_details/widgets/add_student.dart';

import '../../../../../../../model/core/shared/response_content.dart';
import 'widgets/educational_plan/educational_plan.dart';
import 'widgets/follow_up.dart/follow_up.dart';

class EpisodeDetails extends StatefulWidget {
  final Episode episode;
  const EpisodeDetails({Key? key, required this.episode}) : super(key: key);

  @override
  State<EpisodeDetails> createState() => _EpisodeDetailsState();
}

class _EpisodeDetailsState extends State<EpisodeDetails> {
  int selectIndex = 0;
  int indextab = 0;
  List<String> tabs = [
    'follow_up'.tr,
    'educational_plan'.tr,
  ];
  List<String> listStudentStateType = [
    StudentStateType.present,
    StudentStateType.absent,
    StudentStateType.absentExcuse,
    StudentStateType.notRead,
    StudentStateType.excuse,
    StudentStateType.delay,
  ];
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    HomeController homeController = Get.find<HomeController>();
    homeController.initStudntData();
    homeController.loadStudentsOfEpisode(widget.episode.id, isInit: true);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      builder: (HomeController homeController) => Scaffold(
          appBar: AppBar(
            backgroundColor: Get.theme.primaryColor,
            title: Text(
              widget.episode.displayName,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800),
              textScaleFactor: SizeConfig.textScaleFactor,
            ),
            titleSpacing: 2,
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: (() {
                  Get.back();
                }),
                icon: Icon(
                  Icons.keyboard_arrow_left_outlined,
                  color: Colors.white,
                  size: 30.sp,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.white,
          drawerEnableOpenDragGesture: !homeController.gettingStudentsOfEpisode,
          drawer: Drawer(
              backgroundColor: Get.theme.primaryColor,
              child: SafeArea(
                child: OrientationBuilder(builder: (context, orientation) {
                  SizeConfig('initialSize')
                      .init(originalWidth: 428, originalHeight: 926);
                  return Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          'images/bgR2.png',
                          repeat: ImageRepeat.repeat,
                        ),
                      ),
                      Positioned.fill(
                          child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 15.w),
                                decoration: const BoxDecoration(
                                  color: Color(0xffF1F1F1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.person,
                                  color: Get.theme.secondaryHeaderColor,
                                  size: 35,
                                )),
                            SizedBox(
                              height: 15.h,
                            ),
                            Text(
                              widget.episode.name,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500),
                              textScaleFactor: SizeConfig.textScaleFactor,
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            Divider(
                                color: Colors.white,
                                indent: 20.w,
                                endIndent: 20.w),
                            SizedBox(
                              height: 10.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: InkWell(
                                onTap: (() async {
                                  Get.back();
                                  bool? result = await Get.dialog(
                                    AddStudent(episodeId: widget.episode.id),
                                    transitionDuration:
                                        const Duration(seconds: 1),
                                    transitionCurve: Curves.easeInOut,
                                  );
                                  if (result != null) {
                                    CostomDailogs.snackBar(
                                        response: ResponseContent(
                                            statusCode: '200',
                                            success: true,
                                            message: 'ok_add'.tr));
                                  }
                                }),
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Get.theme.secondaryHeaderColor
                                            .withOpacity(.7),
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
                                      'add_student'.tr,
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
                            SizedBox(
                              height: 10.h,
                            ),
                            Divider(
                                color: Colors.white,
                                indent: 20.w,
                                endIndent: 20.w),
                            Expanded(
                                child: ListView.separated(
                                    itemBuilder: (_, index) => InkWell(
                                          onTap: () {
                                            setState(() {
                                              selectIndex = index;
                                            });
                                            homeController.initStudntData();
                                            if (indextab == 0) {
                                              homeController.loadPlanLines(
                                                  widget.episode.id,
                                                  homeController
                                                      .listStudentsOfEpisode[
                                                          index]
                                                      .id!);
                                            } else {
                                              homeController.loadEducationalPlan(
                                                  widget.episode.id,
                                                  homeController
                                                      .listStudentsOfEpisode[
                                                          index]
                                                      .id!);
                                            }
                                            Get.back();
                                          },
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 6.h,
                                                horizontal: 10.w),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 6.h,
                                                horizontal: 10.w),
                                            decoration: BoxDecoration(
                                              color: Get
                                                  .theme.secondaryHeaderColor
                                                  .withOpacity(
                                                      selectIndex == index
                                                          ? 0.7
                                                          : 0.4),
                                              //  shape: BoxShape.circle,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10.h),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      homeController
                                                          .listStudentsOfEpisode[
                                                              index]
                                                          .name,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14.sp,
                                                          height: 1.5,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                      textScaleFactor:
                                                          SizeConfig
                                                              .textScaleFactor,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5.w,
                                                  ),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 6.h,
                                                            horizontal: 10.w),
                                                    decoration: BoxDecoration(
                                                      color: Get.theme
                                                          .secondaryHeaderColor,
                                                      //  shape: BoxShape.circle,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Text(
                                                      homeController
                                                          .listStudentsOfEpisode[
                                                              index]
                                                          .state
                                                          .tr,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                      textScaleFactor:
                                                          SizeConfig
                                                              .textScaleFactor,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                    separatorBuilder: (_, __) =>
                                        const SizedBox(),
                                    itemCount: homeController
                                        .listStudentsOfEpisode.length)),
                          ],
                        ),
                      )),
                    ],
                  );
                }),
              )),
          body: SafeArea(
              child: Stack(children: [
            Positioned.fill(
              child: Image.asset(
                'images/bgR2.png',
                repeat: ImageRepeat.repeat,
              ),
            ),
            Positioned.fill(
                child: homeController.gettingStudentsOfEpisode
                    ? const Center(
                        child: ColorLoader(),
                      )
                    : homeController.listStudentsOfEpisode.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'there_is_no_students'.tr,
                                  style: TextStyle(
                                      color: Get.theme.primaryColor,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w800),
                                  textScaleFactor: SizeConfig.textScaleFactor,
                                ),
                                SizedBox(
                                  height: 50.h,
                                ),
                                InkWell(
                                  onTap: (() async {
                                    bool? result = await Get.dialog(
                                      AddStudent(episodeId: widget.episode.id),
                                      transitionDuration:
                                          const Duration(seconds: 1),
                                      transitionCurve: Curves.easeInOut,
                                    );
                                    if (result != null) {
                                      CostomDailogs.snackBar(
                                          response: ResponseContent(
                                              statusCode: '200',
                                              success: true,
                                              message: 'ok_add'.tr));
                                    }
                                  }),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Get.theme.secondaryHeaderColor
                                              .withOpacity(.7),
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
                                        'add_student'.tr,
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
                              ],
                            ),
                          )
                        : Column(
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
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.w, vertical: 15.w),
                                        decoration: const BoxDecoration(
                                          color: Color(0xffF1F1F1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.person,
                                          color: Get.theme.secondaryHeaderColor,
                                          size: 35,
                                        )),
                                    SizedBox(
                                      width: 10.h,
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            homeController
                                                .listStudentsOfEpisode[
                                                    selectIndex]
                                                .name,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14.sp,
                                                height: 1.3,
                                                fontWeight: FontWeight.w500),
                                            textScaleFactor:
                                                SizeConfig.textScaleFactor,
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          PopupMenuButton<int>(
                                            padding: EdgeInsets.zero,
                                            child: Container(
                                              width: 150.w,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5.h,
                                                  horizontal: 10.w),
                                              decoration: BoxDecoration(
                                                color: Get
                                                    .theme.secondaryHeaderColor,
                                                //  shape: BoxShape.circle,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      homeController
                                                          .listStudentsOfEpisode[
                                                              selectIndex]
                                                          .state
                                                          .tr,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                      maxLines: 1,
                                                      textScaleFactor:
                                                          SizeConfig
                                                              .textScaleFactor,
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
                                            itemBuilder: (context) => [
                                              ...listStudentStateType.map(
                                                (e) => PopupMenuItem(
                                                  padding: EdgeInsets.zero,
                                                  value: listStudentStateType
                                                      .indexOf(e),
                                                  height: 50.h,
                                                  child: Column(
                                                    children: [
                                                      Center(
                                                        child: Text(
                                                          e.tr,
                                                          style: const TextStyle(
                                                              decoration:
                                                                  TextDecoration
                                                                      .none,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                          textScaleFactor:
                                                              SizeConfig
                                                                  .textScaleFactor,
                                                        ),
                                                      ),
                                                      // Divider(height: 20.h,thickness: 1.5,)
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                            onSelected: (value) async {
                                              if (homeController
                                                      .listStudentsOfEpisode[
                                                          selectIndex]
                                                      .state
                                                      .tr !=
                                                  listStudentStateType[value]
                                                      .tr) {
                                                ResponseContent response =
                                                    await showCupertinoDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            dialogContext) {
                                                          setAttendance(
                                                              listStudentStateType[
                                                                  value]);
                                                          return WillPopScope(
                                                            onWillPop:
                                                                () async {
                                                              return false;
                                                            },
                                                            child:
                                                                const CupertinoAlertDialog(
                                                              content:
                                                                  WaitingDialog(),
                                                            ),
                                                          );
                                                        });
                                                if (response.isSuccess ||
                                                    response.isNoContent) {
                                                  setState(() {});
                                                } else if (!response
                                                    .isErrorConnection) {
                                                  response.message =
                                                      'error_set_attendance'.tr;
                                                  CostomDailogs.snackBar(
                                                      response: response);
                                                } else {
                                                  CostomDailogs.snackBar(
                                                      response: response);
                                                }
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    PopupMenuButton<int>(
                                      child: Icon(
                                        Icons.more_vert,
                                        color: Get.theme.primaryColor,
                                        size: 30,
                                      ),
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          value: 1,
                                          height: 25.h,
                                          child: Center(
                                            child: Text(
                                              'edit'.tr,
                                              style: TextStyle(
                                                decoration: TextDecoration.none,
                                                color: Get
                                                    .theme.secondaryHeaderColor,
                                              ),
                                              textScaleFactor:
                                                  SizeConfig.textScaleFactor,
                                            ),
                                          ),
                                        ),
                                        const PopupMenuDivider(),
                                        PopupMenuItem(
                                          value: 2,
                                          height: 25.h,
                                          child: Center(
                                            child: Text(
                                              'delete'.tr,
                                              style: const TextStyle(
                                                decoration: TextDecoration.none,
                                                color: Colors.red,
                                              ),
                                              textScaleFactor:
                                                  SizeConfig.textScaleFactor,
                                            ),
                                          ),
                                        ),
                                      ],
                                      onSelected: (int value) async {
                                        if (value == 1) {
                                          //edit
                                          bool? result = await Get.dialog(
                                            AddStudent(
                                                episodeId: widget.episode.id,
                                                student: homeController
                                                        .listStudentsOfEpisode[
                                                    selectIndex]),
                                            transitionDuration:
                                                const Duration(seconds: 1),
                                            transitionCurve: Curves.easeInOut,
                                          );
                                          if (result != null) {
                                            CostomDailogs.snackBar(
                                                response: ResponseContent(
                                                    statusCode: '200',
                                                    success: true,
                                                    message: 'ok_edit'.tr));
                                          }
                                        } else {
                                          // delete
                                          if (await CostomDailogs
                                              .yesNoDialogWithText(
                                                  text:
                                                      '${'do_you_want_delete'.tr} ${homeController.listStudentsOfEpisode[selectIndex].name}')) {
                                            HomeController homeController =
                                                Get.find<HomeController>();
                                            bool result = await homeController
                                                .deleteStudent(
                                                    widget.episode.id,
                                                    homeController
                                                        .listStudentsOfEpisode[
                                                            selectIndex]
                                                        .id!);
                                            if (result) {
                                              int indexDelete = selectIndex;
                                              if (selectIndex > 0) {
                                                setState(() {
                                                  selectIndex = selectIndex - 1;
                                                });

                                                homeController.initStudntData();
                                                if (indextab == 0) {
                                                  homeController.loadPlanLines(
                                                      widget.episode.id,
                                                      homeController
                                                          .listStudentsOfEpisode[
                                                              selectIndex]
                                                          .id!);
                                                } else {
                                                  homeController
                                                      .loadEducationalPlan(
                                                          widget.episode.id,
                                                          homeController
                                                              .listStudentsOfEpisode[
                                                                  selectIndex]
                                                              .id!);
                                                }

                                                await homeController
                                                    .deleteStudentFromList(
                                                        indexDelete);
                                              } else {
                                                if (homeController
                                                        .listStudentsOfEpisode
                                                        .length >
                                                    1) {
                                                await homeController
                                                    .deleteStudentFromList(
                                                        indexDelete);
                                                 homeController.initStudntData();
                                                if (indextab == 0) {
                                                  homeController.loadPlanLines(
                                                      widget.episode.id,
                                                      homeController
                                                          .listStudentsOfEpisode[
                                                              selectIndex]
                                                          .id!);
                                                } else {
                                                  homeController
                                                      .loadEducationalPlan(
                                                          widget.episode.id,
                                                          homeController
                                                              .listStudentsOfEpisode[
                                                                  selectIndex]
                                                              .id!);
                                                }        
                                                }else{
                                                  await homeController
                                                    .deleteStudentFromList(
                                                        indexDelete);
                                                }
                                              }
                                            }

                                            CostomDailogs.snackBar(
                                                response: ResponseContent(
                                                    statusCode: '200',
                                                    success: true,
                                                    message: 'ok_delete'.tr));
                                          }
                                        }
                                      },
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Container(
                                color: Colors.white,
                                height: 50,
                                child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (_, index) =>
                                        CustomListButtonUnderlined(
                                          text: tabs[index],
                                          isSelected: indextab == index,
                                          onPressed: () {
                                            setState(() {
                                              indextab = index;
                                            });
                                          },
                                        ),
                                    separatorBuilder: (_, __) => const SizedBox(
                                          width: 10,
                                        ),
                                    itemCount: tabs.length),
                              ),
                              Expanded(
                                  child: indextab == 0
                                      ? FollowUp(
                                          episode: widget.episode,
                                          planId: homeController
                                              .listStudentsOfEpisode[
                                                  selectIndex]
                                              .episodeId!,
                                          id: homeController
                                              .listStudentsOfEpisode[
                                                  selectIndex]
                                              .id!,
                                        )
                                      : indextab == 1
                                          ? EducationalPlan(
                                              episode: widget.episode,
                                              id: homeController
                                                  .listStudentsOfEpisode[
                                                      selectIndex]
                                                  .id!)
                                          : const SizedBox())
                            ],
                          )),
          ]))),
    );
  }

  void setAttendance(String studentStateType) async {
    HomeController homeController = Get.find<HomeController>();
    ResponseContent responseContent = await homeController.setAttendance(
        homeController.listStudentsOfEpisode[selectIndex].episodeId!,
        studentStateType,
        homeController.listStudentsOfEpisode[selectIndex].id!);
    Get.back(result: responseContent);
  }
}
// tabs[index]