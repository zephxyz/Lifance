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
  String? displayRadius =
      "${300 + Global.instance.streak}m | ${700 + Global.instance.streak}m";
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
          backgroundColor: Colors.white,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(userEmail ?? "loading",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w700)),
            
            ), //temp
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                                const SizedBox(
                                  height: 3,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          top: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              width: 2.5))),
                                  child: const SizedBox(width: 75),
                                ),
                                const Text("streak",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600)),
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
                                const SizedBox(
                                  height: 3,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          top: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              width: 2.5))),
                                  child: const SizedBox(width: 75),
                                ),
                                const Text("registered on",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600)),
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
                                const SizedBox(
                                  height: 3,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          top: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              width: 2.5))),
                                  child: const SizedBox(width: 75),
                                ),
                                const Text("longest streak",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600)),
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
                                const SizedBox(
                                  height: 3,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          top: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              width: 2.5))),
                                  child: const SizedBox(width: 75),
                                ),
                                const Text("radius",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600)),
                              ])),
                      Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(totalDistance == null ? "loading" : "${totalDistance}m"),
                                const SizedBox(
                                  height: 3,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          top: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              width: 2.5))),
                                  child: const SizedBox(width: 75),
                                ),
                                const Text("total distance",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600)),
                              ])),
                      Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("${challengesCompleted ?? "loading"}"),
                                const SizedBox(
                                  height: 3,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          top: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              width: 2.5))),
                                  child: const SizedBox(width: 75),
                                ),
                                const Text(
                                  "challenges\ncompleted",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ])),
                    ]),
              ],
            ),

            ElevatedButton(onPressed: signOut, child: const Text('Sign out'))
          ],
        ));
  }
}
