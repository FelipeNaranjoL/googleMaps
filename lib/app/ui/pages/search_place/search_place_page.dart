import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:found_me/app/data/providers/local/remote/search_api.dart';
import 'package:found_me/app/data/repositories_impl/search_repository_impl.dart';
import 'package:found_me/app/ui/pages/search_place/search_place_controller.dart';
import 'package:found_me/app/utils/formato_distancia.dart';
import 'package:provider/provider.dart';

class SearchPlacePage extends StatelessWidget {
  const SearchPlacePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      //dentro del widget ChangeNotifierProvider, se requiere un contexto, use el del build, pero
      //por alguna razon que desconozco, funciona usando el (_) PENDIENTE
      // para poder acceder a las funciones de SearchPlaceController
      //acceso a SearchPlaceController, la cual contiene un constructor de SearchRepositoryImpl que contiene sus metodos.
      //y esta a su vez requiere de la instancia de SearchAPI, que necesita la instancia de Dio, algo confuso pero necesario para el
      //correcto funcionamiento de la vista del buscador
      create: (_) => SearchPlaceController(
        SearchRepositoryImpl(
          SearchAPI(
            Dio(),
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Builder(
            //dentro de builder, requiero nuevamente el contexto, pero esta vez del contexto de SearchPlaceController
            //una vez con ese contexto, puedo acceder a la funcion de onQueryChanged de search_controller.dart
            builder: (context) {
              return CupertinoTextField(
                onChanged: context.read<SearchPlaceController>().onQueryChanged,
              );
            },
          ),
        ),
        //este consumer se relaciona con SearchPlaceController, el builder requiere de un contexto, el controllador de SearchPlaceController
        //y un widget que no se utilizara de momento
        body: Consumer<SearchPlaceController>(
          builder: (_, controller, __) {
            //se crea la variable places, con el fin de obtener los lugares obtenidos de la api gracias a la query y sus coincidencias
            final places = controller.places;
            //en caso de que la query no haya entregado coincidencias o haya dado nulo, mostrara este mensaje
            if (places == null) {
              return const Center(
                child: Text('Error al momento de buscar la ubicación'),
              );
              //en caso de que la query este vacia o no haya mas o igual a 3 caracteres, mostrara este mensaje
            } else if (places.isEmpty && controller.query.length >= 3) {
              return const Center(
                child: Text('Intenta escribir una dirección'),
              );
            }
            //caso contrario, mostrara una lista, que requerira del contexto y un int, en este caso llamado index, con el fin de
            //listar las coincidencias de la api
            return ListView.builder(
              itemBuilder: (_, index) {
                //se almacena en esta variable, la cantidad de coincidencias encontradas en el controlador de SearchPlaceController
                //y que a su vez, fue almacenada previamente en la lista de places
                final place = places[index];
                //retornara la lista, con los datos de distancia, el nombre de la calle que coincidia con la query y la direccion
                return ListTile(
                  leading: Text(distanceFormat(place.distance)),
                  title: Text(place.title),
                  subtitle: Text(place.address),
                );
              },
              //se creara una nueva seccion de la lista en base a la cantidad de coincidencias almacenadas en la variable places de
              //SearchPlaceController
              itemCount: places.length,
            );
          },
        ),
      ),
    );
  }
}
