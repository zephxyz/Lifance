import 'dart:math';

import 'package:latlong2/latlong.dart';

class DistCalculator {
  static final DistCalculator instance = DistCalculator._();
  DistCalculator._();

  final double _conversion = 1 / 111111;
  final Random rng = Random();

  LatLng calculate(int minDist, int maxDist, LatLng usr) {
    final double latPortion = rng.nextDouble();
    final double lngPortion = 1 - latPortion;

    final double distance =
        (rng.nextInt(maxDist - minDist) + minDist).toDouble();
    double dist = distance * distance;
    print(dist);
    double lat = sqrt(dist * latPortion) * _conversion;
    print(dist * latPortion);
    double lng = sqrt(dist * lngPortion) * (_conversion * cos(lat));
    print(dist * lngPortion);

    //final double latLngPool = distance * _conversion;
    final LatLng chal = usr;

    if (rng.nextBool()) {
      chal.latitude += lat;
    } else {
      chal.latitude -= lat;
    }
    if (rng.nextBool()) {
      chal.longitude += lng;
    } else {
      chal.longitude -= lng;
    }

    return chal;
  }
}
