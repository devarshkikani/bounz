import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/constants/url_const.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../config/manager/moenage_manager.dart';
import '../../config/routes/router_import.gr.dart';

@RoutePage()
class Faq extends StatefulWidget {
  final bool fromSplash;
  const Faq({@PathParam('fromSplash') this.fromSplash = false, Key? key})
      : super(key: key);

  @override
  State<Faq> createState() => _FaqState();
}

class _FaqState extends State<Faq> {
  int progress = 0;

  WebViewController? controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              this.progress = progress;
            });
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(
        Uri.parse(AppUrl.bounzFaq),
      );
  }

  @override
  void dispose() {
    _FaqState();
    super.dispose();
  }

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
                  child: WebViewWidget(controller: controller!),
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
    );
  }
}
