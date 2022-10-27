import 'package:artistic_place_picker/src/artistic_place_picker_bloc.dart';
import 'package:artistic_place_picker/src/artistic_place_picker_pin.dart';
import 'package:artistic_place_picker/src/enums/pin_state.dart';
import 'package:artistic_place_picker/src/helpers/extensions.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ArtisticPlacePickerMap extends StatefulWidget {
  final ArtisticPlacePickerBloc bloc;

  const ArtisticPlacePickerMap({
    required this.bloc,
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
          initialCameraPosition: widget.bloc.config.initialCameraPosition,
          onCameraIdle: () {
            'camera is now idle'.logiosa();

            widget.bloc.updatePinState(PinState.idle);
          },
          onCameraMove: (CameraPosition position) {
            'camera is moving: $position'.logiosa();

            widget.bloc.updateCameraPosition(position);
          },
          onCameraMoveStarted: () {
            'camera started moving'.logiosa();

            widget.bloc.updatePinState(PinState.busy);
          },
        ),
        ArtisticPlacePickerPin(
          pinBuilder: widget.bloc.config.pinBuilder,
          pinStateStream: widget.bloc.pinStateStream,
        ),
      ],
    );
  }
}
