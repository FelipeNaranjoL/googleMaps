import 'package:flutter/material.dart';
import 'package:found_me/app/ui/pages/routes/pages.dart';
import 'package:found_me/app/ui/pages/routes/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //ruta inicial donde siempre iniciara la app, hara las verificaciones pertinentes y dara acceso
      //al mapa al usuario
      initialRoute: Routes.SPLASH,
      //lista de rutas el cual podra moverse el usuario o sera movido en caso de realizar verificaciones
      //de ubicacion y permisos
      routes: appRoutes(),
    );
  }
}
