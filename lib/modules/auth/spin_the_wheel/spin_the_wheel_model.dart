import 'package:bounz_revamp_app/models/spin_wheel/wheel_details.dart';
import 'package:bounz_revamp_app/models/spin_wheel/wheel_response.dart';

class SpinWheelsModel {
  DataWheelDesign? spinData;
  bool isFromSplash;
  SpinData? spinDataResponse;
  bool showBottomSheet;
  final String apiKey;
  final String apiValue;

  SpinWheelsModel({
    required this.isFromSplash,
    required this.apiKey,
    required this.apiValue,
    this.spinData,
    this.spinDataResponse,
    this.showBottomSheet = false,
  });
}
