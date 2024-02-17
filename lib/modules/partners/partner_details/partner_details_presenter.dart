import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/models/partner/emirates_draw_model.dart';
import 'package:bounz_revamp_app/models/partner/new_partner_detail_model.dart';
import 'package:bounz_revamp_app/models/partner/partner_outlet_detail_model.dart';
import 'package:bounz_revamp_app/modules/partners/partner_details/partner_details_model.dart';
import 'package:bounz_revamp_app/modules/partners/partner_details/partner_details_view.dart';
import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:bounz_revamp_app/utils/get_user_location.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:bounz_revamp_app/widgets/distance_calulation.dart';
import 'package:flutter/material.dart';

class PartnerDetailsPresenter {
  Future manageClick({
    required int index,
    required Type type,
    required BuildContext context,
    required NewPartnerDetailModel brandData,
    required AllBranchLobType listData,
  }) async {}
  Future getPartnerDetails(
    BuildContext context,
  ) async {}
  void updateData(int index) {}
  set updateView(PartnerDetailsView partnerDetailsView) {}
}

class BasicPartnerDetailsPresenter extends PartnerDetailsPresenter {
  late PartnerDetailsModel model;
  late PartnerDetailsView view;
  BasicPartnerDetailsPresenter({
    required String merchantCode,
    required String brandCode,
    NewPartnerDetailModel? newPartnerDetailModel,
  }) {
    model = PartnerDetailsModel(
      selectedBranchIndex: 0,
      branchlat: 0,
      branchlong: 0,
      brandCode: brandCode,
      merchantCode: merchantCode,
      newPartnerDetailModel: newPartnerDetailModel,
      distance: [],
      collectList: [],
      redeemList: [],
    );
    view = PartnerDetailsView();
  }

  @override
  Future<void> updateData(int index) async {
    model.selectedBranchIndex = index;
    model.distance = [];
    model.collectList = [];
    model.redeemList = [];
    if (model.newPartnerDetailModel?.allBranches != null) {
      for (var i = 0;
          i < (model.newPartnerDetailModel?.allBranches?.length ?? 0);
          i++) {
        if (model.newPartnerDetailModel?.allBranches![i].lat != null &&
            model.newPartnerDetailModel!.allBranches![i].long != null) {
          model.newPartnerDetailModel?.allBranches![i].distance =
              await calculateDistance(
            GlobalSingleton.currentPosition?.latitude,
            GlobalSingleton.currentPosition?.longitude,
            model.newPartnerDetailModel?.allBranches?[i].lat,
            model.newPartnerDetailModel?.allBranches?[i].long,
          );
        }
      }
      model.newPartnerDetailModel?.allBranches!
          .sort((a, b) => a.distance!.compareTo(b.distance!));
      if (model.newPartnerDetailModel!.allBranches!.isNotEmpty &&
          model.newPartnerDetailModel!.allBranches![model.selectedBranchIndex]
                  .lat !=
              null &&
          model.newPartnerDetailModel!.allBranches![model.selectedBranchIndex]
                  .long !=
              null) {
        model.branchlat = model.newPartnerDetailModel!
            .allBranches![model.selectedBranchIndex].lat!;
        model.branchlong = model.newPartnerDetailModel!
            .allBranches![model.selectedBranchIndex].long!;
      }

      for (var i = 0;
          i <
              model.newPartnerDetailModel!
                  .allBranches![model.selectedBranchIndex].lobTypes!.length;
          i++) {
        if (model.newPartnerDetailModel!.allBranches?[model.selectedBranchIndex]
                    .lobTypes?[i].type !=
                Type.redeem &&
            model.newPartnerDetailModel!.allBranches?[model.selectedBranchIndex]
                    .lobTypes?[i].type !=
                Type.rdmon &&
            model.newPartnerDetailModel!.allBranches?[model.selectedBranchIndex]
                    .lobTypes?[i].type !=
                Type.posredeem) {
          model.collectList.add(
            model.newPartnerDetailModel!.allBranches![model.selectedBranchIndex]
                .lobTypes![i],
          );
        } else {
          model.redeemList.add(
            model.newPartnerDetailModel!.allBranches![model.selectedBranchIndex]
                .lobTypes![i],
          );
        }
      }
    }
  }

  @override
  Future<void> getPartnerDetails(BuildContext context) async {
    String getUserLocation = await UserLocation().getCurrentPosition(
      () {
        getPartnerDetails(context);
      },
      null,
      1,
    );
    if (getUserLocation == "SUCCESS") {
      if (model.newPartnerDetailModel == null) {
        Map<String, dynamic>? response = await NetworkDio.postPartnerNetworkDio(
          url: ApiPath.getPartnerDetail,
          // context: context,
          data: {
            "platform": Platform.isAndroid ? 'android' : 'ios',
            "brand_code": model.brandCode,
            "merchant_code": model.merchantCode
          },
        );
        if (response != null) {
          if (response['statuscode'] == 200) {
            model.newPartnerDetailModel =
                NewPartnerDetailModel.fromJson(response['data']['values']);

            await updateData(0);
            emiratesapiCall(context);
          }
        }
      } else {
        await updateData(0);
        emiratesapiCall(context);
      }
      view.refreshModel(model);
    } else if (getUserLocation == "PERMISSION") {
      if (GlobalSingleton.fromSplash == true) {
        NetworkDio.showWarning(
          message: 'Turn on your location service',
          context: context,
          isDimissible: false,
        );
        Future.delayed(const Duration(milliseconds: 3500), () {
          Navigator.of(context).pop();
        });
      } else {
        AutoRouter.of(context).push(
          MainHomeScreenRoute(
            isFirstLoad: GlobalSingleton.fromSplash == false,
            index: 1,
            isShowDialog: true,
          ),
        );
      }
    }
  }

  Future<void> emiratesapiCall(BuildContext context) async {
    Map<String, dynamic>? response = await NetworkDio.postPartnerNetworkDio(
      url: ApiPath.apiEndPoint + ApiPath.emiratesDraw,
      // context: context,
      data: {"membership_no": GlobalSingleton.userInformation.membershipNo},
    );
    if (response != null) {
      model.emirates = EmiratesDrawModel.fromJson(response);
      model.emiratesUrl = model.emirates?.data?.redirectUrl ?? "";
      if (model.newPartnerDetailModel!.allBranches != null) {
        await getOutletDetailData(
          outletCode: model.newPartnerDetailModel!
              .allBranches![model.selectedBranchIndex].outletCode
              .toString(),
          brandCode: model.newPartnerDetailModel!.brandCode.toString(),
          merchantCode: model.newPartnerDetailModel!.merchantCode.toString(),
          lat: model.newPartnerDetailModel!
              .allBranches![model.selectedBranchIndex].lat!
              .toDouble(),
          long: model.newPartnerDetailModel!
              .allBranches![model.selectedBranchIndex].long!
              .toDouble(),
          context: context,
        );
      }
    }
  }

  Future getOutletDetailData({
    required String outletCode,
    required String brandCode,
    required String merchantCode,
    required double lat,
    required double long,
    required BuildContext context,
  }) async {
    Map<String, dynamic>? response = await NetworkDio.postOfferListCat(
      url: ApiPath.outletDetail,
      // context: context,
      data: {
        "outlet_code": outletCode,
        "brand_code": brandCode,
        "merchant_code": merchantCode,
        "lat": lat,
        "long": long,
        "lobtype": 'visit'
      },
    );
    if (response != null) {
      if (response['statuscode'] == 200) {
        model.partneroOutletDetailModel =
            PartneroOutletDetailModel.fromJson(response['data']['values']);
      }
    }
    view.refreshModel(model);
  }

  @override
  Future<void> manageClick({
    required int index,
    required Type type,
    required BuildContext context,
    required NewPartnerDetailModel brandData,
    required AllBranchLobType listData,
  }) async {
    if (listData.type == Type.click) {
      clickHandle(
        context: context,
        brandData: brandData,
        index: index,
        listData: listData,
        type: type,
        nxtScreenTitle: 'EARN BOUNZ',
        emiratesUrl: null,
      );
    } else if (listData.type == Type.visit) {
      MoenageManager.logScreenEvent(name: 'User Going Stores');
      AutoRouter.of(context).push(
        UserGoingStoreScreenRoute(
            merchantCode: model.newPartnerDetailModel?.merchantCode ?? '',
            outletId: model
                .newPartnerDetailModel!.outletIds![model.selectedBranchIndex],
            title: 'EARN BOUNZ',
            termCondition: listData.termsConditions ?? ''),
      );
    } else if (listData.type == Type.spend) {
      spendHandle(
        context,
        brandData.name!,
        brandData.image!,
        listData,
      );
    } else if (listData.type == Type.spdon) {
      spendOnlineHandle(
        context: context,
        brandData: brandData,
        index: index,
        listData: listData,
        type: type,
      );
    } else if (listData.type == Type.spdinstr) {
      spdinstrHandle(
        context,
        listData,
      );
    } else if (listData.type == Type.redeem) {
      redeemHandle(
          context, model.newPartnerDetailModel?.isPinBased == true, listData);
    } else if (listData.type == Type.rdmon) {
      redeemOnlineHandle(
        context: context,
        brandData: brandData,
        index: index,
        listData: listData,
        type: type,
      );
    } else if (listData.type == Type.afl) {
      await AutoRouter.of(context).push<Map<String, dynamic>?>(
        VisitWebsiteScreenRoute(
          brandData: brandData,
          index: index,
          listData: listData,
          type: type,
          title: 'EARN BOUNZ',
          emiratesUrl: null,
          isExternalBrowser: model.newPartnerDetailModel?.isExternalBrowser
                  .toString()
                  .toLowerCase() ==
              "true",
        ),
      );
    } else if (listData.type == Type.posredeem) {
      MoenageManager.logScreenEvent(name: 'Earn Bounz With Otp');
      AutoRouter.of(context).push(
        EarnBounzWithOtpScreenRoute(
          title: 'REDEEM BOUNZ',
          termsConditions: listData.termsConditions ?? '',
        ),
      );
    }
  }

  Future<void> clickHandle({
    required BuildContext context,
    required int index,
    required Type type,
    required NewPartnerDetailModel brandData,
    required AllBranchLobType listData,
    required String? emiratesUrl,
    required String nxtScreenTitle,
  }) async {
    Map<String, dynamic>? value =
        await AutoRouter.of(context).push<Map<String, dynamic>?>(
      VisitWebsiteScreenRoute(
        brandData: brandData,
        index: index,
        listData: listData,
        type: type,
        title: nxtScreenTitle,
        emiratesUrl: emiratesUrl,
      ),
    );
    if (value != null) {
      if (value['status'] == false) {
        if (value['message'] ==
            'Bonus BOUNZ can only be collected on first click to website.') {
          MoenageManager.logScreenEvent(name: 'Bounz Alreday Earned');
          AutoRouter.of(context).push(const BounzAlreadyEarnedRoute());
        } else if (value['message'] ==
            'You should be in 100 Meter radius of store location to earn BOUNZ') {
          MoenageManager.logScreenEvent(name: 'User far From Store');
          AutoRouter.of(context).push(
            UserFarFromStoreScreenRoute(
              title: 'EARN BOUNZ',
            ),
          );
        }
      } else {
        MoenageManager.logScreenEvent(name: 'Bounz Received');
        AutoRouter.of(context).push(
          BounzReceivedScreenRoute(
            earned: value["earndata"]['earned'].split(' ').first,
          ),
        );
      }
    }
  }

  Future<void> spendHandle(
    BuildContext context,
    String brandName,
    String brancImg,
    AllBranchLobType listData,
  ) async {
    MoenageManager.logScreenEvent(name: 'Earn Bounz With Otp');
    AutoRouter.of(context).push(
      EarnBounzWithOtpScreenRoute(
        title: 'EARN BOUNZ',
        termsConditions: listData.termsConditions ?? '',
      ),
    );
  }

  Future<void> spendOnlineHandle({
    required int index,
    required Type type,
    required NewPartnerDetailModel brandData,
    required BuildContext context,
    required AllBranchLobType listData,
  }) async {
    if (model.newPartnerDetailModel?.name == 'Emirates Draw' &&
        model.emiratesUrl != null) {
      clickHandle(
        context: context,
        brandData: brandData,
        index: index,
        listData: listData,
        type: type,
        nxtScreenTitle: 'EARN BOUNZ',
        emiratesUrl: model.emiratesUrl,
      );
    } else {
      // if (model.newPartnerDetailModel?.isPinBased == true) {
      //   MoenageManager.logScreenEvent(name: 'Earn Bounz');
      //   AutoRouter.of(context).push(
      //     EarnBounzScreenRoute(
      //       isOffers: false,
      //       selectedIndex: model.selectedBranchIndex,
      //       dataList: model.newPartnerDetailModel,
      //     ),
      //   );
      // } else {
      clickHandle(
        context: context,
        brandData: brandData,
        index: index,
        listData: listData,
        type: type,
        nxtScreenTitle: 'EARN BOUNZ',
        emiratesUrl: null,
      );
      // }
    }
  }

  Future<void> spdinstrHandle(
    BuildContext context,
    AllBranchLobType listData,
  ) async {
    // if (model.newPartnerDetailModel?.isPinBased == true) {
    MoenageManager.logScreenEvent(name: 'Earn Bounz');

    AutoRouter.of(context).push(
      EarnBounzScreenRoute(
        isOffers: false,
        selectedIndex: model.selectedBranchIndex,
        dataList: model.newPartnerDetailModel,
      ),
    );
    // } else {
    //   MoenageManager.logScreenEvent(name: 'Earn Bounz With Otp');
    //   AutoRouter.of(context).push(
    //     EarnBounzWithOtpScreenRoute(
    //       title: 'EARN BOUNZ',
    //       termsConditions: listData.termsConditions ?? '',
    //     ),
    //   );
    // }
  }

  Future<void> redeemOnlineHandle({
    required int index,
    required Type type,
    required NewPartnerDetailModel brandData,
    required BuildContext context,
    required AllBranchLobType listData,
  }) async {
    if (model.newPartnerDetailModel?.name == 'Emirates Draw' &&
        model.emiratesUrl != null) {
      clickHandle(
        context: context,
        brandData: brandData,
        index: index,
        listData: listData,
        type: type,
        nxtScreenTitle: 'REDEEM BOUNZ',
        emiratesUrl: model.emiratesUrl ?? '',
      );
    }
    // else if (model.newPartnerDetailModel?.isPinBased == true) {
    //   MoenageManager.logScreenEvent(name: 'Redeem Bounz');

    //   AutoRouter.of(context).push(
    //     RedeemBounzScreenRoute(
    //       dataList: model.newPartnerDetailModel,
    //       selectedIndex: model.selectedBranchIndex,
    //     ),
    //   );
    // }
    else {
      clickHandle(
        context: context,
        brandData: brandData,
        index: index,
        listData: listData,
        type: type,
        nxtScreenTitle: 'REDEEM BOUNZ',
        emiratesUrl: null,
      );
    }
  }

  void redeemHandle(
    BuildContext context,
    bool isPinBase,
    AllBranchLobType listData,
  ) {
    // if (isPinBase) {
    MoenageManager.logScreenEvent(name: 'Redeem Bounz');
    AutoRouter.of(context).push(
      RedeemBounzScreenRoute(
        dataList: model.newPartnerDetailModel,
        selectedIndex: model.selectedBranchIndex,
      ),
    );
    // } else {
    // MoenageManager.logScreenEvent(name: 'Earn Bounz With Otp');
    // AutoRouter.of(context).push(
    //   EarnBounzWithOtpScreenRoute(
    //     title: 'REDEEM BOUNZ',
    //     termsConditions: listData.termsConditions ?? '',
    //   ),
    // );
    // }
  }

  @override
  set updateView(PartnerDetailsView partnerDetailsView) {
    view = partnerDetailsView;
    view.refreshModel(model);
  }
}
