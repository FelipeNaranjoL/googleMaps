import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:found_me/app/ui/pages/home/controller/home_controller.dart';
import 'package:found_me/app/ui/pages/home/controller/utils/go_to_search.dart';
import 'package:found_me/app/ui/pages/home/widgets/buttons/timeline_tile.dart';
import 'package:provider/provider.dart';

class OriginAndDestination extends StatelessWidget {
  const OriginAndDestination({super.key});
//clase con la que se creara un container flotante una vez definido el origin y destination que mostrara la ruta establecida, como en uber
  @override
  Widget build(BuildContext context) {
    //trabajamos con el contexto mediante un boleano y un controller para ocultar el container nuevo
    final originAndDestinationReady = context.select<HomeController, bool>(
      (controller) {
        final state = controller.state;
        return state.origin != null && state.destination != null;
      },
    );
    //aqui movemos el rectangulo, ademas le agregamos una animacion para que se vea mas vistosa
    return Positioned(
      left: 15,
      right: 15,
      top: 10,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          final position = Tween<Offset>(
            begin: const Offset(0, -1),
            end: const Offset(0, 0),
          ).animate(animation);
          return SlideTransition(
            position: position,
            child: child,
          );
        },
        child: originAndDestinationReady ? const _View() : Container(),
      ),
    );
  }
}

class _View extends StatelessWidget {
  const _View({super.key});

  @override
  Widget build(BuildContext context) {
    //obtenemos los datos de controller
    final controller = Provider.of<HomeController>(context, listen: false);
    final state = controller.state;
    //obtenemos los datos de origin y destination
    final origin = state.origin!;
    final destination = state.destination!;
    //estructura para crear un rectangulo, el boton "x" y el contenido dentro del rectangulo
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //boton de accion  o "x"
          CupertinoButton(
            onPressed: context.read<HomeController>().clearData,
            color: Colors.white,
            padding: const EdgeInsets.all(10),
            borderRadius: BorderRadius.circular(30),
            child: const Icon(
              Icons.close_rounded,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      TimeLineTile(
                        label: "Origen",
                        description: origin.title,
                        onPressed: () => goToSearch(context),
                        isTop: true,
                      ),
                      TimeLineTile(
                        label: "Destino",
                        description: destination.title,
                        onPressed: () => goToSearch(context, false),
                        isTop: false,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                CupertinoButton(
                  onPressed: controller.exchange,
                  color: Colors.grey.withOpacity(0.2),
                  padding: const EdgeInsets.all(10),
                  borderRadius: BorderRadius.circular(30),
                  child: const Icon(
                    Icons.sync,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 5,
                  color: Colors.black12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
