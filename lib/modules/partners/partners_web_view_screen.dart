import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/annotations.dart';
import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
// ignore_for_file: prefer_typing_uninitialized_variables

@RoutePage<Map<String, dynamic>?>()
class Webview extends StatefulWidget {
  static String tag = 'routeproduct-page';
  final String checkURL;
  final String? merchantCode;
  final String? ouutletid;
  final String? points;
  final String? finalURL;
  final String? outletkey;
  final String? type;
  final String? partnerid;
  const Webview(
      {Key? key,
      required this.checkURL,
      this.merchantCode,
      this.ouutletid,
      this.points,
      this.outletkey,
      this.type,
      this.partnerid,
      this.finalURL})
      : super(key: key);

  @override
  _WebviewState createState() => _WebviewState();
}

class _WebviewState extends State<Webview> with TickerProviderStateMixin {
  String? url;
  var dataPass;
  WebViewController? controller;
  int progress = 0;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..enableZoom(false)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            this.progress = progress;
            if (mounted) setState(() {});
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            if (widget.merchantCode != null &&
                widget.ouutletid != null &&
                widget.points != null) {
              if (mounted) {
                _earnApicall(context);
              }
            }
          },
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(
        Uri.parse(widget.checkURL),
      );
  }

  Future<void> _earnApicall(BuildContext context) async {
    if (widget.type != "myaccount") {
      Map _reqbody = {
        "membership_no": GlobalSingleton.userInformation.membershipNo,
        "merchant_code": widget.merchantCode ?? "",
        "outlet_id": widget.ouutletid ?? "",
        "type": widget.type ?? "",
        "lat": GlobalSingleton.currentPosition?.latitude,
        "long": GlobalSingleton.currentPosition?.longitude
      };

      Map<String, dynamic>? response = await NetworkDio.postPartnerNetworkDio(
        url: ApiPath.earn,
        context: context,
        data: _reqbody,
      );
      if (response!["status"] == true) {
        dataPass = {"status": true, "earndata": response["data"]["values"]};
      } else {
        dataPass = {
          "status": false,
          "message": response["message"],
          "earndata": {}
        };
      }
    }
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _WebviewState();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.type == "partnerurl") {
          Navigator.pop(context);
          Navigator.pop(context);
        } else if (widget.type == "myaccount" ||
            widget.type == "trendingoffer" ||
            widget.type == "explore") {
          Navigator.pop(context);
        } else {
          Navigator.pop(context, dataPass);
        }
        return true;
      },
      child: Container(
        color: AppColors.backgroundColor,
        child: Scaffold(
          body: AppBackGroundWidget(
            padding: EdgeInsets.zero,
            child: Stack(
              children: [
                Container(
                  color: AppColors.whiteColor,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (widget.type == "partnerurl") {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        } else if (widget.type == "myaccount" ||
                            widget.type == "trendingoffer" ||
                            widget.type == "explore") {
                          Navigator.pop(context);
                        } else {
                          Navigator.pop(context, dataPass);
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(
                          left: AppSizes.size20,
                          top: AppSizes.size20,
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          color: AppColors.blackColor,
                        ),
                      ),
                    ),
                    Expanded(
                      child: WebViewWidget(
                        controller: controller!,
                      ),
                    ),
                  ],
                ),
                if (progress < 100)
                  const Center(
                    child: CupertinoActivityIndicator(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
