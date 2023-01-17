import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monitor_episodes/controller/home_controller.dart';
import 'package:monitor_episodes/model/core/shared/globals/size_config.dart';
import 'package:monitor_episodes/model/core/shared/response_content.dart';
import 'package:monitor_episodes/ui/shared/utils/custom_dailogs.dart';
import 'package:monitor_episodes/ui/shared/widgets/color_loader/color_loader.dart';
import 'package:monitor_episodes/ui/views/home/widgets/monitor_episode/widgets/add_episode.dart';

import 'widgets/item_episode.dart';
import 'widgets/statistics/statistics.dart';

class MonitorEpisodes extends StatefulWidget {
  const MonitorEpisodes({super.key});

  @override
  State<MonitorEpisodes> createState() => _MonitorEpisodesState();
}

class _MonitorEpisodesState extends State<MonitorEpisodes> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      builder: (HomeController homeController) => Scaffold(body:
          SafeArea(child: OrientationBuilder(builder: (context, orientation) {
        SizeConfig('initialSize').init(originalWidth: 428, originalHeight: 926);
        return Stack(children: [
          Positioned.fill(
            child: Image.asset(
              'images/bgR2.png',
              repeat: ImageRepeat.repeat,
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              homeController.currentIndex = 1;
                            });
                          },
                          child: Card(
                            elevation: 3,
                            margin: EdgeInsets.zero,
                            color: homeController.currentIndex == 1
                                ? Get.theme.secondaryHeaderColor
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                side: BorderSide(
                                    color: homeController.currentIndex == 1
                                        ? Get.theme.secondaryHeaderColor
                                        : Colors.white)),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              child: Text(
                                'statistics'.tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: homeController.currentIndex == 1
                                      ? Colors.white
                                      : Get.theme.primaryColor,
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              homeController.currentIndex = 2;
                            });
                            homeController.loadEpisodes();
                          },
                          child: Card(
                            elevation: 3,
                            margin: EdgeInsets.zero,
                            color: homeController.currentIndex == 2
                                ? Get.theme.secondaryHeaderColor
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10)),
                                side: BorderSide(
                                  color: homeController.currentIndex == 2
                                      ? Get.theme.secondaryHeaderColor
                                      : Colors.white,
                                )),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              child: Text(
                                'episodes'.tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: homeController.currentIndex == 2
                                      ? Colors.white
                                      : Get.theme.primaryColor,
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: homeController.currentIndex == 1
                        ? const Statistics()
                        : homeController.listEpisodes.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'there_is_no_episodes'.tr,
                                      style: TextStyle(
                                          color: Get.theme.primaryColor,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w800),
                                      textScaleFactor:
                                          SizeConfig.textScaleFactor,
                                    ),
                                    SizedBox(
                                      height: 50.h,
                                    ),
                                    InkWell(
                                      onTap: (() async {
                                        bool? result = await Get.dialog(
                                          const AddEpisode(),
                                          transitionDuration:
                                              const Duration(seconds: 1),
                                          transitionCurve: Curves.easeInOut,
                                        );
                                        if (result != null) {
                                          CostomDailogs.snackBar(
                                              response: ResponseContent(
                                                  statusCode: '200',
                                                  success: true,
                                                  message: 'ok_add'.tr));
                                        }
                                      }),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Get.theme.secondaryHeaderColor
                                                  .withOpacity(.7),
                                              Get.theme.secondaryHeaderColor,
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black12,
                                              offset: Offset(5, 5),
                                              blurRadius: 10,
                                            )
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            'add_episode'.tr,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textScaleFactor:
                                                SizeConfig.textScaleFactor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Column(
                                children: [
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  InkWell(
                                    onTap: (() async {
                                      bool? result = await Get.dialog(
                                        const AddEpisode(),
                                        transitionDuration:
                                            const Duration(seconds: 1),
                                        transitionCurve: Curves.easeInOut,
                                      );
                                      if (result != null) {
                                        CostomDailogs.snackBar(
                                            response: ResponseContent(
                                                statusCode: '200',
                                                success: true,
                                                message: 'ok_add'.tr));
                                      }
                                    }),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Get.theme.secondaryHeaderColor
                                                .withOpacity(.7),
                                            Get.theme.secondaryHeaderColor,
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black12,
                                            offset: Offset(5, 5),
                                            blurRadius: 10,
                                          )
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          'add_episode'.tr,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textScaleFactor:
                                              SizeConfig.textScaleFactor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Expanded(
                                      child: homeController.gettingEpisodes
                                          ? const Center(
                                              child: ColorLoader(),
                                            )
                                          : ListView.separated(
                                              itemBuilder: (_, index) =>
                                                  ItemEpisode(
                                                      episode: homeController
                                                          .listEpisodes[index]),
                                              separatorBuilder: (_, __) =>
                                                  const SizedBox(),
                                              itemCount: homeController
                                                  .listEpisodes.length))
                                ],
                              ),
                  ),
                ],
              ),
            ),
          ),
        ]);
      }))),
    );
  }
}
