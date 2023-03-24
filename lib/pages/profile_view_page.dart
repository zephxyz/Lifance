import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:tg_proj/misc/dist_calc.dart';
import 'package:tg_proj/auth.dart';
import 'package:tg_proj/misc/geolocation.dart';
import 'package:haversine_distance/haversine_distance.dart';

class ProfileViewPage extends StatefulWidget {
  const ProfileViewPage({super.key});

  @override
  State<ProfileViewPage> createState() => _ProfileViewPageState();
}

class _ProfileViewPageState extends State<ProfileViewPage> {
  String testText = '';
  Position? pos;

  Future<void> getPosition() async {
    pos = await Geolocation.instance.position;
  }

  Future<void> signOut() async {
    await Auth.instance.signOut();
    goToLogin();
  }

  void goToLogin() {
    context.go('/auth');
  }

  Future<void> getChalLoc() async {
    //debug
    pos = await Geolocation.instance.position;
    
    int dist = 0;
    do {
      LatLng chalLatLng = DistCalculator.instance
          .calculate(300, 701, LatLng(pos!.latitude, pos!.longitude));
      final start = Location(pos!.latitude, pos!.longitude);
      final end = Location(chalLatLng.latitude, chalLatLng.longitude);
      dist =
          HaversineDistance().haversine(start, end, Unit.METER).floor();
      setState(() {
      testText =
          "${pos!.latitude} ${pos!.longitude} | ${chalLatLng.latitude} ${chalLatLng.longitude} ${dist}";
    });
    } while (dist < 350);
    
  }

  void page(int index) {
    if (index == 0) return;
    if (index == 1) {
      context.go('/');
    } else {
      context.go('/historyviewmap');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile View'),
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
          currentIndex: 0,
          unselectedItemColor: Colors.black,
          selectedItemColor:
              const Color(0xff725ac1), //,const Color(0xff8D86C9),
          onTap: page,
        ),
        body: FutureBuilder(
          //TEMPORARY FOR DEBUG PURPOSES
          future: getPosition(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: getChalLoc, child: Text(testText)),
                    ElevatedButton(
                        onPressed: signOut, child: const Text('sign out'))
                  ]);
            } else {
              return const Center(
                  child: CircularProgressIndicator(
                color: Color(0xff725ac1),
                backgroundColor: Colors.white,
              ));
            }
          },
        ));
  }
}
