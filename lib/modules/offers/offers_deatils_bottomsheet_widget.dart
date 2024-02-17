// import 'package:flutter/material.dart';
// import 'package:auto_route/auto_route.dart';
// import 'package:bounz_revamp_app/constants/app_sizes.dart';
// import 'package:bounz_revamp_app/widgets/primary_button.dart';
// import 'package:bounz_revamp_app/config/theme/app_colors.dart';
// import 'package:bounz_revamp_app/models/offer/offer_model.dart';
// import 'package:bounz_revamp_app/constants/app_const_text.dart';
// import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
// import 'package:bounz_revamp_app/widgets/rounded_border_button.dart';
// import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
// import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
// import 'package:bounz_revamp_app/models/outlet/outlet_detail_model.dart';

// Future offersDetailsBottomsheet({
//   required BuildContext context,
//   required double lat,
//   required double lng,
//   required int index,
//   required OfferModel offerModel,
//   required OutletDetailModel outletDetailModel,
// }) {
//   return showModalBottomSheet(
//     backgroundColor: AppColors.secondaryContainerColor,
//     context: context,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
//     ),
//     builder: (context) {
//       return StatefulBuilder(
//         builder: (BuildContext context, StateSetter setState) {
//           return SizedBox(
//             height: 210,
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     AppConstString.offerDetails,
//                     style: AppTextStyle.bold16
//                         .copyWith(color: AppColors.darkBlueTextColor),
//                   ),
//                   const SizedBox(height: 15),
//                   Text(
//                     offerModel.ofrDesc.toString(),
//                     style: AppTextStyle.semiBold14.copyWith(
//                       color: AppColors.darkBlueTextColor,
//                       letterSpacing: -.28,
//                     ),
//                   ),
//                   const SizedBox(height: AppSizes.size20),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: RoundedBorderButton(
//                           text: 'Redeem Bounz',
//                           onTap: () {
//                             MoenageManager.logScreenEvent(
//                               name: 'Parnter Redeem Bounz',
//                             );
//                             AutoRouter.of(context).push(
//                               RedeemBounzScreenRoute(
//                                 isOffers: true,
//                                 selectedIndex: index,
//                                 // outletDetailModel: outletDetailModel,
//                               ),
//                             );
//                           },
//                           tColor: AppColors.blackColor,
//                           bColor: AppColors.btnBlueColor.withOpacity(0.5),
//                         ),
//                       ),
//                       const SizedBox(
//                         width: AppSizes.size10,
//                       ),
//                       Expanded(
//                         child: PrimaryButton(
//                           showShadow: true,
//                           onTap: () {
//                             MoenageManager.logScreenEvent(
//                               name: 'Parnter Collect Bounz',
//                             );
//                             AutoRouter.of(context).push(
//                               EarnBounzScreenRoute(
//                                 isOffers: true,
//                                 selectedIndex: index,
//                                 outletDetailModel: outletDetailModel,
//                               ),
//                             );
//                           },
//                           text: 'Earn Bounz',
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       );
//     },
//   );
// }
