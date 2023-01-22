import 'dart:convert';

import 'package:monitor_episodes/model/core/shared/response_content.dart';
import 'package:monitor_episodes/model/helper/api_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/shared/status_and_types.dart';
import '../helper/end_point.dart';

class AuthService {
  final ApiHelper _apiHelper = ApiHelper();
  Future<ResponseContent> postSignIn(
      {required String username, required String password}) async {
    Map<String, dynamic> data = {
      "jsonrpc": "2.0",
      "params": {
        "db": "halaqat_monitoring",
        "login": username,
        "password": password
      }
    };
    ResponseContent response = await _apiHelper.postV2(EndPoint.signIn, jsonEncode(data),
        linkApi: "http://rased-api.maknon.org.sa",
        contentType: ContentTypeHeaders.applicationJson);
    if (response.success ?? false) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt(
          'teacher_id', response.data['result']['data']['teacher_id']);
    }
    return response;
  }
}
