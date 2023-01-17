 

import 'package:monitor_episodes/model/core/educational/educational_plan.dart';
import 'package:monitor_episodes/model/core/shared/enums.dart';
import 'package:monitor_episodes/model/data/database_helper.dart';

class EducationalPlanService {
 

  Future<EducationalPlan> getEducationalPlanLocal(
      int episodeId, int id) async {
    try {
      final dbHelper = DatabaseHelper.instance;
      final allPlanLines = await dbHelper.queryAllRowsWhereTowColumns(
          DatabaseHelper.tableEducationalPlan,
          EducationalPlanColumns.episodeId.value,
          EducationalPlanColumns.studentId.value,
          episodeId,
          id);
      return allPlanLines
          ?.map((val) => EducationalPlan.fromJsonLocal(val))
          .toList()
          .first??EducationalPlan(episodeId: episodeId,planListen: [],planReviewSmall: [],planReviewbig: [],planTlawa: [],studentId:  id);
    } catch (e) {
      return EducationalPlan(episodeId: episodeId,planListen: [],planReviewSmall: [],planReviewbig: [],planTlawa: [],studentId:  id);
    }
  }

  Future setEducationalPlanLocal(EducationalPlan educationalPlan) async {
    try {
      final dbHelper = DatabaseHelper.instance;
      var json = educationalPlan.toJson();
      var count = await dbHelper.queryRowCountWhereAndInteger(
          DatabaseHelper.tableEducationalPlan,
          EducationalPlanColumns.episodeId.value,
          EducationalPlanColumns.studentId.value,
          educationalPlan.episodeId,
          educationalPlan.studentId);
      if (count != null && count > 0) {
        await dbHelper.updateWhereAnd(
            DatabaseHelper.tableEducationalPlan,
            json,
            EducationalPlanColumns.episodeId.value,
            EducationalPlanColumns.studentId.value,
            educationalPlan.episodeId,
            educationalPlan.studentId);
      } else {
        await dbHelper.insert(DatabaseHelper.tableEducationalPlan, json);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteAllEducationalPlans() async {
    try {
      final dbHelper = DatabaseHelper.instance;
      await dbHelper.deleteAll(DatabaseHelper.tableEducationalPlan);
      return true;
    } catch (e) {
      return false;
    }
  }

    Future<bool> deleteAllEducationalPlansOfEpisode(int episodeId) async {
    try {
      final dbHelper = DatabaseHelper.instance;
      await dbHelper.deleteAllWhere(DatabaseHelper.tableEducationalPlan,EducationalPlanColumns.episodeId.value,episodeId);
      return true;
    } catch (e) {
      return false;
    }
  }

    Future<bool> deleteAllEducationalPlansOfStudent(int studentId) async {
    try {
      final dbHelper = DatabaseHelper.instance;
      await dbHelper.deleteAllWhere(DatabaseHelper.tableEducationalPlan,EducationalPlanColumns.studentId.value,studentId);
      return true;
    } catch (e) {
      return false;
    }
  }
}
