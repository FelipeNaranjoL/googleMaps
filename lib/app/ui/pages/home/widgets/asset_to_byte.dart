import 'dart:ui' as ui;
import 'package:flutter/services.dart';

//este codigo es mas que nada una funcion para poder crear una imagen, redimencionarla, darle un formato y pasarlo a la vista de mapa
//por lo demas, no lo entendi muy bien
Future<Uint8List> assetToBytes(String path, {int width = 100}) async {
  final byteData = await rootBundle.load(path);
  final bytes = byteData.buffer.asUint8List();
  final codec = await ui.instantiateImageCodec(bytes, targetWidth: width);
  final frame = await codec.getNextFrame();
  final newByteData = await frame.image.toByteData(
    format: ui.ImageByteFormat.png,
  );

  return newByteData!.buffer.asUint8List();
}
