import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:found_me/app/ui/pages/home/controller/home_controller.dart';
import 'package:found_me/app/ui/pages/home/controller/home_state.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

//clase que creara un marcador en el centro de la pantalla con el fin de establecer una ubicacion de manera manual
class FixedMarker extends StatelessWidget {
  final String? text;
  final double mapPadding, height;
  const FixedMarker({
    super.key,
    required this.text,
    required this.mapPadding,
    required this.height,
  });

//mayormente estructura que busca que los container esten en el centro de la pantalla
  @override
  Widget build(BuildContext context) {
    final pickFromMap = context.select<HomeController, PickFromMap?>(
      (controller) => controller.state.pickFromMap,
    );
    if (pickFromMap == null) {
      return Container();
    }
    return Positioned(
      top: 0.5 * (height + mapPadding) - 25,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.translate(
            offset: const Offset(0, -25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: text != null
                          ? ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 250),
                              child: Text(
                                text!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          : const SpinKitCircle(
                              color: Colors.white,
                              size: 24,
                            ),
                    ),
                  ],
                ),
                Container(
                  width: 2,
                  height: 10,
                  color: Colors.black,
                ),
              ],
            ),
          ),
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}
