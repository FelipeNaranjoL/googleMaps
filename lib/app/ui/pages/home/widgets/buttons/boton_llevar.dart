import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:found_me/app/ui/pages/home/controller/home_controller.dart';
import 'package:found_me/app/ui/pages/home/controller/utils/go_to_search.dart';
import 'package:provider/provider.dart';

class DondeTeLlevo extends StatelessWidget {
  const DondeTeLlevo({
    super.key,
  });

//la estructura de este codigo se basa netamente en el boton que tiene como fin, ayudar al usuario
//ingresar su destino o el lugar a donde quiera ir
  @override
  Widget build(BuildContext context) {
    //trabajamos con el contexto mediante un boleano y un controller para ocultar los botones de zoom y buscador
    final hide = context.select<HomeController, bool>(
      (controller) {
        final state = controller.state;
        final originAndDestinationReady =
            state.origin != null && state.destination != null;
        return originAndDestinationReady ||
            state.fetching ||
            state.pickFromMap != null;
      },
    );
    if (hide) {
      return Container();
    }
    return Positioned(
      bottom: 35,
      left: 20,
      right: 20,
      child: SafeArea(
        //al precionar el boton, lo redirigira a la vista de SearchPlacePage, en el cual podra escribir la ubicacion deseada y se desplegara
        //los datos sugeridos por la api de hereapi mediante la funcion de autosuggest
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            //boton de zoom +
            CupertinoButton(
              color: Colors.white,
              padding: const EdgeInsets.all(10),
              onPressed: context.read<HomeController>().zoomIn,
              child: const Icon(
                Icons.add,
                color: Colors.black87,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            //boton de zoom -
            CupertinoButton(
              color: Colors.white,
              padding: const EdgeInsets.all(10),
              onPressed: context.read<HomeController>().zoomOut,
              child: const Icon(
                Icons.remove,
                color: Colors.black87,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            CupertinoButton(
              onPressed: () => goToSearch(context),
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
          ],
        ),
      ),
    );
  }
}
