import 'package:found_me/app/data/providers/local/remote/search_api.dart';
import 'package:found_me/app/domain/models/place.dart';
import 'package:found_me/app/domain/repositories/search_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

//esta clase se vincula con SearchRepository los metodos escritos en el, con el fin de hacerlo mas accesible y rapido y en un futuro, escalable
class SearchRepositoryImpl implements SearchRepository {
  //se crea la variable _searchAPI que se vincula con la clase de SearchAPI del archivo search_api.dart, con el fin de traer sus metodos
  final SearchAPI _searchAPI;
  //constructor de _searchAPI para poder usar los metodos de SearchAPI
  SearchRepositoryImpl(this._searchAPI);

//creacion del metodo search y su estructura
  @override
  void search(String query, LatLng at) {
    _searchAPI.search(query, at);
  }

//creacion del metodo cancel y su estructura

  @override
  void cancel() {
    _searchAPI.cancel();
  }

//creacion del metodo dispose y su estructura

  @override
  void dispose() {
    _searchAPI.dispose();
  }

//creacion del metodo onResults y su estructura al momento de mandar el resultado de la busqueda del usuario

  @override
  Stream<List<Place>?> get onResults => _searchAPI.onResults;
}
