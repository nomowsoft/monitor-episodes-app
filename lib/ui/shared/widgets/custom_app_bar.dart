import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monitor_episodes/model/core/shared/globals/size_config.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  final String title;
  final Function? onBack;
  final bool isBack;
  final String? fontFamily;
  final TextStyle? style;
  final Widget? leading;
  final List<Widget>? actions;
  const CustomAppBar(
      {Key? key,
      required this.title,
      this.leading,
      this.fontFamily,
      this.style,
      this.onBack,
      this.isBack = false,
      this.actions})
      : preferredSize = const Size.fromHeight(50.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      actions: actions,
      elevation: 0.0,
      title: Text(
        title,
        style: style ??
            TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                fontFamily: fontFamily),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textScaleFactor: SizeConfig.textScaleFactor,
      ),
      backgroundColor: Colors.white,
      centerTitle: true,
      titleSpacing: 2,
    );
  }

  Function back() {
    return onBack ??
        () {
          Get.back();
        };
  }
}
