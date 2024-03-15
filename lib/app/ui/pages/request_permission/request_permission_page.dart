import 'dart:async';
import 'package:flutter/material.dart';
import 'package:found_me/app/ui/pages/request_permission/request_permission_controller.dart';
import 'package:found_me/app/ui/pages/routes/routes.dart';
import 'package:permission_handler/permission_handler.dart';

class RequestPermissionPage extends StatefulWidget {
  const RequestPermissionPage({super.key});

  @override
  State<RequestPermissionPage> createState() => _RequestPermissionPageState();
}

// se crea esta vista para cuando el usuario no tenga los permisos requeridos de ubicacion, con el fin de dar la opcion de darlos o
//denegarlos en cualquier momento
class _RequestPermissionPageState extends State<RequestPermissionPage>
    with WidgetsBindingObserver {
  // variable  que permite usar las funciones de request_permission_controller,con el argumento de que
  //la localizacion este siempre en uso
  final _controller = RequestPermissionController(Permission.locationWhenInUse);
  //esta variable permite escuchar eventos en caso de esperar alguna respuesta o accion por parte del
  //usuario, la llamamos simplemente _subscription
  late StreamSubscription _subscription;
  //esta variable permitira saber si el usuario fue o no a las configuraciones del dispositivo para permitir
  //el acceso del a la app de usar su ubicacion
  bool _fromSettings = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    //aqui trabajaremos con condicionales, en caso de que el permiso sea otorgado, lo redirigiremos mediantes rutas hacia home
    //caso contrario, saldra una vista la cual explicara que requiere los permisos de ubicacion para que la app funcione correctamente
    //obviamente con los botones y los funcionamientos esperados
    _subscription = _controller.onStatusChanged.listen(
      (status) {
        if (status == PermissionStatus.granted) {
          _goTohome();
        } else if (status == PermissionStatus.permanentlyDenied) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Permisos necesarios'),
              content: const Text(
                  'Necesito que me otorgues permisos de ubicacion para poder funcionar de manera correcta'),
              actions: [
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    _fromSettings = await openAppSettings();
                  },
                  child: const Text('Ir a configuraciones'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Denegar'),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    //en esta condificonal, se verifica si es que fue al apartado de permisos es true, la cual mandara a la funcion check
    //si resulta que status es true, pasara a la condicional la cual verificara si el permiso fue otorgado, en caso de que haya pasado
    //esa condicion, se mandara al usuario a la vista de home
    // print("$state");
    if (state == AppLifecycleState.resumed && _fromSettings) {
      final status = await _controller.check();
      if (status == PermissionStatus.granted) {
        _goTohome();
      }
    }
    _fromSettings = false;
  }

//barre, cierra o elimina los elementos que ya no se necesitan o los procesos
  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    _subscription.cancel();
    _controller.dispose();
    super.dispose();
  }

//funcion que redirige a la ruta de home
  void _goTohome() {
    Navigator.pushReplacementNamed(context, Routes.HOME);
  }

// estructura para solicitar permisos de ubicacion, en pocas palabras, lo visual
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          child: ElevatedButton(
            child: const Text('Permitir'),
            onPressed: () {
              _controller.request();
            },
          ),
        ),
      ),
    );
  }
}
