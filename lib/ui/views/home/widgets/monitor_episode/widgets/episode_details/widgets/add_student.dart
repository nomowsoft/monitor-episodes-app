import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:monitor_episodes/controller/home_controller.dart';
import 'package:monitor_episodes/model/core/countries/country.dart';
import 'package:monitor_episodes/model/core/episodes/episode.dart';
import 'package:monitor_episodes/model/core/episodes/student_of_episode.dart';
import 'package:monitor_episodes/model/core/plan_lines/plan_line.dart';
import 'package:monitor_episodes/model/core/plan_lines/plan_lines.dart';
import 'package:monitor_episodes/model/core/shared/constants.dart';
import 'package:monitor_episodes/model/core/shared/globals/size_config.dart';
import 'package:monitor_episodes/model/core/shared/status_and_types.dart';
import 'package:monitor_episodes/model/services/episodes_service.dart';
import 'package:monitor_episodes/model/services/plan_lines_service.dart';
import 'package:monitor_episodes/model/services/students_of_episode_service.dart';
import 'package:monitor_episodes/ui/shared/utils/validator.dart';
import 'package:monitor_episodes/ui/views/home/widgets/monitor_episode/widgets/episode_details/widgets/select_episode.dart';

import 'select_country.dart';

class AddStudent extends StatefulWidget {
  final int? episodeId;
  final StudentOfEpisode? student;
  const AddStudent({super.key, this.episodeId, this.student});

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController episode = TextEditingController();
  late bool listen, reviewsmall, reviewbig, tlawa;
  late String gender;
  late PlanLines planLinesLocal;
  List genders = ['male'.tr, 'female'.tr];
  final formKey = GlobalKey<FormState>();
  List listReadOnly = [];
  bool get getSelectCourses => listen || reviewsmall || reviewbig || tlawa;
  bool get isEdit => widget.student != null;
  List<Episode> listEpisodes = [];
  Episode? selectEpisode;

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    if (widget.episodeId == null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        listEpisodes = await EdisodesService().getEdisodesLocal() ?? [];
        episode.text = listEpisodes.isEmpty ? '' : listEpisodes[0].name;
        selectEpisode = listEpisodes.isEmpty ? null : listEpisodes[0];
      });
    }

    if (isEdit) {
      name.text = widget.student!.name;
      phone.text = widget.student!.phone;
      country.text = widget.student!.country;
      gender = widget.student!.gender.tr;
      listen = true;
      reviewsmall = false;
      reviewbig = false;
      tlawa = false;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        PlanLines? planLines = await PlanLinesService()
            .getPlanLinesLocal(widget.student!.episodeId!, widget.student!.id!);
        planLinesLocal = planLines!;
        listen = planLines.listen != null;
        reviewsmall = planLines.reviewsmall != null;
        reviewbig = planLines.reviewbig != null;
        tlawa = planLines.tlawa != null;
        if (listen) {
          listReadOnly.add(PlanLinesType.listen);
        }
        if (reviewsmall) {
          listReadOnly.add(PlanLinesType.reviewsmall);
        }
        if (reviewbig) {
          listReadOnly.add(PlanLinesType.reviewbig);
        }
        if (tlawa) {
          listReadOnly.add(PlanLinesType.tlawa);
        }

        setState(() {});
      });
    } else {
      gender = genders[0];
      country.text = Constants.listCountries
          .firstWhere((element) => element.code == 'SA')
          .name;
      listen = true;
      reviewsmall = false;
      reviewbig = false;
      tlawa = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      builder: (HomeController homeController) => WillPopScope(
        onWillPop: () async {
          if (MediaQuery.of(context).viewInsets.bottom == 0.0) {
           return await true;
          } else {
            FocusScope.of(context).unfocus();
            return await false;
          }
        },
        child: Form(
          key: formKey,
          child: GestureDetector(
            onTap: (){
               FocusScope.of(context).unfocus();
            },
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
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          isEdit ? 'edit_student'.tr : 'add_student'.tr,
                          style: TextStyle(
                              color: Get.theme.primaryColor,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w800),
                          textScaleFactor: SizeConfig.textScaleFactor,
                        ),
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
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.name,
                            keyboardAppearance: Brightness.light,
                            validator: Validator.nameValidator,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                      widget.episodeId == null
                          ? Column(
                              children: [
                                SizedBox(
                                  height: 10.h,
                                ),
                                // Episode
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'episode'.tr,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500),
                                      textScaleFactor:
                                          SizeConfig.textScaleFactor,
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        Episode? episode = await showDialog(
                                          context: context,
                                          builder: (contextDialog) =>
                                              AlertDialog(
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      15.0))),
                                                  contentPadding:
                                                      const EdgeInsets.all(15),
                                                  content: SelectEpisode(
                                                    listEpisode: listEpisodes,
                                                  )),
                                        );
                                        if (episode != null) {
                                          setEpisode = episode;
                                        }
                                      },
                                      child: AbsorbPointer(
                                        absorbing: true,
                                        child: TextFormField(
                                          textInputAction: TextInputAction.next,
                                          keyboardType: TextInputType.name,
                                          keyboardAppearance: Brightness.light,
                                          validator: Validator.episodeValidator,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          controller: episode,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Colors.white,
                                              suffixIcon: Icon(
                                                Icons.keyboard_arrow_down,
                                                color: Get.theme.primaryColor,
                                              )),
                                          onChanged: (val) {},
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : const SizedBox(),
                      SizedBox(
                        height: 10.h,
                      ),

                      ///phone
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'phone'.tr,
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
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.phone,
                            keyboardAppearance: Brightness.light,
                            controller: phone,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'enter_phone'.tr,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),

                      /// address
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'country'.tr,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500),
                            textScaleFactor: SizeConfig.textScaleFactor,
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          GestureDetector(
                            onTap: () async {
                              Country? country = await showDialog(
                                context: context,
                                builder: (contextDialog) => const AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15.0))),
                                    contentPadding: EdgeInsets.all(15),
                                    content: SelectCountry()),
                              );
                              if (country != null) {
                                setCountry = country.name;
                              }
                            },
                            child: AbsorbPointer(
                              absorbing: true,
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.name,
                                keyboardAppearance: Brightness.light,
                                controller: country,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    suffixIcon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Get.theme.primaryColor,
                                    )),
                                onChanged: (val) {},
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: 10.h,
                      ),
                      //gender
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
                                    'gender'.tr,
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
                                            color: Get
                                                .theme.secondaryHeaderColor
                                                .withOpacity(0.8),
                                            //  shape: BoxShape.circle,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  gender,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  maxLines: 1,
                                                  textScaleFactor: SizeConfig
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
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              itemBuilder: (context) => [
                                ...genders.map(
                                  (e) => PopupMenuItem(
                                    padding: EdgeInsets.zero,
                                    value: e,
                                    height: 50.h,
                                    child: Column(
                                      children: [
                                        Center(
                                          child: Text(
                                            e,
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
                                setGender = value;
                              },
                            ),
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          const Expanded(child: SizedBox()

                              //     ///age
                              //     Column(
                              //   mainAxisAlignment: MainAxisAlignment.start,
                              //   crossAxisAlignment: CrossAxisAlignment.start,
                              //   children: [
                              //     Text(
                              //       'age'.tr,
                              //       style: TextStyle(
                              //           color: Colors.black,
                              //           fontSize: 14.sp,
                              //           fontWeight: FontWeight.w500),
                              //       textScaleFactor: SizeConfig.textScaleFactor,
                              //     ),
                              //     SizedBox(
                              //       height: 5.h,
                              //     ),
                              //     TextFormField(
                              //       textInputAction: TextInputAction.next,
                              //       keyboardType: TextInputType.number,
                              //       keyboardAppearance: Brightness.light,
                              //       inputFormatters: [
                              //         FilteringTextInputFormatter.digitsOnly
                              //       ],
                              //       controller: age,
                              //       validator: Validator.ageValidator,
                              //       autovalidateMode:
                              //           AutovalidateMode.onUserInteraction,
                              //       style: TextStyle(
                              //           color: Colors.black,
                              //           fontSize: 14.sp,
                              //           fontWeight: FontWeight.w500),
                              //       decoration: InputDecoration(
                              //         filled: true,
                              //         fillColor: Colors.white,
                              //         hintText: 'enter_age'.tr,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              )
                        ],
                      ),

                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        children: [
                          Text(
                            'courses_student'.tr,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500),
                            textScaleFactor: SizeConfig.textScaleFactor,
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          !getSelectCourses
                              ? Text(
                                  'select_one_courses_student'.tr,
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500),
                                  textScaleFactor: SizeConfig.textScaleFactor,
                                )
                              : const SizedBox(),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    AbsorbPointer(
                                      absorbing: listReadOnly.any((element) =>
                                          element == PlanLinesType.listen),
                                      child: Checkbox(
                                          value: listen,
                                          activeColor: listReadOnly.any(
                                                  (element) =>
                                                      element ==
                                                      PlanLinesType.listen)
                                              ? Get.theme.secondaryHeaderColor
                                                  .withOpacity(0.5)
                                              : Get.theme.secondaryHeaderColor,
                                          onChanged: onChangedListen),
                                    ),
                                    Text(
                                      'hifz'.tr,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500),
                                      textScaleFactor:
                                          SizeConfig.textScaleFactor,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    AbsorbPointer(
                                      absorbing: listReadOnly.any((element) =>
                                          element == PlanLinesType.reviewbig),
                                      child: Checkbox(
                                          value: reviewbig,
                                          activeColor: listReadOnly.any(
                                                  (element) =>
                                                      element ==
                                                      PlanLinesType.reviewbig)
                                              ? Get.theme.secondaryHeaderColor
                                                  .withOpacity(0.5)
                                              : Get.theme.secondaryHeaderColor,
                                          onChanged: onChangedReviewbig),
                                    ),
                                    Text(
                                      'mourajaa_g'.tr,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500),
                                      textScaleFactor:
                                          SizeConfig.textScaleFactor,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    AbsorbPointer(
                                      absorbing: listReadOnly.any((element) =>
                                          element == PlanLinesType.reviewsmall),
                                      child: Checkbox(
                                          value: reviewsmall,
                                          activeColor: listReadOnly.any(
                                                  (element) =>
                                                      element ==
                                                      PlanLinesType.reviewsmall)
                                              ? Get.theme.secondaryHeaderColor
                                                  .withOpacity(0.5)
                                              : Get.theme.secondaryHeaderColor,
                                          onChanged: onChangedReviewsmall),
                                    ),
                                    Text(
                                      'mourajaa_s'.tr,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500),
                                      textScaleFactor:
                                          SizeConfig.textScaleFactor,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    AbsorbPointer(
                                      absorbing: listReadOnly.any((element) =>
                                          element == PlanLinesType.tlawa),
                                      child: Checkbox(
                                          value: tlawa,
                                          activeColor: listReadOnly.any(
                                                  (element) =>
                                                      element ==
                                                      PlanLinesType.tlawa)
                                              ? Get.theme.secondaryHeaderColor
                                                  .withOpacity(0.5)
                                              : Get.theme.secondaryHeaderColor,
                                          onChanged: onChangedTlawa),
                                    ),
                                    Text(
                                      'tilawa'.tr,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500),
                                      textScaleFactor:
                                          SizeConfig.textScaleFactor,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),

                      SizedBox(
                        height: 20.h,
                      ),
                      InkWell(
                        onTap: (() async {
                          if ((formKey.currentState?.validate() ?? false) &&
                              getSelectCourses) {
                            bool result;
                            StudentOfEpisode studentOfEpisode;
                            PlanLines planLines;
                            if (!isEdit) {
                              studentOfEpisode = StudentOfEpisode(
                                episodeId: (widget.episodeId == null
                                    ? selectEpisode!.id
                                    : widget.episodeId!),
                                name: name.text,
                                phone: phone.text,
                                country: country.text,
                                gender: gender,
                                state: "تحضير الطالب",
                                stateDate: DateFormat('yyyy-MM-dd')
                                    .format(DateTime.now()),
                              );

                              planLines = PlanLines(
                                  episodeId: (widget.episodeId == null
                                      ? selectEpisode!.id
                                      : widget.episodeId!),
                                  studentId: studentOfEpisode.id);
                              if (listen) {
                                planLines.listen = PlanLine.fromDefault();
                              }
                              if (reviewbig) {
                                planLines.reviewbig = PlanLine.fromDefault();
                              }
                              if (reviewsmall) {
                                planLines.reviewsmall = PlanLine.fromDefault();
                              }
                              if (tlawa) {
                                planLines.tlawa = PlanLine.fromDefault();
                              }
                              result = await homeController.addStudent(
                                  studentOfEpisode,
                                  planLines,
                                  (widget.episodeId == null
                                      ? selectEpisode!.id
                                      : widget.episodeId!)!);
                            } else {
                              studentOfEpisode = StudentOfEpisode(
                                episodeId: (widget.episodeId == null
                                    ? selectEpisode!.id
                                    : widget.episodeId!),
                                id: widget.student!.id,
                                ids: widget.student!.ids,
                                name: name.text,
                                phone: phone.text,
                                country: country.text,
                                gender: gender,
                                state: widget.student!.state,
                                stateDate: widget.student!.stateDate,
                              );
                              planLines = planLinesLocal;
                              if (!listReadOnly.any((element) =>
                                      element == PlanLinesType.listen) &&
                                  listen) {
                                planLines.listen = PlanLine.fromDefault();
                              }
                              if (!listReadOnly.any((element) =>
                                      element == PlanLinesType.reviewbig) &&
                                  reviewbig) {
                                planLines.reviewbig = PlanLine.fromDefault();
                              }
                              if (!listReadOnly.any((element) =>
                                      element == PlanLinesType.reviewsmall) &&
                                  reviewsmall) {
                                planLines.reviewsmall = PlanLine.fromDefault();
                              }
                              if (!listReadOnly.any((element) =>
                                      element == PlanLinesType.tlawa) &&
                                  tlawa) {
                                planLines.tlawa = PlanLine.fromDefault();
                              }
                              result = await homeController.editStudent(
                                  studentOfEpisode,
                                  planLines,
                                  (widget.episodeId == null
                                      ? selectEpisode!.id
                                      : widget.episodeId!)!);
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
        ),
      ),
    );
  }

  set setGender(String setGender) {
    setState(() {
      gender = setGender;
    });
  }

  set setCountry(String setCountry) {
    setState(() {
      country.text = setCountry;
    });
  }

  set setEpisode(Episode newEpisode) {
    setState(() {
      episode.text = newEpisode.name;
      selectEpisode = newEpisode;
    });
  }

  void onChangedListen(bool? value) {
    setState(() {
      listen = value ?? false;
    });
  }

  void onChangedReviewbig(bool? value) {
    setState(() {
      reviewbig = value ?? false;
    });
  }

  void onChangedReviewsmall(bool? value) {
    setState(() {
      reviewsmall = value ?? false;
    });
  }

  void onChangedTlawa(bool? value) {
    setState(() {
      tlawa = value ?? false;
    });
  }
}
