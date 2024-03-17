import 'package:google_maps_flutter/google_maps_flutter.dart';

//esta clase tiene como fin, almacenar la ubicacion actual del usuario
// se uso un singleton, con el fin de instanciar a una clase y poder acceder desde cualquier otra
class CurrentPosition {
  //constructor privado
  CurrentPosition._();
  static CurrentPosition i = CurrentPosition._();
  //variables para almacenar el valor de la ubicacion actual del usuario
  LatLng? _value;
  LatLng? get value => _value;

//funcion para modificar el valor de value o "v"
  void setValue(LatLng? v) {
    _value = v;
  }
}
