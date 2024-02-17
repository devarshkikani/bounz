import 'package:webview_flutter/webview_flutter.dart';

class MyTravelScreenModel {
  WebViewController? controller;
  bool isLoading;
  MyTravelScreenModel({
    required this.isLoading,
    this.controller,
  });
}
