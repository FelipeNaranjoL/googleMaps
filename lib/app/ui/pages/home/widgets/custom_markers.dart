import 'package:flutter/material.dart';

//se crea una clase de CustomPainter para poder trabajar con ella
class MyCustomMarker extends CustomPainter {
  //añadiendo variable para almacenar un texto y añadiendo un constructor para que sea un dato
  //requerido, al igual que el int
  final String label;
  final int? duration;
  MyCustomMarker({
    required this.label,
    required this.duration,
  });

//funcion que automatiza el crear texto y ubicarlo de manera automatica dentro de una estructura
//aunque tambien trabajara con iconos
  void _drawText({
    required Canvas canvas,
    required Size size,
    required String text,
    required double width,
    double? dx,
    double? dy,
    String? fontFamily,
    double fontSize = 18,
    Color color = Colors.black,
    FontWeight? fontWeight,
  }) {
    //texto dentro de mi rectangulo, enlazado con la instancia necesaria para funcionar
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontFamily: fontFamily,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
      //ubicacion del texto, en este caso empezara los la izquierda
      textDirection: TextDirection.ltr,
      //maximo de lineas
      maxLines: 2,
    );
    //ubicacion del texto para que este centrado de izquierda a derecha (margen)
    textPainter.layout(
      maxWidth: width,
    );
    //posicionamiento del texto de arriba y abajo, aunque el primer parametro debe coincidir con layout
    textPainter.paint(
      canvas,
      Offset(
        dx ?? size.height * 0.5 - textPainter.width * 0.5,
        size.height * 0.5 - textPainter.size.height * 0.5 + (dy ?? 0),
      ),
    );
  }

  @override
  //funcion que se encarga de dibujar
  void paint(Canvas canvas, Size size) {
    //definimos las variables y las clases con las que trabajaremos
    final paint = Paint();
    paint.color = Colors.white;
    // final rect = Rect.fromLTWH(0, 0, size.width, size.height);
//estructura (segun el SizedBox definido previamente) que se usara como base para crear el custom painter
    final rRect = RRect.fromLTRBR(
      0,
      0,
      size.width,
      size.height,
      const Radius.circular(5),
    );
    //estructura (rectangular) donde se hara el dibujo
    canvas.drawRRect(rRect, paint);
    paint.color = Colors.black87;
    // estructura del rectangulo negro
    final miniRect = RRect.fromLTRBAndCorners(
      0,
      0,
      size.height,
      size.height,
      topLeft: const Radius.circular(5),
      bottomLeft: const Radius.circular(5),
    );
    canvas.drawRRect(miniRect, paint);
    //llamada a la funcion _drawText con todos o algunos de sus atributos
    _drawText(
      canvas: canvas,
      size: size,
      text: label,
      dx: size.height + 10,
      width: size.width - size.height - 10,
    );
    //en caso de que duration sea nulo, mostrara solo el icono
    if (duration == null) {
      //llamada a la funcion _drawText con todos o algunos de sus atributos
      _drawText(
        canvas: canvas,
        size: size,
        text: String.fromCharCode(
          Icons.gps_fixed_rounded.codePoint,
        ),
        fontFamily: Icons.gps_fixed_rounded.fontFamily,
        fontSize: 35,
        color: Colors.white,
        width: size.height,
      );
    } else {
      //en cualquier otro caso, mostrara el tiuempo de duracion de viaje en el lugar del icono
      //y acompañado del texto "min" o "horas"
      //variable que almacenara el valor de minutos entre punto A y B y que sera convertido en Hrs o Min dependiendo del tiempo del mismo
      final realDuraation = Duration(seconds: duration!);
      final minutes = realDuraation.inMinutes;
      final String durationAsText =
          "${minutes > 59 ? realDuraation.inHours : minutes}";
      _drawText(
        canvas: canvas,
        size: size,
        text: durationAsText,
        fontSize: 28,
        dy: -10,
        color: Colors.white,
        width: size.height,
        fontWeight: FontWeight.w300,
      );
      _drawText(
        canvas: canvas,
        size: size,
        text: minutes > 59 ? "Horas" : "Min",
        fontSize: 20,
        dy: 15,
        color: Colors.white,
        width: size.height,
        fontWeight: FontWeight.bold,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
