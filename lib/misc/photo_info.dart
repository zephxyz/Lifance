import 'package:cloud_firestore/cloud_firestore.dart';

class PhotoInfo {
  final String? _path;
  final Timestamp? _date;

  PhotoInfo(this._path, this._date);

  get getPath => _path;
  get getDate => _date;
}
