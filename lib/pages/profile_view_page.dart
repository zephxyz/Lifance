import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tg_proj/misc/auth.dart';
import 'package:tg_proj/misc/firestore.dart';
import 'package:tg_proj/misc/global.dart';
import 'package:tg_proj/misc/emoji_text.dart';
import 'package:intl/intl.dart';

class ProfileViewPage extends StatefulWidget {
  const ProfileViewPage({super.key});

  @override
  State<ProfileViewPage> createState() => _ProfileViewPageState();
}

class _ProfileViewPageState extends State<ProfileViewPage> {
  Timestamp? userRegisteredOn;
  String? displayRadius;
  int? totalDistance;
  int? challengesCompleted;
  int? longestStreak;
  String? userEmail;

  Future<void> signOut() async {
    await Auth.instance.signOut();
    goToLoginPage();
  }

  void goToLoginPage() {
    context.go('/auth');
  }

  void handleRedirection(int index) {
    if (index == 0) return;
    if (index == 1) {
      context.go('/');
    } else {
      context.go('/historyviewmap');
    }
  }

  Future<void> onLoad() async {
    userRegisteredOn = await Firestore.instance.getUserRegisteredOn();
    totalDistance = await Firestore.instance.getTotalDistance();
    displayRadius =
        "${300 + Global.instance.streak}m | ${700 + Global.instance.streak}m";
    userEmail = await Firestore.instance.getUserEmail();
    challengesCompleted = await Firestore.instance.getChallengesCompleted();
    longestStreak = await Firestore.instance.getLongestStreak();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    onLoad();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.location_pin),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.timeline),
              label: 'History',
            ),
          ],
          currentIndex: 0,
          unselectedItemColor: Colors.black,
          selectedItemColor:
              const Color(0xff725ac1), //,const Color(0xff8D86C9),
          onTap: handleRedirection,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(userEmail ?? "loading",
                  style: const TextStyle(fontSize: 20)),
            ), //temp
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text("${Global.instance.streak}"),
                                    const EmojiText(text: '🔥'),
                                  ],
                                ),
                                const Text("streak"),
                              ])),
                      Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(userRegisteredOn != null
                                    ? DateFormat('yyyy-MM-dd')
                                        .format(userRegisteredOn!.toDate())
                                    : "loading"),
                                const Text("registered on"),
                              ])),
                      Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text("${longestStreak ?? "loading"}"),
                                    const EmojiText(text: '🔥'),
                                  ],
                                ),
                                const Text("longest streak"),
                              ])),
                    ]),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(displayRadius ?? "loading"),
                                const Text("radius"),
                              ])),
                      Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("${totalDistance ?? "loading"}m"),
                                const Text("total distance"),
                              ])),
                      Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("${challengesCompleted ?? "loading"}"),
                                const Text("challenges completed"),
                              ])),
                    ]),
              ],
            ),

            ElevatedButton(onPressed: signOut, child: const Text('Sign out'))
          ],
        ));
  }
}
