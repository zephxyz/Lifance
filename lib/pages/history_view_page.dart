import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lifance/misc/global.dart';
import 'package:lifance/misc/geolocation.dart';
import 'package:lifance/misc/firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:lifance/pages/photo_details_page.dart';
import 'package:lifance/widgets/bottom_appbar_fab.dart';
import 'package:lifance/misc/challenge_state.dart';

import '../widgets/appbar.dart';
import '../widgets/bottom_appbar.dart';
import '../misc/photo_info.dart';

class HistoryViewPageMap extends StatefulWidget {
  const HistoryViewPageMap({super.key});

  @override
  State<HistoryViewPageMap> createState() => _HistoryViewPageMapState();
}

class _HistoryViewPageMapState extends State<HistoryViewPageMap> {
  List<Marker> markers = [];
  Position? pos;
  StreamSubscription<ChallengeState>? challengeStateListener;

  @override
  void initState() {
    super.initState();
    challengeStateListener =
        Global.instance.challengeStateStream.listen((event) {
      if (event == ChallengeState.completed) {
        context.go('/challengecompleted');
      }
    });
  }

  @override
  void dispose() {
    challengeStateListener?.cancel();
    super.dispose();
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
      appBar: const MyAppBar(),
      bottomNavigationBar: const MyBottomAppBar(
        currentPage: 2,
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
      floatingActionButton: const BottomAppbarFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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

  StreamSubscription<ChallengeState>? challengeStateListener;

  Future<void> getPhotos() async {
    photos = await Firestore.instance.getHistoryPhotos();
    setState(() {});
  }

  void zoomIn(int index) {
    final mySystemTheme = SystemUiOverlayStyle.dark
        .copyWith(systemNavigationBarColor: Colors.black);
    SystemChrome.setSystemUIOverlayStyle(mySystemTheme);
    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return PhotoDetailsPage(photoInfo: photos[index]);
        }));
  }

  List<Widget> getChildren() {
    List<Widget> children = [];

    for (int i = 0; i < photos.length; i++) {
      final photo = photos[i];

      children.add(
        GestureDetector(
            onTap: () => zoomIn(i),
            child: Image.file(
              File(photo.getPath),
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            )),
        //Text(DateFormat('yyyy-MM-dd').format(photo.getDate.toDate())),
      );
    }

    return children;
  }

  @override
  void initState() {
    super.initState();
    getPhotos();
    challengeStateListener =
        Global.instance.challengeStateStream.listen((event) {
      if (event == ChallengeState.completed) {
        context.go('/challengecompleted');
      }
    });
    
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
      bottomNavigationBar: const MyBottomAppBar(
        currentPage: 3,
      ),
      body: GridView(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        children: [for (var widget in getChildren()) widget],
      ),
      floatingActionButton: const BottomAppbarFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
