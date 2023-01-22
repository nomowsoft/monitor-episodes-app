import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monitor_episodes/model/core/shared/constants.dart';
import 'package:monitor_episodes/model/core/user/auth_model.dart';
import '../model/services/teacher_service.dart';

class TeacherController extends GetxController {
  late TextEditingController name, phone, country;
  late String gender;
  TeacherModel? _teacher;
  TeacherModel? get teacher => _teacher;
  bool _gettingData = true;

  set setGender(String setGender) => {gender = setGender, update()};
  set gettingData(bool val) => {_gettingData = val, update()};
  bool get gettingData => _gettingData;
  List genders = ['male'.tr, 'female'.tr];

  @override
  Future onInit() async {
    // ignore: todo
    // TODO: implement onInit
    super.onInit();
    initFields();
    // await getUser();
  }

  initFields() {
    name = TextEditingController();
    phone = TextEditingController();
    country = TextEditingController();
    country.text = Constants.listCountries
        .firstWhere((element) => element.code == 'SA')
        .name;
    gender = genders[0];
    _gettingData = false;
  }

  // Future userLogOut() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.clear();
  //   _teacher = null;
  //   update();
  // }

  Future signUp() async {
    // TeacherModel teacherModel = TeacherModel(
    //     name: name.text,
    //     phone: phone.text,
    //     gender: gender,
    //     address: country.text);
    // await TeacherService().setTeacherLocal(teacherModel);
    // update();
  }

  set setCountry(String setCountry) {
    country.text = setCountry;
    update();
  }

  setCountryID(int countryID) {
    country.text =
        Constants.listCountries.firstWhere((element) => element.id == countryID).name;
  }
}
