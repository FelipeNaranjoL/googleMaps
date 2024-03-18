import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:found_me/app/data/providers/local/remote/search_api.dart';
import 'package:found_me/app/data/repositories_impl/search_repository_impl.dart';
import 'package:found_me/app/domain/models/place.dart';
import 'package:found_me/app/ui/pages/search_place/search_place_controller.dart';
import 'package:found_me/app/ui/pages/search_place/widgets/search_app_bar.dart';
import 'package:found_me/app/ui/pages/search_place/widgets/search_inputs.dart';
import 'package:found_me/app/ui/pages/search_place/widgets/search_results.dart';
import 'package:provider/provider.dart';

//esta clase tiene como fin de existir para compartir origen y destino del usuario
class SearchResponse {
  final Place origin, destination;
  SearchResponse(this.origin, this.destination);
}

class SearchPlacePage extends StatelessWidget {
  const SearchPlacePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      //dentro del widget ChangeNotifierProvider, se requiere un contexto, se requiere un create con el contexto, en este caso
      //es "_", que esta enlazado con SearchPlaceController con el fin de obtener
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
        //cambiando el background y el color de volver de appBar
        //envolvemos en un wigdet el appBar para gestionar mejor nuestro codigo
        appBar: const SearchAppBar(),
        //caja de tamaño que consumira todo el alto y ancho de la pantalla
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          // ignore: prefer_const_constructors
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            //creando columnas para los label_input
            // ignore: prefer_const_constructors
            child: Column(
              children: const [
                cabeceraInputs(),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                    //este consumer se relaciona con SearchPlaceController, el builder requiere de un contexto, el controllador de SearchPlaceController
                    //y un widget que no se utilizara de momento
                    child: SearchResults()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
