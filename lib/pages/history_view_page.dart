import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tg_proj/misc/global.dart';

import '../misc/emoji_text.dart';

class HistoryViewPageMap extends StatefulWidget {
  const HistoryViewPageMap({super.key});

  @override
  State<HistoryViewPageMap> createState() => _HistoryViewPageMapState();
}

class _HistoryViewPageMapState extends State<HistoryViewPageMap> {
  void page(int index) {
    if (index == 2) return;
    if (index == 0) {
      context.go('/profileview');
    } else {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text("${Global.instance.streak}"),
              const EmojiText(text: '🔥')
            ]),
            const Text(' '),
            const Text('300m | 700m')
          ]),
        ),
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
          currentIndex: 2,
          unselectedItemColor: Colors.black,
          selectedItemColor:
              const Color(0xff725ac1), //,const Color(0xff8D86C9),
          onTap: page,
        ),
        body: Container());
  }
}

class HistoryViewPagePhotos extends StatelessWidget {
  const HistoryViewPagePhotos({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
