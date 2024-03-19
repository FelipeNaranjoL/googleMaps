//para mejor comprension ver clase 41
import 'dart:async';
import 'package:geolocator/geolocator.dart';

//este archivo no es mio, pero busca recrear las funciones de geolocator con metodos estaticos propios

class GeolocatorWrapper {
  //escuchar posicion y notificarlo
  StreamController<Position>? _positionController;
  //escuchar estado de GPS y notificarlo
  StreamController<bool>? _serviceEnabledController;
  //escuchar cambio de posicion del usuario y escuchar cambios del estado del GPS y notificarlo
  StreamSubscription? _positionSubscription, _serviceEnabledSubscription;

  //metodo que revisa si el servicio de ubicacion esta habilitado
  Future<bool> get isLocationServiceEnabled =>
      Geolocator.isLocationServiceEnabled();

  /// Returns a [Future] indicating if the user allows the App to access the device's location.
  Future<LocationPermission> checkPermission() => Geolocator.checkPermission();

  //este revisa si el permiso fue habilidato y permitira el acceso al mapa
  Future<bool> get hasPermission async {
    final status = await checkPermission();
    return status == LocationPermission.always ||
        status == LocationPermission.whileInUse;
  }

  /// Calcula el angulo de rotacion entre 2 puntos
  double bearing(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) =>
      Geolocator.bearingBetween(
        startLatitude,
        startLongitude,
        endLatitude,
        endLongitude,
      );

  /// metodo que retornara los cambios de estado del gps
  Stream<bool> get onServiceEnabled {
    _serviceEnabledController ??= StreamController.broadcast();

    // escucha los cambio de estado del gps
    _serviceEnabledSubscription = Geolocator.getServiceStatusStream().listen(
      (event) {
        final enabled = event == ServiceStatus.enabled;
        if (enabled) {
          _notifyServiceEnabled(true);
          if (_positionController != null) {
            _initLocationUpdates();
          }
        }
      },
    );

    return _serviceEnabledController!.stream;
  }

  /// metodo que escuchara los cambios de ubicacion del gps (seguimiento)
  Stream<Position> get onLocationUpdates {
    _positionController ??= StreamController.broadcast();
    _initLocationUpdates();
    return _positionController!.stream;
  }

  //metodo que escuchara los cambios constantes del gps
  void _initLocationUpdates() async {
    await _positionSubscription?.cancel();
    _positionSubscription = Geolocator.getPositionStream().listen(
      (event) {
        _positionController?.sink.add(event);
      },
      onError: (e) {
        if (e is LocationServiceDisabledException) {
          _notifyServiceEnabled(false);
        }
      },
    );
  }

  /// metodo que notifica a los stream que el servicio cambio de estado prendido/apagado
  void _notifyServiceEnabled(bool enabled) {
    _serviceEnabledController?.sink.add(enabled);
  }

//metodos para abrir ajustes o dar permisos
  Future<bool> openAppSettings() => Geolocator.openAppSettings();
  Future<LocationPermission> requestPermission() =>
      Geolocator.requestPermission();
  Future<bool> openLocationSettings() => Geolocator.openLocationSettings();

  // metodo que retorna la posicion actual
  Future<Position?> getCurrentPosition({
    LocationAccuracy desiredAccuracy = LocationAccuracy.best,
    bool forceAndroidLocationManager = false,
    Duration? timeLimit,
  }) async {
    try {
      // esta dentro de un try/catch por que existe la posibilidad de un error si el
      //gps no fue habilitado antes
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: desiredAccuracy,
        forceAndroidLocationManager: forceAndroidLocationManager,
        timeLimit: timeLimit,
      );
      return position;
    } catch (e) {
      return null;
    }
  }

  //metodo que devuelve la última posición conocida almacenada en el
  // dispositivo del usuario.
  Future<Position?> getLastKnownPosition(
      {bool forceAndroidLocationManager = false}) async {
    return Geolocator.getLastKnownPosition(
      forceAndroidLocationManager: forceAndroidLocationManager,
    );
  }

  //cancela o cierra los streams de la app
  void dispose() {
    _positionController?.close();
    _serviceEnabledSubscription?.cancel();
    _serviceEnabledController?.close();
    _positionSubscription?.cancel();
  }
}
