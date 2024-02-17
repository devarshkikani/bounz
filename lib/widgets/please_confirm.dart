// import 'package:flutter/material.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';
// import 'package:bounz_revamp_app/widgets/primary_button.dart';
// import 'package:bounz_revamp_app/config/theme/app_colors.dart';
// import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
//
// class PleaseConfirm extends StatefulWidget {
//   const PleaseConfirm({Key? key}) : super(key: key);
//
//   @override
//   State<PleaseConfirm> createState() => _PleaseConfirmState();
// }
//
// class _PleaseConfirmState extends State<PleaseConfirm> {
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: () {
//         showModalBottomSheet(
//             backgroundColor: AppColors.secondaryContainerColor,
//             context: context,
//             shape: const RoundedRectangleBorder(
//               borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(20.0),
//                   topRight: Radius.circular(20.0)),
//             ),
//             builder: (context) {
//               return SizedBox(
//                 height: 30.2.h,
//                 child: Padding(
//                   padding: EdgeInsets.all(5.w),
//                   child: Column(
//                     children: [
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   "Please Confirm",
//                                   style: AppTextStyle.bold16
//                                       .copyWith(color: AppColors.blackColor),
//                                 ),
//                                 SizedBox(height: 3.h),
//                                 Text(
//                                   "Please confirm that you have read \nand understood the privacy policy.",
//                                   style: AppTextStyle.semiBold14
//                                       .copyWith(color: AppColors.blackColor),
//                                 )
//                               ]),
//                           const Icon(
//                             Icons.topic,
//                             size: 50,
//                           )
//                         ],
//                       ),
//                       SizedBox(height: 4.h),
//                       PrimaryButton(
//                         text: "Continue",
//                         tColor: AppColors.whiteColor,
//                         bColor: AppColors.btnBlueColor,
//                         height: 9.h,
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             });
//       },
//       child: Text(
//         'Please Confirm',
//         style: AppTextStyle.bold24,
//       ),
//     );
//   }
// }
