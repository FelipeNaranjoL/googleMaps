import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:found_me/app/ui/pages/home/controller/home_controller.dart';
import 'package:found_me/app/ui/pages/search_place/search_place_page.dart';
import 'package:provider/provider.dart';

class DondeTeLlevo extends StatelessWidget {
  const DondeTeLlevo({
    super.key,
  });

//la estructura de este codigo se basa netamente en el boton que tiene como fin, ayudar al usuario
//ingresar su destino o el lugar a donde quiera ir
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 35,
      left: 20,
      right: 20,
      child: SafeArea(
        //al precionar el boton, lo redirigira a la vista de SearchPlacePage, en el cual podra escribir la ubicacion deseada y se desplegara
        //los datos sugeridos por la api de hereapi mediante la funcion de autosuggest
        child: CupertinoButton(
          onPressed: () async {
            final route = MaterialPageRoute<SearchResponse>(
              builder: (_) => const SearchPlacePage(),
            );
            final response = await Navigator.push<SearchResponse>(
              context,
              route,
            );
            //en caso de que la respuesta sea distinta de nula, asignaremos el origen y el destino deseado por el usuario
            if (response != null) {
              // print('origen: ${response.origin.title}');
              final controller = context.read<HomeController>();
              controller.setOriginAndDestination(
                response.origin,
                response.destination,
              );
            }
          },
          //el resto es contenido visual para hacer mas atractivo la vista
          padding: EdgeInsets.zero,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: const Text(
              'A donde vamos hoy?',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black87),
            ),
          ),
        ),
      ),
    );
  }
}
