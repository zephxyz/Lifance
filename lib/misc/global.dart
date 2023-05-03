import 'package:flutter/material.dart';
import 'package:tg_proj/misc/firestore.dart';
import 'package:tg_proj/misc/emoji_text.dart';

class Global {
  static final Global instance = Global._();

  Global._();


  int streak = -1;

  double latToAdd = 0;
  double lngToAdd = 0;
  int distanceToAdd = 0;

  /// Resets the challenge values that are added to the database
  void reset(){
    latToAdd = 0;
    lngToAdd = 0;
    distanceToAdd = 0;
  }

  Future<void> getStreak() async {
    streak = await Firestore.instance.getStreak();
  }

}
