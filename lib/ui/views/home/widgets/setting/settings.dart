import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monitor_episodes/controller/home_controller.dart';
import 'package:monitor_episodes/model/core/shared/globals/size_config.dart';
import 'package:monitor_episodes/model/localization/translation.dart';
import 'package:monitor_episodes/model/services/auth_service.dart';
import 'package:monitor_episodes/ui/shared/utils/custom_dailogs.dart';
import 'package:monitor_episodes/ui/shared/utils/waitting_dialog.dart';
import 'package:monitor_episodes/ui/views/login_screen/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
            InkWell(
              onTap: () async {
                bool result = await CostomDailogs.yesNoDialogWithText(
                    text: 'confirm_delete_account'.tr);
                // remove from server
                if (result) {
                  Get.defaultDialog(
                      content: const WaitingDialog(),
                      title: '',
                      titlePadding:const EdgeInsets.all(5),
                      middleText: '');
                  var response = await AuthService().deleteAccount();
                  Get.back();
                  if (response.isSuccess) {
                    // remove from local
                    var homeController = Get.find<HomeController>();
                    final prefs = await SharedPreferences.getInstance();
                    prefs.clear();
                    prefs.setString('language_code', Translation.locale.languageCode);
                    await homeController.deleteDatabase();
                    Get.offAll(() => const LoginScreen(),
                        duration: const Duration(seconds: 2),
                        curve: Curves.easeInOut,
                        transition: Transition.fadeIn);
                  } else {
                    CostomDailogs.snackBar(response: response);
                  }
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(179, 238, 238, 238),
                    borderRadius: BorderRadius.circular(12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          width: 0.5,
                          height: 20,
                          decoration:
                              BoxDecoration(color: Get.theme.primaryColor),
                        ),
                        Text(
                          'delete_account'.tr,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const Icon(Icons.arrow_forward)
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
