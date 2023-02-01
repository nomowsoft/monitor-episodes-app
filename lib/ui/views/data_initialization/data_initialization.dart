import 'package:flutter/material.dart';
import 'package:monitor_episodes/model/core/shared/globals/size_config.dart';

import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../controller/data_sync_controller.dart';

class DataInitialization extends StatefulWidget {
  const DataInitialization({Key? key}) : super(key: key);

  @override
  State<DataInitialization> createState() => _DataInitializationState();
}

class _DataInitializationState extends State<DataInitialization> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: GetBuilder(
            init: DataSyncController(),
            builder: (DataSyncController dataSyncController) =>
                dataSyncController.gettingEpisodes
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            SvgPicture.asset(
                              'images/sync.svg',
                              height: 200.h,
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Text(
                              'initializing_loading_data'.tr,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                height: 1.5,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                              textScaleFactor: SizeConfig.textScaleFactor,
                            ),
                            SizedBox(
                              height: 50.h,
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.only(start: 30.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      dataSyncController.gettingEpisodes
                                          ? SizedBox(
                                              width: 30.w,
                                              height: 30.w,
                                              child: CircularProgressIndicator(
                                                color: Get.theme.primaryColor,
                                              ),
                                            )
                                          : Icon(
                                              Icons.check_circle_outline,
                                              color: Colors.green,
                                              size: 30.sp,
                                            ),
                                      SizedBox(
                                        width: 20.w,
                                      ),
                                      Text(
                                        '${'episodes_and_students'.tr} ...',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textScaleFactor:
                                            SizeConfig.textScaleFactor,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Row(
                                    children: [
                                      dataSyncController.gettingEpisodes
                                          ? SizedBox(
                                              width: 30.w,
                                              height: 30.w,
                                              child: CircularProgressIndicator(
                                                color: Get.theme.primaryColor,
                                              ),
                                            )
                                          : dataSyncController.gettingEpisodes
                                              ? Icon(
                                                  Icons.info,
                                                  color: Colors.grey,
                                                  size: 30.sp,
                                                )
                                              : Icon(
                                                  Icons.check_circle_outline,
                                                  color: Colors.green,
                                                  size: 30.sp,
                                                ),
                                      SizedBox(
                                        width: 20.w,
                                      ),
                                      Text(
                                        '${'student_courses'.tr} ...',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textScaleFactor:
                                            SizeConfig.textScaleFactor,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Row(
                                    children: [
                                      dataSyncController.gettingEpisodes
                                          ? SizedBox(
                                              width: 30.w,
                                              height: 30.w,
                                              child: CircularProgressIndicator(
                                                color: Get.theme.primaryColor,
                                              ),
                                            )
                                          : dataSyncController.gettingEpisodes
                                              ? Icon(
                                                  Icons.info,
                                                  color: Colors.grey,
                                                  size: 30.sp,
                                                )
                                              : Icon(
                                                  Icons.check_circle_outline,
                                                  color: Colors.green,
                                                  size: 30.sp,
                                                ),
                                      SizedBox(
                                        width: 20.w,
                                      ),
                                      Text(
                                        '${'educational_plan'.tr} ...',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textScaleFactor:
                                            SizeConfig.textScaleFactor,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                ],
                              ),
                            ),
                          ])
                    : dataSyncController.hasError
                        ? Center(
                            child: InkWell(
                            onTap: () {
                              dataSyncController.loadDataSaveLocal();
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 40,
                                ),
                                Icon(Icons.refresh, color: Colors.red.shade700),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Text(
                                  (!dataSyncController.hasError)
                                      ? 'error_connect_to_netwotk'.tr
                                      : 'error_connect_to_server'.tr,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textScaleFactor: SizeConfig.textScaleFactor,
                                ),
                              ],
                            ),
                          ))
                        : const SizedBox()),
      ),
    );
  }
}
