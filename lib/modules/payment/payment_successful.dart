import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
// import 'package:bounz_revamp_app/config/theme/app_colors.dart';

@RoutePage()
class PaymentSuccessful extends StatefulWidget {
  final String? totalPoints;
  final int? pageIndex;
  final Map? fixedValueData;
  const PaymentSuccessful(
      {Key? key, this.totalPoints, this.pageIndex, this.fixedValueData})
      : super(key: key);

  @override
  _PaymentSuccessfulState createState() => _PaymentSuccessfulState();
}

class _PaymentSuccessfulState extends State<PaymentSuccessful> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      GlobalSingleton.transactionList = null;
      if (widget.totalPoints != null) {
        MoenageManager.logScreenEvent(name: 'Reward Claimed');
        AutoRouter.of(context).popAndPush(
          RewardClaimedScreenRoute(
            title: AppConstString.congratulations,
            earnPoints: num.parse(widget.totalPoints!),
            pageIndex: widget.pageIndex ?? 0,
            fixedValueData: widget.fixedValueData,
          ),
        );
      } else {
        if (widget.pageIndex == 4) {
          MoenageManager.logScreenEvent(name: 'Purchased History');
          AutoRouter.of(context).replaceNamed('/purchased_history_screen/true');
        } else {
          MoenageManager.logScreenEvent(name: 'Pay Bills');
          AutoRouter.of(context).pushAndPopUntil(
              MainHomeScreenRoute(index: widget.pageIndex),
              predicate: (_) => false);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackGroundWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // GestureDetector(
            //   onTap: () {
            //     Navigator.of(context).pop();
            //   },
            //   child: const Icon(
            //     Icons.arrow_back,
            //     color: AppColors.whiteColor,
            //   ),
            // ),
            const SizedBox(
              height: AppSizes.size50,
            ),
            Center(
              child: Text(
                AppConstString.paymentSuccess,
                style: AppTextStyle.bold16,
              ),
            ),
            Center(
              child: Lottie.asset(AppAssets.yellowRightWithPop),
            ),
          ],
        ),
      ),
    );
  }
}
