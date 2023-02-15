import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:tg_auth/misc/geolocation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LocationPermission? gps = LocationPermission.denied;
  Position? pos;

  Future<void> foo() async {
    gps = await Geolocation.instance.gpsPermission;
    pos = await Geolocation.instance.position;
  }

  Future<void> refreshBtn() async {
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: foo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(),
            body: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.white,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(
                        color: Color(0xff725ac1),
                        backgroundColor: Colors.white,
                      )
                    ])),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          if (gps == LocationPermission.denied ||
              gps == LocationPermission.unableToDetermine) {
            return Scaffold(
                appBar: AppBar(
                  title: const Text('Home'),
                ),
                body: SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("GPS PERMISSION REQUIRED TO SHOW MAP"),
                        const Text(
                            "This app requires permission to access GPS as the core elements cannot function without it",
                            textAlign: TextAlign.center),
                        const ElevatedButton(
                            onPressed: Geolocator.openAppSettings,
                            child: Text("Open app settings")),
                        const SizedBox(),
                        ElevatedButton(
                            onPressed: refreshBtn, child: const Text("Refresh"))
                      ],
                    )));
          } else if (gps == LocationPermission.deniedForever) {
            return Scaffold(
                appBar: AppBar(
                  title: const Text('Home'),
                ),
                body: SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("GPS PERMISSION DENIED FOREVER"),
                        const Text(
                            "This app requires permission to access GPS as the core elements cannot function without it",
                            textAlign: TextAlign.center),
                        const ElevatedButton(
                            onPressed: Geolocator.openAppSettings,
                            child: Text(
                              "Open app settings",
                            )),
                        const SizedBox(),
                        ElevatedButton(
                            onPressed: refreshBtn, child: const Text("Refresh"))
                      ],
                    )));
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text('Home'),
              
            ),
            //TODO: bottomNavigationBar: BottomAppBar(), 
            body: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Scaffold(
                body: FlutterMap(
                  options: MapOptions(
                      center: LatLng(pos?.latitude ?? 0,
                          pos?.longitude ?? 0), //pos!.latitude, pos!.longitude
                      zoom: 13.0,
                      minZoom: 2,
                      maxZoom: 18.3,
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
                ),
              ),
            ),
          );
        } else {
          return const Text("ERROR");
        }
      },
    );
  }
}
