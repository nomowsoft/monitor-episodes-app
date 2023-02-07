import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:monitor_episodes/model/core/episodes/check_student_work_responce.dart';
import 'package:monitor_episodes/model/core/episodes/check_students_responce.dart';
import 'package:monitor_episodes/model/core/plan_lines/plan_lines.dart';
import 'package:monitor_episodes/model/core/shared/enums.dart';
import 'package:monitor_episodes/model/core/episodes/student_of_episode.dart';
import 'package:monitor_episodes/model/core/episodes/student_state.dart';
import 'package:monitor_episodes/model/data/database_helper.dart';
import 'package:intl/intl.dart';
import 'package:monitor_episodes/model/services/episodes_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/shared/response_content.dart';
import '../core/shared/status_and_types.dart';
import '../helper/api_helper.dart';
import '../helper/end_point.dart';

class StudentsOfEpisodeService {
  Future<List<StudentOfEpisode>?> getStudentsOfEpisodeLocal(
      int episodeId) async {
    try {
      final dbHelper = DatabaseHelper.instance;
      final allStudents = await dbHelper.queryAllRowsWhere(
          DatabaseHelper.tableStudentOfEpisode,
          StudentOfEpisodeColumns.episodeId.value,
          episodeId);
      return allStudents
              ?.map((val) => StudentOfEpisode.fromJsonLocal(val))
              .toList() ??
          [];
    } catch (e) {
      return null;
    }
  }

  //getStateLocalForStudent
  Future<List<int?>> getStateLocalForStudent(int studentId) async {
    try {
      final dbHelper = DatabaseHelper.instance;
      final allStudents = await dbHelper.queryAllRowsWhere(
          DatabaseHelper.tableStudentState, 'student_id', studentId);
      return allStudents
              ?.map((val) => StudentState.fromJson(val))
              .toList()
              .map((e) => e.ids)
              .toList() ??
          [];
    } catch (e) {
      return [];
    }
  }

  Future<StudentOfEpisode?> getLastStudentsLocal() async {
    try {
      final dbHelper = DatabaseHelper.instance;
      final allStudents = await dbHelper.queryAllRows(
        DatabaseHelper.tableStudentOfEpisode,
      );
      return allStudents
          ?.map((val) => StudentOfEpisode.fromJsonLocal(val))
          .toList()
          .last;
    } catch (e) {
      return null;
    }
  }

  Future<StudentOfEpisode?> getStudent(int studentId) async {
    try {
      final dbHelper = DatabaseHelper.instance;
      final allStudents = await dbHelper.queryAllRowsWhere(
          DatabaseHelper.tableStudentOfEpisode,
          StudentOfEpisodeColumns.id.value,
          studentId);
      return allStudents
          ?.map((val) => StudentOfEpisode.fromJsonLocal(val))
          .toList()
          .first;
    } catch (e) {
      return null;
    }
  }

  Future setStudentsOfEpisodeLocal(
      List<StudentOfEpisode> studentEpisodes) async {
    try {
      final dbHelper = DatabaseHelper.instance;
      for (var student in studentEpisodes) {
        var json = student.toJson();
        await dbHelper.insert(DatabaseHelper.tableStudentOfEpisode, json);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future setStudentOfEpisode(
      StudentOfEpisode studentEpisode, PlanLines planLines,
      {isFromCheck}) async {
    SharedPreferences sharPre = await SharedPreferences.getInstance();

    try {
      final dbHelper = DatabaseHelper.instance;
      var jsonLocal = studentEpisode.toJson();
      bool isHifz = planLines.listen != null;
      bool isTilawa = planLines.tlawa != null;
      bool isBigReview = planLines.reviewbig != null;
      bool isSmalleview = planLines.reviewsmall != null;

      if (isFromCheck) {
        await dbHelper.insert(DatabaseHelper.tableStudentOfEpisode, jsonLocal);
      } else {
        await dbHelper.insert(DatabaseHelper.tableStudentOfEpisode, jsonLocal);
        var result = await getLastStudentsLocal();
        result!.ids = int.parse('${sharPre.getInt('login_log')}${result.id}');
        await dbHelper.update(
            DatabaseHelper.tableStudentOfEpisode, result.toJson());
        var epi = await EdisodesService().getEpisode(result.episodeId!);
        result.episodeId = epi!.ids;
        var jsonServer = await result.toJsonServer(isCreate: true);
        jsonServer.addAll({
          'is_hifz': isHifz ? 1 : 0,
          'is_tilawa': isTilawa ? 1 : 0,
          'is_big_review': isBigReview ? 1 : 0,
          'is_small_review': isSmalleview ? 1 : 0,
          EpisodeColumns.operation.value: 'create'
        });
        await dbHelper.insert(
            DatabaseHelper.logTableStudentOfEpisode, jsonServer);
        // studentCrudOperationsRemoately(
        //     dbHelper, DatabaseHelper.logTableStudentOfEpisode);
      }

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future updateStudentsOfEpisodeLocal(
      StudentOfEpisode studentEpisode, PlanLines? planLines) async {
    try {
      final dbHelper = DatabaseHelper.instance;
      var stu = await getStudent(studentEpisode.id!);
      studentEpisode.ids = stu?.ids;
      var jsonLocal = studentEpisode.toJson();
      await dbHelper.update(DatabaseHelper.tableStudentOfEpisode, jsonLocal);

      if (planLines != null) {
        var jsonServer = await studentEpisode.toJsonServer();
        bool isHifz = planLines.listen != null;
        bool isTilawa = planLines.tlawa != null;
        bool isBigReview = planLines.reviewbig != null;
        bool isSmalleview = planLines.reviewsmall != null;

        jsonServer.addAll({
          'is_hifz': isHifz ? 1 : 0,
          'is_tilawa': isTilawa ? 1 : 0,
          'is_big_review': isBigReview ? 1 : 0,
          'is_small_review': isSmalleview ? 1 : 0,
          EpisodeColumns.operation.value: 'update'
        });
        await dbHelper.insert(
            DatabaseHelper.logTableStudentOfEpisode, jsonServer);
        // studentCrudOperationsRemoately(
        //     dbHelper, DatabaseHelper.logTableStudentOfEpisode);
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<int> getCountStudent() async {
    try {
      final dbHelper = DatabaseHelper.instance;
      final count =
          await dbHelper.queryRowCount(DatabaseHelper.tableStudentOfEpisode);
      return count ?? 0;
    } catch (e) {
      return 0;
    }
  }

  Future<bool> deleteStudent(int id,
      {int? ids, bool isFromCheck = false}) async {
    try {
      final dbHelper = DatabaseHelper.instance;
      if (isFromCheck) {
        await dbHelper.deleteV1(DatabaseHelper.tableStudentOfEpisode, ids??id);
      } else {
        await dbHelper.deleteAllWhere(DatabaseHelper.tableStudentOfEpisode,
            StudentOfEpisodeColumns.id.value, id);
               await dbHelper.insert(DatabaseHelper.logTableStudentOfEpisode,
          {'id': ids, EpisodeColumns.operation.value: 'delete'});
      }

   
      // studentCrudOperationsRemoately(
      //     dbHelper, DatabaseHelper.logTableStudentOfEpisode);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteAllStudentsOfEpisode() async {
    try {
      final dbHelper = DatabaseHelper.instance;
      await dbHelper.deleteAll(DatabaseHelper.tableStudentOfEpisode);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteStudentsOfEpisode(int episodeId) async {
    try {
      final dbHelper = DatabaseHelper.instance;
      await dbHelper.deleteAllWhere(DatabaseHelper.tableStudentOfEpisode,
          StudentOfEpisodeColumns.episodeId.value, episodeId);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<StudentState>?> getStudentsStateLocal() async {
    try {
      final dbHelper = DatabaseHelper.instance;
      final allStudentsState =
          await dbHelper.queryAllRows(DatabaseHelper.tableStudentState);
      return allStudentsState
              ?.map((val) => StudentState.fromJson(val))
              .toList() ??
          [];
    } catch (e) {
      return null;
    }
  }

  Future<StudentState?> getLastStudentsStateLocal() async {
    try {
      final dbHelper = DatabaseHelper.instance;
      final allStudentsState =
          await dbHelper.queryAllRows(DatabaseHelper.tableStudentState);
      return allStudentsState
          ?.map((val) => StudentState.fromJson(val))
          .toList()
          .last;
    } catch (e) {
      return null;
    }
  }

  Future<List<StudentState>> getMostStudentsState(String type) async {
    try {
      final dbHelper = DatabaseHelper.instance;
      final allStudentsState = await dbHelper.queryAllRowsWhere(
          DatabaseHelper.tableStudentState,
          StudentStateColumns.state.value,
          type);
      return allStudentsState
              ?.map((val) => StudentState.fromJson(val))
              .toList() ??
          [];
    } catch (e) {
      return [];
    }
  }

  Future<List<StudentState>> getMostStudentsStateOfTowTypes(
      String type1, String type2) async {
    try {
      final dbHelper = DatabaseHelper.instance;
      final allStudentsState = await dbHelper.queryAllRowsWhereOR(
          DatabaseHelper.tableStudentState,
          StudentStateColumns.state.value,
          type1,
          type2);
      return allStudentsState
              ?.map((val) => StudentState.fromJson(val))
              .toList() ??
          [];
    } catch (e) {
      return [];
    }
  }

  Future<StudentState?> getStudentStateToDayLocal(int studentId) async {
    try {
      final dbHelper = DatabaseHelper.instance;
      final allStudentsState = await dbHelper.queryAllRowsWhereTowColumns(
          DatabaseHelper.tableStudentState,
          StudentStateColumns.studentId.value,
          StudentStateColumns.date.value,
          studentId,
          DateFormat('yyyy-MM-dd').format(DateTime.now()));
      if (kDebugMode) {
        print(allStudentsState);
      }
      return (allStudentsState?.isNotEmpty ?? false)
          ? allStudentsState
              ?.map((val) => StudentState.fromJson(val))
              .toList()
              .toList()
              .first
          : null;
    } catch (e) {
      return null;
    }
  }

  Future<int> getCountStudentStateLocal() async {
    try {
      final dbHelper = DatabaseHelper.instance;
      final count =
          await dbHelper.queryRowCount(DatabaseHelper.tableStudentState);
      return count ?? 0;
    } catch (e) {
      return 0;
    }
  }

  Future setStudentStateLocal(StudentState studentsState,
      {bool isFromCheck = false}) async {
    SharedPreferences sharPre = await SharedPreferences.getInstance();

    try {
      final dbHelper = DatabaseHelper.instance;
      //local
      var jsonLocal = studentsState.toJson();
      var count = await dbHelper.queryRowCountWhereAnd(
          DatabaseHelper.tableStudentState,
          StudentStateColumns.studentId.value,
          StudentStateColumns.date.value,
          studentsState.studentId,
          studentsState.date);
      if (count != null && count > 0) {
        await dbHelper.deleteAllWhereAnd(
            DatabaseHelper.tableStudentState,
            StudentStateColumns.studentId.value,
            StudentStateColumns.date.value,
            studentsState.studentId,
            studentsState.date);
      }

      await dbHelper.insert(DatabaseHelper.tableStudentState, jsonLocal);
      // server
      if (!isFromCheck) {
        var result = await getLastStudentsStateLocal();
        result!.ids = int.parse('${sharPre.getInt('login_log')}${result.id}');
        await dbHelper.update(
            DatabaseHelper.tableStudentState, result.toJson());
        var epi = await EdisodesService().getEpisode(result.episodeId);
        result.episodeId = epi!.ids!;
        var stu = await getStudent(result.studentId);
        result.studentId = stu!.ids!;
        var jsonServer = result.toJsonServer();
        var countLog = await dbHelper.queryRowCountWhereAnd(
            DatabaseHelper.logTableStudentState,
            'id',
            'date_presence',
            result.studentId,
            result.date);
        if (countLog != null && countLog > 0) {
          dbHelper.updateWhereAnd(DatabaseHelper.logTableStudentState,
              jsonServer, 'id', 'date_presence', result.studentId, result.date);
        } else {
          // var stuState = await getLastStudentsStateLocal();
          // jsonServer['id'] = stuState!.id;
          await dbHelper.insert(
              DatabaseHelper.logTableStudentState, jsonServer);
        }
        // studentCrudOperationsRemoately(
        //     dbHelper, DatabaseHelper.logTableStudentState);
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return false;
    }
  }

  Future<bool> deleteAllStudentsState() async {
    try {
      final dbHelper = DatabaseHelper.instance;
      await dbHelper.deleteAll(DatabaseHelper.tableStudentState);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteStudentStateOfEp(
    int studentId,
  ) async {
    try {
      final dbHelper = DatabaseHelper.instance;
      await dbHelper.deleteAllWhere(DatabaseHelper.tableStudentState,
          StudentStateColumns.studentId.value, studentId);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<ResponseContent> checkStudents(
      int episodeId, List<int> studentsIds) async {
    var json = {
      'data': {"halaqa_id": episodeId, "students": studentsIds}
    };
    var data = jsonEncode(json);
    ResponseContent response = await ApiHelper().postV2(
        EndPoint.checkStudents, data,
        linkApi: "http://rased-api.maknon.org.sa",
        contentType: ContentTypeHeaders.applicationJson);
    if (response.success ?? false) {
      try {
        response.data = response.data != null
            ? CheckStudentsResponce.fromJson(response.data['result']['result'])
            : null;
        return response;
      } catch (e) {
        return ResponseContent(
            statusCode: '1', message: '#Convert-Response#\n${e.toString()}');
      }
    } else {
      return response;
    }
  }

  Future<ResponseContent<dynamic>> checkStudentListenLineAndAttendances(
      int studentIds,
      int studentId,
      List<int?> worksIds,
      List<int?> attendancesIds,
      int episodeId) async {
    var json = {
      'data': {
        "student_id": studentIds,
        "works": worksIds,
        'attendances': attendancesIds
      }
    };
    var data = jsonEncode(json);
    ResponseContent response = await ApiHelper().postV2(
        EndPoint.checkStudentWorks, data,
        linkApi: "http://rased-api.maknon.org.sa",
        contentType: ContentTypeHeaders.applicationJson);
    if (response.success ?? false) {
      try {
        response.data = response.data != null
            ? CheckStudentsWorkResponce.fromJson(
                response.data['result']['result'], episodeId, studentId)
            : null;
        return response;
      } catch (e) {
        return ResponseContent(
            statusCode: '1', message: '#Convert-Response#\n${e.toString()}');
      }
    } else {
      return response;
    }
  }

  // Future<bool> _studentsWillDeleted(List deletedStudentsIds) async {
  //   try {
  //     final dbHelper = DatabaseHelper.instance;

  //     for (var id in deletedStudentsIds) {
  //      await dbHelper.delete(DatabaseHelper.tableStudentOfEpisode, id);
  //     }

  //     return true;
  //   } catch (e) {
  //     return false;
  //   }
  // }

//  Future<bool> _newStudentsWillAdded(List newStudents, int episodeId) {
//   for (var newStudent in newStudents) {
//     if(newStudent !is int){
//          Map<String,dynamic> data={
//          'id':newStudent['id_mobile'],
//          ''
//   };
//     }
//   }

//  }
}

//==============================================================================================

studentCrudOperationsRemoately(
    DatabaseHelper dbHelper, String logTableName) async {
  // var result = await dbHelper.queryAllRowsWhere(DatabaseHelper.logTableEpisode,
  //     EpisodeColumns.operation.value, operation);
  var result = await dbHelper.queryAllRows(logTableName);
  var listOfStudents = result!.map((e) => Map.of(e)).toList();
  // var data = jsonEncode(
  //   {
  //     'data': [listOfEpisodes]
  //   },
  // );
  if (logTableName == DatabaseHelper.logTableStudentState) {
    sendToServer(listOfStudents, 'attendance', dbHelper, logTableName);
  } else {
    var listOfStudentTypeCreate = [];
    var listOfStudentTypeUdate = [];
    var listOfStudentTypeDelete = [];
    for (var student in listOfStudents) {
      if (student['operation'] == 'create') {
        student.remove('operation');
        // student.remove('IDs');
        student.update('gender', (value) => value == 'ذكر' ? 'male' : 'female');
        student.update('is_hifz', (value) => value == 1 ? true : false);
        student.update('is_tilawa', (value) => value == 1 ? true : false);
        student.update('is_big_review', (value) => value == 1 ? true : false);
        student.update('is_small_review', (value) => value == 1 ? true : false);

        listOfStudentTypeCreate.add(student);
      } else if (student['operation'] == 'update') {
        student.remove('operation');
        // student.remove('IDs');
        student.remove('halaqa_id');
        student.remove('mobile');
        student.remove('country_id');
        student.update('gender', (value) => value == 'ذكر' ? 'male' : 'female');
        student.update('is_hifz', (value) => value == 1 ? true : false);
        student.update('is_tilawa', (value) => value == 1 ? true : false);
        student.update('is_big_review', (value) => value == 1 ? true : false);
        student.update('is_small_review', (value) => value == 1 ? true : false);
        listOfStudentTypeUdate.add(student);
      } else if (student['operation'] == 'delete') {
        listOfStudentTypeDelete.add({'id': student['id']});
      }
      continue;
    }

    sendToServer(listOfStudentTypeCreate, 'create', dbHelper,
        DatabaseHelper.logTableStudentOfEpisode);
    sendToServer(listOfStudentTypeUdate, 'update', dbHelper,
        DatabaseHelper.logTableStudentOfEpisode);
    sendToServer(listOfStudentTypeDelete, 'delete', dbHelper,
        DatabaseHelper.logTableStudentOfEpisode);
  }
}

void sendToServer(
    List list, String operation, DatabaseHelper dbHelper, String logTableName) {
  if (list.isNotEmpty) {
    var data = jsonEncode(
      {'data': list},
    );

    String endPoint = operation == 'create'
        ? EndPoint.createStudent
        : operation == 'update'
            ? EndPoint.updateStudent
            : operation == 'delete'
                ? EndPoint.deleteStudent
                : EndPoint.createStudentAttendance;

    ApiHelper()
        .postV2(endPoint, data,
            linkApi: "http://rased-api.maknon.org.sa",
            contentType: ContentTypeHeaders.applicationJson)
        .then((response) {
      if (response.isSuccess) {
        operation != 'attendance'
            ? dbHelper.deleteAllWhere(
                logTableName, EpisodeColumns.operation.value, operation)
            : dbHelper.deleteAll(logTableName);
      }
    });
  }
}
