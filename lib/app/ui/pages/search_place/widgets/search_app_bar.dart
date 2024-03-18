import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:found_me/app/ui/pages/search_place/search_place_controller.dart';
import 'package:found_me/app/ui/pages/search_place/search_place_page.dart';
import 'package:provider/provider.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SearchAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.black87),
      elevation: 0,
      //en la parte superior, se agregara acciones, con el fin de aceptar el viaje entre
      //origen y destino
      actions: [
        Builder(
          //el builder trabajara con el contexto actual, se creara controller afiliado a SearchPlaceController
          //con el fin de observar los cambios, una variable booleana para saber si existe un origen y destino ya establecidos
          //y retornara un CupertinoButton con el texto de "ok" y una funcion
          builder: (context) {
            final controller = context.watch<SearchPlaceController>();
            final origin = controller.origin;
            final destination = controller.destination;
            final bool enabled = origin != null && destination != null;
            return CupertinoButton(
              onPressed: enabled
                  ? () {
                      Navigator.pop(
                        context,
                        SearchResponse(origin, destination),
                      );
                    }
                  : null,
              child: const Text('Ok'),
            );
          },
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(55);
}
