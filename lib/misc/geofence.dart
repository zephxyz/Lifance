import 'dart:async';

import 'package:geofence_service/geofence_service.dart';
import 'global.dart';

class Geofences {
  static final Geofences instance = Geofences._();

  Geofences._();

  //test

  final GeofenceService _geofenceService = GeofenceService.instance.setup();

  void start() {
    _registerListeners();
    _geofenceService.start();
  }

  void pause() {
    _geofenceService.pause();
  }

  void resume() {
    _geofenceService.resume();
  }

  void stop() {
    _geofenceService
        .removeGeofenceStatusChangeListener(_onGeofenceStatusChanged);
    _geofenceService.removeLocationChangeListener(_onLocationChanged);
    _geofenceService.removeLocationServicesStatusChangeListener(
        _onLocationServicesStatusChanged);
    _geofenceService.removeActivityChangeListener(_onActivityChanged);
    _geofenceService.removeStreamErrorListener(_onError);
    _geofenceService.clearAllListeners();
    _geofenceService.stop();
  }

  void _registerListeners() {
    _geofenceService.addGeofenceStatusChangeListener(_onGeofenceStatusChanged);
    _geofenceService.addLocationChangeListener(_onLocationChanged);
    _geofenceService.addLocationServicesStatusChangeListener(
        _onLocationServicesStatusChanged);
   _geofenceService.addActivityChangeListener(_onActivityChanged);
    _geofenceService.addStreamErrorListener(_onError);
    _geofenceService.start(_geofenceList).catchError(_onError);
  }

  final StreamController<Geofence> _geofenceStreamController =
      StreamController<Geofence>.broadcast();
  final StreamController<Activity> _activityStreamController =
      StreamController<Activity>.broadcast();

  Stream<Geofence> get geofenceStream => _geofenceStreamController.stream;
  Stream<Activity> get activityStream => _activityStreamController.stream;

  final _geofenceList = <Geofence>[
    Geofence(
        id: "test",
        latitude: Global.instance.challenge.lat,
        longitude: Global.instance.challenge.lng,
        radius: [GeofenceRadius(id: 'radius', length: 100)])
  ];

  //end of test
  Future<void> _onGeofenceStatusChanged(
      Geofence geofence,
      GeofenceRadius geofenceRadius,
      GeofenceStatus geofenceStatus,
      Location location) async {
    /*print('geofence: ${geofence.toJson()}');
    print('geofenceRadius: ${geofenceRadius.toJson()}');
    print('geofenceStatus: ${geofenceStatus.toString()}');*/
    _geofenceStreamController.sink.add(geofence);
  }

// This function is to be called when the activity has changed.
  void _onActivityChanged(Activity prevActivity, Activity currActivity) {
    print('prevActivity: ${prevActivity.toJson()}');
    print('currActivity: ${currActivity.toJson()}');
    _activityStreamController.sink.add(currActivity);
  }

// This function is to be called when the location has changed.
  void _onLocationChanged(Location location) {

   // print('location: ${location.toJson()}');
  }

// This function is to be called when a location services status change occurs
// since the service was started.
  void _onLocationServicesStatusChanged(bool status) {
    print('isLocationServicesEnabled: $status');
  }

// This function is used to handle errors that occur in the service.
  void _onError(error) {
    final errorCode = getErrorCodesFromError(error);
    if (errorCode == null) {
      print('Undefined error: $error');
      return;
    }

    print('ErrorCode: $errorCode');
  }
}
