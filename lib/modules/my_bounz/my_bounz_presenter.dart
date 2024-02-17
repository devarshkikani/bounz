import 'package:bounz_revamp_app/models/my_bounz/expiry_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:bounz_revamp_app/modules/my_bounz/my_bounz_view.dart';
import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/modules/my_bounz/my_bounz_model.dart';
import 'package:bounz_revamp_app/models/my_bounz/my_bounz_card_model.dart';

class MyBounzPresenter {
  void updateDate(int index, Map<String, dynamic> selected) {}
  Future<void> transactionList({required BuildContext context}) async {}
  void updateTabIndex(int index) {}
  void updateExpiringIndex(bool isExpiring) {}
  set updateModel(MybounzView value) {}
}

class BasicMyBounzPresenter implements MyBounzPresenter {
  late MybounzModel model;
  late MybounzView view;
  BasicMyBounzPresenter() {
    view = MybounzView();
    model = MybounzModel(
      totalRedeemPoint: 0,
      currentIndex: 0,
      currentTabIndex: 0,
      isExpiring: true,
      selectedMonth: {
        'title': 'This Month',
        'month': DateTime.now().month.toString() +
            ", " +
            DateTime.now().year.toString(),
      },
    );
  }

  @override
  Future<void> transactionList({required BuildContext context}) async {
    Map<String, dynamic>? response = await NetworkDio.postDioHttpMethod(
      url: ApiPath.apiEndPoint + ApiPath.myBounzGetTransaction,
      context: context,
      data: {
        "membership_no":
            GlobalSingleton.userInformation.membershipNo.toString(),
      },
    );

    model.earnedList = [];
    model.reedemList = [];
    model.myBounzCardList = [];
    model.filteredMyBounzCardList = [];
    if (response != null) {
      model.totalRedeemPoint = response['values']['total_points'];
      for (Map<String, dynamic> e in response['values']['transaction_data']) {
        MyBounzCardModel myBounzCardModel = MyBounzCardModel.fromJson(e);
        model.myBounzCardList!.add(myBounzCardModel);
        if (myBounzCardModel.transactionDate!.month.toString() +
                ", " +
                myBounzCardModel.transactionDate!.year.toString() ==
            model.selectedMonth['month']) {
          model.filteredMyBounzCardList!.add(myBounzCardModel);
          if (myBounzCardModel.transactionType == 'credit') {
            model.earnedList!.add(myBounzCardModel);
          } else {
            model.reedemList!.add(myBounzCardModel);
          }
        }
      }
    }
    model.merchantList = model.filteredMyBounzCardList!.groupByyy();
    Map<String, dynamic>? expiryData = await NetworkDio.postDioHttpMethod(
      url: ApiPath.apiEndPoint + ApiPath.getExpiryDetails,
      context: context,
      data: {
        "membership_no":
            GlobalSingleton.userInformation.membershipNo.toString(),
      },
    );
    model.expiryDetails = ExpiryDetails(expired: [], expiry: []);
    if (expiryData != null) {
      model.expiryDetails = ExpiryDetails.fromJson(expiryData['values']);
    }
    view.refreshModel(model);
  }

  @override
  void updateDate(int index, Map<String, dynamic> selected) {
    model.selectedMonth = selected;
    model.currentIndex = index;
    model.filteredMyBounzCardList = [];
    model.reedemList = [];
    model.earnedList = [];
    for (MyBounzCardModel e in model.myBounzCardList!) {
      if (e.transactionDate!.month.toString() +
              ", " +
              e.transactionDate!.year.toString() ==
          model.selectedMonth['month']) {
        model.filteredMyBounzCardList!.add(e);
        if (e.transactionType == 'credit') {
          model.earnedList!.add(e);
        } else {
          model.reedemList!.add(e);
        }
      }
    }
    model.merchantList = model.filteredMyBounzCardList!.groupByyy();
    view.refreshModel(model);
  }

  @override
  set updateModel(MybounzView value) {
    view = value;
    view.refreshModel(model);
  }

  @override
  void updateTabIndex(int index) {
    model.currentTabIndex = index;
    view.refreshModel(model);
  }

  @override
  void updateExpiringIndex(bool isExpiring) {
    model.isExpiring = isExpiring;
    view.refreshModel(model);
  }
}

extension UtilListExtension on List<MyBounzCardModel> {
  groupByyy() {
    try {
      List<Map<String, dynamic>> result = [];
      List<String> keys = [];

      forEach((f) {
        return keys.add('${f.partnerName}');
      });

      for (var k in [...keys.toSet()]) {
        List<MyBounzCardModel> data = [
          ...where((e) => '${e.partnerName}' == k)
        ];
        result.add({
          k: data,
          'expand': false,
        });
      }

      return result;
    } catch (e) {
      return <Map<String, dynamic>>[];
    }
  }
}
