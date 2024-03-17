import 'package:found_me/app/domain/models/place.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

// en esta clase, creamos los metodos necesarios para el funcionamiento de autosuggest y no tenes que escribirlos en diferentes
// archivos dart y que el codigo no se vea  tan extenso
abstract class SearchRepository {
  Stream<List<Place>?> get onResults;
  void cancel();
  void dispose();
  void search(String query, LatLng at);
}
