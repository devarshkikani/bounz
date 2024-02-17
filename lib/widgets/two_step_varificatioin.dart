// import 'package:flutter/material.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';
// import 'package:bounz_revamp_app/widgets/primary_button.dart';
// import 'package:bounz_revamp_app/config/theme/app_colors.dart';
// import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
//
// class TwoStepVarification extends StatefulWidget {
//   const TwoStepVarification({Key? key}) : super(key: key);
//
//   @override
//   State<TwoStepVarification> createState() => _TwoStepVarificationState();
// }
//
// class _TwoStepVarificationState extends State<TwoStepVarification> {
//   bool _checked = false;
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
//               return StatefulBuilder(
//                   builder: (BuildContext context, StateSetter setState) {
//                 return SizedBox(
//                   height: 42.h,
//                   child: Padding(
//                     padding: EdgeInsets.all(5.w),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "2 - Step Verification Required",
//                           style: AppTextStyle.bold16
//                               .copyWith(color: AppColors.blackColor),
//                         ),
//                         SizedBox(height: 3.h),
//                         Text(
//                           "For a better security, choose a previously \nused mobile number to request OTP.",
//                           style: AppTextStyle.semiBold14
//                               .copyWith(color: AppColors.blackColor),
//                         ),
//                         SizedBox(height: 4.h),
//                         Row(
//                           children: [
//                             GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   _checked = !_checked;
//                                 });
//                               },
//                               child: _checked
//                                   ? const Icon(
//                                       Icons.radio_button_checked,
//                                       color: AppColors.btnBlueColor,
//                                       size: 20,
//                                     )
//                                   : const Icon(
//                                       Icons.radio_button_unchecked,
//                                       color: AppColors.btnBlueColor,
//                                       size: 20,
//                                     ),
//                             ),
//                             SizedBox(width: 3.h),
//                             Text(
//                               " +971 (04) 492 8869",
//                               style: AppTextStyle.semiBold14
//                                   .copyWith(color: AppColors.blackColor),
//                             )
//                           ],
//                         ),
//                         SizedBox(height: 3.5.h),
//                         Align(
//                           alignment: Alignment.center,
//                           child: PrimaryButton(
//                               height: 9.h,
//                               text: 'Request OTP',
//                               onTap: () {},
//                               bColor: _checked
//                                   ? AppColors.btnBlueColor
//                                   : AppColors.btnBlueColor.withOpacity(0.5)),
//                         )
//                       ],
//                     ),
//                   ),
//                 );
//               });
//             });
//       },
//       child: Text(
//         '2 - Step Verification Required',
//         style: AppTextStyle.bold24,
//       ),
//     );
//   }
// }
