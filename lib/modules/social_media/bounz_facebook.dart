import 'package:bounz_revamp_app/utils/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/constants/url_const.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';

@RoutePage()
class BounzFacebook extends StatefulWidget {
  const BounzFacebook({Key? key}) : super(key: key);

  @override
  State<BounzFacebook> createState() => _BounzFacebookState();
}

class _BounzFacebookState extends State<BounzFacebook> {
  final bool _isLoading = true;

  WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://')) {
              return NavigationDecision.navigate;
            } else {
              return NavigationDecision.prevent;
            }
          }),
    )
    ..loadRequest(
      Uri.parse(
        AppUrl.bounzFacebook,
      ),
    );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: AppBackGroundWidget(
        padding: EdgeInsets.zero,
        child: Stack(
          children: [
            Container(
              color: AppColors.whiteColor,
            ),
            if (_isLoading)
              const Center(
                child: ProcessIndicator(),
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(
                        left: AppSizes.size20, top: AppSizes.size20),
                    child: Icon(
                      Icons.arrow_back,
                      color: AppColors.blackColor,
                    ),
                  ),
                ),
                const SizedBox(
                  height: AppSizes.size20,
                ),
                Expanded(
                  child: WebViewWidget(
                    controller: controller,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
