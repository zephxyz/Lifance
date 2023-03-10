import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tg_proj/misc/geolocation.dart';
import 'package:geolocator/geolocator.dart';

class GetPermissionPage extends StatefulWidget {
  const GetPermissionPage({super.key});

  @override
  State<GetPermissionPage> createState() => _GetPermissionPageState();
}

class _GetPermissionPageState extends State<GetPermissionPage> {
  LocationPermission? gps = LocationPermission.denied;

  Future<void> refreshBtn() async {
    setState(() {});
  }

  Future<void> getPermission() async {
    gps = await Geolocation.instance.gpsPermission;
  }

  Future<void> goToHome() async {
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getPermission(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Scaffold(
                body: Center(
                    child: CircularProgressIndicator(
              color: Color(0xff725ac1),
              backgroundColor: Colors.white,
            )));
          } else {
            if (gps == LocationPermission.denied ||
                gps == LocationPermission.unableToDetermine) {
              return Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    title: const Text('Home'),
                  ),
                  body: Column(
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
                  ));
            } else if (gps == LocationPermission.deniedForever) {
              return Scaffold(
                  appBar: AppBar(
                    title: const Text('Home'),
                  ),
                  body: Column(
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
                  ));
            } else {
              return Center(
                // TODO: make this automatic
                child: ElevatedButton(
                    onPressed: goToHome, child: const Text('Continue')),
              );
            }
          }
        });
  }
}
