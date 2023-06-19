import 'package:cloud_firestore/cloud_firestore.dart';

class Challenge {
  double lat;
  double lng;
  int distance;
  int totalDistance;
  Timestamp? timeOfStart;
  Timestamp? timeOfEnd;

  get timeTaken =>
      timeOfStart?.toDate().difference(timeOfEnd?.toDate() ?? DateTime.now()) ??
      const Duration();

  get timeTakenFormatted => '${(timeTaken.inSeconds.abs() ~/ 60).toString().padLeft(2, '0')}:${(timeTaken.inSeconds.abs() % 60).toString().padLeft(2, '0')}';

  Challenge(this.lat, this.lng, this.distance, this.totalDistance,
      this.timeOfStart, this.timeOfEnd);
}
