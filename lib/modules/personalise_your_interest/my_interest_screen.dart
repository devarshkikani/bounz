import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/manager/storage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/constants/app_storage_key.dart';
import 'package:bounz_revamp_app/models/user/user_information.dart';
import 'package:bounz_revamp_app/modules/auth/registration/select_interest/select_interest_presenter.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart' as tindercard;

@RoutePage()
class MyInterestScreen extends StatefulWidget {
  final bool fromSplash;
  const MyInterestScreen({
    @PathParam('fromSplash') this.fromSplash = false,
    Key? key,
  }) : super(key: key);

  @override
  _MyInterestScreenState createState() => _MyInterestScreenState();
}

class _MyInterestScreenState extends State<MyInterestScreen>
    with TickerProviderStateMixin {
  bool isLoading = true;
  tindercard.CardController? cardController = tindercard.CardController();
  List<int> selectedInterest = [];
  List<Interest> interestList = [];
  List<Interest> interestList2 = [];
  //late AnimationController _animationController;
  // late Animation<double> _animation;
  //late AnimationController _controller;
  // bool _isFirstTextVisible = true;

  SelectInterestPresenter personalDetailsPresenter = SelectInterestPresenter();
  bool shouldSwipeLeft = false;

  bool showTutorialScreen = true;

  @override
  void initState() {
    super.initState();

    interestList = GlobalSingleton.userInformation.interests!;
    interestList2 = GlobalSingleton.userInformation.interests!;
  }

  @override
  void dispose() {
    //_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (shouldSwipeLeft) {
      shouldSwipeLeft = false;
      Future.delayed(const Duration(milliseconds: 200), () {
        cardController!.triggerLeft();
      });
    }
    return WillPopScope(
      onWillPop: () async {
        if (widget.fromSplash) {
          MoenageManager.logScreenEvent(name: 'Main Home');
          AutoRouter.of(context).pushAndPopUntil(
              MainHomeScreenRoute(isFirstLoad: true, index: 0),
              predicate: (_) => false);
        } else {
          AutoRouter.of(context).canPop();
        }
        return true;
      },
      child: Scaffold(
        body: AppBackGroundWidget(
          child: SingleChildScrollView(
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
                  AppConstString.interest.toUpperCase(),
                  style: AppTextStyle.regular36.copyWith(fontFamily: 'Bebas'),
                ),
                const SizedBox(
                  height: AppSizes.size30,
                ),
                if (interestList.isNotEmpty) interestSection(),
                SizedBox(
                  height: MediaQuery.of(context).size.height /
                      (interestList.isNotEmpty ? 4.96 : 1.476),
                  child: interestList.isNotEmpty
                      ? const SizedBox()
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const SizedBox(
                                height: 2,
                              ),
                              Text(
                                "You haven't selected interest yet.",
                                style: AppTextStyle.bold20.copyWith(
                                  color: AppColors.brownishColor,
                                ),
                              ),
                              const SizedBox(
                                height: AppSizes.size1,
                              ),
                              PrimaryButton(
                                text: AppConstString.addNewPreferences,
                                onTap: () {
                                  MoenageManager.logScreenEvent(
                                      name: 'Add New Preferences');

                                  AutoRouter.of(context).push(
                                    AddNewPreferencesScreenRoute(),
                                  );
                                },
                                showShadow: true,
                              ),
                              const SizedBox(
                                height: AppSizes.size1,
                              ),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget interestSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: 470,
          child: Stack(
            alignment: Alignment.center,
            children: [
              tindercard.TinderSwapCard(
                allowVerticalMovement: false,
                orientation: tindercard.AmassOrientation.top,
                totalNum: interestList2.length,
                cardController: cardController,
                minHeight: 249,
                maxHeight: 250,
                minWidth: MediaQuery.of(context).size.width * .6,
                maxWidth: MediaQuery.of(context).size.width * .9,
                swipeCompleteCallback: (orientation, index) {
                  if (orientation.name == 'left') {
                    //   interestList.remove(interestList2[index]);
                    setState(() {});
                    //  GlobalSingleton.userInformation.interests = interestList;

                    StorageManager.setStringValue(
                      key: AppStorageKey.userInformation,
                      value: jsonEncode(GlobalSingleton.userInformation),
                    );
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
            text: AppConstString.addNewPreferences,
            onTap: () {
              MoenageManager.logScreenEvent(name: 'Add New Preferences');

              AutoRouter.of(context).push(
                AddNewPreferencesScreenRoute(),
              );
            },
            showShadow: true,
          ),
        ),
      ],
    );
  }

  Widget interestContent(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          shouldSwipeLeft = true;
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
                  imageUrl: interestList2[index].imageNew.toString(),
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
                  interestList2[index].name.toString(),
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
