import 'package:place_pickarte/place_pickarte.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:place_pickarte/src/widgets/place_pickarte_pin.dart';

final _initialDefaultLocationLatLng = Location(
  lat: 40.4093,
  lng: 49.8671,
);
const _initialCameraZoom = 16.5;

class PlacePickarteConfig {
  final GoogleMapConfig googleMapConfig;
  final PlacesAutocompleteConfig? placesAutocompleteConfig;
  final PinBuilder? pinBuilder;
  final bool myLocationAsInitial;
  final GoogleMapsGeocoding? googleMapsGeocoding;

  PlacePickarteConfig({
    required this.googleMapConfig,
    Location? initialLocation,
    double initialZoom = _initialCameraZoom,
    this.pinBuilder,
    this.googleMapsGeocoding,
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
  CameraPosition get initialGoogleMapCameraPosition =>
      _initialGoogleMapCameraPosition;
}
