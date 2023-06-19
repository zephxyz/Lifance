import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:lifance/misc/challenge_state.dart';
import 'package:lifance/misc/firestore.dart';
import 'package:lifance/widgets/bottom_appbar_fab.dart';
import 'package:lifance/misc/dist_calc.dart';
import 'package:lifance/misc/geolocation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import 'package:haversine_distance/haversine_distance.dart';
import 'package:lifance/misc/global.dart';
import '../widgets/appbar.dart';
import '../widgets/bottom_appbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Position? pos;
  Marker challengeMarker = Global.instance.challengeMarker;
  StreamSubscription<ChallengeState>? challengeStateListener;

  Future<void> getPosition() async {
    pos = await Geolocation.instance.position;
    if (Global.instance.isChallengeStarted) {
      Global.instance.challenge.distance = DistCalculator.instance.getDist(
          Location(pos?.latitude ?? 0, pos?.longitude ?? 0),
          Location(
              Global.instance.challenge.lat, Global.instance.challenge.lng));
    }
  }

  Future<void> refreshChallenge() async {
    await DistCalculator.instance.refreshChallenge();
  }

  Future<void> abandonChallenge() async {
    await Firestore.instance.onChallengeAbandon();
    Global.instance.abandonChallenge();
  }

  @override
  void initState() {
    super.initState();
    Global.instance.onStart();

    challengeStateListener =
        Global.instance.challengeStateStream.listen((event) async {
      if (event == ChallengeState.completed) {
        context.go("/challengecompleted");
      } else if (event == ChallengeState.ongoingStateChanged) {
        setState(() {
          challengeMarker = Global.instance.challengeMarker;
        });
      }
    });

    final mySystemTheme = SystemUiOverlayStyle.light
        .copyWith(systemNavigationBarColor: Colors.white);
    SystemChrome.setSystemUIOverlayStyle(mySystemTheme);
  }

  @override
  void dispose() {
    challengeStateListener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      bottomNavigationBar: const MyBottomAppBar(currentPage: 1),
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
                  ),
                  if (Global.instance.isChallengeStarted)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FloatingActionButton(
                            onPressed: () => showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Refresh challenge"),
                                  content: const Text(
                                      "This allows you to refresh the location goal of the challenge.\n\nShould be used only if the location is unreachable."),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("Cancel")),
                                    TextButton(
                                        onPressed: () {
                                          refreshChallenge();
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("Refresh")),
                                  ],
                                );
                              },
                            ),
                            mini: true,
                            child: const Icon(Icons.refresh),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FloatingActionButton(
                            onPressed: () => showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Abandon challenge"),
                                    content: const Text(
                                        "Are you sure you want to abandon this challenge? Once a challenge is abandoned, you cannot return to it."),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("Cancel")),
                                      TextButton(
                                          onPressed: () {
                                            abandonChallenge();
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("Abandon", style: TextStyle(color: Colors.red),)),
                                    ],
                                  );
                                }),
                            backgroundColor: Colors.red,
                            mini: true,
                            child: const Icon(Icons.close),
                          ),
                        ),
                      ],
                    )
                ],
              );
            }
          }),
      floatingActionButton: const BottomAppbarFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
