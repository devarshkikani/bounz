import 'dart:async';

import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AnimatedReward extends StatefulWidget {
  const AnimatedReward({super.key});

  @override
  State<AnimatedReward> createState() => _AnimatedRewardState();
}

class _AnimatedRewardState extends State<AnimatedReward> {
  Timer? timer;
  int start = 2;
  double turns = 0.0;
  int tapCount = 0;
  Alignment alignmentRight = Alignment.centerRight;
  Alignment alignmentleft = Alignment.centerLeft;
  bool isClicked = false;

  void autoAnimate() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (start == 0) {
          if (mounted == true) {
            setState(() {
              isClicked = !isClicked;
              tapCount++;
              turns = (tapCount % 2 == 0) ? turns - 0.5 : turns + 0.5;
              start = 2;
            });
          }
        } else {
          if (mounted == true) {
            setState(() {
              start--;
            });
          }
        }
      },
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      autoAnimate();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedPositioned(
                duration: const Duration(seconds: 1),
                curve: Curves.linear,
                left: isClicked
                    ? (MediaQuery.of(context).size.width * 0.55) +
                        AppSizes.size20
                    : 30,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.15,
                  child: Image.asset(
                    AppAssets.smilesText,
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(seconds: 1),
                left: isClicked
                    ? 30
                    : MediaQuery.of(context).size.width * 0.55 +
                        AppSizes.size20,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.15,
                  child: SvgPicture.asset(
                    AppAssets.bounzText,
                    alignment: Alignment.bottomCenter,
                  ),
                ),
              ),
              AnimatedRotation(
                turns: turns,
                duration: const Duration(seconds: 1),
                child: Image.asset(
                  AppAssets.rewardExchange,
                  fit: BoxFit.cover,
                  height: 80,
                  width: 80,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
