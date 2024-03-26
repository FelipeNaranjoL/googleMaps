import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:found_me/app/ui/pages/home/controller/home_controller.dart';
import 'package:found_me/app/ui/pages/home/controller/home_state.dart';
import 'package:provider/provider.dart';

class ConfirmFromMapButton extends StatelessWidget {
  const ConfirmFromMapButton({super.key});

  @override
  Widget build(BuildContext context) {
    final PickFromMap? data = context.select<HomeController, PickFromMap?>(
      (controller) {
        final state = controller.state;
        return state.pickFromMap;
      },
    );
    if (data == null) {
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
            //boton de gps
            CupertinoButton(
              color: Colors.white,
              padding: const EdgeInsets.all(10),
              onPressed: context.read<HomeController>().goToMyPosition,
              child: const Icon(
                Icons.gps_fixed_rounded,
                color: Colors.black87,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            CupertinoButton(
              onPressed: () {},
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
                  'Confirmar',
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
