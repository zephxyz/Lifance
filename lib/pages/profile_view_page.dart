import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tg_proj/misc/auth.dart';
import 'package:tg_proj/misc/firestore.dart';
import 'package:tg_proj/misc/global.dart';
import 'package:tg_proj/misc/emoji_text.dart';

class ProfileViewPage extends StatefulWidget {
  const ProfileViewPage({super.key});

  @override
  State<ProfileViewPage> createState() => _ProfileViewPageState();
}

class _ProfileViewPageState extends State<ProfileViewPage> {
  
 

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
                              const Text('300m | 700m')
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
                        const Text('300m | 700m')
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed:
                      Firestore.instance.createDocOnRegister,
                  child: const Text('reset db')),
              ElevatedButton(onPressed: signOut, child: const Text('sign out')),
              ElevatedButton(
                  onPressed: goToPhotoPage,
                  child: const Text('go to photo page')),
            ]));
  }
}
