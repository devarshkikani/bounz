import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/main.dart';
import 'package:bounz_revamp_app/utils/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;

class UserLocation {
  Circle circle = Circle();
  Future<String> getCurrentPosition(
      Function()? afterSuccess, BuildContext? context, int index,
      {bool? dontDo}) async {
    if (context != null) circle.show(context);
    loc.Location location = loc.Location();
    bool ison = await location.serviceEnabled();
    if (!ison) {
      bool isturnedon = await location.requestService();
      if (!isturnedon) {
        if (context != null) circle.hide(context);
        return "PERMISSION";
      }
    }

    if (GlobalSingleton.currentPosition != null) {
      if (context != null) circle.hide(context);
      return "SUCCESS";
    }
    final bool hasPermission =
        await handleLocationPermission(afterSuccess, dontDo: dontDo);

    if (!hasPermission) {
      if (context != null) circle.hide(context);
      return "FAILED";
    }

    try {
      final LocationPermission hasPermission =
          await Geolocator.checkPermission();
      if(hasPermission.name != "denied"){
        final Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
        );
        GlobalSingleton.currentPosition = position;
        if (context != null) circle.hide(context);
        return "SUCCESS";
      }
      else{
        return "FAILED";
      }

      // return _getAddressFromLatLng(position);
    } on Position catch (_) {

      if (context != null) circle.hide(context);
      return "FAILED";
    }
  }

  Future<bool> handleLocationPermission(Function()? afterSuccess,
      {bool? dontDo}) async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied && dontDo != true) {
        MoenageManager.logScreenEvent(name: 'Location Permission');

        appRouter
            .push(LocationPermissionScreenRoute(afterSuccess: afterSuccess));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever && dontDo != true) {
      MoenageManager.logScreenEvent(name: 'Location Permission');

      appRouter.push(LocationPermissionScreenRoute(afterSuccess: afterSuccess));
      return false;
    }

    return true;
  }
}
