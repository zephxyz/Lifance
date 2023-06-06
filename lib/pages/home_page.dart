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
  Marker daily = Marker(point: LatLng(0, 0), builder: (context) => Container());
  int distance =
      DistCalculator.instance.getDist(Location(0, 0), Location(0, 0));
  String displayDistance = '';
  bool isAlreadyStarted = false;
  double chalLat = 0;
  double chalLng = 0;

  Timer? _timer;

  final int minDist = 0;
  final int maxDist = 50;

  Future<void> getPosition() async {
    pos = await Geolocation.instance.position;

    distance = DistCalculator.instance.getDist(
        Location(pos!.latitude, pos!.longitude), Location(chalLat, chalLng));
  }

  Future<void> getChallengeIfAlreadyStarted() async {
    final challenge = await Firestore.instance.getChallengePending();
    if (challenge != null) {
      pos = await Geolocation.instance.position;
      setState(() {
        chalLat = challenge['lat'];
        chalLng = challenge['lng'];
        daily = Marker(
            point: LatLng(chalLat, chalLng),
            builder: (context) =>
                const Icon(Icons.room, color: Colors.red, size: 25));
        isAlreadyStarted = true;
        

        _timer = Timer.periodic(const Duration(seconds: 10), (_) async {
          Position pos = await Geolocation.instance.position;
          int temp = DistCalculator.instance.getDist(
              Location(pos.latitude, pos.longitude),
              Location(challenge['lat'], challenge['lng']));
          if (temp <= 50) {
            await finishChallenge();
          }
          displayDistance = "${temp.toString()}m";
        }
        );
        
      });
    } else {
      setState(() {});
    }
  }

  Future<void> initiateChallenge() async {
    if (await Firestore.instance.isChallengePending()) return;
    Marker temp = DistCalculator.instance.initiateChallenge(
        minDist, maxDist, LatLng(pos!.latitude, pos!.longitude));
    await Firestore.instance.onChallengeStart(
        GeoPoint(temp.point.latitude, temp.point.longitude),
        GeoPoint(pos!.latitude, pos!.longitude));
    setState(() {
      isAlreadyStarted = true;
      daily = temp;
      distance = DistCalculator.instance.getDist(
          Location(pos!.latitude, pos!.longitude),
          Location(daily.point.latitude, daily.point.longitude));
      displayDistance = "${distance.toString()}m";
      _timer = Timer.periodic(const Duration(seconds: 1), (_) async {
        Position pos = await Geolocation.instance.position;
        int temp = DistCalculator.instance.getDist(
            Location(pos.latitude, pos.longitude),
            Location(daily.point.latitude, daily.point.longitude));
        if (temp <= 50) {
          await finishChallenge();
        }
        displayDistance = "${temp.toString()}m";
      });
    });
  }

  //

  Future<void> finishChallenge() async {
    _timer?.cancel();
    Global.instance.latToAdd = daily.point.latitude;
    Global.instance.lngToAdd = daily.point.longitude;
    Global.instance.distanceToAdd = DistCalculator.instance.getDist(
        Location(pos!.latitude, pos!.longitude),
        Location(daily.point.latitude, daily.point.longitude));

    context.go('/photopage');
  }

  void handleRedirection(int index) {
    if (index == 1) return;
    if (index == 0) {
      context.go('/profileview');
    } else {
      context.go('/historyviewmap');
    }
  }

  @override
  void initState() {
    super.initState();
    Firestore.instance.onFirstLogin();
    Firestore.instance.checkStreak();
    getChallengeIfAlreadyStarted();

    final mySystemTheme = SystemUiOverlayStyle.light
        .copyWith(systemNavigationBarColor: Colors.white);
    SystemChrome.setSystemUIOverlayStyle(mySystemTheme);
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
          currentIndex: 1,
          unselectedItemColor: Colors.black,
          selectedItemColor:
              const Color(0xff725ac1), //,const Color(0xff8D86C9),
          onTap: handleRedirection,
          backgroundColor: Colors.white,
        ),
        body: Stack(children: [
          FutureBuilder(
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
                      maxBounds: LatLngBounds(
                          LatLng(-90, -180.0), LatLng(90.0, 180.0)),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: const ['a', 'b', 'c'],
                      ),
                      CurrentLocationLayer(),
                      MarkerLayer(
                        markers: [daily],
                      )
                    ],
                  );
                }
              }),
          Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: initiateChallenge,
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(12.0),
                ),
                child: isAlreadyStarted
                    ? Text(displayDistance)
                    : const Text('start'),
              ))
        ]));
  }
}
