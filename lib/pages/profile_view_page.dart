import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tg_proj/misc/auth.dart';
import 'package:tg_proj/misc/geolocation.dart';
import 'package:tg_proj/misc/firestore.dart';
import 'package:camera/camera.dart';

class ProfileViewPage extends StatefulWidget {
  const ProfileViewPage({super.key});

  @override
  State<ProfileViewPage> createState() => _ProfileViewPageState();
}

class _ProfileViewPageState extends State<ProfileViewPage> {
  String testText = '';
  Position? pos;
  CameraController controller = CameraController(
      const CameraDescription(
          name: '0',
          lensDirection: CameraLensDirection.back,
          sensorOrientation: 0),
      ResolutionPreset.high);

  File imageFile =
      File('/data/user/0/com.example.tg_auth/cache/CAP4665657332330325940.jpg');

  Future<void> getPosition() async {
    pos = await Geolocation.instance.position;
  }

  @override
  void initState() {
    super.initState();
    controller.initialize();
  }

  Future<void> signOut() async {
    await Auth.instance.signOut();
    goToLogin();
  }

  Future<void> openCamera() async {
    final XFile image = await controller.takePicture();
    setState(() {
      imageFile = File(image.path);
      
    });


    // Do something with the captured image
    print('Image captured: ${image.path}');
  }

  void goToLogin() {
    context.go('/auth');
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
                        onPressed: Firestore
                            .instance.createDocOnRegister /*getChalLoc*/,
                        child: Text(testText)),
                    ElevatedButton(
                        onPressed: signOut, child: const Text('sign out')),
                    ElevatedButton(
                        onPressed: openCamera, child: const Text('take photo')),
                    Image.file(
                      imageFile,
                      width: 200,
                      height: 200,
                      alignment: Alignment.center,
                    ),
                    CameraPreview(controller)
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
