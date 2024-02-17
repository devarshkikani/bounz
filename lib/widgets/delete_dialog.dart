// import 'package:flutter/material.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';
// import 'package:bounz_revamp_app/widgets/primary_button.dart';
// import 'package:bounz_revamp_app/config/theme/app_colors.dart';
// import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
// import 'package:bounz_revamp_app/widgets/rounded_border_button.dart';
//
// class DeleteDialog extends StatefulWidget {
//   const DeleteDialog({Key? key}) : super(key: key);
//
//   @override
//   State<DeleteDialog> createState() => _DeleteDialogState();
// }
//
// class _DeleteDialogState extends State<DeleteDialog> {
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
//                 height: 32.h,
//                 child: Padding(
//                   padding: EdgeInsets.all(6.w),
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
//                                   "Are you sure?",
//                                   style: AppTextStyle.bold16
//                                       .copyWith(color: AppColors.blackColor),
//                                 ),
//                                 const SizedBox(height: 15),
//                                 Text(
//                                   "Sure you want to delete all the\nnotifications?",
//                                   style: AppTextStyle.semiBold14
//                                       .copyWith(color: AppColors.blackColor),
//                                 )
//                               ]),
//                           const SizedBox(
//                               height: 60.0, child: Icon(Icons.notifications))
//                         ],
//                       ),
//                       SizedBox(height: 5.h),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: RoundedBorderButton(
//                               text: "Yes",
//                               tColor: AppColors.blackColor,
//                               bColor: AppColors.blackColor,
//                               height: 8.h,
//                             ),
//                           ),
//                           SizedBox(
//                             width: 3.w,
//                           ),
//                           Expanded(
//                             child: PrimaryButton(
//                               text: "No",
//                               tColor: AppColors.whiteColor,
//                               bColor: AppColors.btnBlueColor,
//                               height: 9.h,
//                             ),
//                           )
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               );
//             });
//       },
//       child: Text(
//         'Delete Dialog',
//         style: AppTextStyle.bold24,
//       ),
//     );
//   }
// }
