 

import 'package:monitor_episodes/model/core/shared/enums.dart';
import 'package:monitor_episodes/model/core/plan_lines/plan_lines.dart';
import 'package:monitor_episodes/model/data/database_helper.dart';

class PlanLinesService{
 
  
    Future<PlanLines?> getPlanLinesLocal(int episodeId,int studentId) async {
    try {
      final dbHelper = DatabaseHelper.instance;
      final allPlanLines =
          await dbHelper.queryAllRowsWhereTowColumns(DatabaseHelper.tablePlanLines,PlanLinesColumns.episodeId.value,PlanLinesColumns.studentId.value,episodeId,studentId);
      return allPlanLines?.map((val) => PlanLines.fromJsonLocal(val)).toList().first;
    } catch (e) {
      return null;
    }
  }
  
  Future setPlanLinesLocal(PlanLines planLines) async {
    try {
      final dbHelper = DatabaseHelper.instance; 
      var json = planLines.toJson();
      await dbHelper.insert(DatabaseHelper.tablePlanLines, json);
      return true;
    } catch (e) {
      return false;
    }
  }
   Future<bool> updatePlanLinesLocal(PlanLines planLines) async {
    try {
      final dbHelper = DatabaseHelper.instance;
      await dbHelper.deleteAllWhereAnd(DatabaseHelper.tablePlanLines,PlanLinesColumns.episodeId.value,PlanLinesColumns.studentId.value,planLines.episodeId,planLines.studentId);
      await setPlanLinesLocal(planLines);
      return true;
    } catch (e) {
      return false;
    }
  }
 
 Future<bool> deleteAllPlanLines() async {
    try {
      final dbHelper = DatabaseHelper.instance;
      await dbHelper.deleteAll(DatabaseHelper.tablePlanLines);
      return true;
    } catch (e) {
      return false;
    }
  }

   Future<bool> deleteAllPlanLinesOfEpisode(int episodeId) async {
    try {
      final dbHelper = DatabaseHelper.instance;
      await dbHelper.deleteAllWhere(DatabaseHelper.tablePlanLines,PlanLinesColumns.episodeId.value,episodeId);
      return true;
    } catch (e) {
      return false;
    }
  }
   Future<bool> deleteAllPlanLinesOfStudent(int studentId) async {
    try {
      final dbHelper = DatabaseHelper.instance;
      await dbHelper.deleteAllWhere(DatabaseHelper.tablePlanLines,PlanLinesColumns.studentId.value,studentId);
      return true;
    } catch (e) {
      return false;
    }
  }

}