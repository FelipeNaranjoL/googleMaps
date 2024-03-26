import 'dart:ui';

import 'package:found_me/app/domain/models/place.dart';
import 'package:found_me/app/domain/models/route.dart';
import 'package:found_me/app/ui/pages/home/controller/home_state.dart';
import 'package:found_me/app/ui/pages/home/controller/utils/place_to_markers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<HomeState> setRouteAndMarkers({
  required HomeState state,
  required List<Route> routes,
  required Place origin,
  required Place destination,
  required BitmapDescriptor dot,
}) async {
  //esto es esto
  //final copy = Map<MarkerId, Marker>.from(_state.markers);
  //pero mas resumido
  final markersCopy = {...state.markers};
  //se generan los id de los marcadores de manera personalizada y tambien para los puntos que se generaran en el mapa para que se entienda mejor
  const originId = MarkerId('origin');
  const destinationId = MarkerId('destination');
  const originDot = MarkerId('originDot');
  const destinationDot = MarkerId('destinationDot');

  //variable para acceder a los datos de routes
  final route = routes.first;
  //variables que mostrara el icono dependiendo si es origin o destination
  //si es origen, mostrara el icono de gps, si es destino, mostrara el tiempo de llegada estimada
  final originIcon = await placeToMarker(origin, null);
  final destinationIcon = await placeToMarker(destination, route.duration);

  //dentro de los marcadores, se asignara el id, su posicion y su nombre flotante
  //segun la informacion de su origen/destino
  final originMarker = Marker(
    markerId: originId,
    position: origin.position,
    icon: originIcon,
    anchor: const Offset(0.5, 1.2),
  );
  final destinationMarker = Marker(
    markerId: destinationId,
    position: destination.position,
    icon: destinationIcon,
    anchor: const Offset(0.5, 1.2),
  );
  //se asigna el id dentro de la lista de originMarker/destinationMarker y en los puntos de originDot y destinationDot
  markersCopy[originId] = originMarker;
  markersCopy[destinationId] = destinationMarker;
  markersCopy[originDot] = Marker(
    markerId: originDot,
    position: route.points.first,
    icon: dot,
    anchor: const Offset(0.5, 0.5),
  );
  markersCopy[destinationDot] = Marker(
    markerId: destinationDot,
    position: route.points.last,
    icon: dot,
    anchor: const Offset(0.5, 0.5),
  );
  //variable que almacenara la copia de la polyline, el id de la misma y el polyline
  final polylinesCopy = {...state.polylines};
  const polylineId = PolylineId('route');
  final polyline = Polyline(
    polylineId: polylineId,
    points: route.points,
    width: 2,
  );
  //guardamos la copia del polilyne dentro de la polyline en si junto con su id
  polylinesCopy[polylineId] = polyline;
  //se envia los datos asignados en el buscador al metodo copyWith
  //reemplazando los valores de ese metodo con los asignados en este archivo
  return state.copyWith(
    origin: origin,
    destination: destination,
    markers: markersCopy,
    polilynes: polylinesCopy,
    fetching: false,
  );
}
