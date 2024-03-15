import 'dart:async';
import 'package:flutter/material.dart';
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

//funcion encargada de ejecutar _init
  HomeController() {
    _init();
  }

  Future<void> _init() async {
    //se revisa si el gps esta habilitado o no
    final gpsEnabled = await Geolocator.isLocationServiceEnabled();
    // en state, se pasa el valor actual de gpsEnabled, modificando gpsEnabled del home_state
    _state = state.copyWith(gpsEnabled: gpsEnabled);
    _gpsSubscription = Geolocator.getServiceStatusStream().listen(
      (status) async {
        final gpsEnabled = status == ServiceStatus.enabled;
        if (gpsEnabled) {
          //en caso de que gpsEnabled sea true, se modificara este valor con el de home_state, quedando como
          //true
          _state = state.copyWith(gpsEnabled: gpsEnabled);
          _initLocationUpdates();
        }
        // print('estado de solicitud $_gpsEnabled');
      },
    );
    _initLocationUpdates();
  }

  //funcion encargada de dar las actualizaciones de la posicion inicial del usuario en caso de que prenda o apague el gps
  Future<void> _initLocationUpdates() async {
    //variable que deja en claro si se tiene la ubicacion actual o no
    bool initialized = false;
    //se cancela o borra esta variable para evitar errores al cambiar entre pantallas o crear muchas llamadas
    await _positionSubscription?.cancel();
    //variable que nos dara la posicion actual, con una localizacion precisa y que se actualizara la ubicacion
    //cada 5 metros recorridos
    _positionSubscription = Geolocator.getPositionStream(
      desiredAccuracy: LocationAccuracy.high,
      distanceFilter: 5,
    ).listen(
      (position) async {
        // print('posicion $position');
        //en caso de que sea falsa, se mandara el parametro de position para establecer una posicion
        //inicial en la funcion _setInitialPosition, el initialized ya que se obtuvo la ubicacion y se manda
        //a notificar a la app
        if (!initialized) {
          _setInitialPosition(position);
          initialized = true;
          notifyListeners();
        }
      },
      //en caso extremo, se advierte al programador el error y notifica a la app para que realice una accion
      onError: (e) {
        // print(' error ${e.runtimeType}');
        if (e is LocationServiceDisabledException) {
          //aqui se mandara un false a home_state, dejando en claro que hubo un error y que el
          //gps no fue habilitado
          _state = state.copyWith(gpsEnabled: false);
          notifyListeners();
        }
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

//funcion encargada de redirigir al usuario a las configuraciones de gps para habilitarlo
  Future<void> turnOnGps() => Geolocator.openLocationSettings();

//esta funcion, libera las acciones realizadas por el usuario una vez cierre la app
  @override
  void dispose() {
    _positionSubscription?.cancel();
    _gpsSubscription?.cancel();
    super.dispose();
  }
}
