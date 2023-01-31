import 'package:get/get.dart';

import '../model/core/educational/educational_plan.dart';
import '../model/core/episodes/student_of_episode.dart';
import '../model/core/plan_lines/plan_lines.dart';
import '../model/core/shared/response_content.dart';
import '../model/services/episodes_service.dart';

class DataSyncController extends GetxController {
  late bool _gettingEpisodes, _hasError;
  late bool _gettingPlanLines, _hasErrorPlanLines;
  late bool _gettingEducationalPlan, _hasErrorEducationalPlan;
  late bool _gettingBehaviours, _hasErrorBehaviours;
  late bool _gettingChangedData, _hasErrorChangedData;
  late bool _isWorkLocal;
  bool isEpisodesNotEmpty = true;
  late ResponseContent responseEpisodes,
      responsePlanLines,
      responseEducationalPlan,
      responseBehaviours;
  int countStudentState = 0;
  int countGeneralBehaviors = 0;
  int countNewStudentBehaviours = 0;
  int countListenLines = 0;
  final bool isLoadDataSaveLocal;
  final bool isUploadToServer;
  DataSyncController({
    this.isLoadDataSaveLocal = false,
    this.isUploadToServer = false,
  });
  @override
  void onInit() async {
    // ignore: todo
    // TODO: implement onInit
    super.onInit();
    initFilds();
  }

  initFilds() {
    isEpisodesNotEmpty = true;
    _gettingEpisodes = false;
    _hasError = false;
    _gettingPlanLines = false;
    _hasErrorPlanLines = false;
    _gettingEducationalPlan = false;
    _hasErrorEducationalPlan = false;
    _gettingBehaviours = false;
    _hasErrorBehaviours = false;
    _isWorkLocal = false;
    _gettingChangedData = false;
    _hasErrorChangedData = false;
  }

  // Future<ResponseContent> loadDataSaveLocalOnBackground() async {
  //   List<StudentOfEpisode> studentsOfEpisodes = [];
  //   List<PlanLines> planLines = [];
  //   List<EducationalPlan> educationalPlans = [];
  //   // List<Behaviour> listBehaviours = [];
  //   // List<BehaviourStudent> listBehaviourStudents = [];

  //   //Load Edisodes and Students

  //   ResponseContent episodesResponse =
  //       await EdisodesService().getEdisodes(userLogin!.teachId.toString());
  //   if (episodesResponse.isSuccess || episodesResponse.isNoContent) {
  //     final listEpisodes = List<Episode>.from(episodesResponse.data);
  //     if (listEpisodes.isNotEmpty) {
  //       for (var episode in listEpisodes) {
  //         ResponseContent studentsOfEpisodeResponse =
  //             await StudentsOfEpisodeService()
  //                 .getStudentsOfEpisode(episode.id.toString());
  //         if (!studentsOfEpisodeResponse.isSuccess) {
  //           return studentsOfEpisodeResponse;
  //         } else {
  //           studentsOfEpisodes.addAll(
  //               List<StudentOfEpisode>.from(studentsOfEpisodeResponse.data));
  //         }
  //       }
  //       // load  PlanLines and Educational Plans
  //       for (var student in studentsOfEpisodes) {
  //         ResponseContent planLinesResponse = await PlanLinesService()
  //             .getPlanLines(student.episodeId!, student.studentId!);
  //         ResponseContent educationalPlanResponse =
  //             await EducationalPlanService()
  //                 .getEducationalPlan(student.episodeId!, student.studentId!);
  //         ResponseContent behavioursOfStudentResponse =
  //             await BehavioursService()
  //                 .getBehavioursOfStudent(student.id.toString());
  //         if ((planLinesResponse.isSuccess || planLinesResponse.isNoContent) &&
  //             (educationalPlanResponse.isSuccess ||
  //                 educationalPlanResponse.isNoContent) &&
  //             (behavioursOfStudentResponse.isSuccess ||
  //                 behavioursOfStudentResponse.isNoContent)) {
  //           planLines.add(planLinesResponse.data);
  //           educationalPlans.add(educationalPlanResponse.data);
  //           listBehaviourStudents.addAll(
  //               (behavioursOfStudentResponse.data as List)
  //                   .map((e) => BehaviourStudent(linkId: student.id!, name: e))
  //                   .toList());
  //         } else {
  //           return planLinesResponse.isSuccess
  //               ? educationalPlanResponse
  //               : planLinesResponse;
  //         }
  //       }
  //       // load BehavioursTypes
  //       ResponseContent behavioursTypesResponse =
  //           await BehavioursService().getBehaviours();
  //       if (behavioursTypesResponse.isSuccess ||
  //           behavioursTypesResponse.isNoContent) {
  //         listBehaviours = List<Behaviour>.from(behavioursTypesResponse.data);
  //       }
  //       // Load
  //     }
  //   }
  //   if (episodesResponse.isSuccess) {
  //     // Save data Local
  //     final listEpisodes = List<Episode>.from(episodesResponse.data);
  //     if (listEpisodes.isNotEmpty) {
  //       isEpisodesNotEmpty = true;
  //       await EdisodesService().setEdisodesLocal(listEpisodes);
  //       await StudentsOfEpisodeService().setStudentsOfEpisodeLocal(
  //           List<StudentOfEpisode>.from(studentsOfEpisodes));
  //       for (var planLine in planLines) {
  //         PlanLinesService().setPlanLinesLocal(planLine);
  //       }
  //       for (var educationalPlan in educationalPlans) {
  //         EducationalPlanService().setEducationalPlanLocal(educationalPlan);
  //       }
  //       BehavioursService().setBehavioursStudentLocal(listBehaviourStudents);
  //       BehavioursService().setBehaviourTypesLocal(listBehaviours);
  //     }
  //     setIsWorkLocal(true);
  //   }
  //   return episodesResponse;
  // }

  //seter
  set gettingEpisodes(bool val) => {_gettingEpisodes = val, update()};
  set hasError(bool val) => {_hasError = val, update()};
  set gettingPlanLines(bool val) => {_gettingPlanLines = val, update()};
  set hasErrorPlanLines(bool val) => {_hasErrorPlanLines = val, update()};
  set isWorkLocal(bool val) => {_isWorkLocal = val, update()};
  set gettingEducationalPlan(bool val) =>
      {_gettingEducationalPlan = val, update()};
  set hasErrorEducationalPlan(bool val) =>
      {_hasErrorEducationalPlan = val, update()};
  set gettingBehaviours(bool val) => {_gettingBehaviours = val, update()};
  set hasErrorBehaviours(bool val) => {_hasErrorBehaviours = val, update()};
  set gettingChangedData(bool val) => {_gettingChangedData = val, update()};
  set hasErrorChangedData(bool val) => {_hasErrorChangedData = val, update()};

  //geter
  bool get gettingEpisodes => _gettingEpisodes;
  bool get hasError => _hasError;
  bool get gettingPlanLines => _gettingPlanLines;
  bool get hasErrorPlanLines => _hasErrorPlanLines;
  bool get isWorkLocal => _isWorkLocal;
  bool get gettingEducationalPlan => _gettingEducationalPlan;
  bool get hasErrorEducationalPlan => _hasErrorEducationalPlan;
  bool get gettingBehaviours => _gettingBehaviours;
  bool get hasErrorBehaviours => _hasErrorBehaviours;
  bool get gettingChangedData => _gettingChangedData;
  bool get hasErrorChangedData => _hasErrorChangedData;
  bool get isNoChanges =>
      countStudentState == 0 &&
      countGeneralBehaviors == 0 &&
      countNewStudentBehaviours == 0 &&
      countListenLines == 0;
}
