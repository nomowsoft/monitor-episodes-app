import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:monitor_episodes/model/core/shared/globals/size_config.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  String text =
      "تطبيق يساعد معلم القرآن في جمعية مكنون في إدارة الحلقة وتحضير الطلاب وإدخال التسميع ومتابعة الحفظ والتسجيل في الاختبارات، ويتميز هذا التطبيق بالعمل دون الحاجة إلى الاتصال بالإنترنت (أوف لاين)، وينعكس ذلك تلقائيا في مكنون التعليمي";

  @override
  void initState() {
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
          child: Column(children: [
            SvgPicture.asset(
              'images/maknoon_icon.svg',
              height: 150.h,
            ),
            SizedBox(height: 20.h,),
            Text(
              text,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.sp,
                  height: 1.5,
                  
                  fontWeight: FontWeight.w500),
                   textAlign: TextAlign.center,
              textScaleFactor: SizeConfig.textScaleFactor,
            ),
             
          ]),
        ),
      ),
    );
  }
}
