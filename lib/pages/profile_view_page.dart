import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tg_proj/misc/auth.dart';
import 'package:tg_proj/misc/firestore.dart';
import 'package:tg_proj/misc/global.dart';
import 'package:tg_proj/widgets/bottom_appbar.dart';
import 'package:tg_proj/widgets/bottom_appbar_fab.dart';
import 'package:tg_proj/widgets/emoji_text.dart';
import 'package:intl/intl.dart';
import 'package:tg_proj/misc/challenge_state.dart';
import 'package:tg_proj/misc/user_info.dart';

class ProfileViewPage extends StatefulWidget {
  const ProfileViewPage({super.key});

  @override
  State<ProfileViewPage> createState() => _ProfileViewPageState();
}

class _ProfileViewPageState extends State<ProfileViewPage> {
  UserInfo? user;
  bool loaded = false;
  String _deleteErrMsg = "";

  StreamSubscription<ChallengeState>? challengeStateStream;

  Future<void> signOut() async {
    await Auth.instance.signOut().then((_) {
      Navigator.of(context).pop();
      goToLoginPage();
     });
    goToLoginPage();
  }

  void goToLoginPage() {
    context.go('/auth');
  }

  Future<void> deleteAccount() async {}

  void handleRedirection(int index) {
    if (index == 0) return;
    if (index == 1) {
      context.go('/');
    } else {
      context.go('/historyviewmap');
    }
  }

  Future<void> onLoad() async {
    await Firestore.instance.getUserInfo().then((value) => setState(() {
          user = value;
          loaded = true;
        }));
  }

  @override
  void initState() {
    super.initState();
    onLoad();
    challengeStateStream = Global.instance.challengeStateStream.listen((event) {
      if (event == ChallengeState.completed) {
        context.go('/photopage');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var deleteController = TextEditingController();
    String deleteText = "";
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: const MyBottomAppBar(
        currentPage: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(
            height: 16,
          ),
          GestureDetector(
            onTap: () => showDialog(
              context: context,
              builder: (context) =>  AlertDialog(
                title: const Text("Email"),
                content:
                    const Text("This is the email adress you have registered under."),
                    actions: [
                                  TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text("Got it")),
                                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Card(
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: user?.getEmail == null && !loaded
                      ? const CircularProgressIndicator()
                      : FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                            user?.getEmail ??
                               (loaded ? "Something went wrong..." : "loading..."),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            )),
                      ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: GridView(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 16,
                  ),
                  children: [
                    GestureDetector(
                      onTap: () => showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text("Streak"),
                                content: const Text(
                                    "This is your streak.\n\nA streak is a continuous series of challenges completed on consecutive days.\n\nBy completing challenges day after day, you can increase your streak."),
                                actions: [
                                  TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text("Got it")),
                                ],
                              )),
                      child: Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Center(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        "${Global.instance.streak}",
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                      const EmojiText(text: '🔥'),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                              ),
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Text(
                                    "streak",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text("Radius"),
                                content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                          "This is the radius the challenge goal can be generated in."),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Image.asset(
                                        "assets/img/radius.png",
                                        alignment: Alignment.center,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      const Text(
                                          "The first value is the minimum distance between you and the challenge goal and the last value is the maximum distance between you and the challenge goal.")
                                      //"),
                                    ]),
                                actions: [
                                  TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text("Got it")),
                                ],
                              )),
                      child: Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Center(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      const Icon(
                                        Icons.blur_circular,
                                        color: Colors.deepOrangeAccent
                                      ),
                                      Text(
                                        Global.instance.radiusText,
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                              ),
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "radius",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Registered on"),
                          content: const Text(
                              "This is the date you have registered on."),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text("Got it")),
                          ],
                        ),
                      ),
                      child: Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Center(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      user?.getRegisteredOn == null && !loaded
                                          ? const CircularProgressIndicator()
                                          : Text(
                                              user?.getRegisteredOn == null
                                                  ? (loaded
                                                      ? "Something went wrong..."
                                                      : "loading...")
                                                  : DateFormat.yMMMd().format(
                                                      user?.getRegisteredOn
                                                          .toDate()),
                                              style: const TextStyle(
                                                  fontSize: 16)),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                              ),
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "registered on",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Total distance"),
                          content: const Text(
                              "This is the total distance which you have traveled while completing challenges."),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text("Got it")),
                          ],
                        ),
                      ),
                      child: Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Center(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      user?.getTotalDistance == null && !loaded
                                          ? const CircularProgressIndicator()
                                          : Text(
                                              user?.getTotalDistance
                                                      .toString() ??
                                                  (loaded
                                                      ? "Something went wrong..."
                                                      : "loading..."),
                                              style: const TextStyle(
                                                  fontSize: 18)),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                              ),
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "total distance",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Longest streak"),
                          content: const Text(
                              "This is the longest streak that you have achieved."),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text("Got it")),
                          ],
                        ),
                      ),
                      child: Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Center(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      user?.getLongestStreak == null && !loaded
                                          ? const CircularProgressIndicator()
                                          : Text(
                                              user?.getLongestStreak
                                                      .toString() ??
                                                  (loaded
                                                      ? "Something went wrong..."
                                                      : "loading..."),
                                              style: const TextStyle(
                                                  fontSize: 18)),
                                      const EmojiText(text: '🔥'),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                              ),
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "longest\nstreak",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Challenges completed"),
                          content: const Text(
                              "This is the total number of challenges that you have completed."),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text("Got it")),
                          ],
                        ),
                      ),
                      child: Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Center(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      user?.getChallengesCompleted == null &&
                                              !loaded
                                          ? const CircularProgressIndicator()
                                          : Text(
                                              user?.getChallengesCompleted
                                                      .toString() ??
                                                  (loaded
                                                      ? "Something went wrong..."
                                                      : "loading..."),
                                              style: const TextStyle(
                                                  fontSize: 18)),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                              ),
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "challenges\ncompleted",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                  onPressed: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: const Text("Sign out"),
                            content: const Text(
                                "Are you sure you want to sign out?"),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text("Cancel")),
                              TextButton(
                                  onPressed: () => signOut(),
                                  child: const Text("Confirm")),
                            ],
                          )),
                  child: const Icon(Icons.logout)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                onPressed: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text("Delete account"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                  "Are you sure you want to delete your account? This action cannot be undone.\n\nBy typing 'delete' below, you confirm that you want to delete your account and you acknowledge that all of your data in \"Lifance\" will be deleted."),
                              TextField(
                                decoration: const InputDecoration(
                                    hintText: "Type 'delete' to confirm"),
                                controller: deleteController,
                                onChanged: (value) {
                                  setState(() {
                                    deleteText = value;
                                  });
                                },
                              ),
                              Text(_deleteErrMsg,
                                  style: const TextStyle(color: Colors.red)),
                            ],
                          ),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text("Cancel")),
                            TextButton(
                                onPressed: () async {
                                  if (deleteText == "delete") {
                                    await Firestore.instance.deleteAccountData();
                                    await Auth.instance.deleteUser().then((_) {
                                      goToLoginPage();
                                      Navigator.of(context).pop();
                                    });
            
                                    goToLoginPage();
                                  } else {
                                    setState(() {
                                      _deleteErrMsg = "Please type 'delete'";
                                    });
                                  }
                                },
                                child: const Text(
                                  "Delete",
                                  style: TextStyle(color: Colors.red),
                                )),
                          ],
                        )),
                backgroundColor: Colors.red,
                child: const Icon(Icons.delete_forever),
              ),
            ),
          ]),
        ],
      ),
      floatingActionButton: const BottomAppbarFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
