import 'dart:convert';

import 'package:monitor_episodes/model/core/shared/enums.dart';
import 'package:monitor_episodes/model/core/episodes/episode.dart';
import 'package:monitor_episodes/model/core/shared/status_and_types.dart';
import 'package:monitor_episodes/model/data/database_helper.dart';
import 'package:monitor_episodes/model/helper/api_helper.dart';
import 'package:monitor_episodes/model/helper/end_point.dart';

import '../core/episodes/episode_students.dart';
import '../core/shared/response_content.dart';

class EdisodesService {
  final ApiHelper _apiHelper = ApiHelper();
  Future<List<Episode>?> getEdisodesLocal() async {
    try {
      final dbHelper = DatabaseHelper.instance;
      final allProducts =
          await dbHelper.queryAllRows(DatabaseHelper.tableEpisode);
      return allProducts?.map((val) => Episode.fromJson(val)).toList() ?? [];
    } catch (e) {
      return null;
    }
  }

  Future<Episode?> getLastEdisodesLocal() async {
    try {
      final dbHelper = DatabaseHelper.instance;
      final allProducts =
          await dbHelper.queryAllRows(DatabaseHelper.tableEpisode);
      return allProducts?.map((val) => Episode.fromJson(val)).toList().last;
    } catch (e) {
      return null;
    }
  }

  Future<Episode?> getEpisode(int edisodeId) async {
    try {
      final dbHelper = DatabaseHelper.instance;
      final allStudents = await dbHelper.queryAllRowsWhere(
          DatabaseHelper.tableEpisode, EpisodeColumns.id.value, edisodeId);
      return allStudents?.map((val) => Episode.fromJson(val)).toList().first;
    } catch (e) {
      return null;
    }
  }

  Future<int> getCountEdisodesLocal() async {
    try {
      final dbHelper = DatabaseHelper.instance;
      final count = await dbHelper.queryRowCount(DatabaseHelper.tableEpisode);
      return count ?? 0;
    } catch (e) {
      return 0;
    }
  }

  Future<bool> setEdisodeLocal(Episode episode,
      {bool isFromCheck = false}) async {
    try {
      final dbHelper = DatabaseHelper.instance;
      var jsonLocal = episode.toJson();
      await dbHelper.insert(DatabaseHelper.tableEpisode, jsonLocal);
      if (!isFromCheck) {
        var jsonServer = await episode.toJsonServer(isCreate: true);
        jsonServer.addAll({EpisodeColumns.operation.value: 'create'});
        await dbHelper.insert(DatabaseHelper.logTableEpisode, jsonServer);
        episodeCrudOperationsRemoately(dbHelper);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateEdisode(Episode episode) async {
    try {
      final dbHelper = DatabaseHelper.instance;
      var jsonLocal = episode.toJson();

      await dbHelper.update(DatabaseHelper.tableEpisode, jsonLocal);
      var jsonServer = await episode.toJsonServer();

      jsonServer.addAll({EpisodeColumns.operation.value: 'update'});
      await dbHelper.insert(DatabaseHelper.logTableEpisode, jsonServer);
      episodeCrudOperationsRemoately(dbHelper);
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

  Future<bool> deletedEpisode(int episodeId, {bool isFromCheck = false}) async {
    try {
      final dbHelper = DatabaseHelper.instance;
      await dbHelper.delete(DatabaseHelper.tableEpisode, episodeId);
      if (!isFromCheck) {
        await dbHelper.insert(DatabaseHelper.logTableEpisode,
            {'id': episodeId, EpisodeColumns.operation.value: 'delete'});
        episodeCrudOperationsRemoately(dbHelper);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  episodeCrudOperationsRemoately(DatabaseHelper dbHelper) async {
    // var result = await dbHelper.queryAllRowsWhere(DatabaseHelper.logTableEpisode,
    //     EpisodeColumns.operation.value, operation);
    var result = await dbHelper.queryAllRows(DatabaseHelper.logTableEpisode);
    var listOfEpisodes = result!.map((e) => Map.of(e)).toList();
    // var data = jsonEncode(
    //   {
    //     'data': [listOfEpisodes]
    //   },
    // );
    var listOfEpisodeTypeCreate = [];
    var listOfEpisodeTypeUdate = [];
    var listOfEpisodeTypeDelete = [];
    for (var episode in listOfEpisodes) {
      if (episode['operation'] == 'create') {
        episode.remove('operation');
        episode.remove('IDs');

        listOfEpisodeTypeCreate.add(episode);
      } else if (episode['operation'] == 'update') {
        episode.remove('operation');
        episode.remove('IDs');
        listOfEpisodeTypeUdate.add(episode);
      } else {
        listOfEpisodeTypeDelete.add({'id': episode['id']});
      }
      continue;
    }

    sendToServer(listOfEpisodeTypeCreate, 'create', dbHelper);
    sendToServer(listOfEpisodeTypeUdate, 'update', dbHelper);
    sendToServer(listOfEpisodeTypeDelete, 'delete', dbHelper);
  }

  void sendToServer(List list, String operation, DatabaseHelper dbHelper) {
    if (list.isNotEmpty) {
      var data = jsonEncode(
        {'data': list},
      );

      String endPoint = operation == 'create'
          ? EndPoint.createHalaqat
          : operation == 'update'
              ? EndPoint.updateHalaqat
              : EndPoint.deleteHalaqat;

      ApiHelper()
          .postV2(endPoint, data,
              linkApi: "http://rased-api.maknon.org.sa",
              contentType: ContentTypeHeaders.applicationJson)
          .then((response) {
        if (response.isSuccess) {
          dbHelper.deleteAllWhere(DatabaseHelper.logTableEpisode,
              EpisodeColumns.operation.value, operation);
        }
      });
    }
  }

  Future<ResponseContent> edisodesFromServer(int teacherId) async {
    ResponseContent response = await ApiHelper().get(
      '${EndPoint.edisodes}?teacher_id=$teacherId',
      linkApi: "http://rased-api.maknon.org.sa",
    );

    if (response.isSuccess) {
      try {
        response.data = response.data['result'] != null
            ? (response.data['result'] as List)
                .map((e) => EpisodeStudents.fromJson(e))
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
}
