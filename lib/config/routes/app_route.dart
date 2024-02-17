part of 'router_import.dart';

@AutoRouterConfig(replaceInRouteName: 'Route')
class AppRouter extends $AppRouter {
  @override
  RouteType get defaultRouteType => const RouteType.adaptive();
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: SplashScreenRoute.page,
          path: '/',
          initial: true,
        ),
        AutoRoute(
          page: WelcomeScreenRoute.page,
          path: '/welcome_screen/:fromSplash',
        ),
        AutoRoute(
          page: LoginRegistrationScreenRoute.page,
          path: '/login_registration_screen',
        ),
        AutoRoute(
          page: DeletedAccountScreenRoute.page,
          path: '/deleted_account_screen',
        ),
        AutoRoute(
          page: OtpVerificationOnboardingRoute.page,
          path: '/otp_verification_onboarding',
        ),
        AutoRoute(
          page: ReffralBounsScreenRoute.page,
          path: '/reffral_bouns_screen',
        ),
        AutoRoute(
          page: ProfileCreatedScreenRoute.page,
          path: '/profile_created_screen',
        ),
        AutoRoute(
          page: UserRegistrationScreenRoute.page,
          path: '/user_registration_screen',
        ),
        AutoRoute(
          page: MyInterestPreferencesUpdatedScreenRoute.page,
          path: '/my_interest_preferences_updated_screen',
        ),
        AutoRoute(
          page: SpinTheWheelScreenRoute.page,
          path: '/spin_the_wheel_screen/:apiKey/:apiValue/:isFromSplash',
        ),
        AutoRoute(
          page: ExchangeHistoryScreenRoute.page,
          path: '/exchange_history_screen',
        ),
        AutoRoute(
          page: RegistrationCompleteScreenRoute.page,
          path: '/registration_complete_screen',
        ),
        AutoRoute(
          page: MainHomeScreenRoute.page,
          path: '/main_home_screen/:index/:isFirstLoad',
        ),
        AutoRoute(
          page: SelectInterestScreenRoute.page,
          path: '/select_interest_screen',
        ),
        AutoRoute(
          page: MyInterestScreenRoute.page,
          path: '/my_interest_screen/:fromSplash',
        ),
        AutoRoute(
            page: AddNewPreferencesScreenRoute.page,
            path: '/add_new_preferences_screen/:fromSplash'),
        AutoRoute(
          page: NotificationScreenRoute.page,
          path: '/notification_screen/:fromSplash',
        ),
        AutoRoute(
          page: RewardExchangeScreenRoute.page,
          path: '/reward_exchange_screen/:fromSplash',
        ),
        AutoRoute(
          path: '/offer_detail_screen/:offerCode/:fromSplash',
          page: OfferDetailScreenRoute.page,
        ),
        AutoRoute(
          page: BuyGiftCardsScreenRoute.page,
          path: '/buy_giftcards_screen/:fromSplash',
        ),
        AutoRoute(
          path: '/partner_details_screen/:merchantCode/:brandCode/:fromSplash',
          page: PartnerDetailsScreenRoute.page,
        ),
        AutoRoute(
          page: PayBillDetailScreenRoute.page,
          path: '/pay_bill_screen/:serviceId/:serviceName/:fromSplash',
        ),
        AutoRoute(
          page: RssFeedDemoRoute.page,
          path: '/rss_feed_demo/:urlLink/:titleName/:fromSplash',
        ),
        AutoRoute(
          page: ShopAndEarnScreenRoute.page,
          path: '/shop_and_earn_screen/:fromSplash',
        ),
        AutoRoute(
          page: ReferEarnScreenRoute.page,
          path: '/refer_earn_screen/:fromSplash',
        ),
        AutoRoute(
          page: BranchesScreenRoute.page,
          path: '/branches_screen',
        ),
        AutoRoute(
          page: PartnerPhotosScreenRoute.page,
          path: '/partner_photos_screen',
        ),
        AutoRoute(
          page: VisitWebsiteScreenRoute.page,
          path: '/visit_website_screen',
        ),
        AutoRoute(
          page: EarnBounzWithOtpScreenRoute.page,
          path: '/earn_bounz_withotp_screen',
        ),
        AutoRoute(
          page: RedeemBounzScreenRoute.page,
          path: '/redeem_bounz_screen',
        ),
        AutoRoute(
          page: EarnBounzScreenRoute.page,
          path: '/earn_bounz_screen',
        ),
        AutoRoute(
          page: RedeemedOfferScreenRoute.page,
          path: '/redeemed_offer_screen',
        ),
        AutoRoute(
          page: RedeemedOfferDetailsScreenRoute.page,
          path: '/redeemed_offer_details_screen',
        ),
        AutoRoute(
          page: CountriesListScreenRoute.page,
          path: '/countries_list_screen',
        ),
        AutoRoute(
          page: LocationPermissionScreenRoute.page,
          path: '/location_permission_screen',
        ),
        AutoRoute(
          page: PaymentFailedScreenRoute.page,
          path: '/payment_failed_screen',
        ),
        AutoRoute(
          page: MobileRechargeOneScreenRoute.page,
          path: '/mobile_recharge_one_screen',
        ),
        AutoRoute(
          page: OperatorListScreenRoute.page,
          path: '/operator_list_screen',
        ),
        AutoRoute(
          page: BillsScreenRoute.page,
          path: '/bills_screen',
        ),
        AutoRoute(
          page: AdvancePaymentScreenRoute.page,
          path: '/advance_payment_screen',
        ),
        AutoRoute(
          page: PaymentSuccessfulRoute.page,
          path: '/payment_successful',
        ),
        AutoRoute(
          page: AddDetailsScreenRoute.page,
          path: '/add_details_screen',
        ),
        AutoRoute(
          page: RewardClaimedScreenRoute.page,
          path: '/reward_claimed_screen',
        ),
        AutoRoute(
          page: CheckoutScreenRoute.page,
          path: '/checkout_screen',
        ),
        AutoRoute(
          page: PaymentDetailsScreenRoute.page,
          path: '/payment_details_screen',
        ),
        AutoRoute(
          page: FeedbackScreenRoute.page,
          path: '/feedback_screen/:fromSplash',
        ),
        AutoRoute(
          page: MyBounzScreenRoute.page,
          path: '/my_bounz_screen/:fromSplash',
        ),
        AutoRoute(
          page: VoucherDetailsScreenRoute.page,
          path: '/voucher_details_screen',
        ),
        AutoRoute(
          page: PrivacyPolicyRoute.page,
          path: '/privacy_policy/:fromSplash',
        ),
        AutoRoute(
          page: MyPurchasesScreenRoute.page,
          path: '/my_purchases_screen/:fromSplash',
        ),
        AutoRoute(
          page: HelpSupportScreenRoute.page,
          path: '/help_support_screen/:fromSplash',
        ),
        AutoRoute(
          page: ReceiptsListScreenRoute.page,
          path: '/receipts_list_screen/:fromSplash',
        ),
        AutoRoute(
          page: ClaimRewardsScreenRoute.page,
          path: '/claim_rewards_screen/:fromSplash',
        ),
        AutoRoute(
          page: TermsConditionsRoute.page,
          path: '/terms_conditions/:fromSplash',
        ),
        AutoRoute(
          page: ReceiptViewScreenRoute.page,
          path: '/receipt_view_screen',
        ),
        AutoRoute(
          page: GiftCardDetailsScreenRoute.page,
          path: '/giftcard_details_screen',
        ),
        AutoRoute(
            page: PurchasedHistoryScreenRoute.page,
            path: '/purchased_history_screen/:fromSplash'),
        AutoRoute(
          page: VoucherDetailsRoute.page,
          path: '/voucher_details',
        ),
        AutoRoute(
          page: PartnersImagePreviewRoute.page,
          path: '/partners_image_preview',
        ),
        AutoRoute(
          page: ShopEarnDetailScreenRoute.page,
          path: '/shop_earn_detail_screen',
        ),
        AutoRoute(
          page: UserFarFromStoreScreenRoute.page,
          path: '/user_far_from_store_screen',
        ),
        AutoRoute(
          page: UserGoingStoreScreenRoute.page,
          path: '/user_going_store_screen',
        ),
        AutoRoute(
          page: BounzAlreadyEarnedRoute.page,
          path: '/bounz_already_earned',
        ),
        AutoRoute(page: FaqRoute.page, path: '/faq/:fromSplash'),
        AutoRoute(
          page: ThankYouScreenRoute.page,
          path: '/thank_you_screen',
        ),
        AutoRoute(
          page: BounzReceivedScreenRoute.page,
          path: '/bounz_received_screen',
        ),
        AutoRoute(
          page: RewardReceivedScreenRoute.page,
          path: '/reward_received_screen',
        ),
        AutoRoute(
          page: NoResultFoundScreenRoute.page,
          path: '/no_result_found_screen',
        ),
        AutoRoute(
          page: NoInternetScreenRoute.page,
          path: '/no_internet_screen',
        ),
        AutoRoute(
          page: SelectProductScreenRoute.page,
          path: '/select_product_screen',
        ),
        AutoRoute(
          page: PaymentWebviewScreenRoute.page,
          path: '/payment_webview_screen',
        ),
        AutoRoute(
          page: SelectCommunicationPreferenceScreenRoute.page,
          path: '/select_communication_preference_screen/:fromSplash',
        ),
        AutoRoute(
          page: SavedCommunicationPreferenceScreenRoute.page,
          path: '/saved_communication_preference_screen',
        ),
        AutoRoute(
          page: MyTravelScreenRoute.page,
          path: '/my_travel_screen/:fromSplash',
        ),
        AutoRoute(
          page: MyProfileScreenRoute.page,
          path: '/my_profile_screen/:fromSplash',
        ),
        AutoRoute(
          page: WebviewRoute.page,
          path: '/webview',
        ),
        AutoRoute(
          page: StoreRedeemSuccessScreenRoute.page,
          path: '/store_redeem_success_screen',
        ),
        AutoRoute(
          page: ForceUpdateScreenRoute.page,
          path: '/force_update_screen/:canSkip/:fromSplash_bus',
        ),
        AutoRoute(
          page: NoDataFoundScreenRoute.page,
          path: '/no_data_found_screen',
        ),
        AutoRoute(
          page: ExternalLinkScreenRoute.page,
          path: '/external_link_screen/:fromSplash',
        ),
        AutoRoute(
          page: InfoRewardExchangeScreenRoute.page,
          path: '/info_reward_exchange_screen/:fromSplash',
        ),
        AutoRoute(
          page: RewardsExSelectionScreenRoute.page,
          path: '/reward_ex_exchange_screen',
        ),
        AutoRoute(
          page: SmilesToBounzScreenRoute.page,
          path: '/smile_to_bounz',
        ),
        AutoRoute(
          page: BounzToSmilesScreenRoute.page,
          path: '/bounz_to_smile',
        ),
        AutoRoute(
            page: VoucherWonHistoryScreenRoute.page,
            path: '/voucher_won_history_screen/:fromSplash'),
        AutoRoute(
          page: VoucherGotScreenRoute.page,
          path: '/voucher_got_screen/:fromSplash',
        ),
      ];
}
