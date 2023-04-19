import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';

class GetPermissionPage extends StatefulWidget {
  const GetPermissionPage({super.key});

  @override
  State<GetPermissionPage> createState() => _GetPermissionPageState();
}

class _GetPermissionPageState extends State<GetPermissionPage> {
  LocationPermission? gps = LocationPermission.denied;

  bool isDeniedForever = false;

  void goToHome() {
    context.go('/');
  }

  Future<void> openPermSettings() async {
    Geolocator.openAppSettings();
    LocationPermission locPerm = await Geolocator.checkPermission();
    switch (locPerm) {
      case LocationPermission.always:
        if (isDeniedForever) isDeniedForever = !isDeniedForever;
        goToHome();
        break;
      case LocationPermission.whileInUse:
        if (isDeniedForever) isDeniedForever = !isDeniedForever;
        goToHome();
        break;
      case LocationPermission.deniedForever:
        isDeniedForever = true;
        break;
      default:
        break;
    }
  }

  Future<void> requestPermission() async {
    LocationPermission locPerm = await Geolocator.requestPermission();
    switch (locPerm) {
      case LocationPermission.always:
        if (isDeniedForever) isDeniedForever = !isDeniedForever;
        goToHome();
        break;
      case LocationPermission.whileInUse:
        if (isDeniedForever) isDeniedForever = !isDeniedForever;
        goToHome();
        break;
      case LocationPermission.deniedForever:
        isDeniedForever = true;
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return isDeniedForever
        ? Scaffold(
            appBar: AppBar(),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('This app requires GPS permission to run properly.',
                    textAlign: TextAlign.center),
                Center(
                    child: ElevatedButton(
                  onPressed: requestPermission,
                  child: const Text('Grant permission'),
                ))
              ],
            ),
          )
        : Scaffold(
            appBar: AppBar(),
            body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                      'GPS permission denied forever. This app requires GPS permission to run properly.',
                      textAlign: TextAlign.center),
                  Center(
                      child: ElevatedButton(
                    onPressed: openPermSettings,
                    child: const Text('Open app settings'),
                  ))
                ]));
  }
}
