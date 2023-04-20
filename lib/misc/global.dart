import 'package:flutter/material.dart';
import 'package:tg_proj/misc/firestore.dart';
import 'package:tg_proj/misc/emoji_text.dart';

class Global {
  static final Global instance = Global._();

  Global._();

  String imagePath = '';

  int streak = 0;


  Future<void> getStreak() async {
    streak = await Firestore.instance.getStreak();
  }

  void setImagePath(String path) {
    imagePath = path;
  }

  

}
