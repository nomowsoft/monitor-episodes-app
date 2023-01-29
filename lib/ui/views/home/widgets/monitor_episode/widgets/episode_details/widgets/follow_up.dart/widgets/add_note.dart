import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:monitor_episodes/controller/home_controller.dart';
import 'package:monitor_episodes/model/core/plan_lines/mistakes_plan_line.dart';
import 'package:monitor_episodes/model/core/shared/globals/size_config.dart';
import 'package:monitor_episodes/ui/shared/utils/validator.dart';

class AddNote extends StatefulWidget {
  final String planLine;
  final bool isTlawa;
  const AddNote({Key? key, required this.planLine, this.isTlawa = false})
      : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  late TextEditingController saveErrors;
  late TextEditingController intonationErrors;
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    saveErrors = TextEditingController(text: '0');
    intonationErrors = TextEditingController(text: '0');
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      builder: (HomeController homeController) => Form(
        key: formKey,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: const BorderSide(color: Colors.white)),
                  margin: const EdgeInsets.only(left: 16, right: 16, top: 10),
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Column(children: [
                              widget.isTlawa
                                  ? const SizedBox()
                                  : Text(
                                      'save_errors'.tr,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500),
                                      textScaleFactor:
                                          SizeConfig.textScaleFactor,
                                    ),
                              SizedBox(
                                height: widget.isTlawa ? 0 : 45.h,
                              ),
                              Text(
                                'intonation_errors'.tr,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500),
                                textScaleFactor: SizeConfig.textScaleFactor,
                              ),
                            ]),
                            SizedBox(
                              width: 10.w,
                            ),
                            Expanded(
                              child: Column(children: [
                                widget.isTlawa
                                    ? const SizedBox()
                                    : TextFormField(
                                        textInputAction: TextInputAction.next,
                                        keyboardType: const TextInputType
                                            .numberWithOptions(decimal: true),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r"^\d+\.?\d{0,4}"))
                                        ],
                                        validator: Validator.numberValidator,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        controller: saveErrors,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintText: 'enter_number'.tr,
                                        ),
                                        onChanged: (val) {},
                                      ),
                                SizedBox(
                                  height: widget.isTlawa ? 0 : 5.h,
                                ),
                                TextFormField(
                                  textInputAction: TextInputAction.next,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r"^\d+\.?\d{0,4}"))
                                  ],
                                  validator: Validator.numberValidator,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: intonationErrors,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: 'enter_number'.tr,
                                  ),
                                  onChanged: (val) {},
                                ),
                              ]),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Mistakes mistakes = Mistakes(
                                    totalMstkQty: int.parse(saveErrors.text),
                                    totalMstkRead:
                                        int.parse(intonationErrors.text),
                                  );
                                  homeController.addNote(
                                      widget.planLine, mistakes);
                                  Get.back();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 15.h),
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
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black12,
                                        offset: Offset(5, 5),
                                        blurRadius: 10,
                                      )
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      'save'.tr,
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
                          ],
                        ),
                      ],
                    ),
                  ))
            ]),
      ),
    );
  }
}
