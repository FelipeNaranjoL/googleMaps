//la clase es abstracta para que no se le pueda hacer referencia por equivocacion a otras vistas o clases
//por otro lado las rutas existen para poder redirigir de manera mas sencilla al usuario mediante estos nombres clave
abstract class Routes {
  // ignore: constant_identifier_names
  static const SPLASH = "/";
  // ignore: constant_identifier_names
  static const HOME = "/home";
  // ignore: constant_identifier_names
  static const PERMISSIONS = "/permissions";
}
