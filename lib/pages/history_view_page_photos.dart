import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lifance/misc/challenge_state.dart';
import 'package:lifance/misc/firestore.dart';
import 'package:lifance/misc/global.dart';
import 'package:lifance/misc/photo_info.dart';
import 'package:lifance/pages/photo_details_page.dart';
import 'package:lifance/widgets/appbar.dart';
import 'package:lifance/widgets/bottom_appbar.dart';
import 'package:lifance/widgets/bottom_appbar_fab.dart';
import 'package:lifance/misc/firebase_storage.dart';

class HistoryViewPagePhotos extends StatefulWidget {
  const HistoryViewPagePhotos({super.key});

  @override
  State<HistoryViewPagePhotos> createState() => _HistoryViewPagePhotosState();
}

class _HistoryViewPagePhotosState extends State<HistoryViewPagePhotos> {
  List<PhotoInfo> photos = [];
  List<PhotoInfo> downloadablePhotos = [];
  bool downloading = false;

  StreamSubscription<ChallengeState>? challengeStateListener;

  Future<void> getPhotos() async {
    photos = await Firestore.instance.getHistoryPhotos();
    setState(() {});
  }

  void zoomIn(int index) {
    final mySystemTheme = SystemUiOverlayStyle.dark
        .copyWith(systemNavigationBarColor: Colors.black);
    SystemChrome.setSystemUIOverlayStyle(mySystemTheme);
    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return PhotoDetailsPage(photoInfo: photos[index]);
        }));
  }

  List<Widget> getChildren() {
    List<Widget> children = [];

    for (int i = 0; i < photos.length; i++) {
      final photo = photos[i];
      final file = File(photo.getPath);

      if (!file.existsSync()) {
        downloadablePhotos.add(photo);
        continue;
      }

      children.add(
        GestureDetector(
            onTap: () => zoomIn(i),
            child: Image.file(
              file,
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            )),
        //Text(DateFormat('yyyy-MM-dd').format(photo.getDate.toDate())),
      );
    }
    if (downloadablePhotos.isNotEmpty && downloading == false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDownloadableDialog();
      });
    }
    return children;
  }

  String text() {
    String a = "";
    for (var photo in downloadablePhotos) {
      a = a + photo.getPath;
    }
    return a;
  }

  Future<void> showDownloadableDialog() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Download photos"),
            content: Text(
                "${downloadablePhotos.length} photos were not located on your device but are stored in the cloud. Would you like to download them now?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("No")),
              TextButton(
                  onPressed: () async {
                    for (final photo in downloadablePhotos) {
                      await FbStorage.instance.downloadImage(photo.getUrl,
                          photo.getPath.split('/').last, photo.getIndex);
                    }
                    popDialog();
                    setState(() {
                      downloading = true;
                    });
                  },
                  child: const Text("Yes")),
            ],
          );
        });
  }

  void popDialog() {
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    getPhotos();

    challengeStateListener =
        Global.instance.challengeStateStream.listen((event) {
      if (event == ChallengeState.completed) {
        context.go('/challengecompleted');
      }
    });
  }

  @override
  void dispose() {
    challengeStateListener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      bottomNavigationBar: const MyBottomAppBar(
        currentPage: 3,
      ),
      body: GridView(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        children: [for (var widget in getChildren()) widget],
      ),
      floatingActionButton: const BottomAppbarFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
