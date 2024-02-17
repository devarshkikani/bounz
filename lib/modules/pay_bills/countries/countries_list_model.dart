import 'package:bounz_revamp_app/models/pay_bills/service_model.dart';

class CountryListModel {
  final ServiceModel serviceModel;
  List countryList;
  List? dublicateCountryList;
  CountryListModel({
    required this.countryList,
    required this.serviceModel,
    this.dublicateCountryList,
  });
}
