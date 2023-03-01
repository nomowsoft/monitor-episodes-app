import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:monitor_episodes/model/core/shared/globals/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controller/auth_controller.dart';
import '../../../model/core/shared/response_content.dart';
import '../../shared/utils/custom_dailogs.dart';
import '../../shared/utils/validator.dart';
import 'new_password_page.dart';
import 'password_recovery.dart';

class InvestigationPage extends StatefulWidget {
  const InvestigationPage({super.key});

  @override
  State<InvestigationPage> createState() => _InvestigationPageState();
}

class _InvestigationPageState extends State<InvestigationPage> {
  AuthControllerImp controller = Get.put(AuthControllerImp());

  final _pinPutController1 = TextEditingController();
  final _pinPutController2 = TextEditingController();
  final _pinPutController3 = TextEditingController();
  final _pinPutController4 = TextEditingController();
  bool isopen = true;
  bool islogin = false;
  bool hasWaitAnim = false;
  bool loginErorr = false;
  double opacityLogin = 1.0;
  bool passwordObscure = true;
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final direction = Directionality.of(context);
    return GetBuilder(
      builder: (AuthControllerImp authControllerImp) => Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'images/bgR2.png',
                  repeat: ImageRepeat.repeat,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: const Icon(
                      Icons.arrow_back,
                      size: 32,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
              Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SingleChildScrollView(
                        child: Form(
                          key: formKey,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 200.w,
                                  height: 200.h,
                                  decoration: const BoxDecoration(
                                    color: Color(0x95b18f6e),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, bottom: 25.0),
                                    child: SvgPicture.asset(
                                      'images/maknoon_icon.svg',
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30.h,
                                ),
                                Text(
                                  'verification'.tr,
                                  style: TextStyle(
                                      color: Get.theme.primaryColor,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w800),
                                  textScaleFactor: SizeConfig.textScaleFactor,
                                ),
                                SizedBox(
                                  height: 30.h,
                                ),
                                Text(
                                  "enter_your_code_number".tr,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black38,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 50.h,
                                ),
                                Container(
                                  padding: const EdgeInsets.all(28),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          _textFieldOTP(_pinPutController1,
                                              first: true, last: false),
                                          _textFieldOTP(_pinPutController2,
                                              first: false, last: false),
                                          _textFieldOTP(_pinPutController3,
                                              first: false, last: false),
                                          _textFieldOTP(_pinPutController4,
                                              first: false, last: true),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 22.h,
                                      ),
                                      Stack(
                                        children: [
                                          InkWell(
                                            onTap: (() async {
                                              if (formKey.currentState!
                                                  .validate()) {
                                                setState(() {
                                                  islogin = true;
                                                  loginErorr = false;
                                                  hasWaitAnim = false;
                                                  opacityLogin = 0.0;
                                                });
                                                SharedPreferences prefs =
                                                    await SharedPreferences
                                                        .getInstance();
                                                int codeNumber = prefs.getInt(
                                                        'random_number') ??
                                                    0;

                                                String dt = prefs.getString(
                                                        'time_random_number') ??
                                                    '';
                                                DateTime dt1 =
                                                    DateTime.parse(dt);
                                                DateTime timeNow =
                                                    DateTime.now();
                                                Duration diff =
                                                    dt1.difference(timeNow);
                                                if (diff.inMinutes.abs() <=
                                                    10) {
                                                  String code;
                                                  if (direction ==
                                                      TextDirection.rtl) {
                                                    code =
                                                        "${_pinPutController4.text}${_pinPutController3.text}${_pinPutController2.text}${_pinPutController1.text}";
                                                  } else {
                                                    code =
                                                        "${_pinPutController1.text}${_pinPutController2.text}${_pinPutController3.text}${_pinPutController4.text}";
                                                  }
                                                  if (int.parse(code).toInt() ==
                                                      codeNumber) {
                                                    setState(() {
                                                      hasWaitAnim = true;
                                                      loginErorr = false;
                                                    });
                                                    Get.off(
                                                        () =>
                                                            const NewPassword(),
                                                        duration:
                                                            const Duration(
                                                                seconds: 1),
                                                        curve: Curves.easeInOut,
                                                        transition:
                                                            Transition.fadeIn);
                                                  } else {
                                                    setState(() {
                                                      islogin = false;
                                                      opacityLogin = 1.0;
                                                      hasWaitAnim = false;
                                                    });
                                                    CostomDailogs.snackBar(
                                                      response: ResponseContent(
                                                          success: false,
                                                          message:
                                                              'verification_code_is_incorrect'
                                                                  .tr),
                                                    );
                                                  }
                                                } else {
                                                  setState(() {
                                                    islogin = false;
                                                    opacityLogin = 1.0;
                                                    hasWaitAnim = false;
                                                  });
                                                  CostomDailogs.snackBar(
                                                    response: ResponseContent(
                                                        success: false,
                                                        message:
                                                            'verification_code_has_timed_out'
                                                                .tr),
                                                  );
                                                }
                                              }
                                            }),
                                            child: AnimatedContainer(
                                              width:
                                                  islogin ? 45 : Get.size.width,
                                              height: 45,
                                              curve: Curves.fastOutSlowIn,
                                              duration: const Duration(
                                                  milliseconds: 700),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Get.theme
                                                        .secondaryHeaderColor
                                                        .withOpacity(.7),
                                                    Get.theme
                                                        .secondaryHeaderColor,
                                                  ],
                                                  begin: direction ==
                                                          TextDirection.rtl
                                                      ? Alignment.topLeft
                                                      : Alignment.topRight,
                                                  end: direction ==
                                                          TextDirection.rtl
                                                      ? Alignment.bottomRight
                                                      : Alignment.bottomLeft,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        islogin ? 70 : 14),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Colors.black12,
                                                    offset: Offset(5, 5),
                                                    blurRadius: 10,
                                                  )
                                                ],
                                              ),
                                              child: Center(
                                                child: AnimatedOpacity(
                                                  duration: const Duration(
                                                      seconds: 1),
                                                  opacity: opacityLogin,
                                                  child: Text(
                                                    'verify'.tr,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    textScaleFactor: SizeConfig
                                                        .textScaleFactor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          AnimatedContainer(
                                            width: islogin ? 45 : 45,
                                            height: 45,
                                            curve: Curves.fastOutSlowIn,
                                            duration: const Duration(
                                                milliseconds: 700),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Get.theme.secondaryHeaderColor
                                                      .withOpacity(.7),
                                                  Get.theme
                                                      .secondaryHeaderColor,
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      islogin ? 100 : 14),
                                            ),
                                            child: Center(
                                              child: Opacity(
                                                opacity: opacityLogin == 0.0
                                                    ? 1.0
                                                    : 0.0,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(1),
                                                  child: islogin && !hasWaitAnim
                                                      ? CircularProgressIndicator(
                                                          backgroundColor: Get
                                                              .theme
                                                              .secondaryHeaderColor,
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                      Color>(
                                                                  islogin
                                                                      ? Colors
                                                                          .white
                                                                      : Get
                                                                          .theme
                                                                          .secondaryHeaderColor))
                                                      : loginErorr
                                                          ? const Icon(
                                                              Icons
                                                                  .error_outline,
                                                              color: Colors.red,
                                                              size: 40,
                                                            )
                                                          : const Icon(
                                                              Icons
                                                                  .check_circle_outlined,
                                                              color:
                                                                  Colors.green,
                                                              size: 40,
                                                            ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 22.h,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Get.to(() =>
                                              const PasswordRecoveryPage());
                                        },
                                        child: Text(
                                          'resend_new_code'.tr,
                                          style: TextStyle(
                                            color:
                                                Get.theme.secondaryHeaderColor,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textScaleFactor:
                                              SizeConfig.textScaleFactor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textFieldOTP(TextEditingController c, {required bool first, last}) {
    return SizedBox(
      height: 80.h,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: TextField(
          autofocus: true,
          onChanged: (value) {
            if (value.length == 1 && last == false) {
              FocusScope.of(context).nextFocus();
            }
            if (value.isEmpty && first == false) {
              FocusScope.of(context).previousFocus();
            }
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          keyboardType: TextInputType.number,
          controller: c,
          maxLength: 1,
          decoration: InputDecoration(
            counter: const Offstage(),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 2, color: Colors.black12),
                borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Get.theme.primaryColor),
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }
}
