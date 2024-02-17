// import 'package:bounz_revamp_app/modules/spin_wheel_voucher/spin_wheel_voucher_model.dart';
// import 'package:bounz_revamp_app/modules/spin_wheel_voucher/spin_wheel_voucher_view.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:auto_route/auto_route.dart';
// import 'package:moengage_flutter/properties.dart';
// import 'package:bounz_revamp_app/utils/api_path.dart';
// import 'package:bounz_revamp_app/constants/app_storage_key.dart';
// import 'package:bounz_revamp_app/utils/network/network_dio.dart';
// import 'package:bounz_revamp_app/models/user/user_information.dart';
// import 'package:bounz_revamp_app/constants/triggering_condition.dart';
// import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
// import 'package:bounz_revamp_app/config/manager/storage_manager.dart';
// import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
// import 'package:bounz_revamp_app/models/spin_wheel/wheel_details.dart';
// import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
// import 'package:bounz_revamp_app/models/spin_wheel/wheel_response.dart';

// class SpinWheelVoucherPresenter {
//   Future<void> spinWheelVoucherListDesign(
//       {required BuildContext context, required String campaignCode}) async {}
//   Future<SpinData?> spinWheelVoucher(
//       {required BuildContext context, required String spinCode}) async {
//     return null;
//   }

//   void manageClick({required BuildContext context, required SpinData data}) {}
//   set updateView(SpinWheelVoucherView value) {}
// }

// class BasicSpinWheelVoucherPresenter implements SpinWheelVoucherPresenter {
//   late SpinWheelsVoucherModel model;
//   late SpinWheelVoucherView view;

//   BasicSpinWheelVoucherPresenter() {
//     view = SpinWheelVoucherView();
//     model = SpinWheelsVoucherModel();
//   }

//   @override
//   Future spinWheelVoucherListDesign(
//       {required BuildContext context, required String campaignCode}) async {
//     Map<String, dynamic>? response = await NetworkDio.postDioHttpSpinWheel(
//       url: ApiPath.apiEndPoint + ApiPath.spinTheWheelDesign,
//       context: context,
//       data: {
//         "membership_no": GlobalSingleton.userInformation.membershipNo,
//         "campaign_code": campaignCode
//       },
//     );
//     if (response != null) {
//       if (response['status'] == true) {
//         model.spinData = DataWheelDesign.fromJson(response);
//       }
//       view.refreshModel(model);
//     }
//   }

//   Future getProfileData(BuildContext context) async {
//     Map<String, dynamic>? response = await NetworkDio.getDioHttpMethod(
//       url: ApiPath.apiEndPoint + ApiPath.getProfile,
//       //context: context,
//       queryParameters: {
//         "membership_no": GlobalSingleton.userInformation.membershipNo,
//       },
//     );
//     if (response != null) {
//       GlobalSingleton.userInformation = UserInformation.fromJson(
//         response['data']['values'][0],
//       );
//       StorageManager.setStringValue(
//         key: AppStorageKey.userInformation,
//         value: userInformationToJson(GlobalSingleton.userInformation),
//       );
//     }
//   }

//   @override
//   void manageClick({
//     required BuildContext context,
//     required SpinData data,
//   }) {
//     Future.delayed(
//       const Duration(seconds: 5),
//       () {
//         MoenageManager.logScreenEvent(
//           name: 'SpinTheWheelVoucher',
//         );
//         final properties = MoEProperties();
//         if (data.values!.prizeType == "coupon") {
//           properties
//               .addAttribute(
//                   TriggeringCondition.winningSpoke, data.values?.spokeId)
//               .addAttribute(
//                   TriggeringCondition.voucherName, data.values!.couponCode)
//               .setNonInteractiveEvent();
//           AutoRouter.of(context).push(
//             VoucherGotScreenRoute(
//                 spinValue: data.values!.successTitle ?? "", fromSplash: false),
//           );
//         } else if (data.values!.prizeType == "better_luck") {
//           properties
//               .addAttribute(
//                   TriggeringCondition.winningSpoke, data.values?.spokeId)
//               .addAttribute(
//                   TriggeringCondition.bounzEarned, data.values!.points)
//               .addAttribute(
//                   TriggeringCondition.voucherName, data.values!.prizeType)
//               .setNonInteractiveEvent();
//           AutoRouter.of(context).push(
//             VoucherGotScreenRoute(
//                 spinValue: data.values!.successTitle ?? "", fromSplash: false),
//           );
//         } else {
//           properties
//               .addAttribute(
//                   TriggeringCondition.bounzEarned, data.values!.points)
//               .addAttribute(
//                   TriggeringCondition.winningSpoke, data.values?.spokeId)
//               .addAttribute(
//                   TriggeringCondition.spokeReward, data.values!.points)
//               .addAttribute(TriggeringCondition.voucherName, '')
//               .addAttribute(TriggeringCondition.offerName, '')
//               .setNonInteractiveEvent();
//         }
//         AutoRouter.of(context).push(
//           VoucherGotScreenRoute(
//               spinValue: data.values!.successTitle ?? "", fromSplash: false),
//         );
//       },
//     );
//   }

//   @override
//   set updateView(SpinWheelVoucherView spinTheWheelView) {
//     view = spinTheWheelView;
//     view.refreshModel(model);
//   }

//   @override
//   Future<SpinData?> spinWheelVoucher({
//     required BuildContext context,
//     required String spinCode,
//   }) async {
//     Map<String, dynamic>? response = await NetworkDio.postDioHttpMethod(
//       url: ApiPath.apiEndPoint + ApiPath.spinTheWheel,
//       //context: context,
//       data: {
//         "membership_no": GlobalSingleton.userInformation.membershipNo,
//         "spin_code": spinCode,
//       },
//     );

//     if (response != null) {
//       if (response['status'] == true) {
//         model.spinDataResponse = SpinData.fromJson(response);
//         getProfileData(context);
//       } else {
//         model.spinDataResponse = SpinData.fromJson(response);
//       }
//     }
//     return model.spinDataResponse;
//   }
// }
