import 'dart:async';
import 'package:permission_handler/permission_handler.dart';

//se crea la clase con la cual podremos importar las funciones a request_permission_page
class RequestPermissionController {
  final Permission _locationPermission;
  RequestPermissionController(this._locationPermission);
  //obtenemos los datos del status mediante el stream, luego se crea un get para poder obtener esos datos
  //y pasarlos al _streamController
  final _streamController = StreamController<PermissionStatus>.broadcast();
  Stream<PermissionStatus> get onStatusChanged => _streamController.stream;

  //revisa el estado de la solicitud de permiso, y lo enviara a didChangeAppLifecycleState del request_perission_page
  //mas informacion en su funcion
  Future<PermissionStatus> check() async {
    final status = await _locationPermission.status;
    return status;
  }

//funcion encargada de solicitar el acceso de la ubicacion al dispositivo, dependiendo del estado
// de status, dejara pasar al usuario a home o le saltara la pagina de request_perission_page
  Future<void> request() async {
    final status = await _locationPermission.request();
    // print('$status');
    _notify(status);
  }

//esta funcion se encarga de notificar los ultimos cambios de los permisos de ubicacion mediante la
// solicitud de status
  void _notify(PermissionStatus status) {
    if (!_streamController.isClosed && _streamController.hasListener) {
      _streamController.sink.add(status);
    }
  }

//barre, cierra o elimina los elementos que ya no se necesitan o los procesos
  void dispose() {
    _streamController.close();
  }
}
