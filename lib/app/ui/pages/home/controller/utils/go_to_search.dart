import 'package:flutter/material.dart'
    show BuildContext, MaterialPageRoute, Navigator, WidgetsBinding;
import 'package:found_me/app/ui/pages/home/controller/home_controller.dart';
import 'package:found_me/app/ui/pages/search_place/search_place_page.dart';
import 'package:provider/provider.dart';

void goToSearch(BuildContext context, [bool hasOriginFocus = true]) async {
  //obtenemos los datos de controller
  final controller = Provider.of<HomeController>(context, listen: false);
  final state = controller.state;
  final route = MaterialPageRoute<SearchResponse>(
    builder: (_) => SearchPlacePage(
      initialOrigin: state.origin,
      initialDestination: state.destination,
      hasOriginFocus: hasOriginFocus,
    ),
  );
  final response = await Navigator.push<SearchResponse>(
    context,
    route,
  );
  //en caso de que la respuesta sea distinta de nula, asignaremos el origen y el destino deseado por el usuario
  if (response != null) {
    WidgetsBinding.instance!.addPostFrameCallback(
      (_) {
        // print('origen: ${response.origin.title}');
        final controller = context.read<HomeController>();
        //condiciones que corresponderan al tipo de response y ejecutaran las acciones pertienentes
        if (response is OriginAndDestinationResponse) {
          controller.setOriginAndDestination(
            response.origin,
            response.destination,
          );
        } else if (response is PickFromMapResponse) {
          // print("seleccion de origen de manera manual");
          controller.pickFromMap(response.isOrigin);
        }
      },
    );
  }
}
