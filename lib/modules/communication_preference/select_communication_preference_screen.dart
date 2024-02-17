import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/constants/triggering_condition.dart';
import 'package:bounz_revamp_app/modules/communication_preference/communication_preference_model.dart';
import 'package:bounz_revamp_app/modules/communication_preference/communication_preference_presenter.dart';
import 'package:bounz_revamp_app/modules/communication_preference/communication_preference_view.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moengage_flutter/properties.dart';

import '../../config/routes/router_import.gr.dart';

enum CommunicationType { whatsapp, sms, email }

@RoutePage()
class SelectCommunicationPreferenceScreen extends StatefulWidget {
  final bool fromSplash;
  const SelectCommunicationPreferenceScreen(
      {@PathParam('fromSplash') this.fromSplash = false, Key? key})
      : super(key: key);

  @override
  State<SelectCommunicationPreferenceScreen> createState() =>
      _SelectCommunicationPreferenceScreenState();
}

class _SelectCommunicationPreferenceScreenState
    extends State<SelectCommunicationPreferenceScreen>
    implements CommunicationPreferenceView {
  bool checkwhatsapp = false, checksms = false, checkemail = false;
  final CommunicationPreferencePresenter presenter =
      BasicCommunicationPreferencePresenter();

  @override
  void refreshModel(CommunicationPreferenceModel model) {}

  @override
  void initState() {
    super.initState();
    presenter.updateModel = this;
    checksms = GlobalSingleton.userInformation.smsConsent.toString() == 'YES';
    checkemail =
        GlobalSingleton.userInformation.emailConsent.toString() == 'YES';
    checkwhatsapp =
        GlobalSingleton.userInformation.whatsappConsent.toString() == 'YES';
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.fromSplash) {
          MoenageManager.logScreenEvent(name: 'Main Home');
          AutoRouter.of(context).pushAndPopUntil(
              MainHomeScreenRoute(isFirstLoad: true),
              predicate: (_) => false);
        } else {
          AutoRouter.of(context).canPop();
        }
        return true;
      },
      child: Scaffold(
        body: AppBackGroundWidget(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
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
                AppConstString.communicationPreferences1.toUpperCase(),
                style: AppTextStyle.regular36.copyWith(fontFamily: "Bebas"),
              ),
              const SizedBox(
                height: AppSizes.size20,
              ),
              Text(
                AppConstString.wantToReciveComm,
                style: AppTextStyle.regular14,
              ),
              const SizedBox(
                height: AppSizes.size20,
              ),
              Text(
                AppConstString.desiredChannelsOfComn,
                style: AppTextStyle.semiBold14,
              ),
              const SizedBox(
                height: AppSizes.size20,
              ),
              iconsWidget(),
              const SizedBox(
                height: AppSizes.size30,
              ),
              Text(
                AppConstString.unsubscribeLink,
                style: AppTextStyle.regular14,
              ),
              const Spacer(),
              saveButtonWidget()
            ],
          ),
        ),
      ),
    );
  }

  Widget iconsWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        checkIcon(
          image: AppAssets.whatsapp,
          title: AppConstString.wpConsent,
          communicationType: CommunicationType.whatsapp,
          showIcon: checkwhatsapp == true,
          onTap: () {
            setState(() {
              checkwhatsapp = !checkwhatsapp;
            });
          },
        ),
        checkIcon(
          image: AppAssets.sms,
          title: AppConstString.smsConsent,
          communicationType: CommunicationType.sms,
          showIcon: checksms == true,
          onTap: () {
            setState(() {
              checksms = !checksms;
            });
          },
        ),
        checkIcon(
          image: AppAssets.mail,
          title: AppConstString.emailConsent,
          communicationType: CommunicationType.email,
          showIcon: checkemail == true,
          onTap: () {
            setState(() {
              checkemail = !checkemail;
            });
          },
        ),
      ],
    );
  }

  Widget checkIcon({
    required bool showIcon,
    required String image,
    required String title,
    required CommunicationType communicationType,
    required Function() onTap,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: AppSizes.size50,
                height: AppSizes.size50,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SvgPicture.asset(image),
                ),
              ),
              showIcon
                  ? Positioned(
                      bottom: 0,
                      left: 30,
                      child: SvgPicture.asset(AppAssets.rightGreen),
                    )
                  : const SizedBox()
            ],
          ),
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTextStyle.regular14,
        ),
      ],
    );
  }

  saveButtonWidget() {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSizes.size30),
        child: PrimaryButton(
          showShadow: true,
          text: AppConstString.save,
          onTap: () {
            presenter.savedPrefrences(
              sms: checksms == true ? 'YES' : 'NO',
              email: checkemail == true ? 'YES' : 'NO',
              whatsapp: checkwhatsapp == true ? 'YES' : 'NO',
              context: context,
            );
            final properties = MoEProperties();
            properties
                .addAttribute(
                    TriggeringCondition.screenName, "CommunicationPreferences")
                .addAttribute(
                    TriggeringCondition.communicationOptions,
                    {
                      "whatsappConsent": checkwhatsapp,
                      "smsConsent": checksms,
                      "emailConsent": checkemail,
                    }.toString())
                .setNonInteractiveEvent();
            MoenageManager.logEvent(
              MoenageEvent.communicationPreferences,
              properties: properties,
            );
          },
          tColor: AppColors.whiteColor,
          bColor: AppColors.btnBlueColor,
        ),
      ),
    );
  }
}
