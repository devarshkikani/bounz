import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/models/outlet/outlet_detail_model.dart'
    as offer;
import 'package:bounz_revamp_app/models/partner/new_partner_detail_model.dart';
import 'package:bounz_revamp_app/modules/partners/partners_web_view_screen.dart';
// ignore_for_file: library_prefixes

@RoutePage<Map<String, dynamic>?>()
class VisitWebsiteScreen extends StatefulWidget {
  final NewPartnerDetailModel? brandData;
  final AllBranchLobType? listData;
  final int? index;
  final Type? type;
  final String? emiratesUrl;
  final offer.Offer? selectedOffer;
  final bool? isExternalBrowser;
  final String title;
  const VisitWebsiteScreen({
    Key? key,
    this.brandData,
    this.listData,
    this.isExternalBrowser,
    this.index,
    this.type,
    this.selectedOffer,
    this.emiratesUrl,
    required this.title,
  }) : super(key: key);

  @override
  State<VisitWebsiteScreen> createState() => _VisitWebsiteScreenState();
}

class _VisitWebsiteScreenState extends State<VisitWebsiteScreen> {
  Future<void> affiliateAPicall(BuildContext context) async {
    var reqbody = {
      "partner_id": widget.brandData?.partnerId,
      "customer_id": GlobalSingleton.userInformation.membershipNo != null
          ? GlobalSingleton.userInformation.membershipNo.toString()
          : ""
    };
    Map<String, dynamic>? response = await NetworkDio.postCheckUpdateNetworkDio(
      url: ApiPath.affiliate,
      context: context,
      data: reqbody,
    );
    if (response != null) {
      if (response['status'] == true) {
        if (response['data']["values"]["partner_url"] != null) {
          String? partnerUrl = response['data']["values"]["partner_url"];
          if (partnerUrl != null) {
            if (widget.isExternalBrowser.toString().toLowerCase() == "true") {
              if (await canLaunchUrl(Uri.parse(partnerUrl.toString()))) {
                launchUrl(
                  Uri.parse(partnerUrl.toString()),
                  mode: LaunchMode.externalApplication,
                );
              }
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (contex) => Webview(
                    checkURL: partnerUrl,
                    type: 'partnerurl',
                  ),
                ),
              );
            }
          }
        } else {
          SnackBar(
            content: Text(response['message']),
            backgroundColor: AppColors.blueColor,
          );
        }
      } else {
        SnackBar(
          content: Text(response['message']),
          backgroundColor: AppColors.blueColor,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.backgroundColor,
        child: AppBackGroundWidget(
          child: Container(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height - kToolbarHeight - 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        color: AppColors.whiteColor,
                      ),
                    ),
                    const SizedBox(
                      height: AppSizes.size20,
                    ),
                    Text(
                      widget.title,
                      style: AppTextStyle.regular36.copyWith(
                        fontFamily: "Bebas",
                      ),
                    ),
                    Html(
                      data: widget.selectedOffer == null
                          ? widget.listData?.termsConditions ?? ''
                          : widget.selectedOffer?.offerTermsCon,
                    ),
                    const SizedBox(
                      height: AppSizes.size10,
                    ),
                  ],
                ),
                bottomView(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget bottomView() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.40,
      padding: const EdgeInsets.only(bottom: AppSizes.size30),
      alignment: Alignment.bottomCenter,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppAssets.clickToVisit),
          alignment: Alignment.bottomCenter,
          fit: BoxFit.contain,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          PrimaryButton(
            height: MediaQuery.of(context).size.height * 0.065,
            text: AppConstString.visitWebsite,
            onTap: () async {
              if (widget.type == Type.afl) {
                affiliateAPicall(context);
              } else if (widget.selectedOffer == null) {
                if (widget.emiratesUrl != null) {
                  emiratesDraw();
                } else if (widget.type == Type.spdon ||
                    widget.type == Type.rdmon) {
                  launchUrl(
                    Uri.parse(widget.listData?.url ?? ""),
                    mode: LaunchMode.externalApplication,
                  );
                } else {
                  MoenageManager.logScreenEvent(name: 'Web View');
                  Map<String, dynamic>? data =
                      await AutoRouter.of(context).push<Map<String, dynamic>?>(
                    WebviewRoute(
                      checkURL: widget.listData?.url ?? "",
                      type: "click",
                      points: '100',
                      merchantCode: widget.brandData?.merchantCode,
                      ouutletid: widget.brandData?.outletIds?[0] != null
                          ? widget.brandData?.outletIds![0].toString()
                          : null,
                    ),
                  );

                  if (data != null) {
                    if (data["status"] == true) {
                      Map<String, dynamic>? dataPass = {
                        "status": true,
                        "earndata": data["earndata"]
                      };
                      Navigator.pop(context, dataPass);
                    } else {
                      Map<String, dynamic> dataPass = data;
                      Navigator.pop(context, dataPass);
                    }
                  } else {
                    var dataPass = data;
                    Navigator.pop(context, dataPass);
                  }
                }
              } else {
                launchUrl(
                  Uri.parse(widget.selectedOffer?.url ?? ""),
                  mode: LaunchMode.externalApplication,
                );
              }
            },
          ),
          const SizedBox(
            height: AppSizes.size8,
          ),
          Text(
            '*Terms And Conditions Apply',
            style: AppTextStyle.bold14,
          ),
        ],
      ),
    );
  }

  Future emiratesDraw() async {
    if (GlobalSingleton.osType == 'android') {
      FlutterWebBrowser.openWebPage(
        url: widget.emiratesUrl.toString(),
        customTabsOptions: const CustomTabsOptions(
          colorScheme: CustomTabsColorScheme.light,
          darkColorSchemeParams: CustomTabsColorSchemeParams(
            navigationBarDividerColor: Colors.cyan,
          ),
          shareState: CustomTabsShareState.on,
          instantAppsEnabled: true,
          showTitle: true,
          urlBarHidingEnabled: true,
        ),
      );
    } else {
      FlutterWebBrowser.openWebPage(
        url: widget.emiratesUrl.toString(),
        safariVCOptions: const SafariViewControllerOptions(
          barCollapsingEnabled: true,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
          modalPresentationCapturesStatusBarAppearance: true,
          modalPresentationStyle: UIModalPresentationStyle.popover,
        ),
      );
    }
  }

  void visitWebsiteButton() async {
    MoenageManager.logScreenEvent(name: 'Web View');
    Map<String, dynamic>? data =
        await AutoRouter.of(context).push<Map<String, dynamic>?>(
      WebviewRoute(
        checkURL: widget.listData?.url ?? "",
        type: "click",
        points: '100',
        //points: widget.brandData.rewards_website,
        merchantCode: widget.brandData?.merchantCode,
        ouutletid: widget.brandData?.outletIds?[0] != null
            ? widget.brandData?.outletIds![0].toString()
            : null,
      ),
    );

    if (data != null) {
      if (data["status"] == true) {
        Map<String, dynamic>? dataPass = {
          "status": true,
          "earndata": data["earndata"]
        };
        Navigator.pop(context, dataPass);
      } else {
        Map<String, dynamic> dataPass = data;
        Navigator.pop(context, dataPass);
      }
    } else {
      var dataPass = data;
      Navigator.pop(context, dataPass);
    }
  }
}
