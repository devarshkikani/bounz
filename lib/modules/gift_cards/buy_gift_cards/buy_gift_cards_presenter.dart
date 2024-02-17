import 'package:flutter/material.dart';
import 'package:bounz_revamp_app/constants/enum.dart';
import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/constants/triggering_condition.dart';
import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/models/gif_card_voucher/category_model.dart';
import 'package:bounz_revamp_app/models/gif_card_voucher/gift_card_voucher.dart';
import 'package:bounz_revamp_app/modules/gift_cards/buy_gift_cards/buy_gift_cards_view.dart';
import 'package:bounz_revamp_app/modules/gift_cards/buy_gift_cards/buy_gift_cards_model.dart';
import 'package:bounz_revamp_app/modules/gift_cards/buy_gift_cards/buy_gift_card_extension.dart';
import 'package:moengage_flutter/properties.dart';

class BuyGiftCardsPresenter {
  Future getVouchersList(BuildContext? context, {String? serachText}) async {}
  Future getCategoryList(BuildContext context) async {}
  set updateModel(BuyGiftCardsView value) {}
}

class BasicBuyGiftCardsPresenter implements BuyGiftCardsPresenter {
  late BuyGiftCardsModel model;
  late BuyGiftCardsView view;

  BasicBuyGiftCardsPresenter() {
    model = BuyGiftCardsModel(
      categoryList: [],
      filterApplied: false,
      filterPrice: const RangeValues(0, 0),
      priceRange: const RangeValues(0, 0),
      range: Range.lowToHigh,
    );
    view = BuyGiftCardsView();
  }

  @override
  Future getVouchersList(BuildContext? context, {String? serachText}) async {
    model.vouchersList = null;
    final Map<String, dynamic> queryParameters = {
      "channel": 'mobile',
      "tier": 'base',
      "customer_id": GlobalSingleton.userInformation.membershipNo,
      "sort": model.range.title,
      "categories": model.selectedCategory?.categoryCode ?? '',
    };
    if (serachText != null) {
      queryParameters['search'] = serachText;

      final properties = MoEProperties();
      properties
          .addAttribute(TriggeringCondition.searchKeyword, serachText)
          .setNonInteractiveEvent();
      MoenageManager.logEvent(
        MoenageEvent.search,
        properties: properties,
      );
    }
    if (model.filterApplied) {
      queryParameters["price"] =
          '${model.filterPrice.start.toInt()},${model.filterPrice.end.toInt()}';
    }
    Map<String, dynamic>? response =
        await NetworkDio.getGiftVoucherDioHttpMethod(
      url: ApiPath.giftCardEndPoint + ApiPath.giftvoucher,
      context: context,
      notShowError: true,
      queryParameters: queryParameters,
    );
    model.vouchersList = [];
    if (response != null) {
      if (response['code'] == 'GV_0002') {
        for (Map<String, dynamic> e in response['objects']) {
          final GiftCardVoucher giftCardVoucher = GiftCardVoucher.fromJson(e);
          model.vouchersList!.add(giftCardVoucher);
        }
        if (const RangeValues(0, 0) == model.filterPrice) {
          model.filterPrice = RangeValues(
            response['price_range']['min'].toDouble(),
            response['price_range']['max'].toDouble(),
          );
        }
        model.priceRange = RangeValues(
          response['price_range']['min'].toDouble(),
          response['price_range']['max'].toDouble(),
        );
      } else if (response['code'] == 'GV_0003') {
        model.vouchersList = [];
        queryParameters['search'] = serachText;
        final properties = MoEProperties();
        properties
            .addAttribute(TriggeringCondition.searchKeyword, serachText)
            .setNonInteractiveEvent();
        MoenageManager.logEvent(
          MoenageEvent.searchFailed,
          properties: properties,
        );
      }
    }
    view.refreshModel(model);
  }

  @override
  Future getCategoryList(BuildContext context) async {
    if (model.categoryList.isNotEmpty) {
      return;
    }
    final Map<String, dynamic> queryParameters = {
      "channel": 'mobile',
    };
    Map<String, dynamic>? response =
        await NetworkDio.getGiftVoucherDioHttpMethod(
      url: ApiPath.giftCardEndPoint + ApiPath.category,
      context: context,
      notShowError: true,
      queryParameters: queryParameters,
    );
    if (response != null) {
      for (Map<String, dynamic> e in response['objects']) {
        final CategoryModel categoryModel = CategoryModel.fromJson(e);
        model.categoryList.add(categoryModel);
      }
      view.refreshModel(model);
    }
  }

  @override
  set updateModel(BuyGiftCardsView value) {
    view = value;
    view.refreshModel(model);
  }
}
