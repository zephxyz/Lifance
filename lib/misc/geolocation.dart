import 'package:geolocator/geolocator.dart';

class Geolocation {
  static final Geolocation instance = Geolocation._();

  Geolocation._();

  LocationPermission? locPerm;

  Future<void> getPermission() async {
    locPerm = await Geolocator.checkPermission();
  }

  Future<LocationPermission> turnOnServices() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if ((permission != LocationPermission.always ||
            permission != LocationPermission.whileInUse) &&
        permission != LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      return permission;
    } else {
      return permission;
    }
  }

  get gpsPermission => turnOnServices();

  get position => Geolocator.getCurrentPosition();

  get perm => Geolocator.checkPermission();
}
