import 'package:flutter/material.dart';
import 'package:found_me/app/ui/pages/splash/splash_controller.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  //controlador que permite usar las funciones de splash_controller siempre y cuando la ubicacion este en uso
  final _controller = SplashController(Permission.locationWhenInUse);

  @override
  void initState() {
    super.initState();
    //aqui nos aseguramos que almenos se vea una vez la vista splash y cumpla su funcion que es la de verificar si el permiso fue otorgado o no
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _controller.checkPermission();
    });
    //se verifica si el permiso fue otorgado y se le notifica a la app
    _controller.addListener(() {
      //en caso de que el _controller.routeName de un nombre distinto de nulo, redirigira al usuario
      //con el nommbre de la ruta (home,permisos,splash), junto con el contexto que necesite
      if (_controller.routeName != null) {
        Navigator.pushReplacementNamed(context, _controller.routeName!);
      }
    });
  }

//vista que observara el usuario mientras lo redirigen a la vista solicitada
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
