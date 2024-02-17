import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/constants/url_const.dart';
import 'package:bounz_revamp_app/utils/progress_indicator.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../config/manager/moenage_manager.dart';
import '../../config/routes/router_import.gr.dart';

@RoutePage()
class PrivacyPolicy extends StatefulWidget {
  final bool fromSplash;
  const PrivacyPolicy({
    @PathParam('fromSplash') this.fromSplash = false,
    Key? key,
  }) : super(key: key);

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
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
      ),
    )
    ..loadRequest(
      Uri.parse(AppUrl.bounzPrivacyPolicy),
    );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.fromSplash) {
          MoenageManager.logScreenEvent(name: 'Main Home');
          AutoRouter.of(context).pushAndPopUntil(
              MainHomeScreenRoute(isFirstLoad: true, index: 4),
              predicate: (_) => false);
        } else {
          AutoRouter.of(context).canPop();
        }
        return true;
      },
      child: Scaffold(
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
      ),
    );
  }
}
