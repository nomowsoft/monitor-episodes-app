import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:monitor_episodes/controller/home_controller.dart';
import 'package:monitor_episodes/controller/statistics_controller.dart';
import 'package:monitor_episodes/model/core/shared/globals/size_config.dart';
import 'package:monitor_episodes/model/localization/translation.dart';
import 'package:monitor_episodes/model/services/auth_service.dart';
import 'package:monitor_episodes/ui/shared/utils/custom_dailogs.dart';
import 'package:monitor_episodes/ui/shared/utils/waitting_dialog.dart';
import 'package:monitor_episodes/ui/views/home/widgets/monitor_episode/monitor_episodes.dart';
import 'package:monitor_episodes/ui/views/home/widgets/monitor_episode/widgets/add_episode.dart';
import 'package:monitor_episodes/ui/views/home/widgets/monitor_episode/widgets/episode_details/widgets/add_student.dart';
import 'package:monitor_episodes/ui/views/home/widgets/setting/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/core/shared/response_content.dart';
import '../login_screen/login_screen.dart';
import 'widgets/about_us/about_us.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String language;
  late Translation translation;
  double bodyHeight = 0.0;
  bool isOpen = false;
  @override
  void initState() {
    language = Get.locale!.languageCode == 'ar' ? 'عربي' : 'English';
    translation = Translation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: HomeController(),
      builder: (HomeController homeController) => Scaffold(
          appBar: AppBar(
            backgroundColor: Get.theme.primaryColor,
            title: Text(
              homeController.currentPageIndex == 2
                  ? 'about_as'.tr
                  : homeController.currentPageIndex == 3
                      ? 'settings'.tr
                      : 'monitor_episodes'.tr,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800),
              textScaleFactor: SizeConfig.textScaleFactor,
            ),
            titleSpacing: 2,
            centerTitle: true,
          ),
          backgroundColor: Colors.white,
          drawer: Drawer(
              backgroundColor: Get.theme.primaryColor,
              child: SafeArea(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        'images/bgR2.png',
                        repeat: ImageRepeat.repeat,
                      ),
                    ),
                    Positioned.fill(
                        child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'images/maknoon_icon.svg',
                              height: 100.h,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 15.w),
                                decoration: const BoxDecoration(
                                  color: Color(0xffF1F1F1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.person,
                                  color: Get.theme.secondaryHeaderColor,
                                  size: 40,
                                )),
                            SizedBox(
                              height: 20.h,
                            ),
                            Text(
                              homeController.teacher?.name ?? '',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500),
                              textScaleFactor: SizeConfig.textScaleFactor,
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Divider(
                                color: Colors.white,
                                indent: 20.w,
                                endIndent: 20.w),
                            SizedBox(
                              height: 20.h,
                            ),
                            // monitor_episodes
                            ListTile(
                              leading: const Icon(
                                Icons.menu_open,
                                color: Colors.white,
                              ),
                              title: Text(
                                'monitor_episodes'.tr,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500),
                                textScaleFactor: SizeConfig.textScaleFactor,
                              ),
                              onTap: () {
                                homeController.currentPageIndex = 1;
                                Get.back();
                                // Get.to(() => const GlossaryOfTerms());
                              },
                            ),

                            //add_episode
                            ListTile(
                              leading: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              title: Text(
                                'add_episode'.tr,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500),
                                textScaleFactor: SizeConfig.textScaleFactor,
                              ),
                              onTap: () async {
                                Get.back();
                                bool? result = await Get.dialog(
                                  const AddEpisode(),
                                  transitionDuration:
                                      const Duration(seconds: 1),
                                  transitionCurve: Curves.easeInOut,
                                );
                                if (result != null) {
                                  Get.put(StatisticsController())
                                      .getStatisics();
                                  CostomDailogs.snackBar(
                                      response: ResponseContent(
                                          statusCode: '200',
                                          success: true,
                                          message: 'ok_add'.tr));
                                }
                              },
                            ),
                            //add_student
                            ListTile(
                              leading: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              title: Text(
                                'add_student'.tr,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500),
                                textScaleFactor: SizeConfig.textScaleFactor,
                              ),
                              onTap: () async {
                                Get.back();
                                bool? result = await Get.dialog(
                                  const AddStudent(),
                                  transitionDuration:
                                      const Duration(seconds: 1),
                                  transitionCurve: Curves.easeInOut,
                                );
                                if (result != null) {
                                  Get.put(StatisticsController())
                                      .getStatisics();
                                  CostomDailogs.snackBar(
                                      response: ResponseContent(
                                          statusCode: '200',
                                          success: true,
                                          message: 'ok_add'.tr));
                                }
                              },
                            ),
                            // about_as
                            ListTile(
                              leading: const Icon(
                                Icons.notifications,
                                color: Colors.white,
                              ),
                              title: Text(
                                'about_as'.tr,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500),
                                textScaleFactor: SizeConfig.textScaleFactor,
                              ),
                              onTap: () {
                                homeController.currentPageIndex = 2;
                                Get.back();
                              },
                            ),
                            ExpansionTile(
                                tilePadding:
                                    EdgeInsetsDirectional.only(end: 16.w),
                                iconColor: Colors.white,
                                collapsedIconColor: Colors.white,
                                title: ListTile(
                                  leading: const Icon(
                                    Icons.translate,
                                    color: Colors.white,
                                  ),
                                  title: Text(
                                    'language'.tr,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500),
                                    textScaleFactor: SizeConfig.textScaleFactor,
                                  ),
                                ),
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RadioListTile(
                                        activeColor:
                                            Get.theme.secondaryHeaderColor,
                                        title: Text(
                                          "عربي",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        value: "عربي",
                                        groupValue: language,
                                        onChanged: (value) {
                                          if (language != 'عربي') {
                                            language = value.toString();
                                            translation.changeLanguage(
                                                const Locale('ar'));
                                          }
                                        },
                                      ),
                                      RadioListTile(
                                        activeColor:
                                            Get.theme.secondaryHeaderColor,
                                        title: Text(
                                          "English",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        value: "English",
                                        groupValue: language,
                                        onChanged: (value) {
                                          if (language != 'English') {
                                            language = value.toString();
                                            translation.changeLanguage(
                                                const Locale('en'));
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ]),

                            // Theme(
                            //   data: Theme.of(context)
                            //       .copyWith(brightness: Brightness.light),
                            //   child: ExpansionPanelList(
                            //     elevation: 0,
                            //     expansionCallback: (panelIndex, isExpanded) {
                            //       setState(() {
                            //         isOpen = !isExpanded;
                            //       });
                            //     },
                            //     children: [
                            //       ExpansionPanel(
                            //         canTapOnHeader: true,
                            //         backgroundColor: Colors.transparent,
                            //         isExpanded: isOpen,
                            //         headerBuilder: (BuildContext context,
                            //             bool isExpanded) {
                            //           return ListTile(
                            //             leading: const Icon(
                            //               Icons.translate,
                            //               color: Colors.white,
                            //             ),
                            //             trailing: const Icon(
                            //               Icons.keyboard_arrow_down_rounded,
                            //               color: Colors.white,
                            //             ),
                            //             title: Text(
                            //               'language'.tr,
                            //               style: TextStyle(
                            //                   color: Colors.white,
                            //                   fontSize: 16.sp,
                            //                   fontWeight: FontWeight.w500),
                            //               textScaleFactor:
                            //                   SizeConfig.textScaleFactor,
                            //             ),
                            //           );
                            //         },
                            //         body: Column(
                            //           crossAxisAlignment:
                            //               CrossAxisAlignment.start,
                            //           children: [
                            //             RadioListTile(
                            //               activeColor:
                            //                   Get.theme.secondaryHeaderColor,
                            //               title: Text(
                            //                 "عربي",
                            //                 style: TextStyle(
                            //                     color: Colors.white,
                            //                     fontSize: 14.sp,
                            //                     fontWeight: FontWeight.w500),
                            //               ),
                            //               value: "عربي",
                            //               groupValue: language,
                            //               onChanged: (value) {
                            //                 if (language != 'عربي') {
                            //                   language = value.toString();
                            //                   translation.changeLanguage(
                            //                       const Locale('ar'));
                            //                 }
                            //               },
                            //             ),
                            //             RadioListTile(
                            //               activeColor:
                            //                   Get.theme.secondaryHeaderColor,
                            //               title: Text(
                            //                 "English",
                            //                 style: TextStyle(
                            //                     color: Colors.white,
                            //                     fontSize: 14.sp,
                            //                     fontWeight: FontWeight.w500),
                            //               ),
                            //               value: "English",
                            //               groupValue: language,
                            //               onChanged: (value) {
                            //                 if (language != 'English') {
                            //                   language = value.toString();
                            //                   translation.changeLanguage(
                            //                       const Locale('en'));
                            //                 }
                            //               },
                            //             ),
                            //           ],
                            //         ),
                            //       )
                            //     ],
                            //   ),
                            // ),

                            // //Language
                            // isOpen
                            //     ? const Divider(
                            //         thickness: 1.5,
                            //       )
                            //     : const SizedBox(),

                            // ListTile(
                            //   leading: const Icon(
                            //     Icons.translate,
                            //     color: Colors.white,
                            //   ),
                            //   trailing: const Icon(
                            //     Icons.keyboard_arrow_down_rounded,
                            //     color: Colors.white,
                            //   ),
                            //   title: Text(
                            //     'language'.tr,
                            //     style: TextStyle(
                            //         color: Colors.white,
                            //         fontSize: 16.sp,
                            //         fontWeight: FontWeight.w500),
                            //     textScaleFactor: SizeConfig.textScaleFactor,
                            //   ),
                            //   onTap: () async {
                            //     // homeController.currentPageIndex = 3;
                            //     // Get.back();
                            //     isOpen = !isOpen;
                            //     if (isOpen) {
                            //       bodyHeight = 150.h;
                            //     } else {
                            //       bodyHeight = 0.0;
                            //     }
                            //     setState(() {});
                            //   },
                            // ),

                            // AnimatedContainer(
                            //   curve: Curves.easeInOut,
                            //   duration: const Duration(milliseconds: 500),
                            //   height: bodyHeight,
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       RadioListTile(
                            //         activeColor: Get.theme.secondaryHeaderColor,
                            //         title: Text(
                            //           "عربي",
                            //           style: TextStyle(
                            //               color: Colors.white,
                            //               fontSize: 14.sp,
                            //               fontWeight: FontWeight.w500),
                            //         ),
                            //         value: "عربي",
                            //         groupValue: language,
                            //         onChanged: (value) {
                            //           if (language != 'عربي') {
                            //             language = value.toString();
                            //             translation
                            //                 .changeLanguage(const Locale('ar'));
                            //           }
                            //         },
                            //       ),
                            //       RadioListTile(
                            //         activeColor: Get.theme.secondaryHeaderColor,
                            //         title: Text(
                            //           "English",
                            //           style: TextStyle(
                            //               color: Colors.white,
                            //               fontSize: 14.sp,
                            //               fontWeight: FontWeight.w500),
                            //         ),
                            //         value: "English",
                            //         groupValue: language,
                            //         onChanged: (value) {
                            //           if (language != 'English') {
                            //             language = value.toString();
                            //             translation
                            //                 .changeLanguage(const Locale('en'));
                            //           }
                            //         },
                            //       ),
                            //     ],
                            //   ),
                            //   // color: Colors.red,
                            // ),
                            // isOpen
                            //     ? const Divider(
                            //         thickness: 1.5,
                            //       )
                            //     : const SizedBox(),
                            
                            // delete account
                            ListTile(
                              leading: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                              title: Text(
                                'delete_account'.tr,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500),
                                textScaleFactor: SizeConfig.textScaleFactor,
                              ),
                              onTap: () async {
                                bool result =
                                    await CostomDailogs.yesNoDialogWithText(
                                        text: 'confirm_delete_account'.tr);
                                // remove from server
                                if (result) {
                                  Get.defaultDialog(
                                      content: const WaitingDialog(),
                                      title: '',
                                      titlePadding: const EdgeInsets.all(5),
                                      middleText: '');
                                  var response =
                                      await AuthService().deleteAccount();
                                  Get.back();
                                  if (response.isSuccess) {
                                    // remove from local
                                    var homeController =
                                        Get.find<HomeController>();
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.clear();
                                    prefs.setString('language_code',
                                        Translation.locale.languageCode);
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
                            ),
                            //logout
                            ListTile(
                              leading: const Icon(
                                Icons.logout,
                                color: Colors.white,
                              ),
                              title: Text(
                                'logout'.tr,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500),
                                textScaleFactor: SizeConfig.textScaleFactor,
                              ),
                              onTap: () async {
                                // Get.back();
                                final prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setBool('isLogin', false);
                                await homeController.deleteDatabase();
                                Get.offAll(() => const LoginScreen(),
                                    duration: const Duration(seconds: 2),
                                    curve: Curves.easeInOut,
                                    transition: Transition.fadeIn);
                                // bool result =
                                //     await CostomDailogs.yesNoDialogWithText(
                                //         text:
                                //             'do_you_want_to_logout_and_delete_all_data'
                                //                 .tr);
                                // // if (result) {
                                // await homeController.deleteAllEdisodes();
                                // await homeController.removeTeacherLocal();
                                // }
                              },
                            ),
                          ],
                        ),
                      ),
                    )),
                  ],
                ),
              )),
          body: SafeArea(
              child: OrientationBuilder(builder: (context, orientation) {
            SizeConfig('initialSize')
                .init(originalWidth: 428, originalHeight: 926);
            return Stack(children: [
              Positioned.fill(
                child: Image.asset(
                  'images/bgR2.png',
                  repeat: ImageRepeat.repeat,
                ),
              ),
              Positioned.fill(
                  child: homeController.currentPageIndex == 1
                      ? const MonitorEpisodes()
                      : homeController.currentPageIndex == 2
                          ? const AboutUs()
                          : const Settings()),
            ]);
          }))),
    );
  }
}
