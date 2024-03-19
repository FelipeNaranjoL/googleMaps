import 'dart:async';
import 'package:flutter/material.dart';
import 'package:found_me/app/data/providers/local/geolocator_wrapper.dart';
import 'package:found_me/app/domain/models/place.dart';
import 'package:found_me/app/helpers/current_position.dart';
import 'package:found_me/app/ui/pages/home/controller/home_state.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeController extends ChangeNotifier {
  //exportacion del home_state.dart para poder trabajar con las variables creadas dentro del archivo
  HomeState _state = HomeState.initialState;
  HomeState get state => _state;

//variable de escuchar eventos dentro de la app, en este caso son las de escuchar las llamadas del gps
//y el otro de escuchar la posicion del usuario
  StreamSubscription? _gpsSubscription, _positionSubscription;
// varibale encargada de controlar los cambios del mapa
  GoogleMapController? _mapController;
  //hace referencia al doc GeolocatorWrapper.dart para usar sus metodos
  final GeolocatorWrapper _geolocator;

//funcion encargada de ejecutar _init y _geolocator
  HomeController(this._geolocator) {
    _init();
  }

  Future<void> _init() async {
    //se revisa si el gps esta habilitado o no gracias al metodo de isLocationServiceEnabled de _geolocator
    final gpsEnabled = await _geolocator.isLocationServiceEnabled;
    // en state, se pasa el valor actual de gpsEnabled, modificando gpsEnabled del home_state
    _state = state.copyWith(gpsEnabled: gpsEnabled);
    //el metodo onServiceEnabled escucha si el usuario activa el servicio de GPS
    _gpsSubscription = _geolocator.onServiceEnabled.listen(
      (enabled) {
        //en caso de que gpsEnabled sea true, se modificara este valor con el de home_state, quedando como
        //true y se manda a notificar
        _state = state.copyWith(gpsEnabled: enabled);
        notifyListeners();
      },
    );
    _initLocationUpdates();
  }

  //funcion encargada de dar las actualizaciones de la posicion inicial del usuario en caso de que prenda o apague el gps
  Future<void> _initLocationUpdates() async {
    //variable que deja en claro si se tiene la ubicacion actual o no
    bool initialized = false;
    //el metodo onLocationUpdates se encarga de actualizar y escuchar los cambios de
    //posicion del gps
    _positionSubscription = _geolocator.onLocationUpdates.listen(
      (position) {
        //en caso de que sea falsa, se mandara el parametro de position para establecer una posicion
        //inicial en la funcion _setInitialPosition, el initialized ya que se obtuvo la ubicacion y se manda
        //a notificar a la app
        if (!initialized) {
          _setInitialPosition(position);
          initialized = true;
          notifyListeners();
        }
        //enlacamos el archivo de current.position, ya que es un singleton y ocupamos su metodo setValue para almacenar los datos
        // lat y lng de mi posicion actual
        CurrentPosition.i.setValue(
          LatLng(position.latitude, position.longitude),
        );
      },
    );
  }

//funcion encargada de dar la posicion actual del usuario
  void _setInitialPosition(Position position) {
    // si el gps esta habilitado y la _initialPosition es nula, se le asignara una posicion gracias
    //a que se guardo una variable para almacenar la ubicacion del usuario
    if (state.gpsEnabled && state.initialPosition == null) {
      _state = state.copyWith(
        initialPosition: LatLng(position.latitude, position.longitude),
        loading: false,
      );
      // print('posicion inicial $initialPosition');
    }
  }

//funcion de generar un mapa
  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

//esta funcion define el origen y destino que haya seleccionado el usuario
  void setOriginAndDestination(Place origin, Place destination) {
    //esto es esto
    //final copy = Map<MarkerId, Marker>.from(_state.markers);
    //pero mas resumido
    final copy = {..._state.markers};
    //se generan los id de los marcadores de manera personalizada
    const originId = MarkerId('origin');
    const destinationId = MarkerId('destination');
    //dentro de los marcadores, se asignara el id, su posicion y su nombre flotante
    //segun la informacion de su origen/destino
    final originMarker = Marker(
      markerId: originId,
      position: origin.position,
      infoWindow: InfoWindow(title: origin.title),
    );
    final destinationMarker = Marker(
      markerId: destinationId,
      position: destination.position,
      infoWindow: InfoWindow(title: destination.title),
    );
    //se asigna el id dentro de la lista de originMarker/destinationMarker
    copy[originId] = originMarker;
    copy[destinationId] = destinationMarker;
    //se envia los datos asignados en el buscador al metodo copyWith
    //reemplazando los valores de ese metodo con los asignados en este archivo
    _state = _state.copyWith(
      origin: origin,
      destination: destination,
      markers: copy,
    );
    notifyListeners();
  }

//funcion encargada de redirigir al usuario a las configuraciones de gps para habilitarlo
  Future<void> turnOnGps() => _geolocator.openAppSettings();

//
  Future<void> zoomIn() async {
    if (_mapController != null) {
      final zoom = await _mapController!.getZoomLevel();
    }
  }

  //
  Future<void> zoomOut() async {
    if (_mapController != null) {
      final zoom = await _mapController!.getZoomLevel();
    }
  }

//esta funcion, libera las acciones realizadas por el usuario una vez cierre la app
  @override
  void dispose() {
    _positionSubscription?.cancel();
    _gpsSubscription?.cancel();
    super.dispose();
  }
}
