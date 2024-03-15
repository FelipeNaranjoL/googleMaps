import 'package:flutter/widgets.dart' show ChangeNotifier;
import 'package:found_me/app/ui/pages/routes/routes.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashController extends ChangeNotifier {
  //esta variable nos dira si el permiso fue otorgado o no, en caso de ser falso, redirigira al usuario
  //a la vista de permission_request a que le de acceso de manera manual
  final Permission _locationPermisssion;
  //esta variable almacenara el nombre de la ruta especificada en routes.dart
  // y trabajara con _routeName para utilizarla mas adelante, tambien se creo su
  //get para trabajarla desde fuera del controlador
  String? _routeName;
  String? get routeName => _routeName;
  //controlador de _locationPermisssion encargado de verificar en cada momento si el permiso solicitado
  //fue denegado o otorgado
  SplashController(this._locationPermisssion);

//checkPermission tiene como fin, esperar el permiso por parte del usuario y ejecutarse,
//en caso de ser otorgado, redirigira al usuario a la vista de home, caso contrario, lo llevara
//a la vista de permisos para explicar el por que es necesario el permiso de gps
//finamente notificara a la app de que la accion se ejecuto o no
  Future<void> checkPermission() async {
    final isGranted = await _locationPermisssion.isGranted;
    _routeName = isGranted ? Routes.HOME : Routes.PERMISSIONS;
    notifyListeners();
  }
}
