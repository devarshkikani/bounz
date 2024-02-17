import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

@RoutePage()
class HackedDataScreen extends StatefulWidget {
  final bool fromSplash;
  const HackedDataScreen(
      {Key? key,
        @PathParam('fromSplash') this.fromSplash = false})
      : super(key: key);

  @override
  _HackedData createState() => _HackedData();
}

class _HackedData extends State<HackedDataScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: AppBackGroundWidget(
            padding: EdgeInsets.zero,
            child: updateBody(),
          ),
        ));
  }

  Widget updateBody() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(
            height: 40,
          ),
          Text(
            AppConstString.noAccess,
            style: AppTextStyle.semiBold26
                .copyWith(color: AppColors.whiteColor.withOpacity(0.9)),
            softWrap: true,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 35,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            height: 60,
            child: PrimaryButton(
              height: AppSizes.size60,
              text: AppConstString.ok,
              onTap: () {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
            ),
          ),
        ],
      ),
    );
  }
}
