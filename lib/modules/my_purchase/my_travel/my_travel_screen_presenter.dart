import 'package:bounz_revamp_app/modules/my_purchase/my_travel/my_travel_screen_model.dart';
import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'my_travel_screen_view.dart';

class MyTravelPresenter {
  void generateBookingLinkForTravelP({
    required BuildContext context,
    required Map<String, dynamic> data,
    required String apiPath,
  }) {}
  set updateView(MyTravelScreenView myTravelScreenView) {}
}

class BasicMyTravelPresenter extends MyTravelPresenter {
  late MyTravelScreenModel model;
  late MyTravelScreenView view;
  BasicMyTravelPresenter() {
    view = MyTravelScreenView();
    model = MyTravelScreenModel(
      isLoading: true,
    );
  }
  @override
  void generateBookingLinkForTravelP({
    required BuildContext context,
    required Map<String, dynamic> data,
    required String apiPath,
  }) async {
    String? response = await NetworkDio.postDioHttpMethodSSOStr(
        context: context,
        url: ApiPath.travelPurchaseEndPoint + apiPath,
        data: data);
    if (response != null) {
      generateBookingLink(response);
    }
    //generateBookingLink('https://bounz.elevatetrips.com/'); //NOTE: UNCOMMENT THIS CODE IF WANT TO SET DIRECT LINK -- HIMANI
  }

  void generateBookingLink(String link) {
    model.controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..enableZoom(false)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            model.isLoading = false;
          },
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(
        Uri.parse(link),
      );
    view.refreshModel(model);
  }

  @override
  set updateView(MyTravelScreenView myTravelScreenView) {
    view = myTravelScreenView;
    view.refreshModel(model);
  }
}
