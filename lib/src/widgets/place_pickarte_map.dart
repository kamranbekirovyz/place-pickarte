import 'package:place_pickarte/place_pickarte.dart';
import 'package:place_pickarte/src/widgets/place_pickarte_pin.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlacePickarteMap extends StatelessWidget {
  final PlacePickarteController controller;

  const PlacePickarteMap(
    this.controller, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StreamBuilder<MapType>(
          initialData: controller.config.googleMapConfig.googleMapType,
          stream: controller.googleMapTypeStream,
          builder: (context, snapshot) {
            final googleMapType = snapshot.requireData;

            return GoogleMap(
              zoomControlsEnabled:
                  controller.config.googleMapConfig.zoomControlsEnabled,
              myLocationButtonEnabled: false,
              myLocationEnabled: true,
              mapType: googleMapType,
              onMapCreated: controller.onGoogleMapCreated,
              initialCameraPosition:
                  controller.config.initialGoogleMapCameraPosition,
              onCameraIdle: controller.onCameraIdle,
              onCameraMove: controller.onCameraMove,
              onCameraMoveStarted: controller.onCameraMoveStarted,
            );
          },
        ),
        PlacePickartePin(
          pinBuilder: controller.config.pinBuilder,
          pinStateStream: controller.pinStateStream,
        ),
      ],
    );
  }
}
