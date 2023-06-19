import 'dart:math';
import 'package:latlong2/latlong.dart';
import 'package:haversine_distance/haversine_distance.dart';
import 'package:tg_proj/misc/challenge.dart';

class DistCalculator {
  static final DistCalculator instance = DistCalculator._();
  DistCalculator._();

  final double _conversion = 1 / 111111;
  final Random rng = Random();

  Challenge initiateChallenge(int minDist, int maxDist, LatLng position) {
    return _calculate(minDist, maxDist, position);
  }

  bool checkDist(Location start, Location end) {
    return (HaversineDistance().haversine(start, end, Unit.METER).floor() < 50);
  }

  int getDist(Location start, Location end) =>
      HaversineDistance().haversine(start, end, Unit.METER).floor();

  Challenge _calculate(int minDist, int maxDist, LatLng usr) {
    final double latPortion = rng.nextDouble();
    final double lngPortion = 1 - latPortion;

    final double distance =
        (rng.nextInt(maxDist - minDist) + minDist).toDouble();
    double dist = distance * distance;
    double lat = sqrt(dist * latPortion) * _conversion;
    double lng =
        sqrt(dist * lngPortion) * _conversion / cos(usr.latitude * pi / 180);

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

    return Challenge(
        chal.latitude,
        chal.longitude,
        getDist(Location(usr.latitude, usr.longitude),
            Location(chal.latitude, chal.longitude)),
        distance.floor());
  }
}
