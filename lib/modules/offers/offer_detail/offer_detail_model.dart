import 'package:bounz_revamp_app/models/offer/new_offer_detail_model.dart';

class OfferDetailModel {
  NewOfferDetailModel? newOfferDetailModel;
  String? offerDynamicLin;
  String? errorMessgae;
  int selectedOutletIndex;
  OfferDetailModel({
    this.offerDynamicLin,
    this.newOfferDetailModel,
    this.errorMessgae,
    required this.selectedOutletIndex,
  });
}
