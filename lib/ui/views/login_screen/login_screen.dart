import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:monitor_episodes/controller/teacher_controller.dart';
import 'package:monitor_episodes/model/core/shared/globals/size_config.dart';
import 'package:monitor_episodes/ui/shared/utils/validator.dart';

import '../../../controller/auth_controller.dart';
import '../home/home.dart';
import '../sign_up/sign_up.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
    TeacherController teacherController = Get.put(TeacherController());
    teacherController.initFields();
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        isopen = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        AnimatedOpacity(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          opacity: isopen ? 0.0 : 1.0,
                                          child: SvgPicture.asset(
                                            'images/maknoon_icon.svg',
                                            height: MediaQuery.of(context)
                                                        .orientation ==
                                                    Orientation.landscape
                                                ? 200.h
                                                : 150.h,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 30.h,
                                ),
                                Text(
                                  'welcome_with_monitor_episodes'.tr,
                                  style: TextStyle(
                                      color: Get.theme.primaryColor,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w800),
                                  textScaleFactor: SizeConfig.textScaleFactor,
                                ),
                                SizedBox(
                                  height: 50.h,
                                ),

                                /// name
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      height: 5.h,
                                    ),
                                    TextFormField(
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.emailAddress,
                                      keyboardAppearance: Brightness.light,
                                      validator: Validator.nameValidator,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      controller: authControllerImp.username,
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
                                SizedBox(
                                  height: 10.h,
                                ),

                                ///password
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'password'.tr,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500),
                                      textScaleFactor:
                                          SizeConfig.textScaleFactor,
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    TextFormField(
                                      textInputAction: TextInputAction.done,
                                      keyboardType: TextInputType.name,
                                      keyboardAppearance: Brightness.light,
                                      controller: authControllerImp.password,
                                      validator: Validator.passwordValidator,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      obscureText: passwordObscure,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500),
                                      decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                              passwordObscure
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: Colors.black54),
                                          onPressed: () {
                                            setState(() {
                                              passwordObscure =
                                                  !passwordObscure;
                                            });
                                          },
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10.w, vertical: 0),
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText: 'enter_password'.tr,
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(
                                  height: 30.h,
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.to(() => const SignUp());
                                  },
                                  child: Text(
                                    'you_already_have_an_account'.tr,
                                    style: TextStyle(
                                      color: Get.theme.secondaryHeaderColor,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w800,
                                      decoration: TextDecoration.underline,
                                      decorationStyle:
                                          TextDecorationStyle.dashed,
                                      decorationColor: Colors.black,
                                      decorationThickness: 3,
                                    ),
                                    textScaleFactor: SizeConfig.textScaleFactor,
                                  ),
                                ),
                                SizedBox(
                                  height: 30.h,
                                ),
                                Stack(
                                  children: [
                                    InkWell(
                                      onTap: (() async {
                                        if (formKey.currentState!.validate()) {
                                          setState(() {
                                            islogin = true;
                                            loginErorr = false;
                                            hasWaitAnim = false;
                                            opacityLogin = 0.0;
                                          });
                                          await authControllerImp.signIn();
                                          await Future.delayed(
                                              const Duration(seconds: 1));
                                          setState(() {
                                            hasWaitAnim = true;
                                            loginErorr = false;
                                          });
                                          Future.delayed(
                                              const Duration(milliseconds: 500),
                                              () {
                                            setState(() {
                                              islogin = false;
                                              opacityLogin = 1.0;
                                              hasWaitAnim = false;
                                            });
                                          });
                                          Get.off(() => const Home(),
                                              duration:
                                                  const Duration(seconds: 1),
                                              curve: Curves.easeInOut,
                                              transition: Transition.fadeIn);
                                        }
                                      }),
                                      child: AnimatedContainer(
                                        width: islogin ? 45 : Get.size.width,
                                        height: 45,
                                        curve: Curves.fastOutSlowIn,
                                        duration:
                                            const Duration(milliseconds: 700),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Get.theme.secondaryHeaderColor
                                                  .withOpacity(.7),
                                              Get.theme.secondaryHeaderColor,
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.circular(
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
                                            duration:
                                                const Duration(seconds: 1),
                                            opacity: opacityLogin,
                                            child: Text(
                                              'welcom'.tr,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textScaleFactor:
                                                  SizeConfig.textScaleFactor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    AnimatedContainer(
                                      width: islogin ? 45 : 45,
                                      height: 45,
                                      curve: Curves.fastOutSlowIn,
                                      duration:
                                          const Duration(milliseconds: 700),
                                      // padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Get.theme.secondaryHeaderColor
                                                .withOpacity(.7),
                                            Get.theme.secondaryHeaderColor,
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                            islogin ? 100 : 14),
                                      ),
                                      child: Center(
                                        child: Opacity(
                                          // duration: const Duration(milliseconds: 700),
                                          opacity:
                                              opacityLogin == 0.0 ? 1.0 : 0.0,
                                          child: Padding(
                                            padding: const EdgeInsets.all(1),
                                            child: islogin && !hasWaitAnim
                                                ? CircularProgressIndicator(
                                                    backgroundColor: Get.theme
                                                        .secondaryHeaderColor,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                                Color>(
                                                            islogin
                                                                ? Colors.white
                                                                : Get.theme
                                                                    .secondaryHeaderColor))
                                                : loginErorr
                                                    ? const Icon(
                                                        Icons.error_outline,
                                                        color: Colors.red,
                                                        size: 40,
                                                      )
                                                    : const Icon(
                                                        Icons
                                                            .check_circle_outlined,
                                                        color: Colors.green,
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
