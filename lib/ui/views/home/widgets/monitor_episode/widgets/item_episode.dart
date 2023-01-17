import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';
import 'package:monitor_episodes/controller/home_controller.dart';
import 'package:monitor_episodes/model/core/episodes/episode.dart';
import 'package:monitor_episodes/model/core/shared/globals/size_config.dart';
import 'package:monitor_episodes/ui/shared/utils/custom_dailogs.dart';
import 'package:monitor_episodes/ui/views/home/widgets/monitor_episode/widgets/add_episode.dart';
import 'package:monitor_episodes/ui/views/home/widgets/monitor_episode/widgets/episode_details/episode_details.dart';

import '../../../../../../model/core/shared/response_content.dart';

class ItemEpisode extends StatefulWidget {
  final Episode episode;
  const ItemEpisode({Key? key, required this.episode}) : super(key: key);

  @override
  State<ItemEpisode> createState() => _ItemEpisodeState();
}

class _ItemEpisodeState extends State<ItemEpisode> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => EpisodeDetails(episode: widget.episode),
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeInOut,
            transition: Transition.fadeIn);
      },
      child: Container(
        color: const Color(0xffFCFCFC),
        child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: const BorderSide(width: 2, color: Colors.white)),
            margin: EdgeInsets.only(top: 8.h, bottom: 8.h),
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'images/quran.svg',
                              height: 50.h,
                              color: Get.theme.primaryColor,
                            ),
                            SizedBox(
                              width: 15.w,
                            ),
                            Expanded(
                              child: Text(
                                widget.episode.displayName,
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w800,
                                    color: Get.theme.secondaryHeaderColor,
                                    height: 1.5),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textScaleFactor: SizeConfig.textScaleFactor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuButton<int>(
                        child: Icon(
                          Icons.more_vert,
                          color: Get.theme.primaryColor,
                          size: 30,
                        ),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 1,
                            height: 25.h,
                            child: Center(
                              child: Text(
                                'edit'.tr,
                                style:  TextStyle(
                                  decoration: TextDecoration.none,
                                  color: Get.theme.secondaryHeaderColor,
                                ),
                                textScaleFactor: SizeConfig.textScaleFactor,
                              ),
                            ),
                          ),
                          const PopupMenuDivider(),
                          PopupMenuItem(
                            value: 2,
                            height: 25.h,
                            child: Center(
                              child: Text(
                                'delete'.tr,
                                style: const TextStyle(
                                  decoration: TextDecoration.none,
                                  color: Colors.red,
                                ),
                                textScaleFactor: SizeConfig.textScaleFactor,
                              ),
                            ),
                          ),
                        ],
                        onSelected: (int value) async{
                          if(value == 1){
                            //edit
                            bool? result = await Get.dialog(AddEpisode(episode: widget.episode),
                                  transitionDuration: const Duration(seconds: 1),
                                      transitionCurve: Curves.easeInOut, 
                                  );
                                if(result !=null){
                                  CostomDailogs.snackBar(response: ResponseContent(statusCode: '200', success: true,message: 'ok_edit'.tr));
                                }  
                          }else{
                            // delete
                            if(await CostomDailogs.yesNoDialogWithText(text:'${'do_you_want_delete'.tr} ${widget.episode.name }')){
                              HomeController homeController = Get.find<HomeController>();
                               await homeController.deleteEdisode(widget.episode);
                               CostomDailogs.snackBar(response: ResponseContent(statusCode: '200', success: true,message: 'ok_delete'.tr));
                            }
                          }
                        },
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'episode_type'.tr,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              height: 1.4,
                              color: Colors.black54,
                            ),
                            textScaleFactor: SizeConfig.textScaleFactor,
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            widget.episode.epsdType,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              height: 1.4,
                              color: Colors.black,
                            ),
                            textScaleFactor: SizeConfig.textScaleFactor,
                          ),
                        ],
                      )),
                     
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
