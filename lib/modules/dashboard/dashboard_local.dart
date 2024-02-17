import 'package:bounz_revamp_app/config/manager/storage_manager.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/models/dashboard/dashboard_model.dart';

class DashboardLocal {
  Future dashboardSaveToLocal(DashBoardModel data) async {
    StorageManager.removeValue(AppConstString.cacheDatePrefKey);
    StorageManager.removeValue(AppConstString.dashboardDataPrefKey);
    StorageManager.setStringValue(
        key: AppConstString.cacheDatePrefKey,
        value: data.data?.cacheDate.toString() ?? DateTime.now().toString());
    StorageManager.setStringValue(
      key: AppConstString.dashboardDataPrefKey,
      value: dashBoardModelToJson(data),
    );
  }
}
