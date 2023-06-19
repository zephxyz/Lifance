
import 'package:haversine_distance/haversine_distance.dart';
import 'package:latlong2/latlong.dart';
import 'package:tg_proj/misc/firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:tg_proj/misc/challenge.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:tg_proj/misc/geolocation.dart';
import 'package:tg_proj/misc/challenge_state.dart';

import 'dist_calc.dart';

class Global {
  static final Global instance = Global._();

  Global._();

  bool firstLaunch = true;

  int streak = -1;

  final int _baseMinDistance = 300;
  final int _baseMaxDistance = 700;

  Challenge challenge = Challenge(0, 0, 0, 0);
  bool isChallengeStarted = false;

  final StreamController<ChallengeState> _challengeStateController =
      StreamController<ChallengeState>.broadcast();

  Stream<ChallengeState> get challengeStateStream => _challengeStateController.stream;

  Timer? _timer;

  void finishChallenge() {
    _timer?.cancel();
    isChallengeStarted = false;
    _challengeStateController.add(ChallengeState.completed);
  }

  /// Starts the timer that updates the challenge
  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 10), (_) async {
      await Geolocation.instance.position.then((pos) async {
        challenge.distance = DistCalculator.instance.getDist(
            Location(pos.latitude, pos.longitude),
            Location(challenge.lat, challenge.lng));
        if (challenge.distance <= 50) {
          finishChallenge();
        }

        //_challengeStateController.add(ChallengeState.started);
        _challengeStateController.add(ChallengeState.distanceUpdated);
      });
    });
  }

  /// Resets the challenge values that are added to the database
  void resetChallengeValues() {
    challenge = Challenge(0, 0, 0, 0);
  }

  Future<void> fetchStreak() async {
    streak = await Firestore.instance.getStreak();
  }

  Future<void> onStart() async {
    if (firstLaunch) {
      await Firestore.instance.onFirstLogin();
      await Firestore.instance.checkStreak();
      await fetchStreak();
      await getChallengeIfAlreadyStarted();
      firstLaunch = false;
    }
  }

  Future<void> getChallengeIfAlreadyStarted() async {
    final challengeInfo = await Firestore.instance.getChallengePending();
    if (challengeInfo != null) {
      await Geolocation.instance.position.then((pos) {
        challenge.distance = DistCalculator.instance.getDist(
            Location(pos.latitude, pos.longitude),
            Location(challengeInfo['lat'], challengeInfo['lng']));
      });

      challenge.lat = challengeInfo['lat'];
      challenge.lng = challengeInfo['lng'];
      challenge.totalDistance = challengeInfo['total_distance'];
      isChallengeStarted = true;
      startTimer();
      _challengeStateController.add(ChallengeState.started);
      _challengeStateController.add(ChallengeState.distanceUpdated);
    }
  }

  int get minDistance => _baseMinDistance + streak;
  int get maxDistance => _baseMaxDistance + streak;

  String get radiusText => ' $_radiusMinText | $_radiusMaxText';

  String get _radiusMinText => minDistance >= 1000
      ? '${(minDistance / 10).roundToDouble() / 100}km'
      : '${minDistance}m';
  String get _radiusMaxText => maxDistance >= 1000
      ? '${(maxDistance / 10).roundToDouble() / 100}km'
      : '${maxDistance}m';

  Marker get challengeMarker {
    if (isChallengeStarted) {
      return Marker(
          point: LatLng(challenge.lat, challenge.lng),
          builder: (context) =>
              const Icon(Icons.room, color: Colors.red, size: 25));
    }
    return Marker(point: LatLng(0, 0), builder: (context) => const SizedBox());
  }

  String get displayDistance => "${challenge.distance.toString()}m";

  void broadcastStart() {
    _challengeStateController.add(ChallengeState.started);
  }
}
