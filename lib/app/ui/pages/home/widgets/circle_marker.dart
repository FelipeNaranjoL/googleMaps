import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<BitmapDescriptor> getDotMarker() async {
  //se crean las variables que almacenaran el tamaño, texto, e imagen?
  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas(recorder);
  const size = ui.Size(30, 30);
  final customMarker = CircleMarker();
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

//clase creada para pintar un circulo
class CircleMarker extends CustomPainter {
  CircleMarker();
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Colors.black;
    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(
      center,
      size.width * 0.5,
      paint,
    );
    paint.color = Colors.white;
    canvas.drawCircle(
      center,
      size.width * 0.3,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
