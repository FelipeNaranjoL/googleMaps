import 'package:flutter/material.dart';
import 'package:found_me/app/ui/pages/search_place/search_place_controller.dart';
import 'package:found_me/app/utils/formato_distancia.dart';
import 'package:provider/provider.dart';

class SearchResults extends StatefulWidget {
  const SearchResults({super.key});

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SearchPlaceController>();
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
          onTap: () {
            //en caso de presionar algun item de la lista, el teclado desaparecera y el controllador agregara el
            //titulo de la calle en el input de manera automatica
            FocusScope.of(context).unfocus();
            controller.pickPlace(place);
          },
        );
      },
      //se creara una nueva seccion de la lista en base a la cantidad de coincidencias almacenadas en la variable places de
      //SearchPlaceController
      itemCount: places.length,
    );
  }
}
