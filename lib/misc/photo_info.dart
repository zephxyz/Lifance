import 'package:cloud_firestore/cloud_firestore.dart';

class PhotoInfo {
  final String? _path;
  final String? _backupUrl;
  final Timestamp? _date;
  final int _index;

  PhotoInfo(this._path, this._backupUrl, this._date, this._index);

  get getPath => _path;
  get getUrl => _backupUrl;
  get getDate => _date;
  get getIndex => _index;
}
