import 'package:flutter/cupertino.dart';
import 'package:found_me/app/ui/pages/search_place/search_place_controller.dart';
import 'package:found_me/app/ui/pages/search_place/search_place_page.dart';
import 'package:provider/provider.dart';

//clase que permitira definir una ubicacion  desde el buscador del mapa
class PickFromMapButton extends StatelessWidget {
  const PickFromMapButton({super.key});

  @override
  Widget build(BuildContext context) {
    final originHasFocus = context.select<SearchPlaceController, bool>(
        (controller) => controller.originHasFocus);
    return CupertinoButton(
      onPressed: () {
        Navigator.pop(
          context,
          PickFromMapResponse(originHasFocus),
        );
      },
      child: Text(
          "Seleccionar ${originHasFocus ? "origen" : "destino"} desde el mapa"),
    );
  }
}
