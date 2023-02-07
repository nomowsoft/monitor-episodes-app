import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:monitor_episodes/model/core/educational/educational.dart';
import 'package:monitor_episodes/model/core/educational/educational_plan.dart';
import 'package:monitor_episodes/model/core/episodes/check_students_responce.dart';
import 'package:monitor_episodes/model/core/episodes/student_of_episode.dart';
import 'package:monitor_episodes/model/core/episodes/student_state.dart';
import 'package:monitor_episodes/model/core/listen_line/listen_line.dart';
import 'package:monitor_episodes/model/core/plan_lines/mistakes_plan_line.dart';
import 'package:monitor_episodes/model/core/plan_lines/plan_line.dart';
import 'package:monitor_episodes/model/core/plan_lines/plan_lines.dart';
import 'package:monitor_episodes/model/core/quran/surah.dart';
import 'package:monitor_episodes/model/core/shared/constants.dart';
import 'package:monitor_episodes/model/core/shared/status_and_types.dart';
import 'package:monitor_episodes/model/core/user/auth_model.dart';
import 'package:monitor_episodes/model/services/educational_plan_service.dart';
import 'package:monitor_episodes/model/services/listen_line_service.dart';
import 'package:monitor_episodes/model/services/plan_lines_service.dart';
import 'package:monitor_episodes/model/services/upload_service.dart';
import 'package:monitor_episodes/model/services/students_of_episode_service.dart';
import 'package:monitor_episodes/model/services/teacher_service.dart';
import '../main.dart';
import '../model/core/episodes/check_student_work_responce.dart';
import '../model/core/episodes/check_episode.dart';
import '../model/core/episodes/episode.dart';
import '../model/core/shared/response_content.dart';
import '../model/data/database_helper.dart';
import '../model/services/check_episode_service.dart';
import '../model/services/episodes_service.dart';
import '../ui/shared/utils/custom_dailogs.dart';
import '../ui/shared/utils/waitting_dialog.dart';
import '../ui/views/data_initialization/data_initialization.dart';
import '../ui/views/home/home.dart';
import 'data_sync_controller.dart';

class HomeController extends GetxController {
  int _currentPageIndex = 1;
  int _currentIndex = 1;
  TeacherModel? _teacher;
  late bool _gettingEpisodes,
      _gettingStudentsOfEpisode,
      _gettingPlanLines,
      _gettingEducationalPlan;
  List<Episode> _listEpisodes = [];
  List<StudentOfEpisode> _listStudentsOfEpisode = [];
  PlanLines? planLines;
  EducationalPlan? educationalPlan;

  @override
  void onInit() async {
    // ignore: todo
    // TODO: implement onInit
    super.onInit();
    initFilds();
    loadData();
    await getTeacherLocal();
  }

  initFilds() {
    _gettingEpisodes = false;
    _gettingStudentsOfEpisode = false;
    _gettingPlanLines = false;
    _gettingEducationalPlan = false;
  }

  Future loadData() async {
    loadEpisodes();
  }

  //methods
  Future getTeacherLocal() async {
    _teacher = await TeacherService().getUserLocal;
    update();
  }

  Future removeTeacherLocal() async {
    _teacher = await TeacherService().removeTeacherLocal();
    update();
  }

  Future<bool> addEdisode(Episode episode, {bool isFromCheck = false}) async {
    bool result = await EdisodesService()
        .setEdisodeLocal(episode, isFromCheck: isFromCheck);
    if (!isFromCheck) {
      //uplodeToServer
      sendToTheServerFunction();
    }

    loadEpisodes();
    return result;
  }

  Future<bool> editEdisode(Episode episode) async {
    bool result = await EdisodesService().updateEdisode(episode);
    //uplodeToServer
    sendToTheServerFunction();
    loadEpisodes();
    return result;
  }

  Future<bool> deleteEdisode(Episode episode,
      {bool isFromCheck = false}) async {
    try {
      await PlanLinesService().deleteAllPlanLinesOfEpisode(episode.id!);
      await EducationalPlanService()
          .deleteAllEducationalPlansOfEpisode(episode.id!);

      List<StudentOfEpisode> listStudentOfEpisode =
          await StudentsOfEpisodeService()
                  .getStudentsOfEpisodeLocal(episode.id!) ??
              [];
      if (listStudentOfEpisode.isNotEmpty) {
        for (var student in listStudentOfEpisode) {
          //Student State
          await StudentsOfEpisodeService()
              .deleteStudentStateOfEp(student.id ?? 0);
          await ListenLineService().deleteListenLineStudent(student.id ?? 0);
        }
      }
      await StudentsOfEpisodeService().deleteStudentsOfEpisode(episode.id!);
      await EdisodesService().deletedEpisode(episode.id!,
          ids: episode.ids, isFromCheck: isFromCheck);

      //uplodeToServer
      if (!isFromCheck) {
        sendToTheServerFunction();
      }
      loadEpisodes();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future deleteAllEdisodes() async {
    List<Episode>? listEpisodes =
        await EdisodesService().getEdisodesLocal() ?? [];
    for (var episode in listEpisodes) {
      await deleteEdisode(episode);
    }
  }

  Future<bool> addStudent(
      StudentOfEpisode studentOfEpisode, PlanLines planLines, int episodeId,
      {bool isFromCheck = false}) async {
    bool studentResult = await StudentsOfEpisodeService().setStudentOfEpisode(
        studentOfEpisode, planLines,
        isFromCheck: isFromCheck);
    //===
    var stuId = await StudentsOfEpisodeService().getLastStudentsLocal();
    planLines.studentId = stuId!.id;
    //===
    bool planLinesResult =
        await PlanLinesService().setPlanLinesLocal(planLines);

    if (!isFromCheck) {
      //uplodeToServer
      sendToTheServerFunction();
      loadStudentsOfEpisode(episodeId);
    }
    return studentResult && planLinesResult;
  }

  Future<bool> editStudent(StudentOfEpisode studentOfEpisode,
      PlanLines planLines, int episodeId) async {
    bool studentResult = await StudentsOfEpisodeService()
        .updateStudentsOfEpisodeLocal(studentOfEpisode, planLines);
    bool planLinesResult =
        await PlanLinesService().updatePlanLinesLocal(planLines);
    if (studentResult && planLinesResult) {
      int index = _listStudentsOfEpisode
          .indexWhere((element) => element.id == studentOfEpisode.id);
      _listStudentsOfEpisode[index] = studentOfEpisode;
      //uplodeToServer
      sendToTheServerFunction();
      loadPlanLines(episodeId, studentOfEpisode.id!);
      //loadEducationalPlan(episodeId,studentOfEpisode.id!);
    }

    update();
    return studentResult && planLinesResult;
  }

  Future<bool> deleteStudent(int episodeId, int id,
      {int? ids, bool isFromCheck = false}) async {
    try {
      // await EducationalPlanService().deleteAllEducationalPlansOfStudent(id);
      // await PlanLinesService().deleteAllPlanLinesOfStudent(id);
      // // Student State
      // await StudentsOfEpisodeService().deleteStudentStateOfEp(id);
      // await ListenLineService().deleteListenLineStudent(id);
      await StudentsOfEpisodeService()
          .deleteStudent(id, ids: ids ?? id, isFromCheck: isFromCheck);
      if (!isFromCheck) {
        //uplodeToServer
        sendToTheServerFunction();
      }

      update();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future deleteStudentFromList(int indexDelete) async {
    _listStudentsOfEpisode.removeAt(indexDelete);
    update();
  }

  Future loadEpisodes({bool isInit = false}) async {
    if (isInit) {
      _gettingEpisodes = true;
    } else {
      gettingEpisodes = true;
    }
    List<Episode>? listEpisodes = await EdisodesService().getEdisodesLocal();
    if (listEpisodes != null) {
      _listEpisodes = List<Episode>.from(listEpisodes);
    }
    if (isInit) {
      _gettingEpisodes = false;
    } else {
      gettingEpisodes = false;
    }
    update();
  }

  Future loadStudentsOfEpisode(int episodeId, {bool isInit = false}) async {
    if (isInit) {
      _gettingStudentsOfEpisode = true;
    } else {
      gettingStudentsOfEpisode = true;
    }
    List<StudentOfEpisode> listStudentOfEpisode =
        await StudentsOfEpisodeService().getStudentsOfEpisodeLocal(episodeId) ??
            [];
    for (int i = 0; i < listStudentOfEpisode.length; i++) {
      listStudentOfEpisode[i].state = listStudentOfEpisode[i].stateDate ==
              DateFormat('yyyy-MM-dd').format(DateTime.now())
          ? listStudentOfEpisode[i].state
          : 'student_preparation'.tr;
    }
    // listStudentOfEpisode.forEach((element) async {
    //   element.state =
    //       element.stateDate == DateFormat('yyyy-MM-dd').format(DateTime.now())
    //           ? element.state
    //           : 'student_preparation'.tr;
    // });
    _listStudentsOfEpisode = List<StudentOfEpisode>.from(listStudentOfEpisode);

    if (isInit) {
      _gettingStudentsOfEpisode = false;
    } else {
      gettingStudentsOfEpisode = false;
    }
    update();
  }

  //check studentListen & attendances

  void checkStudentListenLineAndAttendances(
      int? studentId, int episodeId) async {
    if (await sendToTheServerFunction()) {
      var worksIds = await ListenLineService()
          .getListenLinesLocalIdsForStudent(studentId!);
      var attendancesIds =
          await StudentsOfEpisodeService().getStateLocalForStudent(studentId);
      var stuIds = await StudentsOfEpisodeService().getStudent(studentId);

      ResponseContent checkStudentsWorksResponse =
          await StudentsOfEpisodeService().checkStudentListenLineAndAttendances(
              stuIds!.ids!, studentId, worksIds, attendancesIds, episodeId);
      if (checkStudentsWorksResponse.isSuccess ||
          checkStudentsWorksResponse.isNoContent) {
        CheckStudentsWorkResponce checkWorks = checkStudentsWorksResponse.data;
        if (checkWorks.update) {
          if (await CostomDailogs.dialogWithText(
              text: 'student_episode_data_is_being_updated'.tr)) {
            bool isCompleted = await Get.dialog(cupertino.Builder(
                builder: (cupertino.BuildContext dialogContext) {
              changeStudentsWorksAndAttendances(
                  checkWorks, dialogContext, episodeId);
              return cupertino.WillPopScope(
                onWillPop: () async {
                  return false;
                },
                child: const cupertino.CupertinoAlertDialog(
                  content: WaitingDialog(),
                ),
              );
            }));
            if (!isCompleted) {
              CostomDailogs.warringDialogWithGet(
                  msg: 'failed_to_upload_changes'.tr);
            } else {
              loadStudentsOfEpisode(episodeId);

              // Get.offAll(() => const SplashScreen(),
              //     duration: const Duration(seconds: 2),
              //     curve: cupertino.Curves.easeInOut,
              //     transition: Transition.fadeIn);
            }
          }
        }
      }
    }
  }

  // check student
  void checkStudent(int episodeId) async {
    if (await sendToTheServerFunction()) {
      List<StudentOfEpisode> listStudentOfEpisode =
          await StudentsOfEpisodeService()
                  .getStudentsOfEpisodeLocal(episodeId) ??
              [];
      var epiIds = await EdisodesService().getEpisode(episodeId);
      ResponseContent checkStudentsResponse =
          await StudentsOfEpisodeService().checkStudents(
        epiIds!.ids!,
        listStudentOfEpisode.isNotEmpty
            ? listStudentOfEpisode.map((e) => e.ids ?? 0).toList()
            : [],
      );
      if (checkStudentsResponse.isSuccess ||
          checkStudentsResponse.isNoContent) {
        CheckStudentsResponce checkStudents = checkStudentsResponse.data;

        if (checkStudents.update) {
          if (await CostomDailogs.dialogWithText(
              text: 'student_episode_data_is_being_updated'.tr)) {
            bool isCompleted = await Get.dialog(cupertino.Builder(
                builder: (cupertino.BuildContext dialogContext) {
              changeStudents(checkStudents, dialogContext, episodeId);
              return cupertino.WillPopScope(
                onWillPop: () async {
                  return false;
                },
                child: const cupertino.CupertinoAlertDialog(
                  content: WaitingDialog(),
                ),
              );
            }));
            if (!isCompleted) {
              CostomDailogs.warringDialogWithGet(
                  msg: 'failed_to_upload_changes'.tr);
            } else {
              loadStudentsOfEpisode(episodeId);

              // Get.offAll(() => const SplashScreen(),
              //     duration: const Duration(seconds: 2),
              //     curve: cupertino.Curves.easeInOut,
              //     transition: Transition.fadeIn);
            }
          }
        }
      }
    }
  }

  //change work and attendances
  void changeStudentsWorksAndAttendances(CheckStudentsWorkResponce checkWorks,
      cupertino.BuildContext dialogContext, int episodeId) async {
    final navigator = cupertino.Navigator.of(dialogContext);
    bool isCompleted = true;
    if (checkWorks.listenLine.isNotEmpty) {
      late PlanLines? planLinesStudent;
      try {
        planLinesStudent = await PlanLinesService()
            .getPlanLinesLocal(episodeId, checkWorks.listenLine[0].studentId);

        List<ListenLine> hifz = [], morajaS = [], morajaB = [], tilawa = [];
        for (var listenLine in checkWorks.listenLine) {
          await addListenLineFromCheck(listenLine.typeFollow,
              listenLine.studentId, episodeId, listenLine);
          switch (listenLine.typeFollow) {
            case 'listen':
              hifz.add(listenLine);
              break;
            case 'reviewsmall':
              morajaS.add(listenLine);
              break;
            case 'reviewbig':
              morajaB.add(listenLine);
              break;
            case 'tlawa':
              tilawa.add(listenLine);
              break;
            default:
          }
        }
        if (hifz.isNotEmpty) {
          planLinesStudent!.listen = getPlanLine(hifz.last);
        }
        if (morajaS.isNotEmpty) {
          planLinesStudent!.reviewsmall = getPlanLine(morajaS.last);
        }
        if (morajaB.isNotEmpty) {
          planLinesStudent!.reviewbig = getPlanLine(morajaB.last);
        }
        if (tilawa.isNotEmpty) {
          planLinesStudent!.tlawa = getPlanLine(tilawa.last);
        }
        await PlanLinesService().updatePlanLinesLocal(planLinesStudent!);
        if (planLines?.studentId == planLinesStudent.studentId) {
          planLines = planLinesStudent;
        }
      } catch (e) {
        isCompleted = false;
      }
    }
    if (checkWorks.studentState.isNotEmpty) {
      try {
        for (var studentsState in checkWorks.studentState) {
          await setAttendance(
              episodeId, studentsState.state, studentsState.studentId,
              studentState: studentsState);
          // StudentsOfEpisodeService()
          //     .setStudentStateLocal(studentsState, isFromCheck: true);
        }
      } catch (e) {
        isCompleted = false;
      }
    }
    update();
    navigator.pop(isCompleted);
  }

  //change student
  changeStudents(CheckStudentsResponce checkStudentsResponce,
      cupertino.BuildContext buildContext, int episodeId) async {
    final navigator = cupertino.Navigator.of(buildContext);
    bool isCompleted = true;
    if (checkStudentsResponce.deletedStudentsIds.isNotEmpty) {
      try {
        for (var id in checkStudentsResponce.deletedStudentsIds) {
          await deleteStudent(episodeId, id, isFromCheck: true);
          // PlanLinesService().deleteAllPlanLinesOfStudent(id);
        }
      } catch (e) {
        isCompleted = false;
      }
    }

    if (checkStudentsResponce.newStudents.isNotEmpty) {
      try {
        for (var studetnt in checkStudentsResponce.newStudents) {
          var studentOfEpisode = StudentOfEpisode(
              episodeId: episodeId,
              ids: studetnt.id,
              name: studetnt.name,
              state: studetnt.state);
          var planLines =
              PlanLines(episodeId: episodeId, studentId: studetnt.id);
          if (studetnt.isHifz) {
            planLines.listen = PlanLine.fromDefault();
          }
          if (studetnt.isBigReview) {
            planLines.reviewbig = PlanLine.fromDefault();
          }
          if (studetnt.isSmallReview) {
            planLines.reviewsmall = PlanLine.fromDefault();
          }
          if (studetnt.isTilawa) {
            planLines.tlawa = PlanLine.fromDefault();
          }
          isCompleted = await addStudent(studentOfEpisode, planLines, episodeId,
              isFromCheck: true);
        }
      } catch (e) {
        isCompleted = false;
      }
    }
    navigator.pop(isCompleted);
  }

  Future loadPlanLines(int episodeId, int id, {bool isInit = false}) async {
    if (isInit) {
      _gettingPlanLines = true;
    } else {
      gettingPlanLines = true;
    }
    PlanLines? planLinesLocal =
        await PlanLinesService().getPlanLinesLocal(episodeId, id);
    if (planLinesLocal != null) {
      planLines = planLinesLocal;
    } else {
      planLines = null;
    }
    if (isInit) {
      _gettingPlanLines = false;
    } else {
      gettingPlanLines = false;
    }
    update();
  }

  Future loadEducationalPlan(int episodeId, int id,
      {bool isInit = false}) async {
    if (isInit) {
      _gettingEducationalPlan = true;
    } else {
      gettingEducationalPlan = true;
    }
    EducationalPlan newEducationalPlan =
        await EducationalPlanService().getEducationalPlanLocal(episodeId, id);
    educationalPlan = newEducationalPlan;
    if (isInit) {
      _gettingEducationalPlan = false;
    } else {
      gettingEducationalPlan = false;
    }
    update();
  }

  initStudntData() {
    planLines = null;
    educationalPlan = null;
  }

  Future<ResponseContent> setAttendance(int episodeId, String filter, int id,
      {StudentState? studentState}) async {
    ResponseContent studentStateResponse = ResponseContent();
    await StudentsOfEpisodeService().setStudentStateLocal(
        studentState ??
            StudentState(
                date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                episodeId: episodeId,
                studentId: id,
                state: filter),
        isFromCheck: studentState != null);

    if (studentState == null) {
      // Send To The Server
      sendToTheServerFunction();
    }

    if (studentState == null) {
      int index =
          _listStudentsOfEpisode.indexWhere((element) => element.id == id);
      if (index >= 0) {
        _listStudentsOfEpisode[index].state = filter.tr;
        _listStudentsOfEpisode[index].stateDate =
            DateFormat('yyyy-MM-dd').format(DateTime.now());
        await StudentsOfEpisodeService()
            .updateStudentsOfEpisodeLocal(_listStudentsOfEpisode[index], null);
      }
    } else {
      if (studentState.date ==
          DateFormat('yyyy-MM-dd').format(DateTime.now())) {
        int index =
            _listStudentsOfEpisode.indexWhere((element) => element.id == id);
        if (index >= 0) {
          _listStudentsOfEpisode[index].state = studentState.state.tr;
          _listStudentsOfEpisode[index].stateDate = studentState.date;
          await StudentsOfEpisodeService().updateStudentsOfEpisodeLocal(
              _listStudentsOfEpisode[index], null);
        }
      }
    }
    studentStateResponse = ResponseContent(statusCode: '200', success: true);

    update();
    return studentStateResponse;
  }

  /// Follow _ up
  changeFromSuraPlanLine(Surah surah, String planLine) {
    if (PlanLinesType.listen == planLine) {
      planLines!.listen!.fromSuraName = surah.name;
      planLines!.listen!.fromAya = 1;
    } else if (PlanLinesType.reviewsmall == planLine) {
      planLines!.reviewsmall!.fromSuraName = surah.name;
      planLines!.reviewsmall!.fromAya = 1;
    } else if (PlanLinesType.reviewbig == planLine) {
      planLines!.reviewbig!.fromSuraName = surah.name;
      planLines!.reviewbig!.fromAya = 1;
    } else if (PlanLinesType.tlawa == planLine) {
      planLines!.tlawa!.fromSuraName = surah.name;
      planLines!.tlawa!.fromAya = 1;
    }
    update();
  }

  changeToSuraPlanLine(Surah surah, String planLine) {
    if (PlanLinesType.listen == planLine) {
      planLines!.listen!.toSuraName = surah.name;
      planLines!.listen!.toAya = planLines!.listen!.fromSuraName == surah.name
          ? planLines!.listen!.fromAya
          : 1;
    } else if (PlanLinesType.reviewsmall == planLine) {
      planLines!.reviewsmall!.toSuraName = surah.name;
      planLines!.reviewsmall!.toAya =
          planLines!.reviewsmall!.fromSuraName == surah.name
              ? planLines!.reviewsmall!.fromAya
              : 1;
    } else if (PlanLinesType.reviewbig == planLine) {
      planLines!.reviewbig!.toSuraName = surah.name;
      planLines!.reviewbig!.toAya =
          planLines!.reviewbig!.fromSuraName == surah.name
              ? planLines!.reviewbig!.fromAya
              : 1;
    } else if (PlanLinesType.tlawa == planLine) {
      planLines!.tlawa!.toSuraName = surah.name;
      planLines!.tlawa!.toAya = planLines!.tlawa!.fromSuraName == surah.name
          ? planLines!.tlawa!.fromAya
          : 1;
    }
    update();
  }

  changeFromAyaPlanLine(int aya, String planLine) {
    if (PlanLinesType.listen == planLine) {
      planLines!.listen!.fromAya = aya;
    } else if (PlanLinesType.reviewsmall == planLine) {
      planLines!.reviewsmall!.fromAya = aya;
    } else if (PlanLinesType.reviewbig == planLine) {
      planLines!.reviewbig!.fromAya = aya;
    } else if (PlanLinesType.tlawa == planLine) {
      planLines!.tlawa!.fromAya = aya;
    }
    update();
  }

  changeToAyaPlanLine(int aya, String planLine) {
    if (PlanLinesType.listen == planLine) {
      planLines!.listen!.toAya = aya;
    } else if (PlanLinesType.reviewsmall == planLine) {
      planLines!.reviewsmall!.toAya = aya;
    } else if (PlanLinesType.reviewbig == planLine) {
      planLines!.reviewbig!.toAya = aya;
    } else if (PlanLinesType.tlawa == planLine) {
      planLines!.tlawa!.toAya = aya;
    }
    update();
  }

  addNote(String planLine, Mistakes mistakes) {
    if (PlanLinesType.listen == planLine) {
      planLines!.listen!.mistakes = mistakes;
    } else if (PlanLinesType.reviewsmall == planLine) {
      planLines!.reviewsmall!.mistakes = mistakes;
    } else if (PlanLinesType.reviewbig == planLine) {
      planLines!.reviewbig!.mistakes = mistakes;
    } else if (PlanLinesType.tlawa == planLine) {
      planLines!.tlawa!.mistakes = mistakes;
    }
    update();
  }

  addListenLine(String typePlanLine, int id, int episodeId,
      {ListenLine? newListenLine}) async {
    late PlanLine planLine;
    late ListenLine listenLine;
    if (newListenLine == null) {
      if (PlanLinesType.listen == typePlanLine) {
        planLine = planLines!.listen!;
      } else if (PlanLinesType.reviewsmall == typePlanLine) {
        planLine = planLines!.reviewsmall!;
      } else if (PlanLinesType.reviewbig == typePlanLine) {
        planLine = planLines!.reviewbig!;
      } else if (PlanLinesType.tlawa == typePlanLine) {
        planLine = planLines!.tlawa!;
      }

      listenLine = ListenLine(
          studentId: id,
          actualDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
          typeFollow: getTypePlanLine(typePlanLine),
          fromSuraId: Constants.listSurah
              .firstWhere((element) => element.name == planLine.fromSuraName)
              .id,
          toSuraId: Constants.listSurah
              .firstWhere((element) => element.name == planLine.toSuraName)
              .id,
          fromAya: planLine.fromAya,
          toAya: planLine.toAya,
          totalMstkQty: planLine.mistakes?.totalMstkQty ?? 0,
          totalMstkRead: planLine.mistakes?.totalMstkRead ?? 0);
    } else {
      listenLine = newListenLine;
      planLine = PlanLine(
          fromSuraName: getSuraName(newListenLine.fromSuraId),
          fromAya: newListenLine.fromAya,
          toAya: newListenLine.toAya,
          toSuraName: getSuraName(newListenLine.toSuraId),
          mistake: 0,
          mistakes: Mistakes(
              totalMstkQty: newListenLine.totalMstkQty,
              totalMstkRead: newListenLine.totalMstkRead));
    }
    ResponseContent responseContent = ResponseContent();
    await ListenLineService()
        .setListenLineLocal(listenLine, isFromCheck: newListenLine != null);
    responseContent = ResponseContent(success: true, statusCode: '200');

    if (responseContent.isSuccess) {
      if (newListenLine == null) {
        // send to the server
        sendToTheServerFunction();
      }

      Educational educational = Educational(
        actualDate: DateTime.tryParse(listenLine.actualDate),
        fromAya: listenLine.fromAya,
        toAya: listenLine.toAya,
        fromSuraName: planLine.fromSuraName,
        toSuraName: planLine.toSuraName,
        totalMstkQty: planLine.mistakes?.totalMstkQty ?? 0,
        totalMstkRead: planLine.mistakes?.totalMstkRead ?? 0,
      );

      // ResponseDataListenLine? dataListenLine = responseContent.data;

      if (PlanLinesType.listen == typePlanLine) {
        planLines!.listen!.fromSuraName = Constants.listVerse
                    .where((element) =>
                        element.surahId ==
                        Constants.listSurah
                            .firstWhere((element) =>
                                element.name == planLine.toSuraName)
                            .id)
                    .last
                    .originalSurahOrder ==
                planLines!.listen!.toAya
            ? Constants.listSurah.last.name == planLine.toSuraName
                ? Constants.listSurah.first.name
                : Constants
                    .listSurah[Constants.listSurah.indexWhere(
                            (element) => element.name == planLine.toSuraName) +
                        1]
                    .name
            : planLines!.listen!.toSuraName;

        planLines!.listen!.fromAya = Constants.listVerse
                    .where((element) =>
                        element.surahId ==
                        Constants.listSurah
                            .firstWhere((element) =>
                                element.name == planLine.toSuraName)
                            .id)
                    .last
                    .originalSurahOrder ==
                planLines!.listen!.toAya
            ? 1
            : planLines!.listen!.toAya + 1;
        planLines!.listen!.toSuraName = '';
        planLines!.listen!.toAya = 0;
        planLines!.listen!.mistakes = null;
        await PlanLinesService().updatePlanLinesLocal(planLines!);
        // educationlPlan
        if (newListenLine == null && educationalPlan != null) {
          educationalPlan!.planListen.add(educational);
          await EducationalPlanService()
              .setEducationalPlanLocal(educationalPlan!);
        } else {
          EducationalPlan newEducationalPlan = await EducationalPlanService()
              .getEducationalPlanLocal(episodeId, id);
          newEducationalPlan.planListen.add(educational);
          await EducationalPlanService()
              .setEducationalPlanLocal(newEducationalPlan);
        }
      } else if (PlanLinesType.reviewsmall == typePlanLine) {
        planLines!.reviewsmall!.fromSuraName = Constants.listVerse
                    .where((element) =>
                        element.surahId ==
                        Constants.listSurah
                            .firstWhere((element) =>
                                element.name == planLine.toSuraName)
                            .id)
                    .last
                    .originalSurahOrder ==
                planLines!.reviewsmall!.toAya
            ? Constants.listSurah.last.name == planLine.toSuraName
                ? Constants.listSurah.first.name
                : Constants
                    .listSurah[Constants.listSurah.indexWhere(
                            (element) => element.name == planLine.toSuraName) +
                        1]
                    .name
            : planLines!.reviewsmall!.toSuraName;
        planLines!.reviewsmall!.fromAya = Constants.listVerse
                    .where((element) =>
                        element.surahId ==
                        Constants.listSurah
                            .firstWhere((element) =>
                                element.name == planLine.toSuraName)
                            .id)
                    .last
                    .originalSurahOrder ==
                planLines!.reviewsmall!.toAya
            ? 1
            : planLines!.reviewsmall!.toAya + 1;
        planLines!.reviewsmall!.toSuraName = '';
        planLines!.reviewsmall!.toAya = 0;
        planLines!.reviewsmall!.mistakes = null;
        await PlanLinesService().updatePlanLinesLocal(planLines!);
        // educationlPlan
        if (newListenLine == null && educationalPlan != null) {
          educationalPlan!.planReviewSmall.add(educational);
          await EducationalPlanService()
              .setEducationalPlanLocal(educationalPlan!);
        } else {
          EducationalPlan newEducationalPlan = await EducationalPlanService()
              .getEducationalPlanLocal(episodeId, id);
          newEducationalPlan.planReviewSmall.add(educational);
          await EducationalPlanService()
              .setEducationalPlanLocal(newEducationalPlan);
        }
      } else if (PlanLinesType.reviewbig == typePlanLine) {
        planLines!.reviewbig!.fromSuraName = Constants.listVerse
                    .where((element) =>
                        element.surahId ==
                        Constants.listSurah
                            .firstWhere((element) =>
                                element.name == planLine.toSuraName)
                            .id)
                    .last
                    .originalSurahOrder ==
                planLines!.reviewbig!.toAya
            ? Constants.listSurah.last.name == planLine.toSuraName
                ? Constants.listSurah.first.name
                : Constants
                    .listSurah[Constants.listSurah.indexWhere(
                            (element) => element.name == planLine.toSuraName) +
                        1]
                    .name
            : planLines!.reviewbig!.toSuraName;
        planLines!.reviewbig!.fromAya = Constants.listVerse
                    .where((element) =>
                        element.surahId ==
                        Constants.listSurah
                            .firstWhere((element) =>
                                element.name == planLine.toSuraName)
                            .id)
                    .last
                    .originalSurahOrder ==
                planLines!.reviewbig!.toAya
            ? 1
            : planLines!.reviewbig!.toAya + 1;
        planLines!.reviewbig!.toSuraName = '';
        planLines!.reviewbig!.toAya = 0;
        planLines!.reviewbig!.mistakes = null;
        await PlanLinesService().updatePlanLinesLocal(planLines!);
        // educationlPlan
        if (newListenLine == null && educationalPlan != null) {
          educationalPlan!.planReviewbig.add(educational);
          await EducationalPlanService()
              .setEducationalPlanLocal(educationalPlan!);
        } else {
          EducationalPlan newEducationalPlan = await EducationalPlanService()
              .getEducationalPlanLocal(episodeId, id);
          newEducationalPlan.planReviewbig.add(educational);
          await EducationalPlanService()
              .setEducationalPlanLocal(newEducationalPlan);
        }
      } else if (PlanLinesType.tlawa == typePlanLine) {
        planLines!.tlawa!.fromSuraName = Constants.listVerse
                    .where((element) =>
                        element.surahId ==
                        Constants.listSurah
                            .firstWhere((element) =>
                                element.name == planLine.toSuraName)
                            .id)
                    .last
                    .originalSurahOrder ==
                planLines!.tlawa!.toAya
            ? Constants.listSurah.last.name == planLine.toSuraName
                ? Constants.listSurah.first.name
                : Constants
                    .listSurah[(Constants.listSurah.indexWhere(
                            (element) => element.name == planLine.toSuraName) +
                        1)]
                    .name
            : planLines!.tlawa!.toSuraName;
        planLines!.tlawa!.fromAya = Constants.listVerse
                    .where((element) =>
                        element.surahId ==
                        Constants.listSurah
                            .firstWhere((element) =>
                                element.name == planLine.toSuraName)
                            .id)
                    .last
                    .originalSurahOrder ==
                planLines!.tlawa!.toAya
            ? 1
            : planLines!.tlawa!.toAya + 1;
        planLines!.tlawa!.toSuraName = '';
        planLines!.tlawa!.toAya = 0;
        planLines!.tlawa!.mistakes = null;
        await PlanLinesService().updatePlanLinesLocal(planLines!);
        // educationlPlan
        if (newListenLine == null && educationalPlan != null) {
          educationalPlan!.planTlawa.add(educational);
          await EducationalPlanService()
              .setEducationalPlanLocal(educationalPlan!);
        } else {
          EducationalPlan newEducationalPlan = await EducationalPlanService()
              .getEducationalPlanLocal(episodeId, id);
          newEducationalPlan.planTlawa.add(educational);
          await EducationalPlanService()
              .setEducationalPlanLocal(newEducationalPlan);
        }
      }
      if (newListenLine == null) {
        int index =
            _listStudentsOfEpisode.indexWhere((element) => element.id == id);

        if (index >= 0) {
          if (_listStudentsOfEpisode[index].state == 'student_preparation'.tr) {
            setAttendance(_listStudentsOfEpisode[index].episodeId!, 'present',
                _listStudentsOfEpisode[index].id!);
            // _listStudentsOfEpisode[index].state = 'present'.tr;
            // _listStudentsOfEpisode[index].stateDate =
            //     DateFormat('yyyy-MM-dd').format(DateTime.now());
            // await StudentsOfEpisodeService()
            //     .updateStudentsOfEpisodeLocal(_listStudentsOfEpisode[index],null);
            // await StudentsOfEpisodeService().setStudentStateLocal(StudentState(
            //     date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
            //     episodeId: _listStudentsOfEpisode[index].episodeId!,
            //     studentId: id,
            //     state: 'present'));
          }
        }
      }
    }
    update();

    return responseContent;
  }

  String getTypePlanLine(String typePlanLine) {
    if (PlanLinesType.listen == typePlanLine) {
      return 'listen';
    } else if (PlanLinesType.reviewsmall == typePlanLine) {
      return 'review_small';
    } else if (PlanLinesType.reviewbig == typePlanLine) {
      return 'review_big';
    } else if (PlanLinesType.tlawa == typePlanLine) {
      return 'tlawa';
    }
    return '';
  }

  //Check halaqat
  Future checkHalaqat() async {
    if (await sendToTheServerFunction()) {
      var listId = await EdisodesService().getEdisodesLocal();
      ResponseContent checkHalaqatResponse = await CheckEpisodeService()
          .postCheckhalaqat(listId!.map((e) => e.ids ?? 0).toList());
      if (checkHalaqatResponse.isSuccess || checkHalaqatResponse.isNoContent) {
        CheckEpisode checkEpisode = checkHalaqatResponse.data;
        if (checkEpisode.update!) {
          if (await CostomDailogs.dialogWithText(
              text: 'episode_data_is_being_updated'.tr)) {
            bool isCompleted = await Get.dialog(cupertino.Builder(
                builder: (cupertino.BuildContext dialogContext) {
              changeHalaqat(
                checkEpisode,
                dialogContext,
              );
              return cupertino.WillPopScope(
                onWillPop: () async {
                  return false;
                },
                child: const cupertino.CupertinoAlertDialog(
                  content: WaitingDialog(),
                ),
              );
            }));
            if (!isCompleted) {
              CostomDailogs.warringDialogWithGet(
                  msg: 'failed_to_upload_changes'.tr);
            } else {
              loadEpisodes();
            }
          }
        }
      }
    }
  }

  //change  Halaqat
  changeHalaqat(
    CheckEpisode checkEpisode,
    cupertino.BuildContext buildContext,
  ) async {
    final navigator = cupertino.Navigator.of(buildContext);
    bool isCompleted = true;
    if (checkEpisode.deletedHalaqat!.isNotEmpty) {
      try {
        for (var id in checkEpisode.deletedHalaqat!) {
          await deleteEdisode(
              Episode(id: id, epsdType: '', name: '', displayName: ''),
              isFromCheck: true);
        }
      } catch (e) {
        isCompleted = false;
      }
    }

    if (checkEpisode.newHalaqat!.isNotEmpty) {
      try {
        for (NewHalaqat halaqaa in checkEpisode.newHalaqat!) {
          for (Students studetnt in halaqaa.students ?? []) {
            for (NewWorks newWorks in studetnt.newWorks ?? []) {
              var lise =
                  ListenLine.fromJsonServer(newWorks.toJson(), studetnt.id!);
              addListenLineFromCheck(lise.typeFollow, studetnt.id!, halaqaa.id!,
                  lise); // var newWorkStudetnt =
            }
            for (NewAttendances newAttendances
                in studetnt.newAttendances ?? []) {
              setAttendance(halaqaa.id!, studetnt.state!, studetnt.id!,
                  studentState: StudentState(
                      studentId: studetnt.id!,
                      episodeId: halaqaa.id!,
                      state: newAttendances.status!,
                      date: newAttendances.datePresence!));
            }

            var studentOfEpisode = StudentOfEpisode(
                episodeId: halaqaa.id,
                id: studetnt.id,
                name: studetnt.name ?? '',
                state: studetnt.state ?? '');

            var planLines =
                PlanLines(episodeId: halaqaa.id, studentId: studetnt.id);
            if (studetnt.isHifz!) {
              planLines.listen = PlanLine.fromDefault();
            }
            if (studetnt.isBigReview!) {
              planLines.reviewbig = PlanLine.fromDefault();
            }
            if (studetnt.isSmallReview!) {
              planLines.reviewsmall = PlanLine.fromDefault();
            }
            if (studetnt.isTilawa!) {
              planLines.tlawa = PlanLine.fromDefault();
            }
            isCompleted = await addStudent(
                studentOfEpisode, planLines, halaqaa.id!,
                isFromCheck: true);
          }
          isCompleted = await addEdisode(
              Episode(
                  displayName: halaqaa.name.toString(),
                  name: halaqaa.name.toString(),
                  epsdType: halaqaa.epsdType.toString(),
                  id: halaqaa.id),
              isFromCheck: true);
        }
      } catch (e) {
        isCompleted = false;
      }
    }
    navigator.pop(isCompleted);
  }
  //

  // Future checkHalaqat() async {
  //   if (await sendToTheServerFunction()) {
  //     var listId = await EdisodesService().getEdisodesLocal();
  //     ResponseContent checkHalaqatResponse = await CheckEpisodeService()
  //         .postCheckhalaqat(listId!.map((e) => e.id ?? 0).toList());
  //     if (checkHalaqatResponse.isSuccess || checkHalaqatResponse.isNoContent) {
  //       try {
  //         checkEpisode = checkHalaqatResponse.data;
  //         if (checkEpisode?.update == true) {
  //           // Add Edisode
  //           final listAddEdisode =
  //               List<NewHalaqat>.from(checkEpisode?.newHalaqat ?? []);
  //           int numberEdisode;
  //           for (numberEdisode = 0;
  //               numberEdisode < listAddEdisode.length;
  //               numberEdisode++) {
  //             addEdisode(
  //                 Episode(
  //                     displayName:
  //                         listAddEdisode[numberEdisode].name.toString(),
  //                     name: listAddEdisode[numberEdisode].name.toString(),
  //                     epsdType:
  //                         listAddEdisode[numberEdisode].typeEpisode.toString(),
  //                     id: listAddEdisode[numberEdisode].id),
  //                 isFromCheck: true);
  //             for (int i = 0; i < listAddEdisode[i].students!.length; i++) {
  //               var studentOfEpisode = StudentOfEpisode(
  //                 episodeId: listAddEdisode[numberEdisode].id!.toInt(),
  //                 name: listAddEdisode[numberEdisode]
  //                     .students![i]
  //                     .name
  //                     .toString(),
  //                 state: listAddEdisode[numberEdisode]
  //                     .students![i]
  //                     .state
  //                     .toString(),
  //               );
  //               int idStedent = listAddEdisode[numberEdisode].id!.toInt();
  //               var plalinLines = PlanLines(
  //                   episodeId: listAddEdisode[numberEdisode].id!.toInt(),
  //                   studentId: listAddEdisode[numberEdisode].students![i].id);
  //               if (listAddEdisode[numberEdisode].students![i].isHifz == true) {
  //                 plalinLines.listen = PlanLine.fromDefault();
  //               } else if (listAddEdisode[numberEdisode]
  //                       .students![i]
  //                       .isTilawa ==
  //                   true) {
  //                 plalinLines.tlawa = PlanLine.fromDefault();
  //               } else if (listAddEdisode[numberEdisode]
  //                       .students![i]
  //                       .isSmallReview ==
  //                   true) {
  //                 plalinLines.reviewsmall = PlanLine.fromDefault();
  //               } else if (listAddEdisode[numberEdisode]
  //                       .students![i]
  //                       .isBigReview ==
  //                   true) {
  //                 plalinLines.reviewbig = PlanLine.fromDefault();
  //               }
  //               addStudent(studentOfEpisode, plalinLines, idStedent,
  //                   isFromCheck: true);
  //             }
  //           }

  //           // !! delete data
  //           final list = List<int>.from(checkEpisode?.deletedHalaqat ?? []);
  //           for (int i = 0; i < list.length; i++) {
  //             deleteEdisode(
  //                 Episode(id: list[i], epsdType: '', name: '', displayName: ''),
  //                 isFromCheck: true);
  //           }

  //           await CostomDailogs.dialogWithText(
  //               text: 'episode_data_is_being_updated'.tr);
  //         }
  //       } catch (e) {
  //         CostomDailogs.warringDialogWithGet(
  //             msg: 'failed_to_upload_changes'.tr);
  //       }
  //       //show masage

  //       // if (checkEpisode?.update == true) {
  //       //   loadEpisodes();
  //       //   if (await CostomDailogs.dialogWithText(
  //       //       text: 'episode_data_is_being_updated'.tr)) {
  //       //     // Get.offAll(() => const DataInitialization(),
  //       //     //     duration: const Duration(seconds: 2),
  //       //     //     curve: Curves.easeInOut,
  //       //     //     transition: Transition.fadeIn);

  //       //   } else {
  //       //     CostomDailogs.warringDialogWithGet(
  //       //         msg: 'failed_to_upload_changes'.tr);
  //       //   }

  //     }
  //   }

  // bool result = await CostomDailogs.yesNoDialogWithText(
  //     text: 'new_update_is_available'.tr);
  // if (result) {
  //   Get.offAll(() => const DataInitialization(),
  //       duration: const Duration(seconds: 2),
  //       curve: Curves.easeInOut,
  //       transition: Transition.fadeIn);
  // } else {
  //   exit(0);
  // }
  // }

  addListenLineFromCheck(String typePlanLine, int id, int episodeId,
      ListenLine newListenLine) async {
    late PlanLine planLine;
    late ListenLine listenLine;
    listenLine = newListenLine;
    planLine = PlanLine(
        fromSuraName: getSuraName(newListenLine.fromSuraId),
        fromAya: newListenLine.fromAya,
        toAya: newListenLine.toAya,
        toSuraName: getSuraName(newListenLine.toSuraId),
        mistake: 0,
        mistakes: Mistakes(
            totalMstkQty: newListenLine.totalMstkQty,
            totalMstkRead: newListenLine.totalMstkRead));

    ResponseContent responseContent = ResponseContent();
    await ListenLineService().setListenLineLocal(listenLine, isFromCheck: true);
    responseContent = ResponseContent(success: true, statusCode: '200');
    if (responseContent.isSuccess) {
      Educational educational = Educational(
        actualDate: DateTime.tryParse(listenLine.actualDate),
        fromAya: listenLine.fromAya,
        toAya: listenLine.toAya,
        fromSuraName: planLine.fromSuraName,
        toSuraName: planLine.toSuraName,
        totalMstkQty: planLine.mistakes?.totalMstkQty ?? 0,
        totalMstkRead: planLine.mistakes?.totalMstkRead ?? 0,
      );
      EducationalPlan newEducationalPlan =
          await EducationalPlanService().getEducationalPlanLocal(episodeId, id);
      if (PlanLinesType.listen == typePlanLine) {
        newEducationalPlan.planListen.add(educational);
      } else if (PlanLinesType.reviewsmall == typePlanLine) {
        newEducationalPlan.planReviewSmall.add(educational);
      } else if (PlanLinesType.reviewbig == typePlanLine) {
        newEducationalPlan.planReviewbig.add(educational);
      } else if (PlanLinesType.tlawa == typePlanLine) {
        newEducationalPlan.planTlawa.add(educational);
      }
      await EducationalPlanService()
          .setEducationalPlanLocal(newEducationalPlan);
    }
    update();

    return responseContent;
  }

  PlanLine getPlanLine(ListenLine listenLine) {
    PlanLine planLine = PlanLine.fromDefault();
    planLine.fromSuraName = Constants.listVerse
                .where((element) =>
                    element.surahId ==
                    Constants.listSurah
                        .firstWhere((element) =>
                            element.name == getSuraName(listenLine.toSuraId))
                        .id)
                .last
                .originalSurahOrder ==
            listenLine.toAya
        ? Constants.listSurah.last.name == getSuraName(listenLine.toSuraId)
            ? Constants.listSurah.first.name
            : Constants
                .listSurah[Constants.listSurah.indexWhere((element) =>
                        element.name == getSuraName(listenLine.toSuraId)) +
                    1]
                .name
        : getSuraName(listenLine.toSuraId);

    planLine.fromAya = Constants.listVerse
                .where((element) =>
                    element.surahId ==
                    Constants.listSurah
                        .firstWhere((element) =>
                            element.name == getSuraName(listenLine.toSuraId))
                        .id)
                .last
                .originalSurahOrder ==
            listenLine.toAya
        ? 1
        : listenLine.toAya + 1;
    planLine.toSuraName = '';
    planLine.toAya = 0;
    planLine.mistakes = null;

    return planLine;
  }

  // setter
  set currentIndex(int index) => {_currentIndex = index, update()};
  set currentPageIndex(int index) => {_currentPageIndex = index, update()};
  set gettingEpisodes(bool val) => {_gettingEpisodes = val, update()};
  set gettingStudentsOfEpisode(bool val) =>
      {_gettingStudentsOfEpisode = val, update()};
  set gettingPlanLines(bool val) => {_gettingPlanLines = val, update()};
  set gettingEducationalPlan(bool val) =>
      {_gettingEducationalPlan = val, update()};

  //geter
  int get currentIndex => _currentIndex;
  int get currentPageIndex => _currentPageIndex;
  TeacherModel? get teacher => _teacher;
  bool get gettingEpisodes => _gettingEpisodes;
  bool get gettingStudentsOfEpisode => _gettingStudentsOfEpisode;
  bool get gettingPlanLines => _gettingPlanLines;
  bool get gettingEducationalPlan => _gettingEducationalPlan;
  List<Episode> get listEpisodes => _listEpisodes;
  List<StudentOfEpisode> get listStudentsOfEpisode => _listStudentsOfEpisode;

  //upload to the server method ===========================================================
  Future sendToTheServerFunction() async {
    late bool isCompleteEpisodeOperation,
        isCompleteStudentOperation,
        isCompleteStudentAttendance,
        isCompleteStudentWork;
    final dbHelper = DatabaseHelper.instance;
    // get episode logs
    var allEpisodeLogs =
        await UploadService().getOperationOfEpisodeLogs(dbHelper);
    // upload episode
    isCompleteEpisodeOperation =
        await UploadService().uploadEpisode(allEpisodeLogs, dbHelper);

    if (isCompleteEpisodeOperation) {
      // get student logs
      var allStudentLogs =
          await UploadService().getOperationOfStudentLogs(dbHelper);
      // upload student
      isCompleteStudentOperation =
          await UploadService().uploadStudent(allStudentLogs, dbHelper);

      if (isCompleteStudentOperation) {
        // get student Attendance logs
        var allStudentAttendanceLogs =
            await UploadService().getStudentAttendanceLogs(dbHelper);
        // upload student Attendance
        isCompleteStudentAttendance = await UploadService()
            .uploadStudentAttendance(allStudentAttendanceLogs, dbHelper);

        if (isCompleteStudentAttendance) {
          // get student Work logs

          var allStudentWorkLogs =
              await UploadService().getStudentWorkLogs(dbHelper);
          // upload student Work
          isCompleteStudentWork = await UploadService()
              .uploadStudentWork(allStudentWorkLogs, dbHelper);
        }
      }
    }

    if (isCompleteEpisodeOperation &&
        isCompleteStudentOperation &&
        isCompleteStudentAttendance &&
        isCompleteStudentWork) {
      return true;
    } else {
      return false;
    }
  }
  //upload to the server method ===========================================================

}
