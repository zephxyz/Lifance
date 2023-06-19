import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
import 'package:haversine_distance/haversine_distance.dart';
import 'package:lifance/misc/challenge.dart';
import 'package:lifance/misc/global.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lifance/misc/geolocation.dart';
import 'package:lifance/misc/firestore.dart';

class DistCalculator {
  static final DistCalculator instance = DistCalculator._();
  DistCalculator._();

  final double _conversion = 1 / 111111;
  final Random rng = Random();

  Future<void> refreshChallenge() async {
    Position pos = await Geolocation.instance.position;

    int desiredDistance = getDist(Location(pos.latitude, pos.longitude),
        Location(Global.instance.challenge.lat, Global.instance.challenge.lng));

    Challenge newChallenge = _calculate(
        Global.instance.minDistance,
        Global.instance.maxDistance,
        LatLng(pos.latitude, pos.longitude),
        desiredDistance > Global.instance.maxDistance
            ? Global.instance.maxDistance.toDouble()
            : desiredDistance.toDouble());

    Global.instance.challenge.lat = newChallenge.lat;
    Global.instance.challenge.lng = newChallenge.lng;
    Global.instance.challenge.distance = newChallenge.distance;

    Global.instance.broadcastStart();

    await Firestore.instance.updateChallenge();
  }

  Challenge initiateChallenge(int minDist, int maxDist, LatLng position) {
    return _calculate(minDist, maxDist, position, null);
  }

  bool checkDist(Location start, Location end) {
    return (HaversineDistance().haversine(start, end, Unit.METER).floor() < 50);
  }

  int getDist(Location start, Location end) =>
      HaversineDistance().haversine(start, end, Unit.METER).floor();

  Challenge _calculate(
      int minDist, int maxDist, LatLng usr, double? desiredDist) {
    final double latPortion = rng.nextDouble();
    final double lngPortion = 1 - latPortion;

    final double distance =
        desiredDist ?? (rng.nextInt(maxDist - minDist) + minDist).toDouble();
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
        distance.floor(), Timestamp.now(), null);
  }
}
