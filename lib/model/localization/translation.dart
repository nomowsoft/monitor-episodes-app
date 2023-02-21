import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:monitor_episodes/model/localization/ar.dart';
import 'package:monitor_episodes/model/localization/en.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Translation extends Translations {
  @override
  // ignore: todo
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
        'en': translateEnglish,
        'ar': translateArabic,
      };

  // Default locale
  static Locale locale = const Locale('ar');

  // fallbackLocale saves the day when the locale gets in trouble
  static Locale fallbackLocale = const Locale('ar');

  Future<bool> fetchLocale() async {
    try {
      var prefs = await SharedPreferences.getInstance();
      if (prefs.getString('language_code') == null) {
        locale = const Locale('ar');
        return true;
      }
      locale = Locale(prefs.getString('language_code')!);
      return true;
    } catch (e) {
      return false;
    }
  }

  void changeLanguage(Locale type) async {
    var prefs = await SharedPreferences.getInstance();
    if (locale == type) {
      return;
    }
    if (type == const Locale("ar")) {
      locale = const Locale("ar");
      await prefs.setString('language_code', 'ar');
     await Get.updateLocale(locale);
    } else {
      locale = const Locale("en");
      await prefs.setString('language_code', 'en');
     await Get.updateLocale(locale);

    }
  }
}
