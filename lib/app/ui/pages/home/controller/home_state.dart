import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeState {
  //se definen las variables con las que vamos a trabajar, con el fin de enlazarlas al home_controller.dart
  //booleanos para saber si la pagina de home_page ya cargo todo lo necesario para funcionar y
  //la otra para saber si el gps fue habilitado o no
  final bool loading, gpsEnabled;
  //variables que almacenaran los markers y los polylines
  final Map<MarkerId, Marker> markers;
  final Map<PolylineId, Polyline> polilynes;
  final LatLng? initialPosition;

//constructor de las variables
  HomeState(
      {required this.loading,
      required this.gpsEnabled,
      required this.markers,
      required this.polilynes,
      required this.initialPosition});

//funcion encargada de mandar un homeState que se pueda modificar los valores por defecto de esta funcion,
//tiene como nombre initialState
  static HomeState get initialState => HomeState(
      loading: true,
      gpsEnabled: false,
      markers: {},
      polilynes: {},
      initialPosition: null);

//funcion que permite modificar los valores de estas variables dentro del home_controller.dart
  HomeState copyWith({
    bool? loading,
    bool? gpsEnabled,
    Map<MarkerId, Marker>? markers,
    Map<PolylineId, Polyline>? polilynes,
    LatLng? initialPosition,
  }) {
    //aqui se retorna el valor actual o almacenado de las variables o el nuevo modificado
    return HomeState(
      loading: loading ?? this.loading,
      gpsEnabled: gpsEnabled ?? this.gpsEnabled,
      markers: markers ?? this.markers,
      polilynes: polilynes ?? this.polilynes,
      initialPosition: initialPosition ?? this.initialPosition,
    );
  }
}
