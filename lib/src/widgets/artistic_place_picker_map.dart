import 'package:artistic_place_picker/artistic_place_picker.dart';
import 'package:artistic_place_picker/src/helpers/extensions.dart';
import 'package:artistic_place_picker/src/widgets/artistic_place_picker_pin.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ArtisticPlacePickerMap extends StatefulWidget {
  final ArtisticPlacePickerController controller;

  const ArtisticPlacePickerMap({
    required this.controller,
    super.key,
  });

  @override
  State<ArtisticPlacePickerMap> createState() => _ArtisticPlacePickerMapState();
}

class _ArtisticPlacePickerMapState extends State<ArtisticPlacePickerMap> {
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
        ArtisticPlacePickerPin(
          pinBuilder: widget.controller.bloc.config.pinBuilder,
          pinStateStream: widget.controller.bloc.pinStateStream,
        ),
      ],
    );
  }
}
