import 'dart:async';
import 'package:flutter/material.dart'
    show ChangeNotifier, FocusNode, TextEditingController;
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
//estas variables almacenaran el valor de origen y destino de los label_input de search_place_page.dart y asi diferenciarlos y que
//la api no las confunda
  Place? _origin, _destination;
  Place? get origin => _origin;
  Place? get destination => _destination;
  //variables para saber que input posee el foco de atencion
  final originFocusNode = FocusNode();
  final destinationFocusNode = FocusNode();
  //variables para mantener el valor ingresado en los inputs
  final originController = TextEditingController();
  final destinationController = TextEditingController();
  // variables para saber cual fue seleccionado primero
  late bool _originHasFocus;
  bool get originHasFocus => _originHasFocus;

//constructor de _searchRepository
  SearchPlaceController(
    this._searchRepository, {
    required Place? origin,
    required Place? destination,
    required bool hasOriginFocus,
  }) {
    //obtener los campos de origen y destino automaticamente y delimitar que campo tendra el foco de atencion
    _originHasFocus = hasOriginFocus;
    _origin = origin;
    _destination = destination;
    if (_origin != null) {
      originController.text = _origin!.title;
    }
    if (_destination != null) {
      destinationController.text = _destination!.title;
    }
    if (_originHasFocus) {
      originFocusNode.requestFocus();
    } else {
      destinationFocusNode.requestFocus();
    }
    //esta variable almacena el resultado de la busqueda de autosuggets
    _subscription = _searchRepository.onResults.listen(
      (results) {
        // print('resultados de busqueda ${results?.length}');
        //una vez obtenido el resultado, la api buscara coincidencias y lo almacenaremos en esta lista de _places y llamaremos a
        //notifyListeners para actualizar la vista
        _places = results;
        notifyListeners();
      },
    );
    //saber quien tiene el campo de atencion
    originFocusNode.addListener(
      () {
        //en caso de que el origen de atencion sea originFocusNode, tendra prioridad sobre destinationFocusNode
        //se valida que originFocusNode.hasFocus sea true y que ademas, el _originHasFocus sea false
        if (originFocusNode.hasFocus && !_originHasFocus) {
          _onOriginFocusNodeChanged(true);
          //en caso de que !originFocusNode.hasFocus y el origen vacio, el input quedara vacio
        } else if (!originFocusNode.hasFocus && _origin == null) {
          originController.text = '';
        }
      },
    );

    destinationFocusNode.addListener(
      () {
        //en caso de que el origen de atencion sea destinationFocusNode, tendra prioridad sobre originFocusNode
        //se valida que destinationFocusNode.hasFocus sea true y que ademas, el _originHasFocus sea true
        if (destinationFocusNode.hasFocus && _originHasFocus) {
          _onOriginFocusNodeChanged(false);
        } else if (!destinationFocusNode.hasFocus && _destination == null) {
          destinationController.text = '';
        }
      },
    );
  }

//este metodo busca quitar la prioridad a un input, con el fin de limpiar la vista de listas
//o items y que visualmente no se vea tan mal
  void _onOriginFocusNodeChanged(bool hasFocus) {
    //dependiendo de la respuesta de la variable _originHasFocus (true/false), eliminara la lista
    //y dejara la consulta vacia y se notificara a la app
    _originHasFocus = hasFocus;
    _places = [];
    _query = '';
    notifyListeners();
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
          // print('llamando a la api');
          //se crea la variable de currentPosition con el fin de traer la posicion actual del usuario a esta verificacion y enlazarla a la
          //llamada de la api
          final currentPosition = CurrentPosition.i.value;
          if (currentPosition != null) {
            //se elimina los llamados de _searchRepository en caso de que se elimine la query ingresada por el usuario o una peticion anterior
            _searchRepository.cancel();
            _searchRepository.search(query, currentPosition);
            // final results = _searchRepository.search(query, currentPosition);
          }
        } else {
          // print('llamada cancelada de la api');
          clearQuery();
        }
      },
    );
  }

//funcion que limpiara la variable query para que no haya ningun dato guardado en ella
  void clearQuery() {
    //se elimina los llamados de _searchRepository en caso de que se elimine la query ingresada por el usuario o una peticion anterior
    _searchRepository.cancel();
    _places = [];
    //en caso de que alguno de estos campos sea borrado, el boton de "ok" se deshabilitara
    if (_originHasFocus) {
      _origin = null;
    } else {
      _destination = null;
    }
    notifyListeners();
  }

//metodo que recibe la ubicacion de uno de los inputs
  void pickPlace(Place place) {
    //este valor jamas sera nulo ya que si o si se debio haber escrito algo en uno de los input y se le asignara
    //el valor de true o false y no uno nulo y se notificara a la app
    if (_originHasFocus) {
      _origin = place;
      originController.text = place.title;
    } else {
      _destination = place;
      destinationController.text = place.title;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    //liberamos los valores en caso de que ya no sean necesarios
    originController.dispose();
    destinationController.dispose();
    //liberamos los valores una vez que no sean necesarios o se cierre la app
    originFocusNode.dispose();
    destinationFocusNode.dispose();
    //creamos el dispose para eliminar el llamado de esta variable una vez se cierre la app
    _debouncer?.cancel();
    //se cancela esta variable  en caso de que se cierre la app
    _subscription.cancel();
    //se elimina los llamados de _searchRepository en caso de que se cierre la app o no sean necesario esta variable y sus metodos
    _searchRepository.dispose();
    super.dispose();
  }
}
