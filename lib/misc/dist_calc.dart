import 'dart:math';

import 'package:latlong2/latlong.dart';

class DistCalculator {
  final int _minDist;
  final int _maxDist;
  final LatLng _usr;
  static const double _conversion = 1 / 111000;
  final Random rng = Random();

  DistCalculator(this._minDist, this._maxDist, this._usr);

  LatLng calculate() {
    final double latPortion = rng.nextDouble();
    final double lngPortion = 1 - latPortion;
    final int distance = rng.nextInt(_maxDist - _minDist) + _minDist;
    final double latLngPool = distance * _conversion;
    final LatLng chal = _usr;

    if (rng.nextBool()) {
      chal.latitude +=
          ((latPortion * latLngPool) * 10000000).round() / 10000000;
    } else {
      chal.latitude -=
          ((latPortion * latLngPool) * 10000000).round() / 10000000;
    }
    if (rng.nextBool()) {
      chal.longitude +=
          ((lngPortion * latLngPool) * 10000000).round() / 10000000;
    } else {
      chal.longitude -=
          ((lngPortion * latLngPool) * 10000000).round() / 10000000;
    }

    return chal;
  }
}
