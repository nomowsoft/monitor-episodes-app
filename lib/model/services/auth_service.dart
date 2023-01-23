import 'dart:convert';

import 'package:monitor_episodes/model/core/shared/response_content.dart';
import 'package:monitor_episodes/model/helper/api_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/shared/status_and_types.dart';
import '../core/user/auth_model.dart';
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
    ResponseContent response = await _apiHelper.postV2(
        EndPoint.signIn, jsonEncode(data),
        linkApi: "http://rased-api.maknon.org.sa",
        contentType: ContentTypeHeaders.applicationJson);
    if (response.success ?? false) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('teacher_id', response.data['result']['data']['teacher_id']);
    } else {
      response.message = 'اسم المستخدم او كلمة المرور خطا';
    }
    return response;
  }

  Future<ResponseContent> postSignUp(
      {required TeacherModel teacherModel}) async {
    Map<String, dynamic> data = teacherModel.toJson();
    // Map<String, dynamic> d = {
    //   "name": "test",
    //   "login": "test10",
    //   "password": "123",
    //   "mobile": "555555555",
    //   "country_id": 1
    // };
    ResponseContent response = await _apiHelper.postV2(
        EndPoint.createTeacherAccount, jsonEncode(data),
        linkApi: "http://rased-api.maknon.org.sa",
        contentType: ContentTypeHeaders.applicationJson);
    if (response.success ?? false) {
      if (response.data['result']['success']) {
        print(response.data);
        response.success = true;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt('teacher_id', response.data['result']['data']['user_id']);
      } else {
        print(response.data);
        response.success = false;
        response.message = response.data['result']['error'];
      }
    }else{
      response.message = 'اسم المستخدم موجود بالفعل الرجاء تسجيل الدخول';

    }
    return response;
  }
}
