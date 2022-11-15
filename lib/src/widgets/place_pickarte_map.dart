import 'package:place_pickarte/place_pickarte.dart';
import 'package:place_pickarte/src/helpers/extensions.dart';
import 'package:place_pickarte/src/widgets/place_pickarte_pin.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlacePickarteMap extends StatelessWidget {
  final PlacePickarteController controller;

  const PlacePickarteMap({
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          myLocationButtonEnabled: false,
          myLocationEnabled: true,
          mapType: controller.config.mapType,
          onMapCreated: controller.onGoogleMapCreated,
          initialCameraPosition: controller.config.initialCameraPosition,
          onCameraIdle: () {
            'camera is now idle'.logiosa();

            controller.bloc.updatePinState(PinState.idle);
          },
          onCameraMove: (CameraPosition position) {
            'camera is moving: $position'.logiosa();

            controller.bloc.updateCameraPosition(position);
          },
          onCameraMoveStarted: () {
            'camera started moving'.logiosa();

            controller.bloc.updatePinState(PinState.dragging);
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
