import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifance/misc/photo_info.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class PhotoDetailsPage extends StatelessWidget {
  final PhotoInfo photoInfo;

  const PhotoDetailsPage({Key? key, required this.photoInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                IconButton(
                    onPressed: () {
                      final mySystemTheme = SystemUiOverlayStyle.light
                          .copyWith(systemNavigationBarColor: Colors.white);
                      SystemChrome.setSystemUIOverlayStyle(mySystemTheme);

                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    color: Colors.transparent),
                IconButton(
                    onPressed: () => showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: const Text("Time of taking photo"),
                              content: Text(DateFormat.yMMMMEEEEd()
                                  .format(photoInfo.getDate.toDate())),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Close"))
                              ],
                            )),
                    icon: const Icon(
                      Icons.info,
                      color: Colors.white,
                    ),
                    color: Colors.transparent)
              ]),
           Expanded(
              child: GestureDetector(
                child: InteractiveViewer(
                  child: Image.file(
                    File(photoInfo.getPath),
                    fit: BoxFit.contain,
                  ),
                ),
              ),),
        ]),
      ),
    );
  }
}
