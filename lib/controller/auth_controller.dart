import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:monitor_episodes/model/core/shared/response_content.dart';
import 'package:monitor_episodes/model/core/user/auth_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/core/shared/constants.dart';
import '../model/services/auth_service.dart';

abstract class AuthController {
  late TextEditingController name;
  late TextEditingController username;
  late TextEditingController password;
  late TextEditingController mobile;
  late TextEditingController country;
  late int countryID;
  late String gender;

  initFilds() {}
  setCountryID(String countryID);
  signIn() async {}
  signUp() async {}
}

class AuthControllerImp extends GetxController implements AuthController {
  @override
  late TextEditingController name;
  @override
  late TextEditingController password;

  @override
  late TextEditingController username;
  @override
  late TextEditingController country;
  @override
  late int countryID;

  @override
  late String gender;

  @override
  late TextEditingController mobile;

  late TextEditingController email;
  late TextEditingController newPasswordUser;

  late TextEditingController code;

  List genders = ['male'.tr, 'female'.tr];

  bool _gettingData = true;
  bool _hasError = true;

  set setGender(String setGender) => {gender = setGender, update()};
  set gettingData(bool val) => {_gettingData = val, update()};
  bool get gettingData => _gettingData;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initFilds();
  }

  @override
  initFilds() {
    email = TextEditingController();
    name = TextEditingController();
    password = TextEditingController();
    username = TextEditingController();
    mobile = TextEditingController();
    country = TextEditingController();
    code = TextEditingController();
    newPasswordUser = TextEditingController();
    countryID = 192;
    country.text = Constants.listCountries
        .firstWhere((element) => element.code == 'SA')
        .name;
    gender = genders[0];

    _gettingData = false;
    _hasError = false;
  }

  @override
  Future<ResponseContent> signIn() async {
    ResponseContent response = await AuthService()
        .postSignIn(username: username.text, password: password.text);
    return response;
  }

  @override
  Future<ResponseContent> signUp() async {
    TeacherModel teacherModel = TeacherModel(
        name: name.text,
        login: username.text,
        password: password.text,
        gender: gender,
        mobile: mobile.text,
        country: country.text,
        countryID: countryID);
    ResponseContent response =
        await AuthService().postSignUp(teacherModel: teacherModel);
    if (response.isSuccess || response.isNoContent) {
      ResponseContent response = await AuthService()
          .postSignIn(username: username.text, password: password.text);
      return response;
    }
    return response;
  }

  @override
  setCountryID(String id) {
    country.text =
        Constants.listCountries.firstWhere((element) => element.id == id).name;
    countryID = int.parse(id);
    update();
  }

  generateRandom() {
    int min = 1000;
    int max = 9999;
    var randomizer = Random();
    var rNum = min + randomizer.nextInt(max - min);
    return rNum;
  }

  Future<ResponseContent> sendCode() async {
    int number = generateRandom();
    DateTime dateToday = DateTime.now();
    String date = dateToday.toString();
    // .substring(0, 10)
    // print(dateToday.hour.toString() +
    //     ":" +
    //     dateToday.minute.toString() +
    //     ":" +
    //     dateToday.second.toString());
    // print(date);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('time_random_number', date);

    prefs.setInt('random_number', number);

    ResponseContent response =
        await AuthService().postSendCode(email.text, number);
    return response;
  }

  Future<ResponseContent> newPassword() async {
    ResponseContent response =
        await AuthService().postNewPassword(email.text, newPasswordUser.text);
    if (response.isSuccess || response.isNoContent) {
      ResponseContent response = await AuthService()
          .postSignIn(username: email.text, password: newPasswordUser.text);
      return response;
    }
    return response;
  }
}
