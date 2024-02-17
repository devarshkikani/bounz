import 'dart:ui';
import 'package:bounz_revamp_app/models/dashboard/dashboard_model.dart';

class MainHomeModel {
  DashBoardModel? dashBoardModel;
  List<Footer>? footer;
  Color footerBgColor;
  Color footerTextColor;
  Color footerHoverColor;
  Color footerHoverBgColor;
  bool? isWheelSpined;

  MainHomeModel({
    this.dashBoardModel,
    this.footer,
    required this.footerBgColor,
    required this.footerTextColor,
    required this.footerHoverColor,
    required this.footerHoverBgColor,
    this.isWheelSpined,
  });
}
