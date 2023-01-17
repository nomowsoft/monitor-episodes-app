import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monitor_episodes/model/core/shared/globals/size_config.dart';

class CustomListButtonUnderlined extends StatelessWidget {

  final String text;
  final bool isSelected;
  final Function onPressed;

  const CustomListButtonUnderlined({Key? key,required this.text,this.isSelected=false,required this.onPressed}) : super(key: key);
 @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0.0) ,
        padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 10.w))
      ),
       
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: TextStyle(color: isSelected ? Colors.black : const Color(0xff9fa1a7) , fontSize: 15.0.sp),
           textScaleFactor:SizeConfig.textScaleFactor,
          ),
          SizedBox(
            height: 15.h,
            width: 7.0 * text.length,
            child: Divider(
              color: isSelected ?Get.theme.primaryColor :Colors.transparent,
              height: 5,
              thickness: 3,
            ),
          )
        ],
      ),
      onPressed: (){
        onPressed();
      },
    );

  }
   
}
