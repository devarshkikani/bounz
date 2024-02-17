import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ViewDetailsScreen extends StatefulWidget {
  final Map fixedValueData;
  final bool fromRecentTrasaction;

  const ViewDetailsScreen({
    super.key,
    required this.fixedValueData,
    required this.fromRecentTrasaction,
  });

  @override
  State<ViewDetailsScreen> createState() => _ViewDetailsScreenState();
}

class _ViewDetailsScreenState extends State<ViewDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackGroundWidget(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  if (widget.fromRecentTrasaction) {
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
                "Details",
                textAlign: TextAlign.center,
                style: AppTextStyle.regular36.copyWith(fontFamily: "Bebas"),
              ),
              decoratedContainer("Code", widget.fixedValueData['code'] ?? ''),
              decoratedContainer(
                  "Serial", widget.fixedValueData['serial'] ?? ''),
              decoratedContainer(
                  "Usage Info", widget.fixedValueData['usage_info'] ?? ''),
              decoratedContainer(
                  "Validity", widget.fixedValueData['validity'] ?? ''),
              const SizedBox(
                height: AppSizes.size50,
              ),
              doneButtonWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget decoratedContainer(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: AppSizes.size20,
        ),
        Text(
          title,
          style: AppTextStyle.bold16,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            color: AppColors.textFieldColor.withOpacity(.23),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  content,
                  style: AppTextStyle.regular16
                      .copyWith(color: AppColors.whiteColor),
                ),
              ),
              if (title == "Code")
                InkWell(
                  onTap: () {
                    NetworkDio.showWarning(
                      context: context,
                      message: 'Saved code in clipboard',
                    );
                    Clipboard.setData(
                      ClipboardData(
                        text: content,
                      ),
                    );
                  },
                  child: SvgPicture.asset(
                    AppAssets.copy,
                    height: 22,
                    // ignore: deprecated_member_use
                    color: AppColors.whiteColor,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget doneButtonWidget() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSizes.size30),
        child: PrimaryButton(
          bColor: AppColors.backgroundColor,
          tColor: AppColors.whiteColor,
          text: AppConstString.done,
          onTap: () {
            MoenageManager.logScreenEvent(name: 'Pay Bills');
            AutoRouter.of(context).pushAndPopUntil(
                MainHomeScreenRoute(index: 2),
                predicate: (_) => false);
          },
        ),
      ),
    );
  }
}
