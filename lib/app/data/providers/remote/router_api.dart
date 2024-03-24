import 'package:dio/dio.dart';
import 'package:flexible_polyline/flexible_polyline.dart';
import 'package:found_me/app/domain/models/route.dart';
import 'package:found_me/app/helpers/const.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

//clase enfocada en realizar rutas con la api de hereapi
class RoutesApi {
  final Dio _dio;
  RoutesApi(this._dio);

//metodo que buscara o hara la ruta entre 2 puntos
  Future<List<Route>?> get({
    //valores requeridos para que funcione la creacion del polyline
    required LatLng origin,
    required LatLng destination,
  }) async {
    try {
      //url de la api
      final response = await _dio.get(
        'https://router.hereapi.com/v8/routes',
        queryParameters: {
          //parametros usados en postman
          'apiKey': apiKey,
          'origin': '${origin.latitude},${origin.longitude}',
          'destination': '${destination.latitude},${destination.longitude}',
          'transportMode': "car",
          'alternatives': 3,
          'return': 'polyline,summary,instructions,actions',
          'lang': 'es-ES',
        },
      );
      //pbtenemos todos los datos de postman o de la peticion get
      final routes = (response.data["routes"] as List).map(
        (e) {
          //ingresamos dentro de la lista de datos obtenidos y sacamos los que nos importan
          final json = e["sections"][0];
          final duration = json['summary']['duration'] as int;
          final length = json['summary']['length'] as int;
          final polyline = json['polyline'] as String;
          //decodificamos el resultado de polilyne a LatLng
          final points = FlexiblePolyline.decode(polyline)
              .map(
                (e) => LatLng(e.lat, e.lng),
              )
              .toList();
          return Route(
            duration: duration,
            length: length,
            points: points,
          );
        },
      );
      return routes.toList();
    } catch (e) {
      print(e);
      return null;
    }
  }
}
