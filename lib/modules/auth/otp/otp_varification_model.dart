import 'package:bounz_revamp_app/constants/enum.dart';

class OtpVarificationModel {
  String validOtp;
  int currentSeconds;
  UserType userType;
  bool enableResend;
  String countryCode;
  String mobileNumber;
  String? email;
  bool isFromLogin;
  OtpVarificationModel({
    this.email,
    required this.validOtp,
    required this.currentSeconds,
    required this.enableResend,
    required this.countryCode,
    required this.mobileNumber,
    required this.userType,
    required this.isFromLogin,
  });
}
