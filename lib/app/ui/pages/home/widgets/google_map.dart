import 'package:flutter/material.dart';
import 'package:found_me/app/ui/pages/home/home_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (_, controller, gpsMessageWidget) {
        if (!controller.gpsEnabled) {
          return gpsMessageWidget!;
        }

        final initialCameraPosition = CameraPosition(
          target: LatLng(controller.initialPosition!.latitude,
              controller.initialPosition!.longitude),
          zoom: 10,
        );
        return GoogleMap(
          markers: controller.markers,
          polygons: controller.polygons,
          polylines: controller.polylines,
          onMapCreated: controller.onMapCreated,
          initialCameraPosition: initialCameraPosition,
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          zoomControlsEnabled: false,
          compassEnabled: true,
          onTap: controller.onTap,
        );
      },
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
