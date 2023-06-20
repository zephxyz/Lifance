import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:lifance/misc/auth.dart';
import 'package:lifance/misc/global.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:lifance/misc/photo_info.dart';
import 'package:lifance/misc/user_info.dart';

class Firestore {
  static final Firestore instance = Firestore._();

  Firestore._();

  auth.User? user = Auth.instance.currentUser;

  void refreshUser() {
    user = Auth.instance.currentUser;
  }

  Future<void> onChallengeAbandon() async {
    if (user == null) {
      return;
    }
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .update({'challenge_pending': null});
  }

  Future<int> getStreak() async {
    if (user == null) {
      return 0;
    }
    final docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();
    return docSnapshot.data()?['streak'] ?? 0;
  }

  Future<void> updateChallenge() async {
    if (user == null) {
      return;
    }
    await FirebaseFirestore.instance.collection('users').doc(user?.uid).update({
      'challenge_pending': {
        'lat': Global.instance.challenge.lat,
        'lng': Global.instance.challenge.lng,
      }
    });
  }

  Future<void> onFirstLogin() async {
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
    if (user == null) {
      return;
    }
    final docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();
    final temp = docSnapshot.data()?['last_challenge_completed'];
    if (temp == null) return;
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
      'longest_streak': 0,
    });
  }

  Future<void> setTimeOfEnd(Timestamp timeOfEnd) async {
    if (user == null) {
      return;
    }

    final docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();

    final challengePending = docSnapshot.data()?['challenge_pending'];
    if (challengePending != null) {
      final updatedChallengePending = {
        ...challengePending,
        'time_of_end': timeOfEnd,
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .update({'challenge_pending': updatedChallengePending});
    }
  }

  Future<bool> isChallengePending() async {
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

  Future<void> onChallengeStart(
      GeoPoint point, GeoPoint startPos, int totalDistance) async {
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
        'total_distance': totalDistance,
        'time_of_end': null,
      }
    });
  }

  Future<List<Marker>> getHistoryMarkers() async {
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

  Future<Map<String, dynamic>?> getChallengePending() async {
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
      double lat, double lng, int distance, String? savedPath) async {
    if (user == null) {
      return;
    }

    final int? index = await getChallengesCompleted();
    final usrData =
        FirebaseFirestore.instance.collection('users').doc(user?.uid);

    final docSnapshot = await usrData.get();
    final timeNow = DateTime.now();
    final totalDistance = await docSnapshot.data()?['total_distance'] ?? 0;

    await usrData.collection('challenge_history').doc('$index').set({
      'LatLng': GeoPoint(lat, lng),
      'image_path': savedPath,
      'completed_on': timeNow,
      'total_distance': distance,
    });
    await usrData.update({'challenges_completed': ((index ?? 0) + 1)});
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

    final docSnapshotAfterUpdate = await usrData.get();

    int tempStreak = await docSnapshotAfterUpdate.data()?['streak'] ?? 0;
    int tempLongestStreak =
        await docSnapshotAfterUpdate.data()?['longest_streak'] ?? 0;
    if (tempStreak > tempLongestStreak) {
      await usrData.update({'longest_streak': tempStreak});
    }
    await Global.instance.fetchStreak();
  }

  Future<int?> getChallengesCompleted() async {
    if (user == null) {
      return null;
    }
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get()
        .then((value) => value.data()?['challenges_completed'] ?? 0);
  }

  Future<UserInfo?> getUserInfo() async {
    if (user == null) {
      return null;
    }
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get()
        .then((value) => UserInfo(
            user?.email,
            value.data()?['registered_on'],
            TotalDistance(value.data()?['total_distance']),
            value.data()?['longest_streak'],
            value.data()?['challenges_completed']));
  }

  Future<List<PhotoInfo>> getHistoryPhotos() async {
    if (user == null) {
      return [];
    }
    final docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('challenge_history')
        .orderBy('completed_on', descending: true)
        .get();
    final List<PhotoInfo> photos = [];

    for (var doc in docSnapshot.docs) {
      final data = doc.data();
      final String? photoPath = data['image_path'];
      if (photoPath == null) {
        continue;
      }
      final Timestamp? time = data['completed_on'];
      if (time == null) {
        continue;
      }
      photos.add(PhotoInfo(photoPath, time));
    }

    return photos;
  }

  Future<void> deleteAccountData() async {
    if (user == null) {
      return;
    }
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .delete();
  }
}
