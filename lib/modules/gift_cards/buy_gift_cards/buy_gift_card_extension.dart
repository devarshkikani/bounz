import 'package:bounz_revamp_app/constants/enum.dart';

extension PayBillsExtention on Range {
  String get title {
    switch (this) {
      case Range.aToz:
        return 'az';
      case Range.zToa:
        return 'za';
      case Range.highToLow:
        return 'hl';
      case Range.lowToHigh:
        return 'lh';
      default:
        return '';
    }
  }
}
