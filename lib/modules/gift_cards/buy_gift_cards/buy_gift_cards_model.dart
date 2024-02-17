import 'package:flutter/material.dart';
import 'package:bounz_revamp_app/constants/enum.dart';
import 'package:bounz_revamp_app/models/gif_card_voucher/category_model.dart';
import 'package:bounz_revamp_app/models/gif_card_voucher/gift_card_voucher.dart';

class BuyGiftCardsModel {
  List<GiftCardVoucher>? vouchersList;
  List<CategoryModel> categoryList;
  CategoryModel? selectedCategory;
  RangeValues filterPrice;
  RangeValues priceRange;
  Range range;
  bool filterApplied;
  BuyGiftCardsModel({
    required this.categoryList,
    required this.range,
    required this.filterPrice,
    required this.priceRange,
    required this.filterApplied,
    this.vouchersList,
    this.selectedCategory,
  });
}
