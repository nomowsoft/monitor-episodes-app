import 'dart:convert';

import 'package:monitor_episodes/model/core/shared/enums.dart';
import 'package:monitor_episodes/model/core/listen_line/listen_line.dart';
import 'package:monitor_episodes/model/data/database_helper.dart';
import 'package:monitor_episodes/model/helper/end_point.dart';

import '../core/shared/status_and_types.dart';
import '../helper/api_helper.dart';

class ListenLineService {
  Future<List<ListenLine>?> getListenLinesLocal() async {
    try {
      final dbHelper = DatabaseHelper.instance;
      final allStudents =
          await dbHelper.queryAllRows(DatabaseHelper.tableListenLine);
      return allStudents?.map((val) => ListenLine.fromJson(val)).toList() ?? [];
    } catch (e) {
      return null;
    }
  }

  Future<List<int?>> getListenLinesLocalIdsForStudent(int studentId) async {
    try {
      final dbHelper = DatabaseHelper.instance;
      final allStudents = await dbHelper.queryAllRowsWhere(
          DatabaseHelper.tableListenLine, 'student_id', studentId);
      return allStudents
              ?.map((val) => ListenLine.fromJson(val))
              .toList()
              .map((e) => e.id)
              .toList() ??
          [];
    } catch (e) {
      return [];
    }
  }

  Future<ListenLine?> getLastListenLinesLocal() async {
    try {
      final dbHelper = DatabaseHelper.instance;
      final allStudents =
          await dbHelper.queryAllRows(DatabaseHelper.tableListenLine);
      return allStudents?.map((val) => ListenLine.fromJson(val)).toList().last;
    } catch (e) {
      return null;
    }
  }

  Future<List<ListenLine>> getListenLinesOfType(String type) async {
    try {
      final dbHelper = DatabaseHelper.instance;
      final allStudents = await dbHelper.queryAllRowsWhere(
          DatabaseHelper.tableListenLine,
          ListenLineColumns.typeFollow.value,
          type);
      return allStudents?.map((val) => ListenLine.fromJson(val)).toList() ?? [];
    } catch (e) {
      return [];
    }
  }

  Future<int> getCountListenLinesLocal() async {
    try {
      final dbHelper = DatabaseHelper.instance;
      final count =
          await dbHelper.queryRowCount(DatabaseHelper.tableListenLine);
      return count ?? 0;
    } catch (e) {
      return 0;
    }
  }

  Future<int> getCountListenLinesOfType(String type) async {
    try {
      final dbHelper = DatabaseHelper.instance;
      final count = await dbHelper.queryRowCountWhereString(
          DatabaseHelper.tableListenLine,
          ListenLineColumns.typeFollow.value,
          type);
      return count ?? 0;
    } catch (e) {
      return 0;
    }
  }

  Future setListenLineLocal(ListenLine listenLine,{bool isFromCheck = false}) async {
    try {
      final dbHelper = DatabaseHelper.instance;
      var jsonLocal = listenLine.toJson();
      await dbHelper.insert(DatabaseHelper.tableListenLine, jsonLocal);
      if(!isFromCheck){
      var jsonServer = await listenLine.toJsonServer();
      await dbHelper.insert(DatabaseHelper.logTableStudentWork, jsonServer);
      setStudentListenLineRemotely(dbHelper);

      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteAllListenLineStudent() async {
    try {
      final dbHelper = DatabaseHelper.instance;
      await dbHelper.deleteAll(DatabaseHelper.tableListenLine);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteListenLineStudent(int linkId) async {
    try {
      final dbHelper = DatabaseHelper.instance;
      await dbHelper.deleteAllWhere(DatabaseHelper.tableListenLine,
          ListenLineColumns.linkId.value, linkId);
      return true;
    } catch (e) {
      return false;
    }
  }

  void setStudentListenLineRemotely(DatabaseHelper dbHelper) async {
    var result =
        await dbHelper.queryAllRows(DatabaseHelper.logTableStudentWork);
    var listOfStudentsWork = result!.map((e) => Map.of(e)).toList();

    if (listOfStudentsWork.isNotEmpty) {
      var data = jsonEncode(
        {'data': listOfStudentsWork},
      );

      ApiHelper()
          .postV2(EndPoint.createStudentWorks, data,
              linkApi: "http://rased-api.maknon.org.sa",
              contentType: ContentTypeHeaders.applicationJson)
          .then((response) {
        if (response.isSuccess) {
          dbHelper.deleteAll(DatabaseHelper.logTableStudentWork);
        }
      });
    }
  }
}
