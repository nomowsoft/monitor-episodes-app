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
import 'package:monitor_episodes/model/services/students_of_episode_service.dart';
import 'package:monitor_episodes/model/services/teacher_service.dart';
import '../model/core/episodes/check_student_work_responce.dart';
import '../model/core/episodes/check_episode.dart';
import '../model/core/episodes/episode.dart';
import '../model/core/shared/response_content.dart';
import '../model/services/check_episode_service.dart';
import '../model/services/episodes_service.dart';
import '../ui/shared/utils/custom_dailogs.dart';
import '../ui/shared/utils/waitting_dialog.dart';
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
  CheckEpisode? checkEpisode;

  @override
  void onInit() async {
    // ignore: todo
    // TODO: implement onInit
    super.onInit();
    initFilds();
    loadData();
    await getTeacherLocal();
   Get.put(DataSyncController()); 
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

  Future<bool> addEdisode(Episode episode) async {
    bool result = await EdisodesService().setEdisodeLocal(episode);
    loadEpisodes();
    return result;
  }

  Future<bool> editEdisode(Episode episode) async {
    bool result = await EdisodesService().updateEdisode(episode);
    loadEpisodes();
    return result;
  }

  Future<bool> deleteEdisode(Episode episode) async {
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
      await EdisodesService().deletedEpisode(episode.id!);
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
    if (!isFromCheck) {
      var stuId = await StudentsOfEpisodeService().getLastStudentsLocal();
      planLines.studentId = stuId!.id;
    }
    bool planLinesResult =
        await PlanLinesService().setPlanLinesLocal(planLines);
    if (!isFromCheck) {
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
      loadPlanLines(episodeId, studentOfEpisode.id!);
      //loadEducationalPlan(episodeId,studentOfEpisode.id!);
    }
    update();
    return studentResult && planLinesResult;
  }

  Future<bool> deleteStudent(int episodeId, int id,
      {bool isFromCheck = false}) async {
    try {
      await EducationalPlanService().deleteAllEducationalPlansOfStudent(id);
      await PlanLinesService().deleteAllPlanLinesOfStudent(id);
      // Student State
      await StudentsOfEpisodeService().deleteStudentStateOfEp(id);
      await ListenLineService().deleteListenLineStudent(id);
      await StudentsOfEpisodeService().deleteStudent(id);
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
    var worksIds =
        await ListenLineService().getListenLinesLocalIdsForStudent(studentId!);
    var attendancesIds =
        await StudentsOfEpisodeService().getStateLocalForStudent(studentId);

    ResponseContent checkStudentsWorksResponse =
        await StudentsOfEpisodeService().checkStudentListenLineAndAttendances(
            studentId, worksIds, attendancesIds, episodeId);
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
                msg: 'error_get_PlanLine_students'.tr);
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

  // check student
  void checkStudent(int episodeId) async {
    List<StudentOfEpisode> listStudentOfEpisode =
        await StudentsOfEpisodeService().getStudentsOfEpisodeLocal(episodeId) ??
            [];
    ResponseContent checkStudentsResponse =
        await StudentsOfEpisodeService().checkStudents(
      episodeId,
      listStudentOfEpisode.isNotEmpty
          ? listStudentOfEpisode.map((e) => e.id ?? 0).toList()
          : [],
    );
    if (checkStudentsResponse.isSuccess || checkStudentsResponse.isNoContent) {
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
                msg: 'error_get_PlanLine_students'.tr);
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

  //change work and attendances
  void changeStudentsWorksAndAttendances(CheckStudentsWorkResponce checkWorks,
      cupertino.BuildContext dialogContext, int episodeId) async {
    final navigator = cupertino.Navigator.of(dialogContext);
    bool isCompleted = true;
    if (checkWorks.listenLine.isNotEmpty) {
      try {
        for (var listenLine in checkWorks.listenLine) {
          await addListenLine(
              listenLine.typeFollow, listenLine.studentId, episodeId,
              newListenLine: listenLine);
        }
      } catch (e) {
        isCompleted = false;
      }
    }
    if (checkWorks.studentState.isNotEmpty) {
      try {
        for (var studentsState in checkWorks.studentState) {
          setAttendance(episodeId, studentsState.state, studentsState.studentId,
              studentState: studentsState);
          StudentsOfEpisodeService()
              .setStudentStateLocal(studentsState, isFromCheck: true);
        }
      } catch (e) {
        isCompleted = false;
      }
    }

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
          PlanLinesService().deleteAllPlanLinesOfStudent(id);
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
              id: studetnt.id,
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
    await StudentsOfEpisodeService().setStudentStateLocal(studentState ??
        StudentState(
            date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
            episodeId: episodeId,
            studentId: id,
            state: filter));

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
          fromAya: getAyaFrom(newListenLine.fromAya),
          toAya: getAyaTo(newListenLine.fromAya),
          toSuraName: getSuraName(newListenLine.fromSuraId),
          mistake: 0);
    }
    ResponseContent responseContent = ResponseContent();
    await ListenLineService().setListenLineLocal(listenLine);
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
        if (educationalPlan != null) {
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
        if (educationalPlan != null) {
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
        if (educationalPlan != null) {
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
  Future<ResponseContent> checkHalaqat() async {
    List listId = _listEpisodes.map((e) => e.id).toList();
    ResponseContent checkHalaqatResponse =
        await CheckEpisodeService().postCheckhalaqat(listId);
    if (checkHalaqatResponse.isSuccess || checkHalaqatResponse.isNoContent) {
      checkEpisode = checkHalaqatResponse.data;
      // Add Edisode
      final listAddEdisode =
          List<NewHalaqat>.from(checkEpisode?.newHalaqat ?? []);
      int numberEdisode;
      for (numberEdisode = 0;
          numberEdisode < listAddEdisode.length;
          numberEdisode++) {
        addEdisode(Episode(
            displayName: listAddEdisode[numberEdisode].name.toString(),
            name: listAddEdisode[numberEdisode].name.toString(),
            epsdType: listAddEdisode[numberEdisode].typeEpisode.toString(),
            id: listAddEdisode[numberEdisode].id));
        for (int i = 0; i < listAddEdisode[i].students!.length; i++) {
          var studentOfEpisode = StudentOfEpisode(
            episodeId: listAddEdisode[numberEdisode].id!.toInt(),
            name: listAddEdisode[numberEdisode].students![i].name.toString(),
            state: listAddEdisode[numberEdisode].students![i].state.toString(),
          );
          int idStedent = listAddEdisode[numberEdisode].id!.toInt();
          var plalinLines = PlanLines(
              episodeId: listAddEdisode[numberEdisode].id!.toInt(),
              studentId: listAddEdisode[numberEdisode].students![i].id);
          if (listAddEdisode[numberEdisode].students![i].isHifz == true) {
            plalinLines.listen = PlanLine.fromDefault();
          } else if (listAddEdisode[numberEdisode].students![i].isTilawa ==
              true) {
            plalinLines.tlawa = PlanLine.fromDefault();
          } else if (listAddEdisode[numberEdisode].students![i].isSmallReview ==
              true) {
            plalinLines.reviewsmall = PlanLine.fromDefault();
          } else if (listAddEdisode[numberEdisode].students![i].isBigReview ==
              true) {
            plalinLines.reviewbig = PlanLine.fromDefault();
          }
          addStudent(studentOfEpisode, plalinLines, idStedent);
        }
      }
      // !! delete data
      final list = List<int>.from(checkEpisode?.deletedHalaqat ?? []);
      for (int i = 0; i < list.length; i++) {
        deleteEdisode(
            Episode(id: list[i], epsdType: '', name: '', displayName: ''));
      }
    }
    CostomDailogs.snackBar(
        response: ResponseContent(
            statusCode: '200',
            success: true,
            message: 'the_data_has_been_updated_successfully'.tr));

    return checkHalaqatResponse;
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
}
