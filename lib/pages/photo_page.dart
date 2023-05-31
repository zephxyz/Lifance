import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tg_proj/misc/global.dart';
import 'package:tg_proj/misc/firestore.dart';
import 'package:flutter/services.dart';

class PhotoPage extends StatefulWidget {
  const PhotoPage({super.key});

  @override
  State<PhotoPage> createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  CameraController? controller;
  bool photoWasTaken = false;
  File file = File('');

  Future<void> initializeCamera() async {
    if (!photoWasTaken) {
      final cameras = await availableCameras();
      final mediaCamera = cameras.firstWhere((camera) => camera.name == '0',
          orElse: () => cameras.first);

      controller = CameraController(
        mediaCamera,
        ResolutionPreset.max,
        enableAudio: false,
      );

      await controller!.initialize();
    
      controller!.setFlashMode(FlashMode.off);
    }
  }

  @override
  void initState() {
    super.initState();
    final mySystemTheme = SystemUiOverlayStyle.light.copyWith(systemNavigationBarColor: Colors.black);
    SystemChrome.setSystemUIOverlayStyle(mySystemTheme);
  }

  @override
  void dispose() {
    final mySystemTheme = SystemUiOverlayStyle.light.copyWith(systemNavigationBarColor: Colors.white);
    SystemChrome.setSystemUIOverlayStyle(mySystemTheme);
    controller?.dispose();
    super.dispose();
  }

  void goToHome() {
    context.go('/');
  }

  Future<void> takePhoto() async {
    final image = await controller!.takePicture();
    setState(() {
      file = File(image.path);
      photoWasTaken = true;
    });
  }

  Future<void> confirmPhoto() async {
    final directory = await getApplicationDocumentsDirectory();
    final savedImagePath =
        '${directory.path}/ChallengePhotos/${file.path.split('/').last}';

    File newFile = File(savedImagePath);
    newFile.create(recursive: true);
    newFile.writeAsBytesSync(file.readAsBytesSync());
    file.deleteSync(recursive: true);
    await Firestore.instance.addChallengeToHistory(
        Global.instance.latToAdd,
        Global.instance.lngToAdd,
        Global.instance.distanceToAdd,
        savedImagePath);

    Global.instance.reset();

    goToHome();
  }

  Future<void> skipTakingPhoto() async {
    await Firestore.instance.addChallengeToHistory(Global.instance.latToAdd,
        Global.instance.lngToAdd, Global.instance.distanceToAdd, null);

    goToHome();
  }

  Future<void> discardPhoto() async {
    setState(() {
      photoWasTaken = false;
    });
    await file.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: initializeCamera(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              return Container(
                color: Colors.black,
                child: Stack(fit: StackFit.loose, children: [
                  photoWasTaken
                      ? Align(
                          alignment: Alignment.center, child: Image.file(file))
                      : Align(
                          alignment: Alignment.center,
                          child: CameraPreview(controller!)),
                  photoWasTaken
                      ? Align(
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                  onPressed: discardPhoto,
                                  style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(16),
                                      shape: const CircleBorder(),
                                      backgroundColor: Colors.red),
                                  child: const Icon(Icons.delete)),
                              ElevatedButton(
                                  onPressed: confirmPhoto,
                                  style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(16),
                                      shape: const CircleBorder(),
                                      backgroundColor: Colors.green),
                                  child: const Icon(Icons.check)),
                            ],
                          ))
                      : Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                  onPressed: takePhoto,
                                  style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    padding: const EdgeInsets.all(30.0),
                                  ),
                                  child: const Text("")),
                              Center(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  ElevatedButton(
                                      onPressed: skipTakingPhoto,
                                      style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.all(28),
                                          backgroundColor: Colors.black,),
                                      child: const Text('Skip'))
                                ],
                              )),
                            ],
                          )),
                ]),
              );
            }));
  }
}
