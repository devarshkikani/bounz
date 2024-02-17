import 'package:bounz_revamp_app/models/offer/offer_model.dart';
import 'package:bounz_revamp_app/models/offer/offer_category_model.dart';

class OfferHomeViewModel {
  List<OfferModel>? offerList;
  List<OfferCategoryModel>? offerCategoryList;
  OfferHomeViewModel({
    this.offerCategoryList,
    this.offerList,
  });
}
