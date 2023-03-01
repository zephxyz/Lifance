import 'dart:math';

import 'package:latlong2/latlong.dart';

class DistCalculator {
  int minDist;
  int maxDist;
  LatLng usr;
  double conversion = 1 / 111000;
  Random rng = Random();

  DistCalculator(this.minDist, this.maxDist, this.usr);

  LatLng calculate() {
    double latPortion = rng.nextDouble();
    double lngPortion = 1 - latPortion;
    int distance = rng.nextInt(400) + minDist;
    double latLngPool = distance * conversion;
    LatLng chal = usr;
    if (rng.nextBool()) {
      chal.latitude += ((latPortion * latLngPool)* 10000000).round() / 10000000;
    } else {
      chal.latitude -= ((latPortion * latLngPool)* 10000000).round() / 10000000;
    }
    if (rng.nextBool()) {
      chal.longitude += ((lngPortion * latLngPool)* 10000000).round() / 10000000;
    } else {
      chal.longitude -= ((lngPortion * latLngPool)* 10000000).round() / 10000000;
    }

    return chal;
  }
}
