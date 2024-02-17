import 'package:bounz_revamp_app/models/pay_bills/service_model.dart';
import 'package:bounz_revamp_app/models/pay_bills/operator_model.dart';

class OperatorListModel {
  final ServiceModel serviceModel;
  final Map<String, dynamic> country;
  List<OperatorModel> opreterList;
  List<OperatorModel>? dublicateOpreterList;

  OperatorListModel({
    required this.opreterList,
    this.dublicateOpreterList,
    required this.country,
    required this.serviceModel,
  });
}
