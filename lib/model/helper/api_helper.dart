import 'dart:convert' as convert;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/shared/response_content.dart';
import '../core/shared/status_and_types.dart';

class ApiHelper {
  String url = '/api/';
  String link = 'https://api.e-maknoon.org';
  String link2 = 'https://e-maknoon.org';

  Future<bool> testConected() async {
    try {
      final result = await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // ignore: avoid_print
        print('connected');
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      // ignore: avoid_print
      print('not connected');
      return false;
    }
  }
  Future<ResponseContent> getV1<T>(String endPoint,
      {String? linkApi ,String linkCon = '', String header = ''}) async {
    final client = http.Client();
    try {
      Uri uri = Uri.parse(linkApi!=null ? '$linkApi/$endPoint' : (link + url + endPoint));
      final response = await client.get(uri, headers: {'Language': header});
      if (response.statusCode >= 200 && response.statusCode < 299) {
        try {
          var data = convert.jsonDecode(response.body);
          ResponseContent result = ResponseContent.fromJsonList(data,response.statusCode);
          return result;
        } catch (e) {
          return ResponseContent(
              statusCode: '1', message: '#Convert-Response#\n${e.toString()}');
        }
      } else if (response.statusCode >= 400 && response.statusCode < 499) {
        var data = convert.jsonDecode(response.body);
        ResponseContent result = ResponseContent.fromJsonList(data,response.statusCode);
        return result;
      } else {
        return ResponseContent(
            statusCode: '-${response.statusCode.toString()}',
            message: response.body);
      }
    } catch (e) {
      return ResponseContent(
          statusCode: '0', message: 'error_connect_to_netwotk'.tr);
    }
  }

  Future<ResponseContent> postV2<T>(String endPoint, T value,
      {String? linkApi,
      String? contentType,
      bool withToken = false,
      Map<String, String>? headers}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final client = http.Client();
    try {
      Uri uri = Uri.parse(
          linkApi != null ? '$linkApi/$endPoint' : (link + url + endPoint));
      final response = await client.post(uri, body: value, headers: {
        "Accept": "application/json",
        "Content-Type": contentType ?? ContentTypeHeaders.formUrlEncoded,
        'cookie': pref.getString('cookie') ?? '',
        // 'Access-Token':
        //     withToken ? Get.find<UserController>().userLogin?.token ?? '' : '',
        ...?headers
      });
      // create 2,3
      if (response.statusCode >= 200 && response.statusCode < 299) {
        updateCookie(response, pref);
        try {
          var data = convert.jsonDecode(response.body);
          print(data);
          ResponseContent result =
              ResponseContent.fromJson(data, response.statusCode);
          return result;
        } catch (e) {
          print(e);
          return ResponseContent(
              statusCode: '1', message: '#Convert-Response#\n${e.toString()}');
        }
      } else if (response.statusCode >= 400 && response.statusCode < 499) {
        var data = convert.jsonDecode(response.body);
        ResponseContent result =
            ResponseContent.fromJson(data, response.statusCode);
        return result;
      } else {
        return ResponseContent(
            statusCode: '-${response.statusCode.toString()}',
            message: response.body);
      }
    } catch (e) {
      print(e);
      return ResponseContent(
          statusCode: '0', message: 'error_connect_to_netwotk'.tr);
    }
  }

    Future<ResponseContent> get<T>(String endPoint,
      {String? linkApi, String? contentType, Map<String, String>? headers}) async {

    SharedPreferences pref = await SharedPreferences.getInstance();
    final client = http.Client();
    try {
      Uri uri = Uri.parse(
          linkApi != null ? '$linkApi/$endPoint' : (link + url + endPoint));
      final response = await client.get(uri, headers: {
        "Accept": "application/json",
        "Content-Type": contentType ?? ContentTypeHeaders.applicationJson,
        'cookie': pref.getString('cookie') ?? '',
        ...?headers
      });
      if (response.statusCode >= 200 && response.statusCode < 299) {
        try {
          var data = convert.jsonDecode(response.body);
          ResponseContent result = ResponseContent.fromJson(data,response.statusCode);
          return result;
        } catch (e) {
          return ResponseContent(
              statusCode: '1', message: '#Convert-Response#\n${e.toString()}');
        }
      } else if (response.statusCode >= 400 && response.statusCode < 499) {
        var data = convert.jsonDecode(response.body);
        ResponseContent result = ResponseContent.fromJson(data,response.statusCode);
        return result;
      } else {
        return ResponseContent(
            statusCode: '-${response.statusCode.toString()}',
            message: response.body);
      }
    } catch (e) {
      return ResponseContent(
          statusCode: '0', message: 'error_connect_to_netwotk'.tr);
    }
  }

  void updateCookie(http.Response response, SharedPreferences pref) {
    String? rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      pref.setString(
          'cookie', index == -1 ? rawCookie : rawCookie.substring(0, index));
    }
  }
}
