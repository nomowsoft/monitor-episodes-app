import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:monitor_episodes/model/core/plan_lines/plan_lines.dart';
import 'package:monitor_episodes/model/core/shared/enums.dart';
import 'package:monitor_episodes/model/core/episodes/student_of_episode.dart';
import 'package:monitor_episodes/model/core/episodes/student_state.dart';
import 'package:monitor_episodes/model/data/database_helper.dart';
import 'package:intl/intl.dart';

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
      StudentOfEpisode studentEpisode, PlanLines planLines) async {
    try {
      final dbHelper = DatabaseHelper.instance;
      var jsonLocal = studentEpisode.toJson();
      var jsonServer = studentEpisode.toJsonServer();
      bool isHifz = planLines.listen != null;
      bool isTilawa = planLines.tlawa != null;
      bool isBigReview = planLines.reviewbig != null;
      bool isSmalleview = planLines.reviewsmall != null;

      await dbHelper.insert(DatabaseHelper.tableStudentOfEpisode, jsonLocal);
      jsonServer.addAll({
        'is_hifz': isHifz ? 1 : 0,
        'is_tilawa': isTilawa ? 1 : 0,
        'is_big_review': isBigReview ? 1 : 0,
        'is_small_review': isSmalleview ? 1 : 0,
        EpisodeColumns.operation.value: 'create'
      });
      await dbHelper.insert(
          DatabaseHelper.logTableStudentOfEpisode, jsonServer);
      studentCrudOperationsRemoately(dbHelper);
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
      var jsonLocal = studentEpisode.toJson();
      await dbHelper.update(DatabaseHelper.tableStudentOfEpisode, jsonLocal);

      var jsonServer = studentEpisode.toJsonServer();
      if (planLines != null) {
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
        studentCrudOperationsRemoately(dbHelper);
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

  Future<bool> deleteStudent(int id) async {
    try {
      final dbHelper = DatabaseHelper.instance;
      await dbHelper.deleteAllWhere(DatabaseHelper.tableStudentOfEpisode,
          StudentOfEpisodeColumns.id.value, id);
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

  Future setStudentStateLocal(StudentState studentsState) async {
    try {
      final dbHelper = DatabaseHelper.instance;
      var json = studentsState.toJson();
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
      await dbHelper.insert(DatabaseHelper.tableStudentState, json);
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

      await dbHelper.insert(DatabaseHelper.logTableStudentOfEpisode,
          {'id': studentId, EpisodeColumns.operation.value: 'delete'});
      studentCrudOperationsRemoately(dbHelper);
      return true;
    } catch (e) {
      return false;
    }
  }
}

//==============================================================================================

studentCrudOperationsRemoately(DatabaseHelper dbHelper) async {
  // var result = await dbHelper.queryAllRowsWhere(DatabaseHelper.logTableEpisode,
  //     EpisodeColumns.operation.value, operation);
  var result =
      await dbHelper.queryAllRows(DatabaseHelper.logTableStudentOfEpisode);
  var listOfStudents = result!.map((e) => Map.of(e)).toList();
  // var data = jsonEncode(
  //   {
  //     'data': [listOfEpisodes]
  //   },
  // );
  var listOfStudentTypeCreate = [];
  var listOfStudentTypeUdate = [];
  var listOfStudentTypeDelete = [];
  for (var student in listOfStudents) {
    if (student['operation'] == 'create') {
      student.remove('operation');
      student.remove('IDs');
      student.update('gender', (value) => value == 'ذكر' ? 'male' : 'female');
      student.update('is_hifz', (value) => value == 1 ? true : false);
      student.update('is_tilawa', (value) => value == 1 ? true : false);
      student.update('is_big_review', (value) => value == 1 ? true : false);
      student.update('is_small_review', (value) => value == 1 ? true : false);

      listOfStudentTypeCreate.add(student);
    } else if (student['operation'] == 'update') {
      student.remove('operation');
      student.remove('IDs');
      student.remove('halaqa_id');
      student.remove('mobile');
      student.remove('country_id');
      student.update('gender', (value) => value == 'ذكر' ? 'male' : 'female');
      student.update('is_hifz', (value) => value == 1 ? true : false);
      student.update('is_tilawa', (value) => value == 1 ? true : false);
      student.update('is_big_review', (value) => value == 1 ? true : false);
      student.update('is_small_review', (value) => value == 1 ? true : false);
      listOfStudentTypeUdate.add(student);
    } else {
      listOfStudentTypeDelete.add({'id': student['id']});
    }
    continue;
  }

  sendToServer(listOfStudentTypeCreate, 'create', dbHelper);
  sendToServer(listOfStudentTypeUdate, 'update', dbHelper);
  sendToServer(listOfStudentTypeDelete, 'delete', dbHelper);
}

void sendToServer(List list, String operation, DatabaseHelper dbHelper) {
  if (list.isNotEmpty) {
    var data = jsonEncode(
      {'data': list},
    );

    String endPoint = operation == 'create'
        ? EndPoint.createStudent
        : operation == 'update'
            ? EndPoint.updateStudent
            : EndPoint.deleteStudent;

    ApiHelper()
        .postV2(endPoint, data,
            linkApi: "http://rased-api.maknon.org.sa",
            contentType: ContentTypeHeaders.applicationJson)
        .then((response) {
      if (response.isSuccess) {
        dbHelper.deleteAllWhere(DatabaseHelper.logTableStudentOfEpisode,
            EpisodeColumns.operation.value, operation);
      }
    });
  }
}
