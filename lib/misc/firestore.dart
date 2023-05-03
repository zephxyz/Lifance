import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tg_proj/misc/auth.dart';
import 'package:tg_proj/misc/global.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class Firestore {
  static final Firestore instance = Firestore._();

  Firestore._();

  final user = Auth.instance.currentUser;

  Future<int> getStreak() async {
    user?.reload();
    if (user == null) {
      return 0;
    }
    final docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();
    return docSnapshot.data()?['streak'];
  }

  Future<void> isFirstLogin() async {
    user?.reload();
    if (user == null) {
      return;
    }
    final docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();
    if (docSnapshot.data()?['registered_on'] == null) {
      await createDocOnRegister();
    }
  }

  Future<void> checkStreak() async {
    user?.reload();
    if (user == null) {
      return;
    }
    final docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();
    final temp = docSnapshot.data()?['last_challenge_completed'];

    final DateTime lastChallengeCompleted = temp.toDate();
    final usrData =
        FirebaseFirestore.instance.collection('users').doc(user?.uid);

    if (lastChallengeCompleted.hour * 3600 +
            lastChallengeCompleted.minute * 60 +
            lastChallengeCompleted.second +
            DateTime.now().difference(lastChallengeCompleted).inSeconds >
        Duration.secondsPerDay * 2) {
      await usrData.update({'streak': 0});
    }
  }

  Future<void> createDocOnRegister() async {
    user?.reload();
    if (user == null) {
      return;
    }
    await FirebaseFirestore.instance.collection('users').doc(user?.uid).set({
      'email': user?.email,
      'streak': 0,
      'registered_on': Timestamp.now(),
      'total_distance': 0,
      'challenges_completed': 0,
      'last_challenge_completed': null,
      'challenge_pending': null,
    });
  }

  Future<bool> isChallengePending() async {
    user?.reload();
    if (user == null) {
      return false;
    }
    final docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();
    final challengePending = docSnapshot.data()?['challenge_pending'];

    return challengePending != null;
  }

  Future<void> onChallengeStart(GeoPoint point, GeoPoint startPos) async {
    user?.reload();
    if (user == null) {
      return;
    }
    await FirebaseFirestore.instance.collection('users').doc(user?.uid).update({
      'challenge_pending': {
        'lat': point.latitude,
        'lng': point.longitude,
        'time_of_start': Timestamp.now(),
        'lat_of_start': startPos.latitude,
        'lng_of_start': startPos.longitude,
      }
    });
  }

  Future<List<Marker>> getHistoryMarkers() async {
    user?.reload();
    if (user == null) {
      return [];
    }
    final docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('challenge_history')
        .get();
    final List<Marker> markers = [];
    for (var doc in docSnapshot.docs) {
      final data = doc.data();
      final GeoPoint latLng = data['LatLng'];
      markers.add(Marker(
          point: LatLng(latLng.latitude, latLng.longitude),
          builder: (ctx) =>
              const Icon(Icons.room, color: Colors.red, size: 10)));
    }
    return markers;
  }

  Future<int> getCountOfChallenges() async {
    user?.reload();
    if (user == null) {
      return -1;
    }
    final docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();
    final challengesCompleted = docSnapshot.data()?['challenges_completed'] ?? 0;

    return challengesCompleted;
  }

  Future<Map<String, dynamic>?> getChallengePending() async {
    user?.reload();
    if (user == null) {
      return null;
    }
    final docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();
    final challengePending = docSnapshot.data()?['challenge_pending'];

    return challengePending;
  }

  Future<void> addChallengeToHistory(
      double lat, double lng, int distance, String? imgBase64, String? savedPath) async {
     user?.reload();
    if (user == null) {
      return;
    }

    final int index = await getCountOfChallenges();
    final usrData =
        FirebaseFirestore.instance.collection('users').doc(user?.uid);

    final docSnapshot = await usrData.get();
    final timeNow = DateTime.now();
    final totalDistance = await docSnapshot.data()?['total_distance'] ?? 0;

    await usrData.collection('challenge_history').doc('$index').set({
      'LatLng': GeoPoint(lat, lng),
      'base64image': imgBase64,
      'image_path': savedPath,
      'completed_on': timeNow
    });
    await usrData.update({'challenges_completed': (index + 1)});
    await usrData.update({'total_distance': totalDistance + distance});

    final streak = await docSnapshot.data()?['streak'] ?? 0;

    if (streak == 0) {
      await usrData.update({'streak': 1});
    } else {
      Timestamp temp = docSnapshot.data()?['last_challenge_completed'];
      DateTime lastChallengeCompleted = temp.toDate();
      if (lastChallengeCompleted.hour * 3600 +
              lastChallengeCompleted.minute * 60 +
              lastChallengeCompleted.second +
              timeNow.difference(lastChallengeCompleted).inSeconds >
          Duration.secondsPerDay) {
        await usrData.update({'streak': streak + 1});
      }
    }
    await usrData.update({'last_challenge_completed': timeNow});
    await usrData.update({'challenge_pending': null});
    await Global.instance.getStreak();
  }
}
