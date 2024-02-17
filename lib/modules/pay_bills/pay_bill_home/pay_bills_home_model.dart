import 'package:bounz_revamp_app/models/pay_bills/service_model.dart';

class PayBillsModel {
  ServiceModel? selectedService;
  List<ServiceModel>? serviceTelecomRechargesLists;
  List<ServiceModel>? serviceHouseMoreList;
  List<List<ServiceModel>>? serviceList;
  PayBillsModel({
    this.selectedService,
    this.serviceTelecomRechargesLists,
    this.serviceHouseMoreList,
  });
}
