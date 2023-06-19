import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:haversine_distance/haversine_distance.dart';
import 'package:latlong2/latlong.dart';
import 'package:tg_proj/misc/challenge_state.dart';
import 'package:tg_proj/misc/firestore.dart';
import 'package:tg_proj/misc/global.dart';
import 'package:tg_proj/misc/geolocation.dart';

import '../misc/dist_calc.dart';

class BottomAppbarFloatingActionButton extends StatefulWidget {
  const BottomAppbarFloatingActionButton({Key? key}) : super(key: key);

  @override
  BottomAppbarFloatingActionButtonState createState() =>
      BottomAppbarFloatingActionButtonState();
}

class BottomAppbarFloatingActionButtonState
    extends State<BottomAppbarFloatingActionButton> {
  final minDist = 0;
  final maxDist = 50;
  String displayDistance = Global.instance.displayDistance;

  StreamSubscription<ChallengeState>? challengeStateStream;

  Future<void> initiateChallenge() async {
    if (await Firestore.instance.isChallengePending()) return;
    Position pos = await Geolocation.instance.position;

    Global.instance.challenge = DistCalculator.instance.initiateChallenge(
        minDist, maxDist, LatLng(pos.latitude, pos.longitude));
    await Firestore.instance.onChallengeStart(
        GeoPoint(Global.instance.challenge.lat, Global.instance.challenge.lng),
        GeoPoint(pos.latitude, pos.longitude),
        Global.instance.challenge.totalDistance);

    Global.instance.isChallengeStarted = true;
    Global.instance.challenge.distance = DistCalculator.instance.getDist(
        Location(pos.latitude, pos.longitude),
        Location(Global.instance.challenge.lat, Global.instance.challenge.lng));
    Global.instance.startTimer();
    Global.instance.broadcastStart();

    setState(() {
      displayDistance = Global.instance.displayDistance;
    });
  }

  @override
  void initState() {
    super.initState();
    challengeStateStream =
        Global.instance.challengeStateStream.listen((event) async {
      if (event == ChallengeState.distanceUpdated) {
        setState(() {
          displayDistance = Global.instance.displayDistance;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      tooltip: Global.instance.isChallengeStarted
          ? "Remaining distance"
          : "Initiate challenge",
      onPressed: Global.instance.isChallengeStarted ? null : initiateChallenge,
      child: Global.instance.isChallengeStarted
          ? Text(Global.instance.displayDistance)
          : const Icon(Icons.bolt),
    );
  }
}
