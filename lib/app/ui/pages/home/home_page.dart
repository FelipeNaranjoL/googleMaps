import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:found_me/app/data/providers/local/geolocator_wrapper.dart';
import 'package:found_me/app/data/providers/remote/router_api.dart';
import 'package:found_me/app/data/repositories_impl/routes_repository_impl.dart';
import 'package:found_me/app/ui/pages/home/controller/home_controller.dart';
import 'package:found_me/app/ui/pages/home/widgets/google_map.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  // ignore: use_super_parameters
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeController>(
      //esta es una estructura exclusiva de ChangeNotifierProvider, el cual recibira como parametro el HomeController
      //requiere de un contexto, en este caso "_" y un controller, en este caso el HomeController y retornara el controlador resultante
      //dentro de HomeController se hace referencia a GeolocatorWrapper para usar sus metodos y se agrega RouteReposirotyImpl
      //RouteReposirotyImpl para implementar o usar la clase RoutesApi, acceda a sus funciones y mediante Dio nos de una respuesta
      create: (_) => HomeController(
        GeolocatorWrapper(),
        RouteReposirotyImpl(
          RoutesApi(
            Dio(),
          ),
        ),
      ),
      child: Scaffold(
        // appBar: AppBar(),
        //aqui va la estructura del mapa, requiere del controller y un boleano para verificar una condicion, en este caso seria la
        //de loading, en caso de que haya un cambio de valor, se redibujara el Selector y todo lo que haya dentro
        body: Selector<HomeController, bool>(
          //aqui selector requiere de un contexto con el cual se trabajara a lo largo de su estructura y un controller
          //en el builder se trabajara con el contexto y el booleano, en este caso loading y entregara un widget, en este caso
          //loadingWidget que sera una vista de un circulo cargando, simulando la carga de datos del mapa
          selector: (_, controller) => controller.state.loading,
          builder: (context, loading, loadingWidget) {
            //si loading == true,se saltara el widget de loadingWidget y desplegara el mapa, en caso de que el builder tenga el booleano == false,
            //mostrara el loadingWidget
            if (loading) {
              return loadingWidget!;
            }
            //MapView sera el mapa, esta ubicado en otro lado para hacer el codigo menos pesado de entender
            return const MapView();
          },
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
