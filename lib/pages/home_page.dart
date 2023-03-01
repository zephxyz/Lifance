import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:tg_proj/misc/geolocation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:tg_proj/pages/historyViewPage.dart';
import 'package:tg_proj/pages/profileViewPage.dart';
import 'package:tg_proj/misc/dist_calc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Position? pos;
  int pageIndex = 1;
  String testText = " ";

  Future<void> getPosition() async {
    pos = await Geolocation.instance.position;
  }

  void page(int index) {
    if (pageIndex == 3 && index == 3) {
      setState(() {
        pageIndex = 4;
      });
      return;
    }
    setState(() {
      pageIndex = index;
    });
  }

  Future<void> lol() async {
    LatLng chalLatLng =
        DistCalculator(300, 700, LatLng(pos!.latitude, pos!.longitude))
            .calculate();
    setState(() {
      testText = "${pos!.latitude} ${pos!.longitude} | ${chalLatLng.latitude} ${chalLatLng.longitude}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
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
          currentIndex: pageIndex == 4 ? 3 : pageIndex,
          unselectedItemColor: Colors.black,
          selectedItemColor:
              const Color(0xff725ac1), //,const Color(0xff8D86C9),
          onTap: page,
        ),
        body: pageIndex == 1
            ? FutureBuilder(
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
                          zoom: 13.0,
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
                      ],
                    );
                  }
                })
            : pageIndex == 0
                ? ElevatedButton(onPressed: lol, child: Text(testText))
                : pageIndex == 2
                    ? const HistoryViewPageMap()
                    : const HistoryViewPagePhotos());
  }
}
