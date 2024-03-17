import 'package:google_maps_flutter/google_maps_flutter.dart';

//este constructor tiene como fin, almacenar las variables que utilizare en mi search_api.dart y con las cuales llenare los datos del mismo
//archivo, estos datos los visualice en postman o en algun programa que permita leer datos en formato json, aunque es recomendable postman
//por la accesibilidad y fluidez de la misma
class Place {
  final String id, title, address;
  final LatLng position;
  final int distance;

  Place({
    required this.id,
    required this.title,
    required this.address,
    required this.position,
    required this.distance,
  });

//se realizaron esas verificaciones con el fin de que la llamada a la api arroje coincidencias y no de valores nulos o 0
  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'],
      title: json['title'],
      address: json['address'] != null
          ? json['address']['label'] ?? ''
          : '', // Verifica si 'address' es null antes de acceder a 'label'
      position: json['position'] !=
              null // Verifica si 'position' es null antes de acceder a 'lat' y 'lng'
          ? LatLng(
              json['position']['lat'] ??
                  0.0, // Usa un valor predeterminado en caso de que 'lat' sea null
              json['position']['lng'] ??
                  0.0, // Usa un valor predeterminado en caso de que 'lng' sea null
            )
          : LatLng(0.0,
              0.0), // Usa un valor predeterminado para 'position' si es null
      distance: json['distance'] ??
          0, // Asigna 0 como valor predeterminado si 'distance' es null
    );
  }
}
