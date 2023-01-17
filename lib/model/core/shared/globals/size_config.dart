import 'package:get/get.dart';
import 'package:flutter/material.dart';

extension SizeConfig on dynamic {
  static late double originalWidth;
  static late double originalHeight;
  static late double width;
  static late double height;
  static late double scale;
  static late double textScaleFactor;
  static late double ratioSizeHorizontal;
  static late double ratioSizeVertical;

  void init({
    required originalWidth,
    required originalHeight,
  }) {
    originalWidth = originalWidth;
    originalHeight = originalHeight;
    width = Get.size.width > 600 ?  600.0:Get.size.width;
    height = Get.size.height;
    scale = originalWidth / width ;
    textScaleFactor = width / originalWidth ;
    ratioSizeHorizontal = width / originalWidth;
    ratioSizeVertical = height / originalHeight;
  }

  double get w {
    return double.parse((ratioSizeHorizontal * this).toString());
  }
  double get h {
    return double.parse((ratioSizeVertical * this).toString());
  }
  
  double get sp {
    return double.parse(toString());
  }

  bool get isTablet {
    return Get.size.width > 500 && Get.size.height > 500 ;
  }

  bool get isLandscape {
    return Get.mediaQuery.orientation == Orientation.landscape;
  }
  
}
