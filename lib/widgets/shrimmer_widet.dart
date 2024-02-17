import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';

class CustomShrimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  const CustomShrimmerWidget.rectangular(
      {super.key, this.width = double.infinity, required this.height})
      : shapeBorder = const RoundedRectangleBorder();

  const CustomShrimmerWidget.circular(
      {super.key,
      this.width = double.infinity,
      required this.height,
      this.shapeBorder = const CircleBorder()});

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
        baseColor: const Color(0xff383838),
        highlightColor: const Color(0xffc0c0c0),
        period: const Duration(seconds: 2),
        child: Container(
          width: width,
          height: height,
          decoration: ShapeDecoration(
            color: const Color(0xfff9f9f9).withOpacity(.25),
            shape: shapeBorder,
          ),
        ),
      );
}
