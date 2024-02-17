import 'package:bounz_revamp_app/models/pay_bills/service_model.dart';
import 'package:bounz_revamp_app/models/pay_bills/recent_transaction.dart';

class PayBillDetailModel {
  ServiceModel serviceModel;
  List<RecentTransaction> transactionList;
  PayBillDetailModel({
    required this.serviceModel,
    required this.transactionList,
  });
}
