import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:tg_proj/misc/dist_calc.dart';
import 'package:tg_proj/misc/geolocation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import 'package:haversine_distance/haversine_distance.dart';
import 'package:tg_proj/misc/firestore.dart';
import 'package:tg_proj/misc/global.dart';
import 'package:tg_proj/misc/emoji_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Position? pos;
  Marker challengeMarker = Global.instance.challengeMarker;
  StreamSubscription<int>? challengeStateStream;

  final int minDist = 0;
  final int maxDist = 50;

  Future<void> getPosition() async {
    pos = await Geolocation.instance.position;
    if (Global.instance.isChallengeStarted) {
      Global.instance.challenge.distance = DistCalculator.instance.getDist(
          Location(pos?.latitude ?? 0, pos?.longitude ?? 0),
          Location(
              Global.instance.challenge.lat, Global.instance.challenge.lng));
    }
  }

  Future<void> initiateChallenge() async {
    if (await Firestore.instance.isChallengePending()) return;
    pos = await Geolocation.instance.position;

    Global.instance.challenge = DistCalculator.instance.initiateChallenge(
        minDist, maxDist, LatLng(pos!.latitude, pos!.longitude));
    await Firestore.instance.onChallengeStart(
        GeoPoint(Global.instance.challenge.lat, Global.instance.challenge.lng),
        GeoPoint(pos!.latitude, pos!.longitude),
        Global.instance.challenge.totalDistance);

    Global.instance.isChallengeStarted = true;
    Global.instance.challenge.distance = DistCalculator.instance.getDist(
        Location(pos!.latitude, pos!.longitude),
        Location(Global.instance.challenge.lat, Global.instance.challenge.lng));
    Global.instance.startTimer();

    setState(() {
      challengeMarker = Global.instance.challengeMarker;
    });
  }

  void handleRedirection(int index) {
    switch (index) {
      case 0:
        context.go('/profileview');
        break;
      case 1:
        return;
      case 2:
        context.go('/historyviewmap');
        break;
      case 3:
        context.go('/historyviewphotos');
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    Global.instance.onStart();

    challengeStateStream =
        Global.instance.challengeStateStream.listen((event) async {
      if (event == 1) {
        context.go("/photopage");
      }
    });

    final mySystemTheme = SystemUiOverlayStyle.light
        .copyWith(systemNavigationBarColor: Colors.white);
    SystemChrome.setSystemUIOverlayStyle(mySystemTheme);
  }

  @override
  void dispose() {
    challengeStateStream?.cancel();
    super.dispose();
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
                            GestureDetector(
                              onTap: () => showDialog(
                                  context: context,
                                  builder: (context) => const AlertDialog(
                                        title: Text("Streak"),
                                        content: Text(
                                            "This is your streak.\n\nA streak is a continuous series of challenges completed on consecutive days.\n\nBy completing challenges day after day, you can increase your streak."),
                                      )),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const EmojiText(text: '🔥'),
                                    Text(" ${Global.instance.streak}", style: const TextStyle(fontSize: 14),),
                                  ]),
                            ),
                            const Text(' '),
                            GestureDetector(
                                onTap: () => showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: const Text("Radius"),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                            "This is the radius the challenge goal can be generated in."), const SizedBox(height: 20,), Image.asset("assets/img/radius.png", alignment: Alignment.center), const SizedBox(height: 20,), const Text("The first value is the minimum distance between you and the challenge goal and the last value is the maximum distance between you and the challenge goal.")
                                            //"),
                                ]))),
                                child: Row(
                                  children: [
                                    const Icon(Icons.blur_circular),
                                    Text(
                                      Global.instance.radiusText,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ))
                          ]);
                    }
                  },
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                      GestureDetector(
                        onTap: () => showDialog(
                            context: context,
                            builder: (context) => const AlertDialog(
                                  title: Text("Streak"),
                                  content: Text(
                                      "This is your streak.\n\nA streak is a continuous series of challenges completed on consecutive days.\n\nBy completing challenges day after day, you can increase your streak."),
                                )),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const EmojiText(text: '🔥'),
                              Text(
                                " ${Global.instance.streak}",
                                style: const TextStyle(fontSize: 14),
                              )
                            ]),
                      ),
                      const Text(' '),
                      GestureDetector(
                          onTap: () => showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: const Text("Radius"),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                            "This is the radius the challenge goal can be generated in."), const SizedBox(height: 20,), Image.asset("assets/img/radius.png", alignment: Alignment.center,), const SizedBox(height: 20,), const Text("The first value is the minimum distance between you and the challenge goal and the last value is the maximum distance between you and the challenge goal.")
                                            //"),
                                ]))),
                          child: Row(
                            children: [
                              const Icon(Icons.blur_circular),
                              Text(
                                Global.instance.radiusText,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ))
                    ])),
      bottomNavigationBar: BottomAppBar(
          child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
            Tooltip(
              message: "Profile",
              child: IconButton(
                icon: const Icon(
                  Icons.person,
                  color: Colors.black,
                ),
                color: Colors.white,
                onPressed: () => handleRedirection(0),
              ),
            ),
            Tooltip(
              message: "Home",
              child: IconButton(
                icon: const Icon(
                  Icons.home,
                  color: Color(0xff725ac1),
                ),
                color: Colors.white,
                onPressed: () => handleRedirection(1),
              ),
            ),
            Tooltip(
              message: "History",
              child: IconButton(
                  icon: const Icon(
                    Icons.timeline,
                    color: Colors.black,
                  ),
                  color: Colors.white,
                  onPressed: () => handleRedirection(2)),
            ),
            Tooltip(
              message: "Photos",
              child: IconButton(
                  icon: const Icon(
                    Icons.photo,
                    color: Colors.black,
                  ),
                  color: Colors.white,
                  onPressed: () => handleRedirection(3)),
            )
          ])),
      body: FutureBuilder(
          future: getPosition(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Color(0xff725ac1),
                backgroundColor: Colors.white,
              ));
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
                  maxBounds:
                      LatLngBounds(LatLng(-90, -180.0), LatLng(90.0, 180.0)),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: const ['a', 'b', 'c'],
                  ),
                  CurrentLocationLayer(),
                  MarkerLayer(
                    markers: [challengeMarker],
                  )
                ],
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
          tooltip: Global.instance.isChallengeStarted
              ? "Remaining distance"
              : "Initiate challenge",
          onPressed:
              Global.instance.isChallengeStarted ? null : initiateChallenge,
          child: Global.instance.isChallengeStarted
              ? Text(Global.instance.displayDistance)
              : const Icon(Icons.bolt)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
