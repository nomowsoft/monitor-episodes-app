import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:monitor_episodes/model/core/shared/response_content.dart';

import '../model/core/shared/constants.dart';
import '../model/services/auth_service.dart';

abstract class AuthController {
  late TextEditingController name;
  late TextEditingController username;
  late TextEditingController password;
  late TextEditingController phone;
  late TextEditingController country;
  late int countryID;
  late String gender;

  initFilds() {}
  setCountryID(int countryID);
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
  late TextEditingController phone;

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
    name = TextEditingController();
    password = TextEditingController();
    username = TextEditingController();
    phone = TextEditingController();
    country = TextEditingController();
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
  signUp() {}

  @override
  setCountryID(int id) {
    country.text =
        Constants.listCountries.firstWhere((element) => element.id == id).name;
    countryID = id;
    update();
  }
}
