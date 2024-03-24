//
import 'package:found_me/app/domain/models/route.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

abstract class RoutesRepository {
  Future<List<Route>?> get({
    //valores requeridos para que funcione la creacion del polyline
    required LatLng origin,
    required LatLng destination,
  });
}
