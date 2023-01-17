import 'package:flutter/foundation.dart';
import 'package:monitor_episodes/model/core/shared/enums.dart';
import 'package:monitor_episodes/model/core/episodes/student_of_episode.dart';
import 'package:monitor_episodes/model/core/episodes/student_state.dart';
import 'package:monitor_episodes/model/data/database_helper.dart';
import 'package:intl/intl.dart';

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
              .toList().first;
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
  Future setStudentOfEpisode(StudentOfEpisode studentEpisode) async {
    try {
      final dbHelper = DatabaseHelper.instance;
        var json = studentEpisode.toJson();
        await dbHelper.insert(DatabaseHelper.tableStudentOfEpisode, json);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
  Future updateStudentsOfEpisodeLocal(
        StudentOfEpisode studentEpisode) async {
    try {
      final dbHelper = DatabaseHelper.instance;
      var json = studentEpisode.toJson();
      await dbHelper.update(
            DatabaseHelper.tableStudentOfEpisode,
            json);
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
      await dbHelper.deleteAllWhere(DatabaseHelper.tableStudentOfEpisode,StudentOfEpisodeColumns.id.value,id);
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
      await dbHelper.deleteAllWhere(DatabaseHelper.tableStudentOfEpisode,StudentOfEpisodeColumns.episodeId.value,episodeId);
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
      final allStudentsState =
          await dbHelper.queryAllRowsWhere(DatabaseHelper.tableStudentState,StudentStateColumns.state.value,type);
      return allStudentsState
              ?.map((val) => StudentState.fromJson(val))
              .toList() ??
          [];
    } catch (e) {
      return [];
    }
  }

  Future<List<StudentState>> getMostStudentsStateOfTowTypes(String type1,String type2) async {
    try {
      final dbHelper = DatabaseHelper.instance;
      final allStudentsState =
          await dbHelper.queryAllRowsWhereOR(DatabaseHelper.tableStudentState,StudentStateColumns.state.value,type1,type2);
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
      final allStudentsState =
          await dbHelper.queryAllRowsWhereTowColumns(DatabaseHelper.tableStudentState,StudentStateColumns.studentId.value,StudentStateColumns.date.value, studentId,DateFormat('yyyy-MM-dd').format(DateTime.now()));
      if (kDebugMode) {
        print(allStudentsState);
      }
      return (allStudentsState?.isNotEmpty ??false) ? allStudentsState
              ?.map((val) => StudentState.fromJson(val))
              .toList().toList().first:null;
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

  Future setStudentStateLocal(
      StudentState studentsState) async {
    try {
      final dbHelper = DatabaseHelper.instance;
        var json = studentsState.toJson();
        var count = await dbHelper.queryRowCountWhereAnd(DatabaseHelper.tableStudentState,StudentStateColumns.studentId.value,StudentStateColumns.date.value,studentsState.studentId, studentsState.date);
        if(count !=null && count > 0){
        await dbHelper.deleteAllWhereAnd(DatabaseHelper.tableStudentState,StudentStateColumns.studentId.value,StudentStateColumns.date.value,studentsState.studentId, studentsState.date);
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
  
    Future<bool> deleteStudentStateOfEp(int studentId,) async {
    try {
      final dbHelper = DatabaseHelper.instance;
       await dbHelper.deleteAllWhere(DatabaseHelper.tableStudentState,StudentStateColumns.studentId.value,studentId);
      return true;
    } catch (e) {
      return false;
    }
  }
 
}