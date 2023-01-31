// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../model/core/educational/educational_plan.dart';
// import '../model/core/plan_lines/plan_lines.dart';
// import '../model/core/shared/response_content.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import '../ui/views/home/home.dart';

// class DataSyncController extends GetxController {
//   late bool _gettingEpisodes, _hasError;
//   late bool _gettingPlanLines, _hasErrorPlanLines;
//   late bool _gettingEducationalPlan, _hasErrorEducationalPlan;
//   late bool _isWorkLocal;
//   bool isEpisodesNotEmpty = true;
//   AuthModel? userLogin;
//   late ResponseContent responseEpisodes,
//       responsePlanLines,
//       responseEducationalPlan,
//       responseBehaviours;
//   int countStudentState = 0;
//   int countGeneralBehaviors = 0;
//   int countNewStudentBehaviours = 0;
//   int countListenLines = 0;
//   final bool isLoadDataSaveLocal;
//   final bool isUploadToServer;
//   DataSyncController({
//     this.isLoadDataSaveLocal = false,
//     this.isUploadToServer = false,
//   });
//   @override
//   void onInit() async {
//     // ignore: todo
//     // TODO: implement onInit
//     super.onInit();
//     await getUserLocal();

//   }


//   //seter
//   set gettingEpisodes(bool val) => {_gettingEpisodes = val, update()};
//   set hasError(bool val) => {_hasError = val, update()};
//   set gettingPlanLines(bool val) => {_gettingPlanLines = val, update()};
//   set hasErrorPlanLines(bool val) => {_hasErrorPlanLines = val, update()};
//   set isWorkLocal(bool val) => {_isWorkLocal = val, update()};
//   set gettingEducationalPlan(bool val) =>
//       {_gettingEducationalPlan = val, update()};
//   set hasErrorEducationalPlan(bool val) =>
//       {_hasErrorEducationalPlan = val, update()};
//   set gettingBehaviours(bool val) => {_gettingBehaviours = val, update()};
//   set hasErrorBehaviours(bool val) => {_hasErrorBehaviours = val, update()};
//   set gettingChangedData(bool val) => {_gettingChangedData = val, update()};
//   set hasErrorChangedData(bool val) => {_hasErrorChangedData = val, update()};

//   //geter
//   bool get gettingEpisodes => _gettingEpisodes;
//   bool get hasError => _hasError;
//   bool get gettingPlanLines => _gettingPlanLines;
//   bool get hasErrorPlanLines => _hasErrorPlanLines;
//   bool get isWorkLocal => _isWorkLocal;
//   bool get gettingEducationalPlan => _gettingEducationalPlan;
//   bool get hasErrorEducationalPlan => _hasErrorEducationalPlan;
//   bool get gettingBehaviours => _gettingBehaviours;
//   bool get hasErrorBehaviours => _hasErrorBehaviours;
//   bool get gettingChangedData => _gettingChangedData;
//   bool get hasErrorChangedData => _hasErrorChangedData;
//   bool get isNoChanges =>
//       countStudentState == 0 &&
//       countGeneralBehaviors == 0 &&
//       countNewStudentBehaviours == 0 &&
//       countListenLines == 0;

//   //method
//   initFilds() {
//     isEpisodesNotEmpty = true;
//     _gettingEpisodes = false;
//     _hasError = false;
//     _gettingPlanLines = false;
//     _hasErrorPlanLines = false;
//     _gettingEducationalPlan = false;
//     _hasErrorEducationalPlan = false;
//   }

//   Future loadDataSaveLocal({bool isOpenHomeScreen = false}) async {
//     await loadEpisodesAndStudents();
//     await loadStudentsPlanLines();
//     await loadEducationalPlan();
//     await loadBehaviours();

//     if (responseEpisodes.isSuccess &&
//         responsePlanLines.isSuccess &&
//         responseEducationalPlan.isSuccess &&
//         responseBehaviours.isSuccess) {
//       setIsWorkLocal(true);
//       await loadChangedDataLocal(isInit: false);
//       // HomeController homeController = Get.put(HomeController());
//       // homeController.getIsWorkLocal();
//       if (isOpenHomeScreen) {
//         Get.off(() => const Home(),
//             duration: const Duration(seconds: 1),
//             curve: Curves.easeInOut,
//             transition: Transition.fadeIn);
//       }
//     }
//   }

//   Future loadEpisodesAndStudents({bool isInit = false}) async {
//     if (isInit) {
//       _gettingEpisodes = true;
//     } else {
//       gettingEpisodes = true;
//     }
//     responseEpisodes = await getEpisodes();
//     if (isInit) {
//       _hasError = !(responseEpisodes.isSuccess);
//       _gettingEpisodes = false;
//     } else {
//       hasError = !(responseEpisodes.isSuccess);
//       gettingEpisodes = false;
//     }
//   }

//   Future<ResponseContent> getEpisodes() async {
//     ResponseContent episodesResponse =
//         await EdisodesService().getEdisodes(userLogin!.teachId.toString());
//     if (episodesResponse.isSuccess || episodesResponse.isNoContent) {
//       final listEpisodes = List<Episode>.from(episodesResponse.data);
//       await EdisodesService().setEdisodesLocal(listEpisodes);
//       if (listEpisodes.isNotEmpty) {
//         isEpisodesNotEmpty = true;
//         for (var episode in listEpisodes) {
//           ResponseContent studentsOfEpisodeResponse =
//               await getStudentsOfEpisodeAndSaveLocal(episode.id.toString());
//           if (!studentsOfEpisodeResponse.isSuccess) {
//             return studentsOfEpisodeResponse;
//           }
//         }
//       } else {
//         isEpisodesNotEmpty = false;
//       }
//     }
//     update();
//     return episodesResponse;
//   }

//   Future<ResponseContent> getStudentsOfEpisodeAndSaveLocal(
//       String episodeId) async {
//     ResponseContent studentsOfEpisodeResponse =
//         await StudentsOfEpisodeService().getStudentsOfEpisode(episodeId);
//     if (studentsOfEpisodeResponse.isSuccess ||
//         studentsOfEpisodeResponse.isNoContent) {
//       await StudentsOfEpisodeService().setStudentsOfEpisodeLocal(
//           List<StudentOfEpisode>.from(studentsOfEpisodeResponse.data));
//     }
//     update();
//     return studentsOfEpisodeResponse;
//   }

//   Future loadStudentsPlanLines({bool isInit = false}) async {
//     if (isInit) {
//       _gettingPlanLines = true;
//     } else {
//       gettingPlanLines = true;
//     }
//     responsePlanLines = await getPlanLines();
//     if (isInit) {
//       _hasErrorPlanLines = !(responsePlanLines.isSuccess);
//       _gettingPlanLines = false;
//     } else {
//       hasErrorPlanLines = !(responsePlanLines.isSuccess);
//       gettingPlanLines = false;
//     }
//   }

//   Future<ResponseContent> getPlanLines() async {
//     List<Episode> edisodes = await EdisodesService().getEdisodesLocal() ?? [];
//     ResponseContent planLinesResponse = ResponseContent(
//       statusCode: '400',
//     );
//     for (var edisode in edisodes) {
//       List<StudentOfEpisode> studentsOfEpisode =
//           await StudentsOfEpisodeService()
//                   .getStudentsOfEpisodeLocal(edisode.id) ??
//               [];
//       for (var student in studentsOfEpisode) {
//         planLinesResponse = await PlanLinesService()
//             .getPlanLines(edisode.id, student.studentId!);
//         if (planLinesResponse.isSuccess || planLinesResponse.isNoContent) {
//           PlanLinesService().setPlanLinesLocal(planLinesResponse.data);
//         } else {
//           return planLinesResponse;
//         }
//       }
//     }
//     update();
//     return planLinesResponse;
//   }

//   Future loadEducationalPlan({bool isInit = false}) async {
//     if (isInit) {
//       _gettingEducationalPlan = true;
//     } else {
//       gettingEducationalPlan = true;
//     }
//     responseEducationalPlan = await getEducationalPlan();
//     if (isInit) {
//       _hasErrorEducationalPlan = !(responseEducationalPlan.isSuccess);
//       _gettingEducationalPlan = false;
//     } else {
//       hasErrorEducationalPlan = !(responseEducationalPlan.isSuccess);
//       gettingEducationalPlan = false;
//     }
//   }

//   Future<ResponseContent> getEducationalPlan() async {
//     List<Episode> edisodes = await EdisodesService().getEdisodesLocal() ?? [];
//     ResponseContent educationalPlanResponse = ResponseContent(
//       statusCode: '400',
//     );
//     for (var edisode in edisodes) {
//       List<StudentOfEpisode> studentsOfEpisode =
//           await StudentsOfEpisodeService()
//                   .getStudentsOfEpisodeLocal(edisode.id) ??
//               [];
//       for (var student in studentsOfEpisode) {
//         educationalPlanResponse = await EducationalPlanService()
//             .getEducationalPlan(edisode.id, student.studentId!);
//         if (educationalPlanResponse.isSuccess ||
//             educationalPlanResponse.isNoContent) {
//           EducationalPlanService()
//               .setEducationalPlanLocal(educationalPlanResponse.data);
//         } else {
//           return educationalPlanResponse;
//         }
//       }
//     }
//     update();
//     return educationalPlanResponse;
//   }

//   Future loadBehaviours({bool isInit = false}) async {
//     if (isInit) {
//       _gettingBehaviours = true;
//     } else {
//       gettingBehaviours = true;
//     }
//     responseBehaviours = await getBehavioursTypes();
//     if (responseBehaviours.isSuccess || responseBehaviours.isNoContent) {
//       responseBehaviours = await getBehavioursOfStudent();
//     }
//     if (isInit) {
//       _hasErrorBehaviours = !(responseBehaviours.isSuccess);
//       _gettingBehaviours = false;
//     } else {
//       hasErrorBehaviours = !(responseBehaviours.isSuccess);
//       gettingBehaviours = false;
//     }
//   }

//   Future<ResponseContent> getBehavioursTypes() async {
//     ResponseContent behavioursTypesResponse =
//         await BehavioursService().getBehaviours();
//     if (behavioursTypesResponse.isSuccess ||
//         behavioursTypesResponse.isNoContent) {
//       final listBehaviours = List<Behaviour>.from(behavioursTypesResponse.data);
//       BehavioursService().setBehaviourTypesLocal(listBehaviours);
//     }
//     update();
//     return behavioursTypesResponse;
//   }

//   Future<ResponseContent> getBehavioursOfStudent() async {
//     List<Episode> edisodes = await EdisodesService().getEdisodesLocal() ?? [];
//     ResponseContent behavioursOfStudentResponse = ResponseContent(
//       statusCode: '400',
//     );
//     for (var edisode in edisodes) {
//       List<StudentOfEpisode> studentsOfEpisode =
//           await StudentsOfEpisodeService()
//                   .getStudentsOfEpisodeLocal(edisode.id) ??
//               [];
//       for (var student in studentsOfEpisode) {
//         behavioursOfStudentResponse = await BehavioursService()
//             .getBehavioursOfStudent(student.id.toString());
//         if (behavioursOfStudentResponse.isSuccess ||
//             behavioursOfStudentResponse.isNoContent) {
//           final listBehaviourStudents =
//               (behavioursOfStudentResponse.data as List)
//                   .map((e) => BehaviourStudent(linkId: student.id!, name: e))
//                   .toList();
//           BehavioursService().setBehavioursStudentLocal(listBehaviourStudents);
//         } else {
//           return behavioursOfStudentResponse;
//         }
//       }
//     }
//     update();
//     return behavioursOfStudentResponse;
//   }

//   Future loadChangedDataLocal({bool isInit = false}) async {
//     if (isInit) {
//       _gettingChangedData = true;
//     } else {
//       gettingChangedData = true;
//     }
//     await getCountStudentStateLocal();
//     await getCountGeneralBehaviorsLocal();
//     await getCountNewBehaviourLocal();
//     await getCountListenLinesLocal();
//     if (isInit) {
//       //_hasErrorChangedData = !(responseBehaviours.isSuccess);
//       _gettingChangedData = false;
//     } else {
//       // hasErrorChangedData = !(responseBehaviours.isSuccess);
//       gettingChangedData = false;
//     }
//   }

//   Future getCountStudentStateLocal() async {
//     countStudentState =
//         await StudentsOfEpisodeService().getCountStudentStateLocal();
//     update();
//   }

//   Future getCountGeneralBehaviorsLocal() async {
//     countGeneralBehaviors =
//         await StudentsOfEpisodeService().getCountGeneralBehaviorsLocal();
//     update();
//   }

//   Future getCountNewBehaviourLocal() async {
//     countNewStudentBehaviours =
//         await BehavioursService().getCountNewBehaviourLocal();
//     update();
//   }

//   Future getCountListenLinesLocal() async {
//     countListenLines = await ListenLineService().getCountListenLinesLocal();
//     update();
//   }

//   Future<ResponseContent> uploadToServer() async {
//     ResponseContent response = ResponseContent();
//     if (countStudentState > 0) {
//       List<StudentState>? studentsState =
//           await StudentsOfEpisodeService().getStudentsStateLocal();
//       response =
//           await StudentsOfEpisodeService().setAllAttendance(studentsState!);
//       if (!response.isSuccess) {
//         return response;
//       }
//     }
//     if (countListenLines > 0) {
//       List<ListenLine>? listenLines =
//           await ListenLineService().getListenLinesLocal();
//       response = await ListenLineService().postListenLines(listenLines!);
//       if (!response.isSuccess) {
//         return response;
//       }
//     }
//     if (countGeneralBehaviors > 0) {
//       List<StudentGeneralBehavior>? listenLines =
//           await StudentsOfEpisodeService().getGeneralBehaviorsLocal();
//       for (int i = 0; i < listenLines!.length; i++) {
//         response = await StudentsOfEpisodeService().setGeneralBehavior(
//             listenLines[i].studentId, listenLines[i].generalBehavior);
//         if (!response.isSuccess) {
//           break;
//         }
//       }
//       if (!response.isSuccess) {
//         return response;
//       }
//     }
//     if (countNewStudentBehaviours > 0) {
//       List<NewBehaviour>? newBehaviours =
//           await BehavioursService().getNewBehaviourLocal();
//       for (int i = 0; i < newBehaviours!.length; i++) {
//         response = await BehavioursService().addNewBehaviour(
//             newBehaviours[i].planId,
//             newBehaviours[i].behaviorId,
//             newBehaviours[i].sendToParent,
//             newBehaviours[i].sendToTeacher);
//         if (!response.isSuccess) {
//           break;
//         }
//       }
//       if (!response.isSuccess) {
//         return response;
//       }
//     }
//     if (response.isSuccess) {
//       await clearDataSaveLocal();
//       await loadChangedDataLocal();
//     }
//     update();
//     return response;
//   }

//   Future clearDataSaveLocal() async {
//     await StudentsOfEpisodeService().deleteAllStudentsState();
//     await StudentsOfEpisodeService().deleteAllStudentGeneralBehavior();
//     await BehavioursService().deleteAllNewBehaviourStudent();
//     await ListenLineService().deleteAllListenLineStudent();
//   }

//   Future getUserLocal() async {
//     userLogin = await UserService().getUserLocal;
//     update();
//   }

//   Future getIsWorkLocal() async {
//     final prefs = await SharedPreferences.getInstance();
//     isWorkLocal = prefs.getBool('is_work_local') ?? false;
//     update();
//   }

//   Future setIsWorkLocal(bool isWorkLocal) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('is_work_local', isWorkLocal);
//     getIsWorkLocal();
//     update();
//   }
// }
