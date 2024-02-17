// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';
// import 'package:bounz_revamp_app/widgets/primary_button.dart';
// import 'package:bounz_revamp_app/config/theme/app_colors.dart';
// import 'package:bounz_revamp_app/constants/app_const_assets.dart';
// import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
//
// class NoBounzBottomSheet {
//   Future<dynamic> noBounzBottomSheet({required BuildContext context}) {
//     return showModalBottomSheet(
//         backgroundColor: AppColors.secondaryContainerColor,
//         shape: const OutlineInputBorder(
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(20),
//             topRight: Radius.circular(20),
//           ),
//         ),
//         context: context,
//         builder: (context) {
//           return StatefulBuilder(builder: (context, StateSetter setState) {
//             return Padding(
//               padding: EdgeInsets.only(
//                   left: 5.w, top: 3.h, bottom: 3.86.h, right: 5.w),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Something is not right!",
//                             style: AppTextStyle.bold16
//                                 .copyWith(color: AppColors.blackColor),
//                           ),
//                           SizedBox(
//                             height: 1.7.h,
//                           ),
//                           Text(
//                             "You don't have enough BOUNZ!",
//                             style: AppTextStyle.semiBold14
//                                 .copyWith(color: AppColors.blackColor),
//                           ),
//                         ],
//                       ),
//                       SvgPicture.asset(
//                         AppAssets.piggyBank,
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 4.7.h,
//                   ),
//                   Center(
//                     child: PrimaryButton(
//                       tColor: AppColors.whiteColor,
//                       bColor: AppColors.btnBlueColor,
//                       height: 9.h,
//                       onTap: () {
//                         Navigator.of(context).pop();
//                       },
//                       text: "Done",
//                     ),
//                   ),
//                   SizedBox(
//                     height: 1.h,
//                   ),
//                 ],
//               ),
//             );
//           });
//         });
//   }
// }
