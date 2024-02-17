import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';

class SocialButtonWidget extends StatelessWidget {
  final String text;
  final String icon;
  final Function()? tap;

  const SocialButtonWidget(
      {Key? key, required this.icon, required this.text, this.tap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: tap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 4,
            child: Container(
              alignment: Alignment.centerRight,
              child: SvgPicture.asset(
                icon,
              ),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            flex: 5,
            child: Text(
              text,
              style: AppTextStyle.regular14,
            ),
          )
        ],
      ),
    );
  }
}
