import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/constants/environment.dart';

class ApiPath {
  static late String apiEndPoint;
  static late String giftCardEndPoint;
  static late String cmsEndPoint;
  static late String imageEndPoint;
  static late String apiTokenPoint;
  static late String dtOneEndPoint;
  static late String travelPurchaseEndPoint;
  static late String authCredData;
  static late String uatEndPoint;
  static late String offersPartnersEndPoint;
  static late String forceUpdateURL;

  static void setupAppBaseUrls(EnvironmentVariables urls) {
    apiEndPoint = urls.baseUrl;
    cmsEndPoint = urls.cmsBaseUrl;
    apiTokenPoint = urls.cmsAPIToken;
    giftCardEndPoint = urls.giftCardEndPoint;
    dtOneEndPoint = urls.dtOneEndPoint;
    travelPurchaseEndPoint = urls.travelPurchaseEndPoint;
    forceUpdateURL = urls.forceUpdateURL;
    // checkForUpdatedEndPoint = urls.checkForUpdateBaseUrl;
    // redeemOfferEndPoint = urls.redeemOfferBaseUrl;
    uatEndPoint = urls.offersPartnersEndPoint;
    offersPartnersEndPoint = urls.offersPartnersEndPoint;
    GlobalSingleton.sslCheckURL = urls.sslCheckURL;
  }

  static const String tpApplicationKey = '9d04cea4-af10-472b-80f0-7f2c4b9584ed';

  static const String apiKey = 'e57c65e7-e64b-4c7a-bb51-1299ba9c9312';

  //listing
  static const String country = 'listing/country';
  static const String interest = 'listing/v3/interest';
  static const String city = 'listing/city';
  static const String employmentType = 'listing/employment_type';

  static const String verifyOTP = 'otp/v3/verifyOTP';
  static const String verifyPhone = 'member/verifyPhone';
  static const String verifyEmail = 'member/verifyEmail';
  static const String resendOTP = 'otp/v3/resendOTP';
  static const String generateOTP = 'otp/v3/generate_otp';
  static const String getDashBoard = '/api/sdk/v1/screen/detail';
  static const String createUser = 'member/v3/createUser';
  static const String updateUserProfile = 'member/updateUserProfile';
  static const String getProfile = 'member/v3/getProfile?';
  static const String generateOtp = 'member/generate_pos_otp';

  //Pay bills
  static const String countrylist = 'V4/users/countryList';
  static const String servicelist = 'V4/users/serviceList';
  static const String operatorlist = 'V4/users/operatorList';
  static const String productList = 'V4/users/productList';
  static const String createTransaction = 'V4/users/createTransaction';
  static const String payBillTransaction = 'V4/users/myTransaction';
  static const String updatePBTransaction = 'V4/users/updatePgTransaction';
  static const String getstatement = 'V4/users/getstatement';
  static const String calPoint = 'V4/users/calPoint';

  //Spin the wheel
  static const String spinTheWheelDesign = 'point/get_wheel_details';
  static const String spinTheWheel = 'point/spin_wheel';

  //Voucher spin wheel
  static const String partnerCouponSpinTheWheel = 'partnerCoupons/get?';

  //gift
  static const String giftvoucher = 'giftvoucher/list?';
  static const String category = 'category/list?';
  static const String giftVoucherDetails = 'giftvoucher/details?';
  static const String purchaseVoucher = 'transaction/initGVTransaction';
  static const String updateGVTransaction = 'transaction/updatePgTransaction';

  //myTranstion
  static const String myTransactions = 'transaction/myBookings?';

  //travel
  static const String travelPurchase = 'generateBookingLink';

  //communication
  static const String communicationEmailConsent = 'member/emailConsent';
  static const String communicationSmsConsent = 'member/smsConsent';
  static const String communicationWhatsappConsent = 'member/whatsappConsent';
  static const String feedback = 'feedback/submitFeedback';
  static const String deleteUser = 'member/delete_user';
  static const String logoutUser = 'member/updateUserStatus';

  // Digital Receipts
  static const String getPosReceipt = 'listing/get_pos_receipt?';
  static const String getInvoiceDetails = 'point/getInvoiceDetails';
  static const String downloadPDF = 'listing/generate_invoice_pdf';

  //claim rewards
  static const String claimRewards = 'coupons/claim_rewards';
  static const String travelMoreWidBounz = 'generateLink';

  //partner
  static String allPartnerListCat =
      '${offersPartnersEndPoint}V4/users/allPartners';
  static String earn = '${offersPartnersEndPoint}V4/offers/earn';
  static String emiratesDraw = 'service/ED_SSO';
  static String getPartnerDetail =
      '${offersPartnersEndPoint}V4/offers/getBranchesEnc';
  static String affiliate =
      '${offersPartnersEndPoint}V4/users/customer_visit_url';
  static String pinBasedAR =
      '${offersPartnersEndPoint}V4/offers/pinBasedAccRed';
  static String helpSupportEndPoint =
      '${offersPartnersEndPoint}V2/users/customer_care_details';

  //offers
  static String offer = '${offersPartnersEndPoint}V4/offers/offer_search';
  static String offerRedeem = '${offersPartnersEndPoint}V4/offers/offerRedeem';
  static String outletDetail =
      '${offersPartnersEndPoint}V4/offers/outlet_detail';
  static String offerDetail = '${offersPartnersEndPoint}V4/offers/offer_detail';
  static String redeemOfferDetail =
      '${offersPartnersEndPoint}V4/offers/myTransactions';

  // update my interest
  static const String updateUserInfo = 'member/updateUserInfo';

  //my bounz
  static const String myBounzGetTransaction = 'point/v3/getTransactions';
  static const String getExpiryDetails = 'point/getExpiryDetails';

  //login
  static const String socialLogin = 'socialMedia/login';

  //check force update
  static String checkForceUpdate = '${forceUpdateURL}V4/users/checkForceUpdate';

  //smiles
  static const String getAllMembership = 'partner/getAllMembershipsData';
  static const String getLatestPartnerPoints = 'partner/getLatestPartnerPoints';
  static const String linkSmileAccount = 'partner/linkConversionProgramAccount';
  static const String unLinkSmileAccount = 'partner/delinkProgramAccount';
  static const String verifyHashOtp = 'partner/stampOTPHashVerify';
  static const String verifyPostTranOtp = 'partner/verifyPostTransactionOTP';
  static const String postTransactionToBlockchain =
      'partner/postTransactionToBlockchain';
  static const String transactionList =
      'partner/getPointConversionTransactionLists';
}
