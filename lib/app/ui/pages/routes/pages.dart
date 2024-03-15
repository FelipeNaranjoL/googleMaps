import 'package:flutter/widgets.dart';
import 'package:found_me/app/ui/pages/home/home_page.dart';
import 'package:found_me/app/ui/pages/request_permission/request_permission_page.dart';
import 'package:found_me/app/ui/pages/routes/routes.dart';
import 'package:found_me/app/ui/pages/splash/splash_page.dart';

//creamos la estructura para poder redirigir a las distintas vistas de la app, mediante la funcion llamada appRoutes,
//la cual retornara las rutas de spash, permisos, home y otros en caso de realizar actualizaciones

Map<String, Widget Function(BuildContext)> appRoutes() {
  return {
    //se solicita el contexto, en este caso el "_" y luego una funcion la cual envie a la vista deseada
    Routes.SPLASH: (_) => const SplashPage(),
    Routes.PERMISSIONS: (_) => const RequestPermissionPage(),
    Routes.HOME: (_) => const HomePage(),
  };
}
