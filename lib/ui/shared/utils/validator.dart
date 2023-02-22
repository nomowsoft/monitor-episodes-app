import 'package:get/get.dart';

class Validator {
  
  
  static String? passwordValidator(String? val) {
      String value = val?.trim() ?? '';
      if (value.isNotEmpty) {
        return null;
      } else {
        return 'enter_password'.tr;
      }
  }
  
  static String? numberValidator(String? val) {
    String value = val?.trim() ?? '';
    if (value.isEmpty) {
      return 'enter_number'.tr;
    }
    return null;
  }
  static String? ageValidator(String? val) {
    String value = val?.trim() ?? '';
    if (value.isEmpty) {
      return 'enter_age'.tr;
    }
    return null;
  }

  static String? passwordValidatorV1(String? val, bool isValdate) {
    if (isValdate) {
      String value = val?.trim() ?? '';
      if (value.isNotEmpty) {
          return null;
      } else {
        return 'enter_password'.tr;
      }
    } else {
      return null;
    }
  }
  static String? nameValidator(String? val) {
      String value = val?.trim() ?? '';
      if (value.isNotEmpty) {
        return null;
      } else {
        return 'enter_name'.tr;
      }
  }
  static String? episodeValidator(String? val) {
      String value = val?.trim() ?? '';
      if (value.isNotEmpty) {
        return null;
      } else {
        return 'enter_episode'.tr;
      }
  }
  static String? nameDepositorValidator(String? val) {
      String value = val?.trim() ?? '';
      if (value.isNotEmpty) {
        return null;
      } else {
        return 'enter_name_of_the_depositor'.tr;
      }
  }
  static String? phoneValidator(String? val) {
      String value = val?.trim() ?? '';
      if (value.isNotEmpty) {
        // if(value.length == 9){
        // return null;
        // }else{
        //   return 'enter_a_9_digit_number'.tr;
        // }
        return null;
      } else {
        return 'enter_phone'.tr;
      }
  }

  static String? copyOfThePassportCardValidator(String? val) {
      String value = val?.trim() ?? '';
      if (value.isNotEmpty) {
        return null;
      } else {
        return 'enter_copy_of_the_passport_card'.tr;
      }
  }
  static String? identificationNumberLocation(String? val) {
      String value = val?.trim() ?? '';
      if (value.isNotEmpty) {
        return null;
      } else {
        return 'enter_identification_number_location'.tr;
      }
  }
  static String? subjectOfComplaint(String? val) {
      String value = val?.trim() ?? '';
      if (value.isNotEmpty) {
        return null;
      } else {
        return 'enter_subject'.tr;
      }
  }
  static String? detailsOfComplaint(String? val) {
      String value = val?.trim() ?? '';
      if (value.isNotEmpty) {
        return null;
      } else {
        return 'enter_details'.tr;
      }
  }
  static String? attachReceiptValidator(String? val) {
      String value = val?.trim() ?? '';
      if (value.isNotEmpty) {
        return null;
      } else {
        return 'enter_attach_the_receipt_voucher'.tr;
      }
  }

  static String? emailValidator(String? val) {
    String value = val?.trim() ?? '';
    if (value.isNotEmpty) {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = RegExp(pattern.toString());
      if (!(regex.hasMatch(value))) {
        return 'email_error'.tr;
      } else {
        return null;
      }
    } else {
      return 'enter_email'.tr;
    }
  }
}
