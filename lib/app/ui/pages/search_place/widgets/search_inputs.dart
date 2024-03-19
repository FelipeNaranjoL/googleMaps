import 'package:flutter/material.dart';
import 'package:found_me/app/ui/pages/search_place/search_place_controller.dart';
import 'package:found_me/app/ui/pages/search_place/widgets/label_input.dart';
import 'package:provider/provider.dart';

class CabeceraInputs extends StatelessWidget {
  const CabeceraInputs({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    //se crea un provider con el fin de acceder al contexto de SearchPlaceController pero esta vez, sin que se actualice
    //la vista cuando hayan cambios y usar su controller con sus propiedades
    final controller =
        Provider.of<SearchPlaceController>(context, listen: false);
    return Column(
      children: [
        //columna de origen
        LabelInput(
          //caracteristicas que definiste en label_input.dart y que son requeridas
          //controller: controlador para editar el texto ingresado
          //focusNode: se utiliza para definir donde realiazar el foco de atencion en los input
          //placeholder: el texto de ejemplo o guia para el usuario
          //onChanged: metodo encargado de realizar llamadas a la api cuando se ingresa algun texto
          controller: controller.originController,
          focusNode: controller.originFocusNode,
          placeholder: 'origen',
          onChanged: controller.onQueryChanged,
        ),
        //columna de destino
        LabelInput(
          //caracteristicas que definiste en label_input.dart y que son requeridas
          //controller: controlador para editar el texto ingresado
          //focusNode: se utiliza para definir donde realiazar el foco de atencion en los input
          //placeholder: el texto de ejemplo o guia para el usuario
          //onChanged: metodo encargado de realizar llamadas a la api cuando se ingresa algun texto
          controller: controller.destinationController,
          focusNode: controller.destinationFocusNode,
          placeholder: 'Destino',
          onChanged: controller.onQueryChanged,
        ),
      ],
    );
  }
}
