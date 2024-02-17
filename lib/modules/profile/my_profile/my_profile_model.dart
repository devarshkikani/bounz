import 'package:bounz_revamp_app/models/country/country_model.dart';

class MyProfileModel {
  Country? selectedCountry;
  bool disablePhone;
  bool disableEmail;
  bool updatedPhone;
  bool updatedEmail;
  MyProfileModel({
    this.selectedCountry,
    required this.disablePhone,
    required this.disableEmail,
    required this.updatedPhone,
    required this.updatedEmail,
  });
}
