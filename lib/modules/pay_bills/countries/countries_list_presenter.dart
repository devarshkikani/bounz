import 'package:flutter/material.dart';
import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:bounz_revamp_app/models/pay_bills/service_model.dart';
import 'package:bounz_revamp_app/modules/pay_bills/countries/countries_list_view.dart';
import 'package:bounz_revamp_app/modules/pay_bills/countries/countries_list_model.dart';

class CountriesListPresenter {
  Future<void> countryList({required BuildContext context}) async {}
  set updateModel(CountriesListView value) {}
}

class BasicCountriesListPresenter implements CountriesListPresenter {
  late CountryListModel model;
  late CountriesListView view;
  BasicCountriesListPresenter(ServiceModel serviceModel) {
    view = CountriesListView();
    model = CountryListModel(
      serviceModel: serviceModel,
      countryList: [],
    );
  }

  @override
  Future countryList({required BuildContext context}) async {
    Map<String, dynamic>? response = await NetworkDio.postDioHttpMethod(
      url: ApiPath.dtOneEndPoint + ApiPath.countrylist,
      context: context,
      data: {
        'service_id': model.serviceModel.serviceId,
      },
    );
    model.dublicateCountryList = [];
    if (response != null) {
      if (response['status'] == true) {
        model.countryList = response['values'];
        model.dublicateCountryList = response['values'];
      }
      view.refreshModel(model);
    }
  }

  @override
  set updateModel(value) {
    view = value;
    view.refreshModel(model);
  }
}
