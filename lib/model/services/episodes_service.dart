 

import 'package:monitor_episodes/model/core/shared/enums.dart';
import 'package:monitor_episodes/model/core/episodes/episode.dart';
import 'package:monitor_episodes/model/data/database_helper.dart';


class EdisodesService{
 
  Future<List<Episode>?> getEdisodesLocal() async {
    try {
      final dbHelper = DatabaseHelper.instance;
      final allProducts =
          await dbHelper.queryAllRows(DatabaseHelper.tableEpisode);
      return allProducts?.map((val) => Episode.fromJson(val)).toList()??[];
    } catch (e) {
      return null;
    }
  }

   Future<Episode?> getEpisode(int edisodeId) async {
    try {
      final dbHelper = DatabaseHelper.instance;
      final allStudents = await dbHelper.queryAllRowsWhere(
          DatabaseHelper.tableEpisode,
          EpisodeColumns.id.value,
          edisodeId);
      return allStudents
              ?.map((val) => Episode.fromJson(val))
              .toList().first;
    } catch (e) {
      return null;
    }
  }

  Future<int> getCountEdisodesLocal() async {
    try {
      final dbHelper = DatabaseHelper.instance;
      final count =
          await dbHelper.queryRowCount(DatabaseHelper.tableEpisode);
      return count ?? 0;
    } catch (e) {
      return 0;
    }
  }
    
  Future<bool> setEdisodeLocal(Episode episode) async {
    try {
      final dbHelper = DatabaseHelper.instance;
        var json = episode.toJson();
        await dbHelper.insert(DatabaseHelper.tableEpisode, json);
      return true;
    } catch (e) {
      return false;
    }
  }
  Future<bool> updateEdisode(Episode episode) async {
    try {
      final dbHelper = DatabaseHelper.instance;
        var json = episode.toJson();
        await dbHelper.update(DatabaseHelper.tableEpisode, json);
      return true;
    } catch (e) {
      return false;
    }
  }
 

 Future<bool> deleteAllEdisodes() async {
    try {
      final dbHelper = DatabaseHelper.instance;
      await dbHelper.deleteAll(DatabaseHelper.tableEpisode);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deletedEpisode(int episodeId) async {
    try {
      final dbHelper = DatabaseHelper.instance;
      await dbHelper.delete(DatabaseHelper.tableEpisode,episodeId);
      return true;
    } catch (e) {
      return false;
    }
  }
}