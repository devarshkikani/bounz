import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/constants/triggering_condition.dart';
import 'package:bounz_revamp_app/modules/reward_exchange_receive/reward_exchange_history/history_exchange_screen.dart';
import 'package:bounz_revamp_app/widgets/rounded_border_button.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:moengage_flutter/properties.dart';

@RoutePage()
class RewardReceivedScreen extends StatefulWidget {
  const RewardReceivedScreen({Key? key}) : super(key: key);

  @override
  _RewardReceivedScreenState createState() => _RewardReceivedScreenState();
}

class _RewardReceivedScreenState extends State<RewardReceivedScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _sizeAnimation;
  bool _isFirstTextVisible = true;
  double value = 20;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    _opacityAnimation =
        Tween<double>(begin: 1.0, end: 0.0).animate(_controller);

    _sizeAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(_controller);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isFirstTextVisible = false;
        });
      }
    });
    animationController();
  }

  animationController() {
    Future.delayed(const Duration(seconds: 1), () {
      _controller.forward();
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackGroundWidget(
        child: Padding(
          padding: const EdgeInsets.only(top: AppSizes.size50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppConstString.rewardExchange,
                style: AppTextStyle.regular36.copyWith(fontFamily: 'Bebas'),
              ),
              const SizedBox(
                height: AppSizes.size20,
              ),
              Expanded(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    AnimatedOpacity(
                      opacity: _opacityAnimation.value,
                      duration: const Duration(milliseconds: 500),
                      child: AnimatedBuilder(
                          animation: _sizeAnimation,
                          builder: (context, child) {
                            return Align(
                              alignment: Alignment.center,
                              child: Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  Positioned.fill(
                                    child: Lottie.asset(
                                      AppAssets.yellowRipple,
                                      repeat: true,
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(
                                          height: AppSizes.size20,
                                        ),
                                        Center(
                                          child: Text(
                                            AppConstString.youReceived,
                                            style: AppTextStyle.bold24,
                                          ),
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.3,
                                        ),
                                        Center(
                                          child: Text(
                                            GlobalSingleton.smilesTempBal ??
                                                "will be update in 20 mins",
                                            style: AppTextStyle.bold24,
                                          ),
                                        ),
                                        Center(
                                          child: Text(
                                            AppConstString.smiles,
                                            style: AppTextStyle.bold24,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOut,
                      bottom: _isFirstTextVisible ? -580 : 70,
                      child: Stack(
                        children: [
                          Positioned(
                            left: -120,
                            top: -120,
                            right: -100,
                            bottom: 120,
                            child: Lottie.asset(
                              AppAssets.rewardsConfetti,
                              repeat: true,
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                AppConstString.newBOUNZBalance,
                                style: AppTextStyle.bold20,
                              ),
                              Text(
                                GlobalSingleton.bounzNewTempBal ??
                                    "will be update in 20 mins",
                                style: AppTextStyle.bold36,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 9.5,
                              ),
                              Text(
                                AppConstString.newSmilesBalance,
                                style: AppTextStyle.bold20,
                              ),
                              Text(
                                GlobalSingleton.smilesTempBal ??
                                    "will be update in 20 mins",
                                style: AppTextStyle.bold36,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 18.5,
                              ),
                              Text(
                                AppConstString.latestPoints,
                                style: AppTextStyle.regular12,
                              ),
                              const SizedBox(height: 16),
                              historyButtonWidget(),
                              const SizedBox(
                                height: 20,
                              ),
                              doneButtonWidget()
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget doneButtonWidget() {
    return Center(
      child: PrimaryButton(
        onTap: () {
          MoenageManager.logScreenEvent(name: 'Main Home');
          AutoRouter.of(context).pushAndPopUntil(
              MainHomeScreenRoute(isFirstLoad: false, index: 0),
              predicate: (_) => false);
        },
        text: "Home",
      ),
    );
  }

  Widget historyButtonWidget() {
    return RoundedBorderButton(
      height: AppSizes.size60,
      onTap: () {
        final properties = MoEProperties();
        properties.setNonInteractiveEvent();
        properties.addAttribute(
            TriggeringCondition.screenName, 'Reward Exchange');
        MoenageManager.logEvent(
          MoenageEvent.exchangeHistory,
          properties: properties,
        );

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const ExchangeHistoryScreen()),
        );
      },
      bColor: AppColors.btnBlueColor,
      tColor: AppColors.btnBlueColor,
      text: "View History",
    );
  }
}
