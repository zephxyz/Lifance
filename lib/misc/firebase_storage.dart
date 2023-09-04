import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'firestore.dart';

class FbStorage {
  static final FbStorage instance = FbStorage._();

  FbStorage._();

  auth.User? user = auth.FirebaseAuth.instance.currentUser;

  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> upload(String imgPath) async {
    if (user == null) {
      return "";
    }
    final ref = _storage
        .ref()
        .child("/users/${user?.uid}/img")
        .child(imgPath.split("/").last);
    final uploadTask = ref.putFile(File(imgPath));
    final snapshot = await uploadTask.whenComplete(() => null);
    return await snapshot.ref.getDownloadURL();
  }

  // download image using the long lived download url
  Future<void> downloadImage(String url, String name, int index) async {
    final ref = _storage.refFromURL(url);
    final directory = await getApplicationDocumentsDirectory();
    final savedImagePath =
        '${directory.path}/ChallengePhotos/$name';
    final file = File(savedImagePath);
    file.createSync(recursive: true);
    await ref.writeToFile(file);
    await Firestore.instance.updatePhotoPath(savedImagePath, index);
  }
}
