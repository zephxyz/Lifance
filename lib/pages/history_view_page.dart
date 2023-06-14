import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tg_proj/misc/global.dart';
import 'package:tg_proj/misc/geolocation.dart';
import 'package:tg_proj/misc/firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../misc/emoji_text.dart';
import '../misc/photo_info.dart';

class HistoryViewPageMap extends StatefulWidget {
  const HistoryViewPageMap({super.key});

  @override
  State<HistoryViewPageMap> createState() => _HistoryViewPageMapState();
}

class _HistoryViewPageMapState extends State<HistoryViewPageMap> {
  List<Marker> markers = [];
  Position? pos;
  StreamSubscription<int>? challengeStateStream;
  
  @override
  void initState() {
    super.initState();
    challengeStateStream = Global.instance.challengeStateStream.listen((event) {
      if(event == 1) {
        context.go('/photopage');
      }
    });
  }

  void handleRedirection(int index) {
    if (index == 2) return;
    if (index == 0) {
      context.go('/profileview');
    } else {
      context.go('/');
    }
  }

  Future<void> getHistoryMarkers() async {
    markers = await Firestore.instance.getHistoryMarkers();
  }

  Future<void> getPosition() async {
    pos = await Geolocation.instance.position;
    await getHistoryMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Global.instance.streak == -1
              ? FutureBuilder(
                  future: Global.instance.fetchStreak(),
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
                                "${300 + Global.instance.streak}m | ${700 + Global.instance.streak}m")
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
                          "${300 + Global.instance.streak}m | ${700 + Global.instance.streak}m")
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
        selectedItemColor: const Color(0xff725ac1), //,const Color(0xff8D86C9),
        onTap: handleRedirection,
        backgroundColor: Colors.white,
      ),
      body: Stack(children: [
        FutureBuilder(
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
            }),
      ]),
      
    );
  }
}

class HistoryViewPagePhotos extends StatefulWidget {
  const HistoryViewPagePhotos({super.key});

  @override
  State<HistoryViewPagePhotos> createState() => _HistoryViewPagePhotosState();
}

class _HistoryViewPagePhotosState extends State<HistoryViewPagePhotos> {
  List<PhotoInfo> photos = [];

  StreamSubscription<int>? challengeStateStream;

  void handleRedirection(int index) {
    if (index == 2) return;
    if (index == 0) {
      context.go('/profileview');
    } else {
      context.go('/');
    }
  }

  Future<void> getPhotos() async {
    photos = await Firestore.instance.getHistoryPhotos();
    setState(() {});
  }

  List<Widget> getChildren() {
    List<Widget> children = [];

    for (int i = 0; i < photos.length; i++) {
      final photo = photos[i];

     children.add(
        GestureDetector(
            onTap: () => print("success$i"),
            child: Image.file(File(photo.getPath), height: 100, width: 100, fit: BoxFit.cover,)),
        //Text(DateFormat('yyyy-MM-dd').format(photo.getDate.toDate())),
      );

      
      }

    return children;
  }

  @override
  void initState() {
    super.initState();
    getPhotos();
    challengeStateStream = Global.instance.challengeStateStream.listen((event) {
      if(event == 1) {
        context.go('/photopage');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Global.instance.streak == -1
              ? FutureBuilder(
                  future: Global.instance.fetchStreak(),
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
                                "${300 + Global.instance.streak}m | ${700 + Global.instance.streak}m")
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
                          "${300 + Global.instance.streak}m | ${700 + Global.instance.streak}m")
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
        selectedItemColor: const Color(0xff725ac1), //,const Color(0xff8D86C9),
        onTap: handleRedirection,
        backgroundColor: Colors.white,
      ),
      body: GridView(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        children: [
          for (var widget in getChildren()) widget
        ],
      ),
    );
  }
}
