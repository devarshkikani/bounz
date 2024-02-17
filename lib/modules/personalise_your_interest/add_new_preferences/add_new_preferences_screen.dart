import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/constants/triggering_condition.dart';
import 'package:bounz_revamp_app/models/user/user_information.dart';
import 'package:bounz_revamp_app/modules/personalise_your_interest/add_new_preferences/add_new_preferences_presenter.dart';
import 'package:bounz_revamp_app/modules/personalise_your_interest/add_new_preferences/add_new_preferences_view.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart' as tindercard;
import 'package:lottie/lottie.dart';
import 'package:moengage_flutter/properties.dart';

import '../../../config/routes/router_import.gr.dart';

@RoutePage()
class AddNewPreferencesScreen extends StatefulWidget {
  final bool fromSplash;
  const AddNewPreferencesScreen({
    @PathParam('fromSplash') this.fromSplash = false,
    Key? key,
  }) : super(key: key);

  @override
  _AddNewPreferencesScreenState createState() =>
      _AddNewPreferencesScreenState();
}

class _AddNewPreferencesScreenState extends State<AddNewPreferencesScreen>
    with TickerProviderStateMixin
    implements AddNewPreferencesView {
  bool isLoading = true;
  bool swipeSelect = false;
  bool swipeCancle = false;
  tindercard.CardController? cardController = tindercard.CardController();

  List<Interest> interestList = [];
  List<Interest> interestSelected = [];
  List<int> interestId = [];
  bool _isFirstTextVisible = true;
  SelectPreferencePresenter personalDetailsPresenter =
      SelectPreferencePresenter();
  bool shouldSwipeRight = false;
  bool showTutorialScreen = true;
  late Animation<double> _animation;
  late AnimationController _animationController;
  late AnimationController _controller;
  late Animation<double> _animationTest;

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
  void initState() {
    super.initState();

    for (Interest i in GlobalSingleton.userInformation.interests!) {
      interestId.add(i.id!);
      interestSelected.add(i);
    }

    personalDetailsPresenter.getPreferenceData(
        context: context, personalizeAddNewPreferencesView: this);

    // animation
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
  void showPreferenceData(List<Interest> interestData) {
    interestList = interestData;
    isLoading = false;

    setState(() {});
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
                ? SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            if (widget.fromSplash) {
                              MoenageManager.logScreenEvent(name: 'Main Home');
                              AutoRouter.of(context).pushAndPopUntil(
                                  MainHomeScreenRoute(
                                    isFirstLoad: true,
                                  ),
                                  predicate: (_) => false);
                            } else {
                              Navigator.of(context).pop();
                            }
                          },
                          child: const Icon(
                            Icons.arrow_back,
                            color: AppColors.whiteColor,
                          ),
                        ),
                        const SizedBox(
                          height: AppSizes.size30,
                        ),
                        Text(
                          AppConstString.addNewPreferences.toUpperCase(),
                          style: AppTextStyle.regular36
                              .copyWith(fontFamily: 'Bebas'),
                        ),
                        const SizedBox(
                          height: AppSizes.size30,
                        ),
                        Stack(
                          children: [
                            interestSection(),
                            swipeSelect
                                ? Padding(
                                    padding: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width /
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
                        child: SizedBox(
                            width: 230,
                            height: 220,
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
                                  )
                                ])),
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
    return Column(
      children: [
        SizedBox(
          height: 470,
          child: Stack(
            alignment: Alignment.center,
            children: [
              tindercard.TinderSwapCard(
                allowVerticalMovement: false,
                orientation: tindercard.AmassOrientation.top,
                totalNum: interestList.length,
                stackNum: interestList.length > 5 ? 3 : interestList.length - 1,
                cardController: cardController,
                minHeight: 249,
                maxHeight: 250,
                minWidth: MediaQuery.of(context).size.width * .6,
                maxWidth: MediaQuery.of(context).size.width * .9,
                swipeUpdateCallback:
                    (DragUpdateDetails details, Alignment align) {
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
                    if (interestId.contains(interestList[index].id!)) {
                    } else {
                      interestId.add(interestList[index].id!);
                      interestSelected.add(interestList[index]);
                    }
                  } else if (orientation.name == 'left') {
                    setState(() {
                      swipeSelect = false;
                      swipeCancle = false;
                    });

                    if (interestId.contains(interestList[index].id!)) {
                      interestId.remove(interestList[index].id!);
                      int index2 = interestSelected.indexWhere(
                          (element) => element.id == interestList[index].id);
                      interestSelected.removeAt(index2);
                    }
                  }
                },
                cardBuilder: (context, index) => interestContent(index),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: PrimaryButton(
            text: AppConstString.updatePreference,
            onTap: () {
              String newInterestSelected = " ";
              for (int i = 0; i < interestSelected.length; i++) {
                newInterestSelected += interestSelected[i].name! +
                    (((i + 1) == interestSelected.length) ? "" : ",");
              }
              personalDetailsPresenter.updateUser(
                context: context,
                personalizeAddNewPreferencesView: this,
                interestId: interestId,
                interestSelected: interestSelected,
                membershipNo:
                    int.parse(GlobalSingleton.userInformation.membershipNo!),
              );

              final properties = MoEProperties();
              properties
                  .addAttribute(
                      TriggeringCondition.screenName, 'Add New Preferences')
                  .addAttribute(
                      TriggeringCondition.userPreferences, newInterestSelected)
                  .setNonInteractiveEvent();
              MoenageManager.logEvent(
                MoenageEvent.interestsSelected,
                properties: properties,
              );

              setState(() {});
            },
          ),
        ),
      ],
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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 9.5,
                ),
                Text(
                  interestList[index].name.toString(),
                  style: AppTextStyle.regular16,
                ),
                interestId.contains(interestList[index].id)
                    ? Padding(
                        padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width / 32,
                        ),
                        child: Container(
                          margin: const EdgeInsets.only(top: 2),
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                            Icons.done,
                            size: 12,
                            color: AppColors.blackColor.withOpacity(0.5),
                          ),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromARGB(255, 244, 186, 52)),
                        ),
                      )
                    : SizedBox(
                        width: MediaQuery.of(context).size.width / 12,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
