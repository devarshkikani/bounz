import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/constants/environment.dart';
import 'package:bounz_revamp_app/constants/triggering_condition.dart';
import 'package:bounz_revamp_app/main.dart';
import 'package:flutter/material.dart';
import 'package:moengage_flutter/model/inapp/click_data.dart';
import 'package:moengage_flutter/model/inapp/inapp_data.dart';
import 'package:moengage_flutter/model/inapp/navigation_action.dart';
import 'package:moengage_flutter/model/push/push_campaign_data.dart';
import 'package:moengage_flutter/moengage_flutter.dart';
import 'package:moengage_flutter/properties.dart';
import 'package:url_launcher/url_launcher.dart';

enum SelfHandledActions { shown, clicked, dismissed }

class MoenageManager {
  factory MoenageManager() {
    return _instance;
  }

  MoenageManager._internal();
  static final MoenageManager _instance = MoenageManager._internal();
  static late MoEngageFlutter moengagePlugin;

  static void initialiseMoenage(EnvironmentVariables urls) {
    moengagePlugin = MoEngageFlutter(urls.moengageAppID);
    moengagePlugin.setPushClickCallbackHandler(_onPushClick);
    moengagePlugin.setInAppDismissedCallbackHandler(_onInAppDismiss);
    moengagePlugin.setInAppClickHandler(_setInAppClickHandler);
    moengagePlugin.initialise();
    moengagePlugin.registerForPushNotification();
    // moengagePlugin.configureLogs(
    //   LogLevel.VERBOSE,
    //   isEnabledForReleaseBuild: true,
    // );
  }

  static void _setInAppClickHandler(ClickData data) async {
    NavigationAction action = data.action as NavigationAction;
    if (action.keyValuePairs.isNotEmpty) {
      if (action.keyValuePairs.containsKey('navigation_page')) {
        appRouter.pushNamed(action.keyValuePairs['navigation_page'] +
            (GlobalSingleton.fromSplash == false ? '/true' : '/false'));
      } else if (action.keyValuePairs.containsKey('navigation_link')) {
        await launchUrl(
          Uri.parse(action.keyValuePairs['navigation_link']),
          mode: LaunchMode.externalApplication,
        );
      }
    }
  }

  static void logEvent(
    MoenageEvent event, {
    MoEProperties? properties,
  }) {
    moengagePlugin.trackEvent(event.name, properties);
  }

  static void logScreenEvent({required String name}) {
    MoEProperties moEProperties = MoEProperties();
    moEProperties
        .addAttribute(TriggeringCondition.screenName, name)
        .setNonInteractiveEvent();
    moengagePlugin.trackEvent(MoenageEvent.screenView.name, moEProperties);
  }

  static void _onPushClick(PushCampaignData message) async {
    GlobalSingleton.isFromNotification = true;
    bool fromSplash = GlobalSingleton.fromSplash ?? false;
    //IOS
    if (message.platform.name == 'iOS') {
      appRouter.pushNamed(message.data.payload['app_extra']['moe_deeplink'] +
          (fromSplash == false ? '/true' : '/false'));
    } else {
      //Android
      appRouter.pushNamed(message.data.payload['gcm_webUrl'] +
          (fromSplash == false ? '/true' : '/false'));
    }
  }

  static void _onInAppDismiss(InAppData message) {}

  Future asyncSelfHandledDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Choose action'),
            children: [
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, SelfHandledActions.shown);
                },
                child: const Text('Shown'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, SelfHandledActions.clicked);
                },
                child: const Text('Clicked'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.of(context).pushNamed('/referandearnscreen');
                  Navigator.pop(context, SelfHandledActions.dismissed);
                },
                child: const Text('Dismissed'),
              ),
            ],
          );
        });
  }
}

enum MoenageEvent {
  screenView,
  register,
  homeScreenClick,
  screenClick,
  login,
  mobileNumberOtpVerification,
  emailVerification,
  locationSelected,
  userDetails,
  interestsSelected,
  myprofileUpdate,
  addNewPreferences,
  interestsViewed,
  spinTheWheel,
  earnedBounz,
  linkAccountButtonClick,
  rewardsExchange,
  offersSelected,
  offerCta,
  paybills,
  billInfo,
  checkout,
  purchase,
  paymentFailed,
  openNotification,
  clearNotification,
  subscribeToNotification,
  deleteNotification,
  filterApplied,
  exchangeHistory,
  giftcardSelect,
  voucherDetail,
  voucherExpired,
  receiptsSelected,
  receiptsDownload,
  rewardsClaimed,
  giftOptionSelected,
  pinCollectBounz,
  contactSupport,
  helpSupport,
  redeemBounz,
  referralShared,
  communicationPreferences,
  rateUs,
  connectSocially,
  search,
  searchFailed,
  noInternet,
  noOffers,
  affiliateSelected,
  deleteAccount,
  componentType,
  forceUpdate,
  forceSkip,
  delinkAccount,
  initaltePointsExchange,
  confirmExchange,
  exchangeOtpSubmit,
}

extension MoenageEventName on MoenageEvent {
  String get name {
    switch (this) {
      case MoenageEvent.screenView:
        return 'screen_view';
      case MoenageEvent.register:
        return 'register';
      case MoenageEvent.homeScreenClick:
        return 'home_screen_click';
      case MoenageEvent.screenClick:
        return 'screen_click';
      case MoenageEvent.login:
        return 'login';
      case MoenageEvent.mobileNumberOtpVerification:
        return 'mobile_number_otp_verification';
      case MoenageEvent.emailVerification:
        return 'email_verification';
      case MoenageEvent.locationSelected:
        return 'location_selected';
      case MoenageEvent.userDetails:
        return 'user_details';
      case MoenageEvent.interestsSelected:
        return 'interests_selected';
      case MoenageEvent.myprofileUpdate:
        return 'myprofile_update';
      case MoenageEvent.addNewPreferences:
        return 'add_new_preferences';
      case MoenageEvent.interestsViewed:
        return 'interests_viewed';
      case MoenageEvent.spinTheWheel:
        return 'spin_the_wheel';
      case MoenageEvent.earnedBounz:
        return 'earned_bounz';
      case MoenageEvent.linkAccountButtonClick:
        return 'link_account_button_click';
      case MoenageEvent.rewardsExchange:
        return 'rewards_exchange';
      case MoenageEvent.offersSelected:
        return 'offers_selected';
      case MoenageEvent.offerCta:
        return 'offer_cta';
      case MoenageEvent.paybills:
        return 'paybills';
      case MoenageEvent.billInfo:
        return 'bill_info';
      case MoenageEvent.checkout:
        return 'checkout';
      case MoenageEvent.purchase:
        return 'purchase';
      case MoenageEvent.paymentFailed:
        return 'payment_failed';
      case MoenageEvent.openNotification:
        return 'open_notification';
      case MoenageEvent.clearNotification:
        return 'clear_notification';
      case MoenageEvent.subscribeToNotification:
        return 'subscribe_to_notification';
      case MoenageEvent.deleteNotification:
        return 'delete_notification';
      case MoenageEvent.filterApplied:
        return 'filter_applied';
      case MoenageEvent.exchangeHistory:
        return 'exchange_history';
      case MoenageEvent.giftcardSelect:
        return 'giftcard_select';
      case MoenageEvent.voucherDetail:
        return 'voucher_detail';
      case MoenageEvent.voucherExpired:
        return 'voucher_expired';
      case MoenageEvent.receiptsSelected:
        return 'receipts_selected';
      case MoenageEvent.receiptsDownload:
        return 'receipts_download';
      case MoenageEvent.rewardsClaimed:
        return 'rewards_claimed';
      case MoenageEvent.giftOptionSelected:
        return 'gift_option_selected';
      case MoenageEvent.pinCollectBounz:
        return 'pin_collect_bounz';
      case MoenageEvent.contactSupport:
        return 'contact_support';
      case MoenageEvent.helpSupport:
        return 'help_support';
      case MoenageEvent.redeemBounz:
        return 'redeem_bounz';
      case MoenageEvent.referralShared:
        return 'referral_shared';
      case MoenageEvent.communicationPreferences:
        return 'communication_preferences';
      case MoenageEvent.rateUs:
        return 'rate_us';
      case MoenageEvent.connectSocially:
        return 'connect_socially';
      case MoenageEvent.search:
        return 'search';
      case MoenageEvent.searchFailed:
        return 'search_failed';
      case MoenageEvent.noInternet:
        return 'no_internet';
      case MoenageEvent.noOffers:
        return 'no_offers';
      case MoenageEvent.affiliateSelected:
        return 'affiliate_selected';
      case MoenageEvent.deleteAccount:
        return 'delete_account';
      case MoenageEvent.componentType:
        return 'component_type';
      case MoenageEvent.forceUpdate:
        return 'force_update';
      case MoenageEvent.forceSkip:
        return 'force_skip';
      case MoenageEvent.delinkAccount:
        return 'delink_account';
      case MoenageEvent.initaltePointsExchange:
        return 'initalte_points_exchange';
      case MoenageEvent.confirmExchange:
        return 'confirm_exchange';
      case MoenageEvent.exchangeOtpSubmit:
        return 'Exchange_otp_submit';
    }
  }
}
