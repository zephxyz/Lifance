import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tg_proj/misc/auth.dart';

class Firestore {
  static final Firestore instance = Firestore._();

  Firestore._();

  final user = Auth.instance.currentUser;

  Future<void> createDocOnRegister() async {
    if (user == null) {
      return;
    }
    await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
      'email': user!.email,
      'streak': 0,
      'registered_on': Timestamp.now(),
      'total_distance': 0,
      'challenges_completed': 0
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('challenge_history')
        .doc('history')
        .set({});
  }

  Future<int> getCountOfChallenges() async {
    if (user == null) {
      return -1;
    }
    final docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    final challengesCompleted =
        docSnapshot.data()?['challenges_completed'] ?? 0;

    return challengesCompleted;
  }

  Future<void> addChallengeToHistory(
      double lat, double lng, int distance) async {
    if (user == null) {
      return;
    }
    final int index = await getCountOfChallenges();
    final usrData =
        FirebaseFirestore.instance.collection('users').doc(user!.uid);

    final docSnapshot = await usrData.get();

    final totalDistance = docSnapshot.data()?['total_distance'] ?? 0;

    await usrData
        .collection('challenge_history')
        .doc('history')
        .update({index.toString(): GeoPoint(lat, lng)});
    await usrData.update({'challenges_completed': (index + 1)});
    await usrData.update({'total_distance': totalDistance + distance});
    
  }
}
