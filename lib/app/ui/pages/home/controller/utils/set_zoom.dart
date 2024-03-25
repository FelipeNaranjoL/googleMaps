import 'package:google_maps_flutter/google_maps_flutter.dart';
//funcionamiento del zoom
//mientras _mapController sea distinto de nulo, se creara una variable zoom que controlara el nivel de
//del mapa, si zoomIn es falso, se reducira el valor de zoom, llegando como limite a 0,
// caso contrario, aumentara en 1

Future<void> setZoom(GoogleMapController mapController, bool zoomIn) async {
  double zoom = await mapController.getZoomLevel();
  if (!zoomIn) {
    if (zoom - 1 <= 0) {
      return;
    }
  }
  zoom = zoomIn ? zoom + 1 : zoom - 1;
  //luego se obtiene la parte visible del mapa para calcular el centro entre la esquina superior derecha
  //y la esquina inferior izquierda
  final bounds = await mapController.getVisibleRegion();
  final northeast = bounds.northeast;
  final southwest = bounds.southwest;
  final center = LatLng((northeast.latitude + southwest.latitude) / 2,
      (northeast.longitude + southwest.longitude) / 2);
  //se obtiene ese dato y se actualiza la camara para realizar la peticion de zoom que el usuario requiera
  final cameraUpdate = CameraUpdate.newLatLngZoom(center, zoom);
  await mapController.animateCamera(cameraUpdate);
}
