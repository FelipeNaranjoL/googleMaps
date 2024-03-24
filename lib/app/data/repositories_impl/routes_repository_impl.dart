import 'package:found_me/app/data/providers/remote/router_api.dart';
import 'package:found_me/app/domain/models/route.dart';
import 'package:found_me/app/domain/repositories/routes_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

//clase que implementara las funciones de RoutesRepository con los parametros requeridos
class RouteReposirotyImpl implements RoutesRepository {
  final RoutesApi _routesAPI;
  RouteReposirotyImpl(this._routesAPI);
  @override
  Future<List<Route>?> get({
    required LatLng origin,
    required LatLng destination,
  }) {
    return _routesAPI.get(origin: origin, destination: destination);
  }
}
