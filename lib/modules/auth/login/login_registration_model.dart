import 'package:bounz_revamp_app/models/country/country_model.dart';

class LoginRegistrationModel {
  Country? countryCode;
  bool isGoogleSignIn;
  bool isAppleSignIn;
  LoginRegistrationModel({
    this.countryCode,
    required this.isGoogleSignIn,
    required this.isAppleSignIn,
  });
}
