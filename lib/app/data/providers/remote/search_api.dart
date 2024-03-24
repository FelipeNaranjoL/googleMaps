import 'dart:async';
import 'package:dio/dio.dart';
import 'package:found_me/app/domain/models/place.dart';
import 'package:found_me/app/helpers/const.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

class SearchAPI {
  final Dio _dio;
  SearchAPI(this._dio);
  //
  CancelToken? _cancelToken;
//esta variable escuchara los cambbios que obtenga de la lista de lugares
  final _controller = StreamController<List<Place>?>.broadcast();
//esta variable tiene el fin de almacenar el resultado final de la busqueda
  Stream<List<Place>?> get onResults => _controller.stream;
//esta funcion tiene como objetivo ser la conexion de la api de hereapi, especificamente la funcion de autosuggest, envuielta en un try, catch en caso de que hayan errores
//tambien cuenta con los parametros que estimo convenientes para la busqueda mas la apikey
//los cuales retornaran en forma de lista y se veran desplegada en la vista de la app
//para mejor comprension, adjunto la url aqui y en el documento readme
//https://www.here.com/docs/bundle/geocoding-and-search-api-v7-api-reference/page/index.html#/paths/~1autosuggest/get
  void search(String query, LatLng at) async {
    try {
      //_cancelToken obtiene un nuevo valor al realizarar una nueva llamada a la api, en caso de que tengamos mala conexion o
      //querramos eliminar la ubicacion ingresada, CancelToken eliminara ese llamado
      _cancelToken = CancelToken();
      final response = await _dio.get(
        'https://autosuggest.search.hereapi.com/v1/autosuggest',
        queryParameters: {
          "apiKey": apiKey,
          "q": query,
          "at": "${at.latitude},${at.longitude}",
          "in": 'countryCode:CHL',
        },
        cancelToken: _cancelToken,
      );
      //esta variable almacena todos los datos en una lista y las utiliza para mostrarlo a la vista de search_place_page.dart
      //usando la funcion fromJson del archivo place.dart
      final results = (response.data['items'] as List)
          .map(
            (e) => Place.fromJson(e),
          )
          .toList();
      //cuando la comprobacion termine, agregaremos el valor de results al stream y lo escuche
      _controller.sink.add(results);
      //aqui se cancela el token cuando ya no es necesario, por ejemplo si se realiza una nueva busqueda y evitar que entre en bucle con
      //el metodo cancel
      _cancelToken = null;
    } on DioError catch (e) {
      if (e.type != DioErrorType.cancel) {
        //aqui se manda un valor nulo, con el fin evitar errores a usuarios con mala conexion al momento de realizar la peticion
        //get a la api
        _controller.sink.add(null);
      }
    }
  }

//funcion que se encarga de comprobar de que _cancelToken != null, con el fin de deje de utilizar y lo deje con el valor de null
  void cancel() {
    if (_cancelToken != null) {
      _cancelToken!.cancel();
      _cancelToken = null;
    }
  }

  void dispose() {
    //se llama a cancel en caso de que se elimine la ubicacion que el usuario ingreso por error, la cancele y no llame a la api
    cancel();
    //se cerrara el controller o dejara de utilizar cuando ya no sea necesario
    _controller.close();
  }
}
