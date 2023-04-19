
import 'package:flutter/material.dart';
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

  Timer? _timer;

  int minDist = 300;
  int maxDist = 700;

  Future<void> getPosition() async {
    pos = await Geolocation.instance.position;
  }

  Future<void> initiateChallenge() async {
    setState(() {
      daily = DistCalculator.instance.initiateChallenge(
          minDist, maxDist, LatLng(pos!.latitude, pos!.longitude));
      distance = DistCalculator.instance.getDist(
          Location(pos!.latitude, pos!.longitude),
          Location(daily.point.latitude, daily.point.longitude));
      _timer = Timer.periodic(const Duration(seconds: 10), (_) async {
        Position pos = await Geolocation.instance.position;
        if (DistCalculator.instance.checkDist(
            Location(pos.latitude, pos.longitude),
            Location(daily.point.latitude, daily.point.longitude))) {
          finishChallenge();
        }
      });
    });
  }

  Future<void> finishChallenge() async {
    _timer?.cancel();
    Firestore.instance.addChallengeToHistory(
        daily.point.latitude, daily.point.longitude, distance);
    setState(() {
      daily = Marker(point: LatLng(0, 0), builder: (context) => Container());
    });
  }

  void page(int index) {
    if (index == 1) return;
    if (index == 0) {
      context.go('/profileview');
    } else {
      context.go('/historyviewmap');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home', textAlign: TextAlign.center,),
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
          currentIndex: 1,
          unselectedItemColor: Colors.black,
          selectedItemColor:
              const Color(0xff725ac1), //,const Color(0xff8D86C9),
          onTap: page,
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
                        center: LatLng(
                            pos?.latitude ?? 0,
                            pos?.longitude ??
                                0), //pos!.latitude, pos!.longitude
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
                      CurrentLocationLayer(),
                      MarkerLayer(
                        markers: [daily],
                      )
                    ],
                  );
                }
              }),
          Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Center(
                    child: ElevatedButton(
                  onPressed: initiateChallenge,
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(12.0),
                  ),
                  child: const Text('start'),
                ))
              ])
        ]));
  }
}
