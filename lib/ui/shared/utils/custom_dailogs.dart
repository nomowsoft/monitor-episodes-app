import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../model/core/shared/response_content.dart';

class CostomDailogs {
  static snackBar({
    ResponseContent? response,
  }) async {
    Get.closeAllSnackbars();
    // ignore: await_only_futures
    return await Get.showSnackbar(GetSnackBar(
      snackPosition: SnackPosition.BOTTOM,
      borderRadius: 10,
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      messageText: Center(
          child: Text(
        response?.message ?? '',
        style: const TextStyle(color: Colors.white, fontSize: 18),
      )),
      duration: response?.isSuccess ?? false
          ? const Duration(milliseconds: 2000)
          : response?.isErrorConnection ?? false
              ? const Duration(milliseconds: 2000)
              : const Duration(milliseconds: 4000),
      backgroundColor: response?.isSuccess ?? false
          ? Colors.green
          : response?.isErrorConnection ?? false
              ? Colors.red
              : Colors.black,
    ));
  }

  static Future warringDialogWithGet({required String msg}) async {
    return await Get.dialog(CupertinoAlertDialog(
      title: Text(
        'warring'.tr,
        style: const TextStyle(
          fontSize: 16.0,
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        child: Text(
          msg,
          style: const TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          child: Text(
            'ok'.tr,
            style: const TextStyle(),
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ],
    ));
  }

  static Future<bool> dialogWithText({String text = ''}) async {
    return (await Get.dialog(Builder(builder: (BuildContext dialogContext) {
          return WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side: const BorderSide(color: Colors.white)),
                    margin: const EdgeInsets.only(left: 40, right: 40),
                    color: Colors.white,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 30),
                          child: Text(
                            text,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontFamily: 'Loew-Next-Arabic',
                                color: Colors.black,
                                fontSize: 16,
                                height: 1.5),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Get.theme.primaryColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                        side: BorderSide(
                                            color: Get.theme.primaryColor)),
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                  ),
                                  child: Text(
                                    'sync'.tr,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () async {
                                    Get.back(result: true);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ));
        })) ??
        false);
  }

  static Future<bool> yesNoDialogWithText({String text = ''}) async {
    return (await Get.dialog(
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: const BorderSide(color: Colors.white)),
                margin: const EdgeInsets.only(left: 40, right: 40),
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 30),
                      child: Text(
                        text,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontFamily: 'Loew-Next-Arabic',
                            color: Colors.black,
                            fontSize: 20,
                            height: 1.5),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Get.theme.primaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                    side: BorderSide(
                                        color: Get.theme.primaryColor)),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                              ),
                              child: Text(
                                'yes'.tr,
                                style: const TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                Get.back(result: true);
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                    side: BorderSide(
                                        color: Get.theme.primaryColor)),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                              ),
                              child: Text(
                                'no'.tr,
                                style: TextStyle(color: Get.theme.primaryColor),
                              ),
                              onPressed: () async {
                                Get.back(result: false);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ) ??
        false);
  }

   static Future<bool> dialogWithImageAndText(
      {required String text,
      required String buttonText,
      Function()? onPressed,
      required Icon icon}) async {
    return (await Get.dialog(Builder(builder: (BuildContext dialogContext) {
          return WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side: const BorderSide(color: Colors.white)),
                    margin: const EdgeInsets.only(left: 40, right: 40),
                    color: Colors.white,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20,),
                        icon,
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 30),
                          child: Text(
                            text,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontFamily: 'Loew-Next-Arabic',
                                color: Colors.black,
                                fontSize: 15,
                                height: 1.5),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Get.theme.primaryColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                        side: BorderSide(
                                            color: Get.theme.primaryColor)),
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                  ),
                                  onPressed:onPressed?? () async {
                                    Get.back(result: true);
                                  },
                                  child: Text(
                                    buttonText,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ));
        })) ??
        false);
  }
}
