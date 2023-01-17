import 'package:flutter/material.dart';
import 'package:get/get.dart';
class WaitingDialog extends StatelessWidget {
  const WaitingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Text(
          'please_wait'.tr,
          style:const TextStyle(fontFamily: "Loew Next Arabic"),
        ),
        CircularProgressIndicator(
         color: Get.theme.primaryColor,
        ),
      ],
    );
  }
}
