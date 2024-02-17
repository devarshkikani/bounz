import 'package:bounz_revamp_app/constants/enum.dart';

class BounzEnvironment {
  BounzEnvironment(this.environmentType);
  final EnvironmentType environmentType;

  EnvironmentVariables setupEnvironmentVariables() {
    switch (environmentType) {
      case EnvironmentType.development:
        return EnvironmentVariables(
          isProd: false,
          appVersion: '20.68',
          moengageAppID: '668EZ1ENJ3R8N6YSZNAGIQP0',
          cmsBaseUrl: 'https://apisandbox.clubclass.io/target/UATCMS',
          forceUpdateURL: 'https://tyapiuat.bounz.io/rest/',
          sslCheckURL: "https://commapiuat.bounz.io",
          postBackURL: 'https://wearables.bounzrewards.com/spike/',
          // postBackURL: 'https://wearablesuat.bounzrewards.com/spike/',
          authorizationToken:
              'Basic Qy1TOExTOHU6N2QxYTQ0ZTBkNmI5OGZhNWQ3ZjRhNjUzYmFhMGJkYjAxYTE3MTdlNg==',
          cmsAPIToken:
              '214125442A472D4B6150645267556B58703273357638792F423F4528482B4D6251655468566D597133743677397A24432646294A404E635266556A586E5A7234',
          baseUrl:
              'https://apisandbox.clubclass.io/server/development/UATCC2MobileAppV3/',
          giftCardEndPoint:
              'https://apisandbox.clubclass.io/target/YGAGUAT/apiV2/client/',
          dtOneEndPoint:
              'https://apisandbox.clubclass.io/target/DtOneUAT/rest/',
          travelPurchaseEndPoint:
              'https://apisandbox.clubclass.io/target/ETsandbox/api/sso/',
          offersPartnersEndPoint:
              'https://apisandbox.clubclass.io/server/development/UATCPTYHO/rest/',
        );
      case EnvironmentType.production:
        return EnvironmentVariables(
          isProd: true,
          appVersion: '6.0.5',
          moengageAppID: '668EZ1ENJ3R8N6YSZNAGIQP0',
          cmsBaseUrl: 'https://simplikaapi.bounzrewards.com/target/PRODCMS',
          forceUpdateURL: 'https://tyapi.bounzrewards.com/rest/',
          sslCheckURL: "https://commapi.bounzrewards.com/",
          postBackURL: 'https://wearables.bounzrewards.com/spike/',
          authorizationToken:
              'Basic Qy1qeTFUYTM6Y2FhYTIzMjMwYjJmNDVkZDEzYzRkZTQyYmZkNjkzNjRlZThkYzkzZQ==',
          cmsAPIToken:
              '1a232496130a54bcd4e003e1d716ac97\$d98e27775022ed5b197b17bcc3fb5952b130bf9da94e1ea573897d50c272ad95ff84b05e8d48174cdd1038faff9cca4fca8cd5eb23894b82e4127a900c629c2cf7961b2e683d3da6cde3bf79fc8e972bd12366cae37bee02fabdaab97a94d4e6b3f909c7ca3c7e0610c3fb8c0fc6c9315d86a73f322a442cdcfcfb3bc3a38035c0691f05f6b61758304e5647b74c9ec5ac94ca96b93aad9f79e4af99444ba6318bdc201ffd7d42428aac616a11a88d6afd0b070338498550e3ad75952a5655786a1e7691aa8437bf3d1ac223416535fbd366ca88f43f67ee531f077ae7e2d09b',
          baseUrl:
              'https://simplikaapi.bounzrewards.com/server/development/PRODCC2MobileAppV3/',
          giftCardEndPoint:
              'https://simplikaapi.bounzrewards.com/target/YGAGPROD/apiV2/client/',
          dtOneEndPoint:
              'https://simplikaapi.bounzrewards.com/target/DtOnePROD/rest/',
          travelPurchaseEndPoint:
              'https://simplikaapi.bounzrewards.com/target/ETSSOPROD/api/sso/',
          offersPartnersEndPoint:
              'https://simplikaapi.bounzrewards.com/server/development/PRODCPTYHO/rest/',
        );
    }
  }
}

class EnvironmentVariables {
  final String appVersion;
  final String authorizationToken;
  final String giftCardEndPoint;
  final String forceUpdateURL;
  final String cmsAPIToken;
  final String cmsBaseUrl;
  final String baseUrl;
  final String dtOneEndPoint;
  final String travelPurchaseEndPoint;
  final String moengageAppID;
  final String offersPartnersEndPoint;
  final bool isProd;
  final String sslCheckURL;
  final String postBackURL;

  EnvironmentVariables({
    required this.appVersion,
    required this.authorizationToken,
    required this.giftCardEndPoint,
    required this.forceUpdateURL,
    required this.cmsAPIToken,
    required this.cmsBaseUrl,
    required this.baseUrl,
    required this.moengageAppID,
    required this.dtOneEndPoint,
    required this.travelPurchaseEndPoint,
    required this.offersPartnersEndPoint,
    required this.isProd,
    required this.sslCheckURL,
    required this.postBackURL,
  });
}
