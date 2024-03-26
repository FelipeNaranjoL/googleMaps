import 'package:found_me/app/domain/models/place.dart';
import 'package:found_me/app/ui/pages/home/widgets/custom_painters/custom_markers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

//funcion que mostrara la duracion en tiempo entre 2 puntos
Future<BitmapDescriptor> placeToMarker(Place place, int? duration) async {
  //se crean las variables que almacenaran el tamaño, texto, e imagen?
  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas(recorder);
  const size = ui.Size(380, 100);
  final customMarker = MyCustomMarker(
    label: place.title,
    duration: duration,
  );
  //llamamos al metodo paint para subir mi canvas y el tamaño del mismo
  customMarker.paint(canvas, size);
  //variable que almacenara el canvas ya dibujado
  final picture = recorder.endRecording();
  //y definimos sus dimensiones en esta variable
  final image = await picture.toImage(
    size.width.toInt(),
    size.height.toInt(),
  );
  //convertira el canvas a formato png
  final byteData = await image.toByteData(
    format: ui.ImageByteFormat.png,
  );
  //almacenamos por ultima vez en este formato para que BitmapDescriptor lo pueda leer
  final bytes = byteData!.buffer.asUint8List();
  //y lo retornamos para poder verlo en la vista
  return BitmapDescriptor.fromBytes(bytes);
}
