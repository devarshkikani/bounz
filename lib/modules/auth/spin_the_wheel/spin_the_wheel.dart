import 'dart:async';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/models/spin_wheel/wheel_details.dart';
import 'package:bounz_revamp_app/models/spin_wheel/wheel_response.dart';
import 'package:bounz_revamp_app/modules/auth/spin_the_wheel/spin_the_wheel_model.dart';
import 'package:bounz_revamp_app/modules/auth/spin_the_wheel/spin_the_wheel_presenter.dart';
import 'package:bounz_revamp_app/modules/auth/spin_the_wheel/spin_the_wheel_view.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

@RoutePage()
class SpinTheWheelScreen extends StatefulWidget {
  final bool isFromSplash;
  final String apiKey;
  final String apiValue;
  const SpinTheWheelScreen({
    Key? key,
    @PathParam('isFromSplash') this.isFromSplash = true,
    @PathParam('apiKey') this.apiKey = '',
    @PathParam('apiValue') this.apiValue = '',
  }) : super(key: key);

  @override
  State<SpinTheWheelScreen> createState() => _SpinTheWheelScreenState();
}

class _SpinTheWheelScreenState extends State<SpinTheWheelScreen>
    implements SpinTheWheelView {
  StreamController<int> selected = StreamController<int>();
  int duration = 10;
  int count = 10;
  late SpinWheelsModel model;
  bool firstTimeTap = false;
  Timer? countdownTimer;
  bool countDownComplete = true;
  late SpinTheWheelPresenter presenter;

  @override
  void refreshModel(SpinWheelsModel spinWheelModel) {
    model = spinWheelModel;
    if (model.spinData?.statusCode != null) {
      for (int i = 0; i < model.spinData!.values!.wheelData!.length; i++) {
        WheelDatum wheelDatum = model.spinData!.values!.wheelData![i];
        fortuneItem.add(
          FortuneItem(
            child: SizedBox(
              width: 95,
              child: Transform.rotate(
                angle: pi / 2,
                child: Transform(
                  transform: Matrix4.rotationX(0.6),
                  alignment: Alignment.topCenter,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      wheelDatum.name ?? "",
                      softWrap: true,
                      style: AppTextStyle.regular22.copyWith(
                        fontSize: 20.7,
                        fontFamily: "Bebas",
                        letterSpacing: -0.6,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            style: FortuneItemStyle(
              borderWidth: 0,
              textAlign: TextAlign.center,
              color: getColor(wheelDatum.colorCode!),
            ),
          ),
        );
      }
    }
    if (model.showBottomSheet) {
      Future.delayed(Duration.zero, () {
        bottomSheetSpin(context);
      });
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    bool isRegular = !widget.isFromSplash && widget.apiValue == 'promo';
    presenter = BasicSpinTheWheelPresenter(
        widget.isFromSplash,
        widget.apiKey,
        widget.apiValue,
        !widget.isFromSplash && widget.apiValue == 'promo'
            ? GlobalSingleton.spinData
            : null,
        isRegular ? (GlobalSingleton.showBottomSheet ?? false) : false);
    setState(() {
      firstTimeTap = !firstTimeTap;
    });
    presenter.updateView = this;
    if (model.apiValue != 'promo') {
      spinCall();
    }
  }

  spinCall() async {
    await presenter.spinTheWheelListDesign(context: context);
  }

  void startTimeout() {
    if (mounted) {
      setState(() {
        countDownComplete = false;
      });
      Timer.periodic(const Duration(seconds: 1), (timer) {
        if (timer.tick >= duration) {
          countDownComplete = true;
          count = duration;
          timer.cancel();
        }
        count = duration - timer.tick;
        if (mounted) setState(() {});
      });
    }
  }

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  List<FortuneItem> fortuneItem = [];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.isFromSplash) {
          MoenageManager.logScreenEvent(name: 'Main Home');
          AutoRouter.of(context).pushAndPopUntil(
              MainHomeScreenRoute(
                isFirstLoad: true,
              ),
              predicate: (_) => false);
        } else {
          Navigator.of(context).pop();
        }
        return true;
      },
      child: Scaffold(
        body: AppBackGroundWidget(
          padding: EdgeInsets.zero,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: model.spinData != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      topView(),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          firstContainer(),
                          secondContainer(),
                          thirdContainer(),
                          spinTheWheelButton(),
                          Positioned(
                            top: MediaQuery.of(context).size.height / 33,
                            child: SizedBox(
                              width: 80, // change width to your desired value
                              height: 75,
                              child: ClipPath(
                                clipper: TriangleClipper(),
                                child: Container(
                                  color: AppColors.triangleColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: AppSizes.size20,
                      ),
                    ],
                  )
                : const SizedBox(),
          ),
        ),
      ),
    );
  }

  Widget topView() {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.size20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              if (widget.isFromSplash) {
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
            height: AppSizes.size20,
          ),
          Text(
            model.spinData?.values?.title ?? AppConstString.spinWheel,
            style: AppTextStyle.regular36.copyWith(fontFamily: 'Bebas'),
          ),
          const SizedBox(
            height: AppSizes.size20,
          ),
          Text(
            model.spinData?.values?.subtitle ?? AppConstString.spinWheelLucky,
            textAlign: TextAlign.center,
            style: AppTextStyle.light16,
          ),
          const SizedBox(
            height: AppSizes.size30,
          ),
        ],
      ),
    );
  }

  Widget firstContainer() {
    return Center(
      child: Container(
        height: 405,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            width: AppSizes.size10,
            color: AppColors.backgroundColor,
          ),
          color: AppColors.wheelBorderColor,
        ),
      ),
    );
  }

  Widget secondContainer() {
    return Center(
      child: fortuneItem.isNotEmpty
          ? SizedBox(
              width: MediaQuery.of(context).size.width / 1.19,
              height: MediaQuery.of(context).size.height / 1.97,
              child: FortuneWheel(
                animateFirst: false,
                physics: NoPanPhysics(),
                duration: Duration(seconds: duration),
                indicators: const [
                  FortuneIndicator(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      height: AppSizes.size54,
                      width: AppSizes.size60,
                      child: TriangleIndicator(
                        color: AppColors.wheelBorderColor,
                      ),
                    ),
                  ),
                ],
                items: fortuneItem,
                selected: selected.stream,
              ),
            )
          : const SizedBox(),
    );
  }

  Widget thirdContainer() {
    return Center(
      child: Container(
        height: 350,
        width: MediaQuery.of(context).size.width / 1.4,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.whiteColor.withOpacity(0.19),
        ),
      ),
    );
  }

  Widget spinTheWheelButton() {
    return Container(
      width: MediaQuery.of(context).size.width / 4.7,
      height: 350,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.buttonBorderColor,
          width: AppSizes.size6,
        ),
      ),
      child: ElevatedButton(
        onPressed: countDownComplete == true
            ? () async {
                selected.add(1);
                startTimeout();
                SpinData? data = await presenter.spinTheWheel(
                    context: context,
                    spinCode: model.spinData!.values!.spinCode ?? "");
                if (data != null && mounted) {
                  int? temp = data.values?.spokeId;
                  int index = model.spinData!.values!.wheelData!
                      .indexWhere((element) => element.spokeId == temp);
                  selected.add(index);
                  Future.delayed(Duration(seconds: count), () {
                    presenter.manageClick(context: context, data: data);
                  });
                }
              }
            : () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.backgroundColor,
          shape: const CircleBorder(),
        ),
        child: Text(
          "Spin the wheel",
          textAlign: TextAlign.center,
          style: AppTextStyle.regular10.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void bottomSheetSpin(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      enableDrag: false,
      backgroundColor: AppColors.secondaryContainerColor,
      isDismissible: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppSizes.size20),
            topRight: Radius.circular(AppSizes.size20)),
      ),
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Padding(
            padding: EdgeInsets.only(
              top: AppSizes.size20,
              right: AppSizes.size20,
              left: AppSizes.size20,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SizedBox(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Oh-oh! BOUNZER! You've spun your way to the daily limit!",
                        style: AppTextStyle.bold16
                            .copyWith(color: AppColors.darkBlueTextColor),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Come back tomorrow to give that wheel another whirl!",
                        style: AppTextStyle.regular16
                            .copyWith(color: AppColors.darkBlueTextColor),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PrimaryButton(
                          onTap: () {
                            AutoRouter.of(context).push(
                              MainHomeScreenRoute(index: 0),
                            );
                          },
                          height: AppSizes.size60,
                          text: 'Ok',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Color getColor(String color) {
    String subStringColor = color.substring(1);
    return Color(int.parse("0xff" + subStringColor));
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width / 2, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(TriangleClipper oldClipper) => false;
}
