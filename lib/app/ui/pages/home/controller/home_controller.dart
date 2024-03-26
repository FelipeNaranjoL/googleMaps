import 'dart:async';
import 'package:flutter/material.dart';
import 'package:found_me/app/data/providers/local/geolocator_wrapper.dart';
import 'package:found_me/app/domain/models/place.dart';
import 'package:found_me/app/domain/repositories/routes_repository.dart';
import 'package:found_me/app/helpers/current_position.dart';
import 'package:found_me/app/ui/pages/home/controller/home_state.dart';
import 'package:found_me/app/ui/pages/home/controller/utils/set_route.dart';
import 'package:found_me/app/ui/pages/home/controller/utils/set_zoom.dart';
import 'package:found_me/app/ui/pages/home/widgets/custom_painters/circle_marker.dart';
import 'package:found_me/app/utils/fit_map.dart';
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
  //variable que almacenara la clase RoutesRepository y su metodo
  final RoutesRepository _routesRepository;
  //variable
  BitmapDescriptor? _dotMarker;

//funcion encargada de ejecutar _init y _geolocator, _routesRepository
  HomeController(this._geolocator, this._routesRepository) {
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
    //variable que iniciara  el marker de punto de partida
    _dotMarker = await getDotMarker();
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
    final cameraUpdate = CameraUpdate.newLatLng(CurrentPosition.i.value!);
    _mapController!.moveCamera(cameraUpdate);
  }

//esta funcion define el origen y destino que haya seleccionado el usuario
  void setOriginAndDestination(Place origin, Place destination) async {
    //condicion que si nos entrega valores distinto de null, borrara la informacion del rectangulo
    if (_state.origin != null && _state.destination != null) {
      clearData(true);
    } else {
      //caso contrario, cambiara el valor de fetching, evitandonos ver los demas comandos al momento de alternar origen y destino
      _state = state.copyWith(
        fetching: true,
      );
      notifyListeners();
    }
    //llamado del metodo get para formar una polilyne
    final routes = await _routesRepository.get(
      origin: origin.position,
      destination: destination.position,
    );
    //condiciones para que no se caigfa la app en caso de crear una polyline mala
    if (routes != null && routes.isNotEmpty) {
      //llamada a la funcion de setRouteAndMarkers del archivo set_route.dart
      _state = await setRouteAndMarkers(
        state: state,
        routes: routes,
        origin: origin,
        destination: destination,
        dot: _dotMarker!,
      );
      //se le indica a _mapController que anime la camara para visualizar el origen y destino
      //que el usuario haya designado y se notifica a la app
      await _mapController?.animateCamera(
        fitMap(
          origin.position,
          destination.position,
          padding: 120,
        ),
      );
      notifyListeners();
    } else {
      _state = _state.copyWith(
        fetching: false,
      );
      notifyListeners();
    }
  }

//metodo que cambiara de lugar el origin y destination,osea, volteandolos
  Future<void> exchange() async {
    final origin = state.destination!;
    final destination = state.origin!;
    clearData();
    setOriginAndDestination(origin, destination);
  }

//funcion encargada de redirigir al usuario a las configuraciones de gps para habilitarlo
  Future<void> turnOnGps() => _geolocator.openAppSettings();

// metodo que hace zoom al mapa
  Future<void> zoomIn() async {
    if (_mapController != null) {
      //llama al metodo setZoom del archivo set_zoom.dart
      await setZoom(_mapController!, true);
    }
  }

  //metodo que quita zoom al mapa
  Future<void> zoomOut() async {
    if (_mapController != null) {
      //llama al metodo setZoom del archivo set_zoom.dart
      await setZoom(_mapController!, false);
    }
  }

//funcion que borrara los datos de origin y destination para sacar el contenedor de la vista del mapa
  void clearData([bool fetching = false]) {
    _state = _state.clearOriginAndDestination(fetching);
    notifyListeners();
  }

//metodo que enviara los datos al copywith con  los nuevos valores que se le pasanron con PickFromMap
  void pickFromMap(bool isOrigin) {
    _state = _state.setPickFromMap(isOrigin);
    notifyListeners();
  }

//metodo que nos permitira salir del modo de seleccion propia de ubicacion
  void cancelPickFromMap() {
    _state = _state.cancelPickFromMap();
    notifyListeners();
  }

//metodo que al momento de entrar en modo de seleccion propia de ubicacion, me enviara a mi posicion
  Future<void> goToMyPosition() async {
    final zoom = await _mapController!.getZoomLevel();
    final cameraUpdate = CameraUpdate.newLatLngZoom(
      CurrentPosition.i.value!,
      zoom < 16 ? 16 : zoom,
    );
    return _mapController!.animateCamera(cameraUpdate);
  }

//esta funcion, libera las acciones realizadas por el usuario una vez cierre la app
  @override
  void dispose() {
    _positionSubscription?.cancel();
    _gpsSubscription?.cancel();
    super.dispose();
  }
}
