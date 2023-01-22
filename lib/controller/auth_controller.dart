import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

abstract class AuthController {
  late TextEditingController username;
  late TextEditingController password;

  initFilds() {}
  signIn() async {}
}

class AuthControllerImp extends GetxController implements AuthController {
  @override
  late TextEditingController password;

  @override
  late TextEditingController username;
  bool _gettingData = true;
  bool _hasError = true;
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
    password = TextEditingController();
    username = TextEditingController();
    _gettingData = false;
    _hasError = false;
  }

  @override
   signIn() async {

  }
}
