import 'dart:async';
import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:found_me/app/domain/models/place.dart';
import 'package:found_me/app/domain/repositories/search_repository.dart';
import 'package:found_me/app/helpers/current_position.dart';

class SearchPlaceController extends ChangeNotifier {
  //variable que vincula la clase SearchRepository del documento search_repository.dart, con el fin de acceder a sus funciones resumidas
  final SearchRepository _searchRepository;
  //variable que almacenara la peticion de busqueda del usuario
  String _query = '';
  String get query => _query;
  //variable que contiene el tiempo de actualizacion del llamado de la api cuando ingreso una ubicacion
  Timer? _debouncer;
  //variable que almacena un evento de proviniente de un controller o otros StreamSubscription
  late StreamSubscription _subscription;
  //esta variable almacenara los lugares encontrados por la api o sus coincidencias
  List<Place>? _places = [];
  List<Place>? get places => _places;

//constructor de _searchRepository
  SearchPlaceController(this._searchRepository) {
    //esta variable almacena el resultado de la busqueda de autosuggets
    _subscription = _searchRepository.onResults.listen(
      (results) {
        print('resultados de busqueda ${results?.length}');
        //una vez obtenido el resultado, la api buscara coincidencias y lo almacenaremos en esta lista de _places y llamaremos a
        //notifyListeners para actualizar la vista
        _places = results;
        notifyListeners();
      },
    );
  }
  void onQueryChanged(String text) {
    _query = text;
    //elimina una tarea previa, como una llamada a la api,con el fin de evitar errores
    _debouncer?.cancel();
    _debouncer = Timer(
      const Duration(milliseconds: 500),
      () {
        //si el largo de la ubicacion ingresada es >= 3, usara el metodo search, dando a entender que el query sera la ubicacion que el usuario
        //ingreso y el "at" en este caso sera la variable currentPosition
        if (_query.length >= 3) {
          print('llamando a la api');
          //se crea la variable de currentPosition con el fin de traer la posicion actual del usuario a esta verificacion y enlazarla a la
          //llamada de la api
          final currentPosition = CurrentPosition.i.value;
          if (currentPosition != null) {
            //se elimina los llamados de _searchRepository en caso de que se elimine la query ingresada por el usuario o una peticion anterior
            _searchRepository.cancel();
            final results = _searchRepository.search(query, currentPosition);
          }
        } else {
          print('llamada cancelada de la api');
          //se elimina los llamados de _searchRepository en caso de que se elimine la query ingresada por el usuario o una peticion anterior
          _searchRepository.cancel();
          _places = [];
          notifyListeners();
        }
      },
    );
  }

  @override
  void dispose() {
    //creamos el dispose para eliminar el llamado de esta variable una vez se cierre la app
    _debouncer?.cancel();
    //se cancela esta variable  en caso de que se cierre la app
    _subscription.cancel();
    //se elimina los llamados de _searchRepository en caso de que se cierre la app o no sean necesario esta variable y sus metodos
    _searchRepository.dispose();
    super.dispose();
  }
}
