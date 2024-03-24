import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//creando label_input con el fin de resumir el codigo de search_place_page.dart
class LabelInput extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String placeholder;
  final void Function(String) onChanged;
  final VoidCallback onClear;

  const LabelInput({
    Key? key,
    required this.placeholder,
    required this.onChanged,
    required this.focusNode,
    required this.controller,
    required this.onClear,
  }) : super(key: key);

  @override
  State<LabelInput> createState() => _LabelInputState();
}

class _LabelInputState extends State<LabelInput> {
  //declaramos esta variable para alertar cambios
  late ValueNotifier<String> _text;

  @override
  void initState() {
    super.initState();
    // ahora _text almacenara el valor entregado por controller, o en otras palabras, el valor inicial
    _text = ValueNotifier(widget.controller.text);
    widget.controller.addListener(
      () {
        //variable para almacenar el contenido de _text
        final textFromController = widget.controller.text;
        //si _textesta vacio en valor y no contiene nada, el valor por defecto sera nada
        if (textFromController.isEmpty && _text.value.isNotEmpty) {
          _text.value = '';
        } else if (textFromController.isNotEmpty) {
          _text.value = textFromController;
        }
      },
    );
  }

//cuerpo del label, el padding y otras decoraciones
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        //campos de TextField
        //controller: quien maneja el funcionamiento o funciones del input y el valor ingresado
        //focusNode: el nivel de prioridad del input
        //onChanged
        //decoration: atributos de decoracion, mayormente de estilo, lo visual
        controller: widget.controller,
        focusNode: widget.focusNode,
        onChanged: (text) {
          //esta funcion espera a escuchar cambios en la variable text, modifica el valor de
          //_text por text, cuando haya algo escrito en el input, aparecera el icono de borrar contenido
          _text.value = text;
          widget.onChanged(text);
        },
        decoration: InputDecoration(
          labelText: widget.placeholder,
          border: const OutlineInputBorder(),
          suffixIcon: ValueListenableBuilder<String>(
            //valueListenable esperara a _text para realizar los cambios
            valueListenable: _text,
            //el primero es el contexto, luego la variable text que la definimos como un String
            //y finalmente el widget
            builder: (_, text, child) {
              //en caso de que el texto no este vacio, mostrara una X, caso contrario no aparecera nada
              if (text.isNotEmpty) {
                return child!;
              }
              return const SizedBox();
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CupertinoButton(
                //el icono de eliminar contenido al final del input a la derecha
                padding: const EdgeInsets.all(10),
                color: Colors.black26,
                child: const Icon(Icons.close_rounded),
                onPressed: () {
                  //cuando presionamos el icono, borrara el contenido del input, asignara un valor vacio
                  //de tipo String a _text y se notificara a la vista del nuevo valor
                  widget.controller.text = '';
                  _text.value = '';
                  widget.onClear();
                },
              ),
            ),
          ),
        ),
        // placeholder: placeholder,
        // decoration: BoxDecoration(
        //   color: Colors.black12,
        //   border: Border.all(width: 1, color: Colors.black38),
        // ),
      ),
    );
  }
}
