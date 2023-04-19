import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:go_router/go_router.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

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

  Future<void> confirmPhoto() async {
    final success =
        await GallerySaver.saveImage(file.path, albumName: 'Lifeance');
    if (success ?? false) { 
    final directory = await getExternalStorageDirectory();
    final savedImagePath = '${directory?.path}/Lifeance/${file.path.split('/').last}';
    print('Image saved to $savedImagePath');
    goToHome();
  }
  }

  Future<void> discardPhoto() async {
    setState(() {
      photoWasTaken = false;
    });
    file.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Photo Page')),
        body: FutureBuilder(
            future: initializeCamera(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              return Stack(children: [
                ElevatedButton(
                    onPressed: goToHome, child: const Text("go to home")),
                /*Expanded(
                  child: display ?? const Text("No camera found"),
                ),*/
                photoWasTaken
                    ? Row(
                        children: [
                          ElevatedButton(
                              onPressed: confirmPhoto,
                              child: const Text('Confirm')),
                          ElevatedButton(
                              onPressed: discardPhoto,
                              child: const Text('discard'))
                        ],
                      )
                    : ElevatedButton(
                        onPressed: takePhoto, child: const Text("Take photo")),
                        Image.file(File('/storage/Pictures/Lifeance/CAP1208535272532780813.jpg'))
              ]);
            }));
  }
}