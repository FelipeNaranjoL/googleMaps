import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:found_me/app/ui/pages/search_place/search_place_page.dart';

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
          onPressed: () {
            final route = MaterialPageRoute(
              builder: (_) => SearchPlacePage(),
            );
            Navigator.push(context, route);
          },
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
