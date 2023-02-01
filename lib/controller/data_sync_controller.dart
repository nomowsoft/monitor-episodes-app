import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monitor_episodes/model/services/episodes_service.dart';
import '../model/core/educational/educational.dart';
import '../model/core/educational/educational_plan.dart';
import '../model/core/episodes/episode_students.dart';
import '../model/core/episodes/student_of_episode.dart';
import '../model/core/listen_line/listen_line.dart';
import '../model/core/plan_lines/plan_line.dart';
import '../model/core/plan_lines/plan_lines.dart';
import '../model/core/shared/constants.dart';
import '../model/core/shared/response_content.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/core/shared/status_and_types.dart';
import '../model/services/educational_plan_service.dart';
import '../model/services/listen_line_service.dart';
import '../model/services/plan_lines_service.dart';
import '../model/services/students_of_episode_service.dart';
import '../ui/views/home/home.dart';

class DataSyncController extends GetxController {
  late bool _gettingEpisodes, _hasError;
  late ResponseContent responseEpisodes;
  @override
  void onInit() async {
    // ignore: todo
    // TODO: implement onInit
    super.onInit();
    loadDataSaveLocal();
  }

  //seter
  set gettingEpisodes(bool val) => {_gettingEpisodes = val, update()};
  set hasError(bool val) => {_hasError = val, update()};

  //geter
  bool get gettingEpisodes => _gettingEpisodes;
  bool get hasError => _hasError;

  //method
  initFilds() {
    _gettingEpisodes = false;
    _hasError = false;
  }

  Future loadDataSaveLocal() async {
    await loadEpisodesAndStudents();
    if (responseEpisodes.isSuccess) {
      Get.off(() => const Home(),
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
          transition: Transition.fadeIn);
    }
  }

  Future loadEpisodesAndStudents({bool isInit = false}) async {
    if (isInit) {
      _gettingEpisodes = true;
    } else {
      gettingEpisodes = true;
    }
    responseEpisodes = await getEpisodes();
    if (isInit) {
      _hasError = !(responseEpisodes.isSuccess);
      _gettingEpisodes = false;
    } else {
      hasError = !(responseEpisodes.isSuccess);
      gettingEpisodes = false;
    }
  }

  Future<ResponseContent> getEpisodes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int teacherId = prefs.getInt('teacher_id') ?? 0;
    ResponseContent episodesResponse =
        await EdisodesService().edisodesFromServer(teacherId);
    if (episodesResponse.isSuccess || episodesResponse.isNoContent) {
      final listEpisodes = List<EpisodeStudents>.from(episodesResponse.data);
      if (listEpisodes.isNotEmpty) {
        for (var episode in listEpisodes) {
          await EdisodesService().setEdisodeLocal(episode, isCheck: false);
          for (StudentOfEpisodeFromServer student in episode.students ?? []) {
            PlanLines planLines = PlanLines();

            if (student.isHifz) {
              for (var planListen in student.studentWorks.planListen) {
                await addListenLine(
                    PlanLinesType.listen, student.id!, episode.id!, planListen);
              }
              if (student.studentWorks.planListen.isNotEmpty) {
                planLines.listen =
                    getPlanLine(student.studentWorks.planListen.last);
              } else {
                planLines.listen = PlanLine.fromDefault();
              }
            }
            if (student.isSmallReview) {
              for (var planListen in student.studentWorks.planReviewSmall) {
                await addListenLine(PlanLinesType.reviewsmall, student.id!,
                    episode.id!, planListen);
              }
              if (student.studentWorks.planReviewSmall.isNotEmpty) {
                planLines.reviewsmall =
                    getPlanLine(student.studentWorks.planReviewSmall.last);
              } else {
                planLines.reviewsmall = PlanLine.fromDefault();
              }
            }
            if (student.isBigReview) {
              for (var planListen in student.studentWorks.planReviewBig) {
                await addListenLine(PlanLinesType.reviewbig, student.id!,
                    episode.id!, planListen);
              }
              if (student.studentWorks.planReviewBig.isNotEmpty) {
                planLines.reviewbig =
                    getPlanLine(student.studentWorks.planReviewBig.last);
              } else {
                planLines.reviewbig = PlanLine.fromDefault();
              }
            }
            if (student.isHifz) {
              for (var planListen in student.studentWorks.planTlawa) {
                await addListenLine(
                    PlanLinesType.tlawa, student.id!, episode.id!, planListen);
              }
              if (student.studentWorks.planTlawa.isNotEmpty) {
                planLines.tlawa =
                    getPlanLine(student.studentWorks.planTlawa.last);
              } else {
                planLines.tlawa = PlanLine.fromDefault();
              }
            }
            planLines.episodeId = episode.id!;
            planLines.studentId = student.id!;

            await addStudent(student, planLines, episode.id!);
          }
        }
      }
    }
    update();
    return episodesResponse;
  }

  Future<bool> addStudent(StudentOfEpisode studentOfEpisode,
      PlanLines planLines, int episodeId) async {
    studentOfEpisode.episodeId = episodeId;
    bool studentResult = await StudentsOfEpisodeService()
        .setStudentOfEpisode(studentOfEpisode, planLines, isFromCheck: true);
    bool planLinesResult =
        await PlanLinesService().setPlanLinesLocal(planLines);
    return studentResult && planLinesResult;
  }

  addListenLine(String typePlanLine, int id, int episodeId,
      ListenLine newListenLine) async {
    late PlanLine planLine;
    late ListenLine listenLine;
    listenLine = newListenLine;
    planLine = PlanLine(
        fromSuraName: getSuraName(newListenLine.fromSuraId),
        fromAya: newListenLine.fromAya,
        toAya: newListenLine.toAya,
        toSuraName: getSuraName(newListenLine.fromSuraId),
        mistake: 0);

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
}
