import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DondeTeLlevo extends StatelessWidget {
  const DondeTeLlevo({
    super.key,
  });

//la estructura de este codigo se basa netamente en el label que tiene como fin, ayudar al usuario
//ingresar su destino o el lugar a donde quiera ir
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 35,
      left: 20,
      right: 20,
      child: SafeArea(
        child: CupertinoButton(
          onPressed: () {},
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
