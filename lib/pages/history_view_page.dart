import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tg_proj/misc/global.dart';
import 'package:tg_proj/misc/geolocation.dart';
import 'package:tg_proj/misc/firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/services.dart';

import '../misc/emoji_text.dart';

class HistoryViewPageMap extends StatefulWidget {
  const HistoryViewPageMap({super.key});

  @override
  State<HistoryViewPageMap> createState() => _HistoryViewPageMapState();
}

class _HistoryViewPageMapState extends State<HistoryViewPageMap> {
  List<Marker> markers = [];
  Position? pos;
  void page(int index) {
    if (index == 2) return;
    if (index == 0) {
      context.go('/profileview');
    } else {
      context.go('/');
    }
  }

  Future<void> getHistory() async {
    markers = await Firestore.instance.getHistoryMarkers();
  }

  Future<void> getPosition() async {
    pos = await Geolocation.instance.position;
    await getHistory();
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
          currentIndex: 2,
          unselectedItemColor: Colors.black,
          selectedItemColor:
              const Color(0xff725ac1), //,const Color(0xff8D86C9),
          onTap: page,
        ),
        body: FutureBuilder(
            future: getPosition(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return FlutterMap(
                  options: MapOptions(
                      center: LatLng(pos?.latitude ?? 0,
                          pos?.longitude ?? 0), //pos!.latitude, pos!.longitude
                      zoom: 15.0,
                      minZoom: 2,
                      maxZoom: 18.3,
                      keepAlive: true,
                      interactiveFlags:
                          InteractiveFlag.all & ~InteractiveFlag.rotate,
                      maxBounds: LatLngBounds(
                          LatLng(-90, -180.0), LatLng(90.0, 180.0))),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: const ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: markers,
                    )
                  ],
                );
              }
            }));
  }
}

class HistoryViewPagePhotos extends StatelessWidget {
  const HistoryViewPagePhotos({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView();
  }
}
