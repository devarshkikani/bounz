import 'dart:io';
import 'package:bounz_revamp_app/models/spin_wheel/wheel_details.dart';
import 'package:geolocator/geolocator.dart';
import 'package:bounz_revamp_app/models/city/city_model.dart';
import 'package:bounz_revamp_app/models/offer/offer_model.dart';
import 'package:bounz_revamp_app/models/country/country_model.dart';
import 'package:bounz_revamp_app/models/user/user_information.dart';
import 'package:bounz_revamp_app/models/partner/partner_list_model.dart';
import 'package:bounz_revamp_app/models/employment/employment_model.dart';
import 'package:bounz_revamp_app/models/pay_bills/recent_transaction.dart';
import 'package:bounz_revamp_app/models/help_support/help_and_support.dart';

class GlobalSingleton {
  factory GlobalSingleton() {
    return _instance;
  }

  GlobalSingleton._internal();
  static final GlobalSingleton _instance = GlobalSingleton._internal();

  static String authToken = 'af76f94f-25b1-4344-846c-805713219588';
  static String appId = '60e50f51-a2f1-40f9-97a7-9719855913b8';
  static String moEngageAppId = '668EZ1ENJ3R8N6YSZNAGIQP0';
  static late String postbackURL;
  static String? spikeErrorMessage;
  static String osType = Platform.isAndroid ? 'android' : 'ios';
  static DataWheelDesign? spinData;
  static bool? showBottomSheet;
  static late String appVersion;
  static String? referralno;
  static String? storeCode;
  static String? partnerId;
  static bool? isFromNotification;
  static Position? currentPosition;
  static List<Country>? countryList;
  static Map<String, dynamic>? registerUserInfo;
  static late UserInformation userInformation;
  static List<City>? cityList;
  static List<EmploymentModel>? employmentTypeList;
  static DataList? deepLinkDatalist;
  static OfferModel? deepLinkofferModel;
  static List<RecentTransaction>? transactionList;
  static bool? fromSplash;
  static bool isProd = false;
  static bool isWheelSpined = true;
  static bool appLoaded = false;
  static HelpSupportModel? helpSupportData;
  static String? smilesTempBal;
  static String? bounzNewTempBal;
  static String sslCheckURL = '';
  static bool isBack = false;
  static bool isSpinTheWheelCalled = false;

  static resetValues() {
    referralno = '';
    currentPosition;
    countryList;
    registerUserInfo = {};
    userInformation = UserInformation();
    cityList;
    employmentTypeList;
    deepLinkDatalist;
    deepLinkofferModel;
    isSpinTheWheelCalled = false;
    showBottomSheet = null;
    transactionList = null;
    smilesTempBal = "";
    bounzNewTempBal = "";
  }
}
