import 'app_constants.dart';

class FieldValidator {
  static String validateEmail(String value) {
    print("validateEmail : $value ");

    if (value.isEmpty) return Constants.enterEmail;

    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regex = new RegExp(pattern);

    if (!regex.hasMatch(value.trim())) {
      return Constants.enterValidEmail;
    }

    return null;
  }

  static String validateName(String value) {
    if (value.isEmpty) return Constants.enterName;

    if (value.length < 2) {
//      return Constants.enterValidName;
    }



    Pattern pattern = r'^[a-zA-Z\. ]+$';

    RegExp regex = new RegExp(pattern);

    if (!regex.hasMatch(value)) {
//      return Constants.enterValidName;
    }

    return null;
  }

  static String validateOTP(String value) {
    if (value.isEmpty) return Constants.enterOTP;

    if (value.length < 6) {
//      return Constants.enterValidOTP;
    }

    return null;
  }

  static String validatePhone(String value) {
    if (value.isEmpty) return Constants.enterPhone;

//    Pattern pattern = r'^(?:(?:\+|0{0,2})91(\s*[\ -]\s*)?|[0]?)?[789]\d{9}|(\d[ -]?){10}\d$';
//    Pattern pattern =
//        r'\+(9[976]\d|8[987530]\d|6[987]\d|5[90]\d|42\d|3[875]\d|2[98654321]\d|9[8543210]|8[6421]|6[6543210]|5[87654321]|4[987654310]|3[9643210]|2[70]|7|1)\d{1,14}$';
//
//    RegExp regex = new RegExp(pattern);
//
//    if (!regex.hasMatch(value)) {
//      return Constants.enterValidPhone;
//    }

    if (value.contains("/") || value.contains(".") || value.contains(",")) {
      return Constants.enterValidPhone;
    }

    return null;
  }


  static String validateEmptyCheck(String value) {
    if (value.isEmpty) return Constants.emptyMessage;

    return null;
  }
}
