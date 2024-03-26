import 'package:found_me/app/domain/models/place.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeState {
  //se definen las variables con las que vamos a trabajar, con el fin de enlazarlas al home_controller.dart
  //booleanos para saber si la pagina de home_page ya cargo todo lo necesario para funcionar y
  //la otra para saber si el gps fue habilitado o no
  final bool loading, gpsEnabled, fetching;
  //variables que almacenaran los markers y los polylines
  final Map<MarkerId, Marker> markers;
  final Map<PolylineId, Polyline> polylines;
  final LatLng? initialPosition;
  final Place? origin, destination;
  final PickFromMap? pickFromMap;

//constructor de las variables
  HomeState({
    required this.loading,
    required this.gpsEnabled,
    required this.markers,
    required this.polylines,
    required this.initialPosition,
    required this.origin,
    required this.destination,
    required this.fetching,
    required this.pickFromMap,
  });

//funcion encargada de mandar un homeState que se pueda modificar los valores por defecto de esta funcion,
//tiene como nombre initialState
  static HomeState get initialState => HomeState(
        loading: true,
        gpsEnabled: false,
        markers: {},
        polylines: {},
        initialPosition: null,
        origin: null,
        destination: null,
        fetching: false,
        pickFromMap: null,
      );

//funcion que permite modificar los valores de estas variables dentro del home_controller.dart
  HomeState copyWith({
    bool? loading,
    bool? gpsEnabled,
    bool? fetching,
    Map<MarkerId, Marker>? markers,
    Map<PolylineId, Polyline>? polilynes,
    LatLng? initialPosition,
    Place? origin,
    Place? destination,
    PickFromMap? pickFromMap,
  }) {
    //aqui se retorna el valor actual o almacenado de las variables o el nuevo modificado
    return HomeState(
      pickFromMap: pickFromMap ?? this.pickFromMap,
      fetching: fetching ?? this.fetching,
      loading: loading ?? this.loading,
      gpsEnabled: gpsEnabled ?? this.gpsEnabled,
      markers: markers ?? this.markers,
      polylines: polilynes ?? this.polylines,
      initialPosition: initialPosition ?? this.initialPosition,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
    );
  }

  //funcion que permite borrar o limpiar los valores de estas variables dentro del home_controller.dart
  HomeState clearOriginAndDestination(bool fetching) {
    //aqui se retorna el valor actual o almacenado de las variables o el nuevo modificado
    return HomeState(
      pickFromMap: null,
      fetching: fetching,
      loading: loading,
      gpsEnabled: gpsEnabled,
      markers: {},
      polylines: {},
      initialPosition: initialPosition,
      origin: null,
      destination: null,
    );
  }

//metodo que seteara todo al momento de seleccionar una ubicacion a mano
  HomeState setPickFromMap(bool isOrigin) {
    return HomeState(
        pickFromMap: PickFromMap(
          place: null,
          isOrigin: isOrigin,
          origin: origin,
          destination: destination,
          markers: markers,
          polylines: polylines,
        ),
        markers: {},
        polylines: {},
        origin: null,
        destination: null,
        loading: loading,
        fetching: fetching,
        gpsEnabled: gpsEnabled,
        initialPosition: initialPosition);
  }

//metodo que quitara la opcion de seleccionar una ubicacion a mano
  HomeState cancelPickFromMap() {
    //variable que almacenara los datos preventivos de pickFromMap
    final prevData = pickFromMap!;
    //aqui se retorna el valor actual o almacenado de las variables o el nuevo modificado
    return HomeState(
      pickFromMap: null,
      fetching: fetching,
      loading: loading,
      gpsEnabled: gpsEnabled,
      markers: prevData.markers,
      polylines: prevData.polylines,
      initialPosition: initialPosition,
      origin: prevData.origin,
      destination: prevData.destination,
    );
  }
}

//clase que almacenara los datos una vez seleccionemos nosotros mismos el nuevo lugar en el mapa mediante pick_from_map_button.dart
class PickFromMap {
  final Place? place, origin, destination;
  final bool isOrigin;
  final Map<MarkerId, Marker> markers;
  final Map<PolylineId, Polyline> polylines;

  PickFromMap({
    required this.place,
    required this.isOrigin,
    required this.origin,
    required this.destination,
    required this.markers,
    required this.polylines,
  });
}
