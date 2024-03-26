import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:found_me/app/ui/pages/home/controller/home_controller.dart';
import 'package:provider/provider.dart';

//clase que sera el boton "x" para salir del modo de seleccion manual de ubicacion
class CancelPickFromMapButton extends StatelessWidget {
  const CancelPickFromMapButton({super.key});

  @override
  Widget build(BuildContext context) {
    final visible = context.select<HomeController, bool>(
        (controller) => controller.state.pickFromMap != null);
    if (!visible) {
      return Container();
    }
    return Positioned(
      left: 15,
      top: 15,
      child: SafeArea(
        child: CupertinoButton(
          padding: const EdgeInsets.all(7),
          borderRadius: BorderRadius.circular(30),
          onPressed: context.read<HomeController>().cancelPickFromMap,
          child: Icon(
            Icons.close_rounded,
            color: Colors.black,
            size: 25,
          ),
          color: Colors.white,
        ),
      ),
    );
  }
}
