import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

class MapUtils {
  MapUtils() : super();
  // ignore: unused_element
  MapUtils._();
  String? googleUrl = "";
  Future<void> openMap(double latitude, double longitude) async {
    if (Platform.isAndroid) {
      googleUrl = 'geo:$latitude,$longitude?q=$latitude,$longitude';
    } else {
      googleUrl =
          'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    }

    if (await canLaunchUrl(Uri.parse(googleUrl!))) {
      await launchUrl(Uri.parse(googleUrl!));
    } else {
      throw 'Could not open the map.';
    }
  }
}
