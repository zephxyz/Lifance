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

  Future<void> signOut() async {
    await Auth.instance.signOut();
    goToLogin();
  }

  Future<void> goToPhotoPage() async {
    context.go('/photopage');
  }

  void goToLogin() {
    context.go('/auth');
  }

  void page(int index) {
    if (index == 0) return;
    if (index == 1) {
      context.go('/');
    } else {
      context.go('/historyviewmap');
    }
  }

  Future<void> onLoad() async {
    userRegisteredOn = await Firestore.instance.userRegisteredOn();
    totalDistance = await Firestore.instance.getTotalDistance();
    displayRadius =
        "${300 + Global.instance.streak}m | ${700 + Global.instance.streak}m";
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
        appBar: AppBar(
            title: Global.instance.streak == -1
                ? FutureBuilder(
                    future: Global.instance.getStreak(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return Container();
                      } else {
                        return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("${Global.instance.streak}"),
                                    const EmojiText(text: '🔥')
                                  ]),
                              const Text(' '),
                              Text(
                                  "${300 + Global.instance.streak}m | ${700 + Global.instance.streak}m"),
                            ]);
                      }
                    },
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("${Global.instance.streak}"),
                              const EmojiText(text: '🔥')
                            ]),
                        const Text(' '),
                        Text(
                            "${300 + Global.instance.streak}m | ${700 + Global.instance.streak}m"),
                      ])),
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
          onTap: page,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("profile info"), //temp
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(16),
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
                          padding: const EdgeInsets.all(16),
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
                    ]),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(displayRadius ?? "loading"),
                                const Text("radius"),
                              ])),
                              Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("${totalDistance ?? "loading"}m"),
                                const Text("total distance"),
                              ])),
                    ]),
              ],
            ),
            ElevatedButton(onPressed: signOut, child: const Text('sign out'))
          ],
        ));
  }
}
