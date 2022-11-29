import 'package:place_pickarte/src/models/google_map_config.dart';
import 'package:place_pickarte/src/models/places_autocomplete_config.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:place_pickarte/src/services/google/core.dart';
import 'package:place_pickarte/src/widgets/place_pickarte_pin.dart';

final _initialDefaultLocationLatLng = Location(
  lat: 23.1311098,
  lng: -82.3975397,
);
const _initialCameraZoom = 16.5;

class PlacePickarteConfig {
  final GoogleMapConfig googleMapConfig;
  final PlacesAutocompleteConfig? placesAutocompleteConfig;
  final PinBuilder? pinBuilder;
  final bool myLocationAsInitial;

  PlacePickarteConfig({
    required this.googleMapConfig,
    Location? initialLocation,
    double initialZoom = _initialCameraZoom,
    this.pinBuilder,
    this.myLocationAsInitial = true,
    this.placesAutocompleteConfig,
  }) {
    initialLocation ??= _initialDefaultLocationLatLng;

    final target = LatLng(
      initialLocation.lat,
      initialLocation.lng,
    );

    _initialGoogleMapCameraPosition = CameraPosition(
      target: target,
      zoom: initialZoom,
    );
  }

  late final CameraPosition _initialGoogleMapCameraPosition;
  CameraPosition get initialGoogleMapCameraPosition => _initialGoogleMapCameraPosition;
}
