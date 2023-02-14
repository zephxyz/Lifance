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
  LocationPermission? gpsPermission;
  Position? position;

  @override
  void initState() {
    foo();
  }

  Future<void> foo() async {
    LocationPermission gps = await Geolocation().turnOnServices();
    Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      gpsPermission = gps;
      position = pos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Scaffold(
          body: FlutterMap(
            options: MapOptions(
                center: LatLng(position.latitude, position.longitude),
                zoom: 13.0,
                minZoom: 2,
                maxZoom: 18.3,
                interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                maxBounds:
                    LatLngBounds(LatLng(-90, -180.0), LatLng(90.0, 180.0))),
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
  }
}
