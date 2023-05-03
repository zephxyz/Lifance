import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tg_proj/misc/global.dart';
import 'package:tg_proj/misc/firestore.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class PhotoPage extends StatefulWidget {
  const PhotoPage({super.key});

  @override
  State<PhotoPage> createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  CameraController? controller;
  bool photoWasTaken = false;
  File file = File('');

  Widget? display;

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
    photoWasTaken
        ? display = Image.file(file)
        : display = CameraPreview(controller!);
  }

  @override
  void dispose() {
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

  Future<void> addChallengeToHistory(File newFile, String savedPath) async {
    //final Uint8List imagebytes = await compressFile(file);

    //final String base64string = base64.encode(imagebytes);

    await Firestore.instance.addChallengeToHistory(Global.instance.latToAdd,
        Global.instance.lngToAdd, Global.instance.distanceToAdd, /*base64string*/null, savedPath);

    Global.instance.reset();
  }

  Future<void> confirmPhoto() async {
    final directory = await getApplicationDocumentsDirectory();
    final savedImagePath =
        '${directory.path}/ChallengePhotos/${file.path.split('/').last}';

    File newFile = File(savedImagePath);
    newFile.create(recursive: true);
    newFile.writeAsBytesSync(file.readAsBytesSync());

    addChallengeToHistory(newFile, savedImagePath);
    file.deleteSync(recursive: true);
    goToHome();
  }

  Future<void> skip() async {
    await Firestore.instance.addChallengeToHistory(Global.instance.latToAdd,
        Global.instance.lngToAdd, Global.instance.distanceToAdd, null, null);

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
        appBar: AppBar(
            title: ElevatedButton(onPressed: skip, child: const Text('Skip'))),
        body: FutureBuilder(
            future: initializeCamera(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              return Stack(children: [
                ElevatedButton(
                    onPressed: goToHome, child: const Text("go to home")),
                Expanded(
                  flex: 0,
                  child: display ?? const Text("No camera found"),
                ),
                photoWasTaken
                    ? Row(
                        //TODO: position buttons on the bottom side of the screen just like the "take photo" button, fill whitespace under photo preview, position skipbutton in the center of the appbar
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                              onPressed: confirmPhoto,
                              style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  backgroundColor: Colors.green),
                              child: const Text("")),
                          ElevatedButton(
                              onPressed: discardPhoto,
                              style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  backgroundColor: Colors.red),
                              child: const Text(""))
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                            Center(
                                child: ElevatedButton(
                                    onPressed: takePhoto,
                                    style: ElevatedButton.styleFrom(
                                      shape: const CircleBorder(),
                                      padding: const EdgeInsets.all(30.0),
                                    ),
                                    child: const Text(""))),
                          ])
              ]);
            }));
  }
}
