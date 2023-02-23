import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:monitor_episodes/model/core/shared/globals/size_config.dart';

import '../../../controller/auth_controller.dart';
import '../../../model/core/shared/response_content.dart';
import '../../shared/utils/custom_dailogs.dart';
import '../../shared/utils/validator.dart';
import 'investigation_page.dart';

class PasswordRecoveryPage extends StatefulWidget {
  const PasswordRecoveryPage({super.key});

  @override
  State<PasswordRecoveryPage> createState() => _PasswordRecoveryPageState();
}

class _PasswordRecoveryPageState extends State<PasswordRecoveryPage> {
  bool isopen = true;
  bool islogin = false;
  bool hasWaitAnim = false;
  bool loginErorr = false;
  double opacityLogin = 1.0;
  final formKey = GlobalKey<FormState>();
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
                                  width: 200,
                                  height: 200,
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
                                  'password_recovery'.tr,
                                  style: TextStyle(
                                      color: Get.theme.primaryColor,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w800),
                                  textScaleFactor: SizeConfig.textScaleFactor,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'email'.tr,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500),
                                            textScaleFactor:
                                                SizeConfig.textScaleFactor,
                                          ),
                                          SizedBox(
                                            height: 7.h,
                                          ),
                                          TextFormField(
                                            textInputAction:
                                                TextInputAction.next,
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            keyboardAppearance:
                                                Brightness.light,
                                            validator: Validator.emailValidator,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            controller: authControllerImp.email,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Colors.white,
                                              hintText: 'enter_email'.tr,
                                            ),
                                            onChanged: (val) {},
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 22,
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
                                                // Get.off(
                                                //     () =>
                                                //         const InvestigationPage(),
                                                //     duration: const Duration(
                                                //         seconds: 1),
                                                //     curve: Curves.easeInOut,
                                                //     transition:
                                                //         Transition.fadeIn);
                                                ResponseContent
                                                    responseContent =
                                                    await authControllerImp
                                                        .sendCode();
                                                if (responseContent.isSuccess) {
                                                  setState(() {
                                                    hasWaitAnim = true;
                                                    loginErorr = false;
                                                  });
                                                  Get.off(
                                                      () =>
                                                          const InvestigationPage(),
                                                      duration: const Duration(
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
                                                      response:
                                                          responseContent);
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
                                                  begin: direction == TextDirection.rtl
                                                ? Alignment.topLeft
                                                : Alignment.topRight,
                                            end: direction == TextDirection.rtl
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
                                                    'send'.tr,
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
}
