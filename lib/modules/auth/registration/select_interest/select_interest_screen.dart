import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/constants/triggering_condition.dart';
import 'package:bounz_revamp_app/models/interest/interest_model.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart' as intercard;
import 'package:bounz_revamp_app/modules/auth/registration/select_interest/select_interest_view.dart';
import 'package:bounz_revamp_app/modules/auth/registration/select_interest/select_interest_presenter.dart';
import 'package:moengage_flutter/properties.dart';

@RoutePage()
class SelectInterestScreen extends StatefulWidget {
  final Map<String, dynamic> userDetails;
  final String loginType;
  const SelectInterestScreen({
    Key? key,
    required this.userDetails,
    required this.loginType,
  }) : super(key: key);

  @override
  _SelectInterestScreenState createState() => _SelectInterestScreenState();
}

class _SelectInterestScreenState extends State<SelectInterestScreen>
    with TickerProviderStateMixin
    implements SelectInterestView {
  bool isLoading = true;
  intercard.CardController? cardController = intercard.CardController();
  List<int> selectedInterest = [];
  List<String> selectedInterestWithName = [];
  List<Interest> interestList = [];
  SelectInterestPresenter personalDetailsPresenter = SelectInterestPresenter();
  bool shouldSwipeRight = false;
  bool swipeSelect = false;
  bool swipeCancle = false;

  late AnimationController _animationController;
  late Animation<double> _animation;

  late AnimationController _controller;
  late Animation<double> _animationTest;

  bool _isFirstTextVisible = true;

  bool showTutorialScreen = true;

  @override
  void initState() {
    super.initState();
    personalDetailsPresenter.getInterestData(
        context: context, personalizeInterestView: this);

    _controller = AnimationController(
      duration: const Duration(
          seconds: 2), // Increased duration for a slower animation
      vsync: this,
    )..repeat(reverse: true);

    _animationTest = Tween<double>(begin: 0.0, end: 0.285398).animate(
      CurvedAnimation(
          parent: _controller,
          curve:
              Curves.easeInOut), // Using easeInOut curve for a smooth animation
    );

    _controller.forward();
    animation();
  }

  @override
  void registractionComplete() {}

  @override
  void showInterestData(List<Interest> interestData) {
    interestList = interestData;
    isLoading = false;
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void animation() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    Future.delayed(const Duration(seconds: 1), () {
      _isFirstTextVisible = false;

      setState(() {});
    });
    Future.delayed(const Duration(seconds: 2), () {
      _isFirstTextVisible = false;
      _animationController.forward();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (shouldSwipeRight) {
      shouldSwipeRight = false;

      if (swipeCancle) {
        setState(() {
          swipeSelect = false;
        });
      } else {
        cardController!.triggerRight();
        setState(() {
          swipeSelect = true;
        });

        Future.delayed(const Duration(milliseconds: 600), () {
          setState(() {
            swipeSelect = false;
          });
        });
      }
    }
    return Stack(
      children: [
        Scaffold(
          body: AppBackGroundWidget(
            child: !isLoading
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: AppColors.whiteColor,
                        ),
                      ),
                      const SizedBox(
                        height: AppSizes.size30,
                      ),
                      Expanded(
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          children: [
                            Text(
                              AppConstString.fancyImageText.toUpperCase(),
                              style: AppTextStyle.regular36
                                  .copyWith(fontFamily: 'Bebas'),
                            ),
                            const SizedBox(
                              height: AppSizes.size10,
                            ),
                            Text(
                              AppConstString.offerText,
                              style: AppTextStyle.regular16.copyWith(
                                color: AppColors.whiteColor.withOpacity(
                                  0.85,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Stack(
                              children: [
                                interestSection(),
                                swipeSelect
                                    ? Padding(
                                        padding: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.38,
                                            top: 170.0),
                                        child: Container(
                                          width: 43,
                                          height: 45,
                                          decoration: BoxDecoration(
                                              boxShadow: const [
                                                BoxShadow(
                                                    color: AppColors.blackColor,
                                                    blurRadius: 20)
                                              ],
                                              shape: BoxShape.circle,
                                              color: AppColors.whiteColor
                                                  .withOpacity(0.8)),
                                          child: const Icon(
                                            Icons.done_rounded,
                                            size: 40,
                                            color: Colors.green,
                                            shadows: [
                                              Shadow(
                                                  color: AppColors.blackColor,
                                                  blurRadius: 5)
                                            ],
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                                swipeCancle
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            top: 175.0, left: 12),
                                        child: Container(
                                          width: 43,
                                          height: 45,
                                          decoration: BoxDecoration(
                                              boxShadow: const [
                                                BoxShadow(
                                                    color: AppColors.blackColor,
                                                    blurRadius: 20)
                                              ],
                                              shape: BoxShape.circle,
                                              color: AppColors.whiteColor
                                                  .withOpacity(0.8)),
                                          child: const Icon(
                                            Icons.close,
                                            size: 40,
                                            color: Colors.red,
                                            shadows: [
                                              Shadow(
                                                  color: AppColors.blackColor,
                                                  blurRadius: 5)
                                            ],
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                            const SizedBox(
                              height: AppSizes.size10,
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                : const SizedBox(),
          ),
        ),
        if (showTutorialScreen)
          Scaffold(
            backgroundColor: Colors.black.withOpacity(0.86),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Center(
                  child: AnimatedBuilder(
                    animation: _animationTest,
                    builder: (BuildContext context, Widget? child) {
                      return Transform.rotate(
                        angle: _animationTest.value,
                        child: Container(
                          width: 200,
                          height: 200,
                          color: Colors.white,
                          child: Stack(
                              alignment: Alignment.centerRight,
                              children: [
                                Center(
                                  child: Image.asset(
                                    AppAssets.fashionPng,
                                    fit: BoxFit.cover,
                                    height: 200,
                                    width: 200,
                                  ),
                                ),
                                Positioned(
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        boxShadow: const [
                                          BoxShadow(
                                              color: AppColors.blackColor,
                                              blurRadius: 20)
                                        ],
                                        shape: BoxShape.circle,
                                        color: AppColors.whiteColor
                                            .withOpacity(0.8)),
                                    child: const Icon(
                                      Icons.done_rounded,
                                      size: 40,
                                      color: Colors.green,
                                      shadows: [
                                        Shadow(
                                            color: AppColors.blackColor,
                                            blurRadius: 5)
                                      ],
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: SizedBox(
                    height: 50,
                    width: 100,
                    child: Lottie.asset(
                      "assets/gif/swipe_right_hand.json",
                      repeat: true,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 250,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeOut,
                        bottom: _isFirstTextVisible ? -400 : 0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Text(
                                'Things you really fancy',
                                style: AppTextStyle.bold20
                                    .copyWith(letterSpacing: 0),
                              ),
                            ),
                            const SizedBox(
                              height: 11,
                            ),
                            Text(
                              'Swipe Right to Add\n Your Preferences',
                              textAlign: TextAlign.center,
                              style: AppTextStyle.regular16.copyWith(
                                  decoration: TextDecoration.none,
                                  fontSize: 14),
                            ),
                            const SizedBox(
                              height: 45,
                            ),
                            ScaleTransition(
                              scale: _animation,
                              child: PrimaryButton(
                                text: 'Got it',
                                textStyle: AppTextStyle.regular14
                                    .copyWith(decoration: TextDecoration.none),
                                onTap: () {
                                  setState(() {
                                    showTutorialScreen = false;
                                  });
                                },
                                showShadow: true,
                              ),
                            ),
                            const SizedBox(
                              height: 36,
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
      ],
    );
  }

  Widget interestSection() {
    return SizedBox(
      height: 450,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          intercard.TinderSwapCard(
            allowVerticalMovement: false,
            orientation: intercard.AmassOrientation.top,
            totalNum: interestList.length,
            stackNum: interestList.length > 5 ? 3 : interestList.length - 1,
            cardController: cardController,
            minHeight: 249,
            maxHeight: 250,
            minWidth: MediaQuery.of(context).size.width * .6,
            maxWidth: MediaQuery.of(context).size.width * .9,
            swipeUpdateCallback: (DragUpdateDetails details, Alignment align) {
              if (align.x > 3) {
                setState(() {
                  swipeSelect = true;
                  swipeCancle = false;
                });
              } else if (align.x < -3) {
                setState(() {
                  swipeSelect = false;
                  swipeCancle = true;
                });
              } else if (align.x == 0 || align.x < 3 || align.x > -3) {
                setState(() {
                  swipeSelect = false;
                  swipeCancle = false;
                });
              }
            },
            swipeCompleteCallback: (orientation, index) {
              if (orientation.name == 'right') {
                setState(() {
                  swipeSelect = false;
                  swipeCancle = false;
                });

                selectedInterest.add(interestList[index].id!);
                selectedInterestWithName
                    .add(interestList[index].name.toString());
              } else if (orientation.name == 'left') {
                setState(() {
                  swipeSelect = false;
                  swipeCancle = false;
                });
              }
            },
            cardBuilder: (context, index) => interestContent(index),
          ),
          Positioned(
            bottom: 20,
            child: Center(
              child: PrimaryButton(
                text: AppConstString.next,
                onTap: () {
                  final properties = MoEProperties();
                  properties
                      .addAttribute(
                          TriggeringCondition.screenName, 'Select Interest')
                      .addAttribute(TriggeringCondition.userPreferences,
                          selectedInterestWithName)
                      .setNonInteractiveEvent();
                  MoenageManager.logEvent(
                    MoenageEvent.interestsSelected,
                    properties: properties,
                  );
                  Map<String, dynamic> data = widget.userDetails;
                  data['interests'] = selectedInterest;
                  data['login_step'] = 2;
                  personalDetailsPresenter.registerUser(
                    context: context,
                    data: data,
                    loginType: widget.loginType,
                    personalizeInterestView: this,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget interestContent(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          shouldSwipeRight = true;
        });
      },
      child: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.size16),
              child: ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.center,
                    colors: <Color>[
                      AppColors.blackColor.withOpacity(.4),
                      Colors.transparent,
                    ],
                  ).createShader(bounds);
                },
                child: CachedNetworkImage(
                  height: 27.0,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  imageUrl: interestList[index].imageNew.toString(),
                ),
                blendMode: BlendMode.srcATop,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  interestList[index].name.toString(),
                  style: AppTextStyle.regular16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
