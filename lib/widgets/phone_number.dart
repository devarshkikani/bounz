// import 'package:flutter/material.dart';
// import 'package:bounz_revamp_app/widgets/primary_button.dart';
// import 'package:bounz_revamp_app/config/theme/app_colors.dart';
// import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';
//
//   const PhoneNumber({Key? key}) : super(key: key);
//
//   @override
//   State<PhoneNumber> createState() => _PhoneNumberState();
// }
//
// class _PhoneNumberState extends State<PhoneNumber> {
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
//                 height: 30.h,
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
//                                   "Select Number",
//                                   style: AppTextStyle.bold16
//                                       .copyWith(color: AppColors.blackColor),
//                                 ),
//                                 SizedBox(height: 3.h),
//                                 Row(
//                                   children: [
//                                     const Icon(
//                                       Icons.phone,
//                                       size: 16,
//                                     ),
//                                     SizedBox(width: 2.w),
//                                     Text(
//                                       "Call +971 (04) 492 8869",
//                                       style: AppTextStyle.regular12.copyWith(
//                                           color: AppColors.blackColor),
//                                     ),
//                                   ],
//                                 )
//                               ]),
//                         ],
//                       ),
//                       SizedBox(
//                         height: 4.h,
//                       ),
//                       PrimaryButton(
//                         text: "Cancel",
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
//         'Phone Number',
//         style: AppTextStyle.bold24,
//       ),
//     );
//   }
// }
