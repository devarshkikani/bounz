import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RssFeedWebView extends StatefulWidget {
  final String urlLink;
 const RssFeedWebView({required this.urlLink,super.key});

  @override
  State<RssFeedWebView> createState() => _RssFeedWebViewState();
}

class _RssFeedWebViewState extends State<RssFeedWebView> {
  WebViewController? controller;
  int progress = 0;
  @override
  void initState() {
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
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(
        Uri.parse(widget.urlLink),
      );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                      Navigator.pop(context);
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
                  const SizedBox(height: AppSizes.size10),
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
    );
  }
}
