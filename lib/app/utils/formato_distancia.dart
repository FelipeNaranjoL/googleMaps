//metodo que requiere de un valor int, en este caso la distancia, calculara la misma, para obtener valores mas resumidos
//basado en kilometros si superan los 1000 metros en formato x.x KM o 12.4km, obviamente el valor entero puede ser mucho mas alto
String distanceFormat(int valueInMeters) {
  if (valueInMeters >= 1000) {
    return "${(valueInMeters / 1000).toStringAsFixed(1)}\nKM";
  }
  //caso contrario, si el valor es inferior a 1000, el valor sera xxxxm o 921 m
  return "$valueInMeters\nM";
}
