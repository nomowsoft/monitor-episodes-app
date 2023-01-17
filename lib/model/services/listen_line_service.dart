import 'package:monitor_episodes/model/core/shared/enums.dart';
import 'package:monitor_episodes/model/core/listen_line/listen_line.dart';
import 'package:monitor_episodes/model/data/database_helper.dart';

class ListenLineService{
 
    Future<List<ListenLine>?> getListenLinesLocal() async {
    try {
      final dbHelper = DatabaseHelper.instance;
      final allStudents = await dbHelper.queryAllRows(
          DatabaseHelper.tableListenLine);
      return allStudents
              ?.map((val) => ListenLine.fromJson(val))
              .toList() ??
          [];
    } catch (e) {
      return null;
    }
  }
    Future<List<ListenLine>> getListenLinesOfType(String type) async {
    try {
      final dbHelper = DatabaseHelper.instance;
      final allStudents = await dbHelper.queryAllRowsWhere(
          DatabaseHelper.tableListenLine,ListenLineColumns.typeFollow.value,type);
      return allStudents
              ?.map((val) => ListenLine.fromJson(val))
              .toList() ??
          [];
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
      final count =
          await dbHelper.queryRowCountWhereString(DatabaseHelper.tableListenLine,ListenLineColumns.typeFollow.value,type);
      return count ?? 0;
    } catch (e) {
      return 0;
    }
  }
  
  Future setListenLineLocal(ListenLine listenLine) async {
    try {
      final dbHelper = DatabaseHelper.instance; 
        var json = listenLine.toJson();
        await dbHelper.insert(DatabaseHelper.tableListenLine, json);
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
      await dbHelper.deleteAllWhere(DatabaseHelper.tableListenLine,ListenLineColumns.linkId.value,linkId);
      return true;
    } catch (e) {
      return false;
    }
  }
}



 
