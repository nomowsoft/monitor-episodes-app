import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monitor_episodes/model/core/shared/globals/size_config.dart';
import 'package:monitor_episodes/model/localization/translation.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late String language;
  late Translation translation;
  @override
  void initState() {
    language = Get.locale!.languageCode == 'ar' ? 'عربي' : 'English';
    translation = Translation();
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              decoration: BoxDecoration(
                  color: const Color.fromARGB(179, 238, 238, 238),
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                    child: Text(
                      'language'.tr,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  RadioListTile(
                    title: const Text("عربي"),
                    value: "عربي",
                    groupValue: language,
                    onChanged: (value) {
                      if (language != 'عربي') {
                        language = value.toString();
                        translation.changeLanguage(const Locale('ar'));
                      }
                    },
                  ),
                  RadioListTile(
                    title: const Text("English"),
                    value: "English",
                    groupValue: language,
                    onChanged: (value) {
                      if (language != 'English') {
                        language = value.toString();
                        translation.changeLanguage(const Locale('en'));
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.w,
            ),
          ]),
        ),
      ),
    );
  }
}
