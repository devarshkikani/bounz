import 'package:bounz_revamp_app/models/gif_card_voucher/gift_voucher_details.dart';

class GiftCardDetailsModel {
  final String supplierCode;
  final int giftcardId;
  final String giftCategory;
  num price;
  List<double> valuesList;
  int showPrice;
  int? selectedIndex;
  bool error;
  GiftVouchersDetail? giftVouchersDetail;
  GiftCardDetailsModel({
    required this.giftCategory,
    required this.supplierCode,
    required this.giftcardId,
    required this.price,
    required this.showPrice,
    required this.valuesList,
    required this.error,
    this.giftVouchersDetail,
    this.selectedIndex,
  });
}
