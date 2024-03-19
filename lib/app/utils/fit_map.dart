import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' as math;

//esta funcion moviliza el mapa a los puntos de origen y destino para que sean visibles
CameraUpdate fitMap(LatLng origin, LatLng destination, {double padding = 20}) {
  final left = math.min(origin.latitude, destination.latitude);
  final rigth = math.max(origin.latitude, destination.latitude);
  final top = math.min(origin.longitude, destination.longitude);
  final bottom = math.max(origin.longitude, destination.longitude);
  final bounds = LatLngBounds(
    southwest: LatLng(left, top),
    northeast: LatLng(rigth, bottom),
  );
  return CameraUpdate.newLatLngBounds(bounds, padding);
}
