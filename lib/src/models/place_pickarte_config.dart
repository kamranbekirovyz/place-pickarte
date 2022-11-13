import 'package:place_pickarte/src/models/places_autocomplete_config.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const _initialDefaultLocationLatLng = LatLng(
  48.85680899999999,
  2.2867009999999954,
);
const _initialCameraZoom = 16.5;

class PlacePickarteConfig {
  final String? androidApiKey;
  final String? iosApiKey;
  final PlacesAutocompleteConfig? placesAutocompleteConfig;
  late final CameraPosition _initialCameraPosition;

  PlacePickarteConfig({
    LatLng initialLocation = _initialDefaultLocationLatLng,
    double initialZoom = _initialCameraZoom,
    this.androidApiKey,
    this.iosApiKey,
    this.placesAutocompleteConfig,
  }) {
    _initialCameraPosition = CameraPosition(
      target: initialLocation,
      zoom: initialZoom,
    );
  }

  CameraPosition get initialCameraPosition => _initialCameraPosition;
}
