import 'package:geolocator/geolocator.dart';

class Geolocation {
  Future<LocationPermission> turnOnServices() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      return permission;
    } else {
      return permission;
    }
  }
  
  get gpsPermission => turnOnServices();

  get position => Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  
}
