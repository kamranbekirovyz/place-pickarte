import 'package:artistic_place_picker/src/artistic_place_picker_pin.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const _initialDefaultLocationLatLng = LatLng(
  48.85680899999999,
  2.2867009999999954,
);
const _initialCameraZoom = 16.5;

class ArtisticPlacePickerConfig {
  final PinBuilder? pinBuilder;
  final bool logsEnabled;
  late final CameraPosition initialCameraPosition;

  ArtisticPlacePickerConfig({
    LatLng initialLocation = _initialDefaultLocationLatLng,
    double initialZoom = _initialCameraZoom,
    this.pinBuilder,
    this.logsEnabled = true,
  }) {
    initialCameraPosition = CameraPosition(
      target: initialLocation,
      zoom: initialZoom,
    );
  }
}
