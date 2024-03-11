import 'dart:async';
import 'package:flutter/material.dart';
import 'package:found_me/app/ui/pages/home/widgets/asset_to_byte.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeController extends ChangeNotifier {
  final Map<MarkerId, Marker> _markers = {};
  Set<Marker> get markers => _markers.values.toSet();
  final Map<PolylineId, Polyline> _polylines = {};
  Set<Polyline> get polylines => _polylines.values.toSet();
  final Map<PolygonId, Polygon> _polygons = {};
  Set<Polygon> get polygons => _polygons.values.toSet();
  final _markersController = StreamController<String>.broadcast();
  Stream<String> get onMarkerTap => _markersController.stream;
  bool _loading = true;
  bool get loading => _loading;
  late bool _gpsEnabled;
  bool get gpsEnabled => _gpsEnabled;
  StreamSubscription? _gpsSubscription, _positionSubscription;
  Position? _initialPosition, _lastPosition;
  Position? get initialPosition => _initialPosition;
  GoogleMapController? _mapController;
  // String _polylineid = '0';
  // String _polygonid = '0';
  late BitmapDescriptor _guyPin;

  HomeController() {
    _init();
  }

  Future<void> _init() async {
    _guyPin = BitmapDescriptor.fromBytes(
      await assetToBytes(
        'assets/pegman.png',
        width: 90,
      ),
    );
    _gpsEnabled = await Geolocator.isLocationServiceEnabled();
    _loading = false;
    _gpsSubscription = Geolocator.getServiceStatusStream().listen(
      (status) async {
        _gpsEnabled = status == ServiceStatus.enabled;
        if (_gpsEnabled) {
          _initLocationUpdates();
        }
        // print('estado de solicitud $_gpsEnabled');
      },
    );
    _initLocationUpdates();
  }

  Future<void> _initLocationUpdates() async {
    bool initialized = false;
    await _positionSubscription?.cancel();
    _positionSubscription = Geolocator.getPositionStream(
      desiredAccuracy: LocationAccuracy.high,
      distanceFilter: 5,
    ).listen(
      (position) async {
        _setMyPositionMarker(position);
        if (initialized) {
          notifyListeners();
        }
        // print('posicion $position');
        if (!initialized) {
          _setInitialPosition(position);
          initialized = true;
          notifyListeners();
        }
        if (_mapController != null) {
          final zoom = await _mapController!.getZoomLevel();
          final cameraUpdate = CameraUpdate.newLatLngZoom(
            LatLng(position.latitude, position.longitude),
            zoom,
          );
          _mapController!.animateCamera(cameraUpdate);
        }
      },
      onError: (e) {
        // print(' error ${e.runtimeType}');
        if (e is LocationServiceDisabledException) {
          _gpsEnabled = false;
          notifyListeners();
        }
      },
    );
  }

  void _setInitialPosition(Position position) {
    if (_gpsEnabled && _initialPosition == null) {
      // _initialPosition = await Geolocator.getLastKnownPosition();
      _initialPosition = position;
      // print('posicion inicial $initialPosition');
    }
  }

  void _setMyPositionMarker(Position position) {
    double rotation = 0;
    if (_lastPosition != null) {
      rotation = Geolocator.bearingBetween(_lastPosition!.latitude,
          _lastPosition!.longitude, position.latitude, position.longitude);
    }
    const markerId = MarkerId('My-Position');
    final marker = Marker(
        markerId: markerId,
        position: LatLng(position.latitude, position.longitude),
        icon: _guyPin,
        anchor: const Offset(0.5, 0.5),
        rotation: rotation);
    _markers[markerId] = marker;
    _lastPosition = position;
  }

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<void> turnOnGps() => Geolocator.openLocationSettings();

  void onTap(LatLng position) {
    final markerId = MarkerId(_markers.length.toString());
    final marker = Marker(markerId: markerId, position: position);
    _markers[markerId] = marker;
    notifyListeners();
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _gpsSubscription?.cancel();
    _markersController.close();
    super.dispose();
  }
}
