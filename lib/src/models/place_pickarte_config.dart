import 'package:place_pickarte/src/widgets/place_pickarte_pin.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const _initialDefaultLocationLatLng = LatLng(
  48.85680899999999,
  2.2867009999999954,
);
const _initialCameraZoom = 16.5;

class PlacePickarteConfig {
  final PinBuilder? pinBuilder;
  final bool logsEnabled;
  final String? androidApiKey;
  final String? iosApiKey;
  late final CameraPosition initialCameraPosition;

  PlacePickarteConfig({
    LatLng initialLocation = _initialDefaultLocationLatLng,
    double initialZoom = _initialCameraZoom,
    this.pinBuilder,
    this.logsEnabled = true,
    this.androidApiKey,
    this.iosApiKey,
  }) {
    initialCameraPosition = CameraPosition(
      target: initialLocation,
      zoom: initialZoom,
    );
  }
}
