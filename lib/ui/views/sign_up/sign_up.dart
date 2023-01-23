import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:monitor_episodes/controller/teacher_controller.dart';
import 'package:monitor_episodes/model/core/countries/country.dart';
import 'package:monitor_episodes/model/core/shared/globals/size_config.dart';
import 'package:monitor_episodes/ui/shared/utils/validator.dart';
import 'package:monitor_episodes/ui/views/home/home.dart';
import 'package:monitor_episodes/ui/views/home/widgets/monitor_episode/widgets/episode_details/widgets/select_country.dart';

import '../../../controller/auth_controller.dart';
import '../../../model/core/shared/response_content.dart';
import '../../shared/utils/custom_dailogs.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool islogin = false;
  bool hasWaitAnim = false;
  bool loginErorr = false;
  double opacityLogin = 1.0;
  bool isopen = true;
  bool passwordObscure = true;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
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
                                  'create_new_account'.tr,
                                  style: TextStyle(
                                      color: Get.theme.primaryColor,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w800),
                                  textScaleFactor: SizeConfig.textScaleFactor,
                                ),
                                SizedBox(
                                  height: 50.h,
                                ),

                                /// username
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'username'.tr,
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
                                      keyboardType: TextInputType.name,
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
                                        hintText: 'enter_username'.tr,
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
                                  height: 10.h,
                                ),

                                ///phone
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'phone'.tr,
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
                                      keyboardType: TextInputType.phone,
                                      keyboardAppearance: Brightness.light,
                                      controller: authControllerImp.mobile,
                                      validator: Validator.phoneValidator,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500),
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText: 'enter_phone'.tr,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),

                                /// address
                                // Column(
                                //   mainAxisAlignment: MainAxisAlignment.start,
                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                //   children: [
                                //     Text(
                                //       'country'.tr,
                                //       style: TextStyle(
                                //           color: Colors.black,
                                //           fontSize: 14.sp,
                                //           fontWeight: FontWeight.w500),
                                //       textScaleFactor:
                                //           SizeConfig.textScaleFactor,
                                //     ),
                                //     SizedBox(
                                //       height: 5.h,
                                //     ),
                                //     TextFormField(
                                //       textInputAction: TextInputAction.next,
                                //       keyboardType: TextInputType.name,
                                //       keyboardAppearance: Brightness.light,
                                //       controller: teacherController.country,
                                //       style: TextStyle(
                                //         color: Colors.black,
                                //         fontSize: 14.sp,
                                //         fontWeight: FontWeight.w500,
                                //       ),
                                //       decoration: InputDecoration(
                                //         filled: true,
                                //         fillColor: Colors.white,
                                //         hintText: 'enter_country'.tr,
                                //       ),
                                //       onChanged: (val) {},
                                //     ),
                                //   ],
                                // ),

                                /// address
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'country'.tr,
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
                                    GestureDetector(
                                      onTap: () async {
                                        Country? country = await showDialog(
                                          context: context,
                                          builder: (contextDialog) =>
                                              const AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  15.0))),
                                                  contentPadding:
                                                      EdgeInsets.all(15),
                                                  content: SelectCountry()),
                                        );
                                        if (country != null) {
                                          authControllerImp.setCountryID(country.id);
                                        }
                                      },
                                      child: AbsorbPointer(
                                        absorbing: true,
                                        child: TextFormField(
                                          textInputAction: TextInputAction.next,
                                          keyboardType: TextInputType.name,
                                          keyboardAppearance: Brightness.light,
                                          controller: authControllerImp.country,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Colors.white,
                                              suffixIcon: Icon(
                                                Icons.keyboard_arrow_down,
                                                color: Get.theme.primaryColor,
                                              )),
                                          onChanged: (val) {},
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                PopupMenuButton<String>(
                                  padding: EdgeInsets.zero,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'gender'.tr,
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
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10.h,
                                                  horizontal: 10.w),
                                              decoration: BoxDecoration(
                                                color: Get
                                                    .theme.secondaryHeaderColor
                                                    .withOpacity(0.8),
                                                //  shape: BoxShape.circle,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      authControllerImp.gender,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                      maxLines: 1,
                                                      textScaleFactor:
                                                          SizeConfig
                                                              .textScaleFactor,
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons.keyboard_arrow_down,
                                                    size: 25.sp,
                                                    color: Colors.white,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  itemBuilder: (context) => [
                                    ...authControllerImp.genders.map(
                                      (e) => PopupMenuItem(
                                        padding: EdgeInsets.zero,
                                        value: e,
                                        height: 50.h,
                                        child: Column(
                                          children: [
                                            Center(
                                              child: Text(
                                                e,
                                                style: const TextStyle(
                                                    decoration:
                                                        TextDecoration.none,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                textScaleFactor:
                                                    SizeConfig.textScaleFactor,
                                              ),
                                            ),
                                            // Divider(height: 20.h,thickness: 1.5,)
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                  onSelected: (String value) async {
                                    authControllerImp.setGender = value;
                                  },
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
                                          ResponseContent responseContent =
                                              await authControllerImp.signUp();
                                          if (responseContent.isSuccess) {
                                            setState(() {
                                              hasWaitAnim = true;
                                              loginErorr = false;
                                            });
                                            Get.off(() => const Home(),
                                                duration:
                                                    const Duration(seconds: 1),
                                                curve: Curves.easeInOut,
                                                transition: Transition.fadeIn);
                                          } else {
                                            setState(() {
                                              islogin = false;
                                              opacityLogin = 1.0;
                                              hasWaitAnim = false;
                                            });
                                            CostomDailogs.snackBar(
                                                response: responseContent);
                                          }
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
                                              'register'.tr,
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
