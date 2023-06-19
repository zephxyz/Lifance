import 'package:cloud_firestore/cloud_firestore.dart';

class UserInfo {
  final String? _email;
  final Timestamp? _registeredOn;
  final TotalDistance? _totalDistance;
  final int? _longestStreak;
  final int? _challengesCompleted;

  UserInfo(this._email, this._registeredOn, this._totalDistance,
      this._longestStreak, this._challengesCompleted);

  get getEmail => _email;
  get getRegisteredOn => _registeredOn;
  get getTotalDistance => _totalDistance;
  get getLongestStreak => _longestStreak;
  get getChallengesCompleted => _challengesCompleted;
}

class TotalDistance {
  final int _totalDistance;

  TotalDistance(this._totalDistance);

  get getTotalDistance => _totalDistance;

  @override
  String toString() {
    if (_totalDistance >= 10000) {
      return '${(_totalDistance / 1000).toStringAsFixed(2)} km';
    } else {
      return '$_totalDistance m';
    }
  }
}
