import 'package:place_pickarte/place_pickarte.dart';
import 'package:place_pickarte/src/helpers/extensions.dart';
import 'package:place_pickarte/src/widgets/place_pickarte_pin.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlacePickarteMap extends StatefulWidget {
  final PlacePickarteController controller;

  const PlacePickarteMap({
    required this.controller,
    super.key,
  });

  @override
  State<PlacePickarteMap> createState() => _PlacePickarteMapState();
}

class _PlacePickarteMapState extends State<PlacePickarteMap> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          myLocationButtonEnabled: false,
          myLocationEnabled: true,
          onMapCreated: (GoogleMapController mapController) {
            widget.controller.setGoogleMapController(mapController);
          },
          initialCameraPosition: widget.controller.bloc.config.initialCameraPosition,
          onCameraIdle: () {
            'camera is now idle'.logiosa();

            widget.controller.bloc.updatePinState(PinState.idle);
          },
          onCameraMove: (CameraPosition position) {
            'camera is moving: $position'.logiosa();

            widget.controller.bloc.updateCameraPosition(position);
          },
          onCameraMoveStarted: () {
            'camera started moving'.logiosa();

            widget.controller.bloc.updatePinState(PinState.dragging);
          },
        ),
        PlacePickartePin(
          pinBuilder: widget.controller.bloc.config.pinBuilder,
          pinStateStream: widget.controller.bloc.pinStateStream,
        ),
      ],
    );
  }
}
