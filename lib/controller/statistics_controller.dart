import 'dart:collection';

import 'package:get/get.dart';
import 'package:monitor_episodes/model/core/episodes/episode.dart';
import 'package:monitor_episodes/model/core/episodes/student_of_episode.dart';
import 'package:monitor_episodes/model/core/episodes/student_state.dart';
import 'package:monitor_episodes/model/core/listen_line/listen_line.dart';
import 'package:monitor_episodes/model/core/shared/most_model.dart';
import 'package:monitor_episodes/model/core/shared/status_and_types.dart';
import 'package:monitor_episodes/model/services/listen_line_service.dart';
import 'package:monitor_episodes/model/services/quran_service.dart';
import 'package:monitor_episodes/model/services/students_of_episode_service.dart';

import '../model/services/episodes_service.dart';

class StatisticsController extends GetxController {
  late int _numberEpisodes,
      _numberStudents,
      _numberListen,
      _numberReviewsmall,
      _numberReviewbig,
      _numberTlawa,
      _sumListen,
      _sumReviewsmall,
      _sumReviewbig,
      _sumTlawa;
  late bool _gettingStatisics;
  List<MostModel> _listStudentsMostPresent = [];
  List<MostModel> _listStudentsMostDelay = [];
  List<MostModel> _listStudentsMostAbsent = [];

  @override
  void onInit() {
    // ignore: todo
    // TODO: implement onInit
    super.onInit();
    initFilds();
    getStatisics(isInit: true);
  }

  // methodds

  initFilds() {
    _gettingStatisics = false;
  }

  Future getStatisics({bool isInit = false,}) async {
    if (isInit) {
      _gettingStatisics = true;
    } else {
      gettingStatisics = true;
    }
    
    await getCountEdisodes();
    await getCountSudents();
    await getCountListenLine();
    await getMostPresent();
    await getMostDelay();
    await getMostAbsentOrAbsentExcuse();
    await getSumOfTheFaces();

    if (isInit) {
      _gettingStatisics = false;
    } else {
      //await Future.delayed(const Duration(milliseconds: 700));
      gettingStatisics = false;
    }
    update();
  }

  Future getCountEdisodes() async {
    _numberEpisodes = await EdisodesService().getCountEdisodesLocal();
  }

  Future getCountSudents() async {
    _numberStudents = await StudentsOfEpisodeService().getCountStudent();
  }
  Future getCountListenLine() async {
    _numberListen = await ListenLineService().getCountListenLinesOfType(getTypePlanLine(PlanLinesType.listen));
    _numberReviewsmall = await ListenLineService().getCountListenLinesOfType(getTypePlanLine(PlanLinesType.reviewsmall));
    _numberReviewbig = await ListenLineService().getCountListenLinesOfType(getTypePlanLine(PlanLinesType.reviewbig));
    _numberTlawa = await ListenLineService().getCountListenLinesOfType(getTypePlanLine(PlanLinesType.tlawa));
  }

   Future getMostPresent() async {
    List<MostModel> listMostModel =[];
    List<StudentState>  studentsStateList = await StudentsOfEpisodeService().getMostStudentsState(StudentStateType.present);
    final map =  studentsStateList.fold(
      <int,int>{},
      (Map<int, int> fold, element) =>
          fold..update(element.studentId, (value) => value + 1, ifAbsent: () => 1));
      var sortedKeys = SplayTreeMap<int,int>.from(map, (a, b) => map[a]! < map[b]! ? 1 : -1 );
     List<int> keys = sortedKeys.keys.length >= 5 ? sortedKeys.keys.toList().take(5).toList(): sortedKeys.keys.toList();
    for(var studentId in  keys.toList()){
     StudentOfEpisode? student =   await StudentsOfEpisodeService().getStudent(studentId);
     if(student !=null){
       Episode? edisode = await EdisodesService().getEpisode(student.episodeId!);
       var numberPresent = map.entries.firstWhere((element) => element.key ==studentId).value; 
      listMostModel.add(MostModel(nameStudent: student.name,nameEpisode: edisode?.name??'',mostNumber: numberPresent));
     }
    }
    _listStudentsMostPresent = listMostModel ;
  }

   Future getMostDelay() async {
    List<MostModel> listMostModel =[];
    List<StudentState>  studentsStateList = await StudentsOfEpisodeService().getMostStudentsState(StudentStateType.delay);
    final map =  studentsStateList.fold(
      <int,int>{},
      (Map<int, int> fold, element) =>
          fold..update(element.studentId, (value) => value + 1, ifAbsent: () => 1));
      var sortedKeys = SplayTreeMap<int,int>.from(map, (a, b) => map[a]! < map[b]! ? 1 : -1 );
     List<int> keys = sortedKeys.keys.length >= 5 ? sortedKeys.keys.toList().take(5).toList(): sortedKeys.keys.toList();
    for(var studentId in  keys.toList()){
     StudentOfEpisode? student =   await StudentsOfEpisodeService().getStudent(studentId);
     if(student !=null){
      Episode? edisode = await EdisodesService().getEpisode(student.episodeId!);
      var numberPresent = map.entries.firstWhere((element) => element.key ==studentId).value; 
      listMostModel.add(MostModel(nameStudent: student.name,nameEpisode: edisode?.name??'',mostNumber: numberPresent));
     }
    }
    _listStudentsMostDelay = listMostModel ;
  }

   Future getMostAbsentOrAbsentExcuse() async {
    List<MostModel> listMostModel =[];
    List<StudentState>  studentsStateList = await StudentsOfEpisodeService().getMostStudentsStateOfTowTypes(StudentStateType.absent,StudentStateType.absentExcuse);
    final map =  studentsStateList.fold(
      <int,int>{},
      (Map<int, int> fold, element) =>
          fold..update(element.studentId, (value) => value + 1, ifAbsent: () => 1));
      var sortedKeys = SplayTreeMap<int,int>.from(map, (a, b) => map[a]! < map[b]! ? 1 : -1 );
     List<int> keys = sortedKeys.keys.length >=5 ? sortedKeys.keys.toList().take(5).toList(): sortedKeys.keys.toList();
    for(var studentId in  keys.toList()){
     StudentOfEpisode? student =   await StudentsOfEpisodeService().getStudent(studentId);
     if(student !=null){
      Episode? edisode = await EdisodesService().getEpisode(student.episodeId!);
      var numberPresent = map.entries.firstWhere((element) => element.key ==studentId).value; 
      listMostModel.add(MostModel(nameStudent: student.name,nameEpisode: edisode?.name??'',mostNumber: numberPresent));
     }
    }
    _listStudentsMostAbsent = listMostModel ;
  }

  Future getSumOfTheFaces() async {
   List<ListenLine> listenList = await ListenLineService().getListenLinesOfType(getTypePlanLine(PlanLinesType.listen));
   _sumListen = QuranService().sumPages(listenList);
   List<ListenLine> reviewsmallnList = await ListenLineService().getListenLinesOfType(getTypePlanLine(PlanLinesType.reviewsmall));
   _sumReviewsmall = QuranService().sumPages(reviewsmallnList);
   List<ListenLine> reviewbigList = await ListenLineService().getListenLinesOfType(getTypePlanLine(PlanLinesType.reviewbig));
   _sumReviewbig = QuranService().sumPages(reviewbigList);
   List<ListenLine> tlawaList = await ListenLineService().getListenLinesOfType(getTypePlanLine(PlanLinesType.tlawa));
   _sumTlawa = QuranService().sumPages(tlawaList);

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

  // setter
  set gettingStatisics(bool val) => {_gettingStatisics = val, update()};

  //geter
  bool get gettingStatisics => _gettingStatisics;
  String get numberEpisodes => _numberEpisodes.toString();
  String get numberStudents => _numberStudents.toString();
  String get numberListen => _numberListen.toString();
  String get numberReviewsmall => _numberReviewsmall.toString();
  String get numberReviewbig => _numberReviewbig.toString();
  String get numberTlawa => _numberTlawa.toString();
  String get sumListen => _sumListen.toString();
  String get sumReviewsmall => _sumReviewsmall.toString();
  String get sumReviewbig => _sumReviewbig.toString();
  String get sumTlawa => _sumTlawa.toString();
  List<MostModel> get listStudentsMostPresent => _listStudentsMostPresent;
  List<MostModel> get listStudentsMostDelay => _listStudentsMostDelay;
  List<MostModel> get listStudentsMostAbsent => _listStudentsMostAbsent;
}
