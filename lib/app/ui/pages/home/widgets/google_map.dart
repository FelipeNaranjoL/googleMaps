import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:found_me/app/ui/pages/home/controller/home_controller.dart';
import 'package:found_me/app/ui/pages/home/widgets/buttons/boton_llevar.dart';
import 'package:found_me/app/ui/pages/home/widgets/buttons/cancel_pick_from_map_button.dart';
import 'package:found_me/app/ui/pages/home/widgets/buttons/confirm_from_map_button.dart';
import 'package:found_me/app/ui/pages/home/widgets/fixed_marker.dart';
import 'package:found_me/app/ui/pages/home/widgets/origin_and_destination.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    // obtenemos las dimensiones de la pantalla
    final size = MediaQuery.of(context).size;
    //utilizamos este constructor para evitar redibujar todo el contenido nuevo de la vista de mapa y a su vez actualizar
    //lo que el usuario ve, se necesita el parametro del contexto = _, el controlador de HomeController que en este caso es
    //controller y finalmente un widget para desplegar los cambios en caso de que la validacion sea  == false
    return Consumer<HomeController>(
      //en builder, se requiere el contexto, en este caso "_", el controlador y un widget en caso de que algo
      //no salga como lo esperado
      builder: (_, controller, gpsMessageWidget) {
        final state = controller.state;
        //en caso de que state.gpsEnabled sea distinto de true, se desplegara el widget gpsMessageWidget
        //que tiene por objetivo  mostrar al usuario una notificacion acerca de que debe encender su gps
        //caso contrario, desplegara el mapa con las funciones que le añadimos
        if (!state.gpsEnabled) {
          return gpsMessageWidget!;
        }

        //esta es la ubicacion inicial del usuario, otorgada gracias a geolocator y dara un nivel de zoom de 15
        final initialCameraPosition = CameraPosition(
          target: LatLng(state.initialPosition!.latitude,
              state.initialPosition!.longitude),
          zoom: 15,
        );
        //padding del mapa
        final mapPadding = size.height * 0.25;
        // widget de google map, este desplegara el mapa cpmp tal siempre y cuando la api key este bien,
        // tambien le pasamos la cameraposicion anteriormente creada para desplegar nuestra posicion dentro del mapa
        return LayoutBuilder(
          builder: (_, constraints) => Stack(
            alignment: Alignment.center,
            children: [
              GoogleMap(
                //marcadores o puntos de ubicacion dentro del mapa
                markers: state.markers.values.toSet(),
                //los polylines son las lineas que se generan al ir a un punto A al B
                polylines: state.polylines.values.toSet(),
                //esta funcion permite cambiar el estilo del mapa, en este caso, uso el mapa por defecto, por eso la
                //funcion es bastante sencilla
                onMapCreated: (mapController) {
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) {
                      controller.onMapCreated(mapController);
                    },
                  );
                },
                //obtiene las coordenadas del dispositivo con la variable initialCameraPosition
                initialCameraPosition: initialCameraPosition,
                //se declara que tipo de mapa se vera en la vista, normal, satelital, semafoto, entre otros
                mapType: MapType.normal,
                //se visualiza el boton de gps o redirigir a mi posicion y mi punto o mi ubicacion desplegada en el mapa
                myLocationButtonEnabled: false,
                myLocationEnabled: true,
                // el controlador de zoom, este se vera como unos botones, esta desactivada por no ser muy atractiva a la vista
                zoomControlsEnabled: false,
                // compass apra dar una mejor vista a la ubicacion del usuario y este se pueda guiar
                compassEnabled: true,
                //que tan alejado se pudiese ver el mapa de los contenidos
                padding: EdgeInsets.only(top: mapPadding),
              ),
              //esta linea es la generacion de un label por encima del mapa, con el fin de
              //crear un buscador de lugares con la api de hereapi
              const DondeTeLlevo(),
              const OriginAndDestination(),
              //str que llevara el container negro el cual mostrara la ubicacion actual
              FixedMarker(
                text: "null",
                mapPadding: mapPadding,
                height: constraints.maxHeight,
              ),
              const CancelPickFromMapButton(),
              const ConfirmFromMapButton(),
            ],
          ),
        );
      },
      // este seria el gpsMessageWidget, con el fin de mostrar un mensaje de que el gps se desactivo y es encesario estar encendido
      //en todo momento para poder trabajar de una manera eficaz
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Para poder tener una mejor experiencia, mantenga el GPS activado en todo momento',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final controller = context.read<HomeController>();
                controller.turnOnGps();
              },
              child: const Text('Encender GPS'),
            )
          ],
        ),
      ),
    );
  }
}
