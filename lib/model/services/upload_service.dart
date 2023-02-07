import 'dart:convert';

import '../core/shared/enums.dart';
import '../core/shared/status_and_types.dart';
import '../data/database_helper.dart';
import '../helper/api_helper.dart';
import '../helper/end_point.dart';

class UploadService {
  Future<Map<String, dynamic>> getOperationOfEpisodeLogs(
      DatabaseHelper dbHelper) async {
    try {
      Map<String, dynamic> allLogs = {
        'create': List.empty(growable: true),
        'update': List.empty(growable: true),
        'delete': List.empty(growable: true)
      };
      var result = await dbHelper.queryAllRows(DatabaseHelper.logTableEpisode);
      var listOfEpisodes = result?.map((e) => Map.of(e)).toList();
      if (listOfEpisodes != null) {
        for (var element in listOfEpisodes) {
          switch (element['operation']) {
            case 'create':
              element.remove('operation');
              allLogs['create'].add(element);
              break;
            case 'update':
              element.remove('operation');
              allLogs['update'].add(element);
              break;
            case 'delete':
              element.remove('operation');
              allLogs['delete'].add(element);
              break;
            default:
          }
        }
        return allLogs;
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }

  uploadEpisode(Map<String, dynamic> allLogs, DatabaseHelper dbHelper) async {
    try {
      bool create = false, update = false, delete = false;
      for (var item in allLogs.entries) {
        String operation = item.key;
        var value = item.value;
        String endPoint = operation == 'create'
            ? EndPoint.createHalaqat
            : operation == 'update'
                ? EndPoint.updateHalaqat
                : operation == 'delete'
                    ? EndPoint.deleteHalaqat
                    : '';

        var data = jsonEncode(
          {'data': value},
        );
        var responsce = await ApiHelper().postV2(endPoint, data,
            linkApi: "http://rased-api.maknon.org.sa",
            contentType: ContentTypeHeaders.applicationJson);

        if (responsce.isSuccess) {
          dbHelper.deleteAllWhere(DatabaseHelper.logTableEpisode,
              EpisodeColumns.operation.value, operation);
          switch (operation) {
            case 'create':
              create = true;
              break;
            case 'update':
              update = true;
              break;
            case 'delete':
              delete = true;
              break;
            default:
          }
        }
      }
      // allLogs.forEach((operation, value) async {

      // });
      if (create && update && delete) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<Map<String, dynamic>> getOperationOfStudentLogs(
      DatabaseHelper dbHelper) async {
    try {
      Map<String, dynamic> allLogs = {'create': [], 'update': [], 'delete': []};
      var result =
          await dbHelper.queryAllRows(DatabaseHelper.logTableStudentOfEpisode);
      var listOfEpisodes = result?.map((e) => Map.of(e)).toList();
      if (listOfEpisodes != null) {
        for (var element in listOfEpisodes) {
          switch (element['operation']) {
            case 'create':
              element.remove('operation');
              element.update(
                  'gender', (value) => value == 'ذكر' ? 'male' : 'female');
              element.update('is_hifz', (value) => value == 1 ? true : false);
              element.update('is_tilawa', (value) => value == 1 ? true : false);
              element.update(
                  'is_big_review', (value) => value == 1 ? true : false);
              element.update(
                  'is_small_review', (value) => value == 1 ? true : false);
              allLogs['create'].add(element);
              break;
            case 'update':
              element.remove('operation');
              element.remove('halaqa_id');
              element.remove('mobile');
              element.remove('country_id');
              element.update(
                  'gender', (value) => value == 'ذكر' ? 'male' : 'female');
              element.update('is_hifz', (value) => value == 1 ? true : false);
              element.update('is_tilawa', (value) => value == 1 ? true : false);
              element.update(
                  'is_big_review', (value) => value == 1 ? true : false);
              element.update(
                  'is_small_review', (value) => value == 1 ? true : false);
              allLogs['update'].add(element);
              break;
            case 'delete':
              element.remove('operation');
              allLogs['delete'].add({'id': element['id']});
              break;
            default:
          }
        }
        return allLogs;
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }

  uploadStudent(Map<String, dynamic> allLogs, DatabaseHelper dbHelper) async {
    try {
      bool create = false, update = false, delete = false;
      for (var item in allLogs.entries) {
        String operation = item.key;
        var value = item.value;
        String endPoint = operation == 'create'
            ? EndPoint.createStudent
            : operation == 'update'
                ? EndPoint.updateStudent
                : operation == 'delete'
                    ? EndPoint.deleteStudent
                    : '';

        var data = jsonEncode(
          {'data': value},
        );
        var responsce = await ApiHelper().postV2(endPoint, data,
            linkApi: "http://rased-api.maknon.org.sa",
            contentType: ContentTypeHeaders.applicationJson);

        if (responsce.isSuccess) {
          dbHelper.deleteAllWhere(DatabaseHelper.logTableStudentOfEpisode,
              EpisodeColumns.operation.value, operation);
          switch (operation) {
            case 'create':
              create = true;
              break;
            case 'update':
              update = true;
              break;
            case 'delete':
              delete = true;
              break;
            default:
          }
        }
      }
      // allLogs.forEach((operation, value) async {

      // });
      if (create && update && delete) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<Map<String, dynamic>>?> getStudentAttendanceLogs(
      DatabaseHelper dbHelper) async {
    try {
      var result =
          await dbHelper.queryAllRows(DatabaseHelper.logTableStudentState);
      return result ?? [];
    } catch (e) {
      print(e);
      return [];
    }
  }

  uploadStudentAttendance(List<Map<String, dynamic>>? allStudentAttendanceLogs,
      DatabaseHelper dbHelper) async {
    if (allStudentAttendanceLogs!.isNotEmpty) {
      try {
        var data = jsonEncode(
          {'data': allStudentAttendanceLogs},
        );
        var responsce = await ApiHelper().postV2(
            EndPoint.createStudentAttendance, data,
            linkApi: "http://rased-api.maknon.org.sa",
            contentType: ContentTypeHeaders.applicationJson);

        if (responsce.isSuccess) {
          dbHelper.deleteAll(DatabaseHelper.logTableStudentState);
          return true;
        } else {
          return false;
        }
      } catch (e) {
        print(e);
        return false;
      }
    } else {
      return true;
    }
  }

  Future<List<Map<String, dynamic>>?> getStudentWorkLogs(
      DatabaseHelper dbHelper) async {
    try {
      var result =
          await dbHelper.queryAllRows(DatabaseHelper.logTableStudentWork);
      return result ?? [];
    } catch (e) {
      print(e);
      return [];
    }
  }

  uploadStudentWork(List<Map<String, dynamic>>? allStudentWorkLogs,
      DatabaseHelper dbHelper) async {
    if (allStudentWorkLogs!.isNotEmpty) {
      try {
        var data = jsonEncode(
          {'data': allStudentWorkLogs},
        );
        var responsce = await ApiHelper().postV2(
            EndPoint.createStudentWorks, data,
            linkApi: "http://rased-api.maknon.org.sa",
            contentType: ContentTypeHeaders.applicationJson);

        if (responsce.isSuccess) {
          dbHelper.deleteAll(DatabaseHelper.logTableStudentWork);
          return true;
        } else {
          return false;
        }
      } catch (e) {
        print(e);
        return false;
      }
    } else {
      return true;
    }
  }
}
