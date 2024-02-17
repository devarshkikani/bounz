class Validators {
  static String? validateEmail(String? value) {
    const String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    final RegExp regExp = RegExp(pattern);
    if (value == null || value.isEmpty) {
      return 'Email is required';
    } else if (!regExp.hasMatch(value)) {
      return 'Email is Invalid';
    } else {
      return null;
    }
  }

  static String? validatePassword(String value, String passType) {
    const String pattern =
        r'^.*(?=.{8,})((?=.*[!?@#$%^&*()\-_=+{};:,<.>]){1})(?=.*\d)((?=.*[a-z]){1})((?=.*[A-Z]){1}).*$';
    final RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return '$passType is required';
    } else if (value.length < 8) {
      return '$passType should be more than 8 characters';
    } else if (!regExp.hasMatch(value)) {
      return '''The $passType must be at least 8 characters long and contain a mixture of both uppercase and lowercase letters, at least one number and one special character (e.g.,! @ # ?).''';
    } else {
      return null;
    }
  }

  static String? validateText(String? value, String type) {
    if (value?.trim() == '' || value?.trim().isEmpty == true) {
      return '$type is required';
    } else {
      return null;
    }
  }

  static String? validateMobile(String? value, {int? mobileNumberLength}) {
    if (value == '' || value?.isEmpty == true) {
      return "Please Enter a Phone Number";
      //   // } else if (!RegExp(r'^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$').hasMatch(value)){
      //   //   return "Please Enter a Valid Phone Number";
      // }
      // if (mobileNumberLength != null) {
    } else if (value!.length < (mobileNumberLength ?? 9)) {
      return "Invalid Phone Number";
    } else if (value.contains(RegExp(r'[;*+_,#/()]'))) {
      return "Invalid Phone Number";
    }
    // }

    return null;
  }

  static String? validateSmilesMobile(String? value) {
    if (value == '' || value?.isEmpty == true) {
      return "Please Enter a Phone Number";
    } else if (value!.length < 9) {
      return "Invalid Phone Number";
    }
    return null;
  }

  static String? validateSmilesOtp(String? value) {
    if (value == '' || value?.isEmpty == true) {
      return "Please Enter a Otp";
    } else if (value!.length < 5) {
      return "5 digit OTP is required.";
    }
    return null;
  }
}
