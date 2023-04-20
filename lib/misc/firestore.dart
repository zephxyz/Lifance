import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tg_proj/misc/auth.dart';
import 'package:tg_proj/misc/global.dart';

class Firestore {
  static final Firestore instance = Firestore._();

  Firestore._();

  final user = Auth.instance.currentUser;

  Future<int> getStreak() async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    return docSnapshot.data()?['streak'];
  }


  Future<void> checkStreak() async {
    if (user == null) {
      return;
    }
    final docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    final temp = docSnapshot.data()?['last_challenge_completed'];

    final DateTime lastChallengeCompleted = temp.toDate();
    final usrData =
        FirebaseFirestore.instance.collection('users').doc(user!.uid);

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
    await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
      'email': user!.email,
      'streak': 0,
      'registered_on': Timestamp.now(),
      'total_distance': 0,
      'challenges_completed': 0,
      'last_challenge_completed': null
    });
  }

  Future<int> getCountOfChallenges() async {
    if (user == null) {
      return -1;
    }
    final docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    final challengesCompleted = docSnapshot.data()?['challenges_completed'];

    return challengesCompleted;
  }

  Future<void> addChallengeToHistory(
      double lat, double lng, int distance, String path) async {
    if (user == null) {
      return;
    }

    final int index = await getCountOfChallenges();
    final usrData =
        FirebaseFirestore.instance.collection('users').doc(user!.uid);

    final docSnapshot = await usrData.get();
    final timeNow = DateTime.now();
    final totalDistance = await docSnapshot.data()?['total_distance'];

    await usrData.collection('challenge_history').doc('$index').set({
      'LatLng': GeoPoint(lat, lng),
      'photopath': path,
      'completed_on': timeNow
    });
    await usrData.update({'challenges_completed': (index + 1)});
    await usrData.update({'total_distance': totalDistance + distance});

    final streak = await docSnapshot.data()?['streak'];

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
    await Global.instance.getStreak();
  }
}
