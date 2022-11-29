import 'package:place_pickarte/place_pickarte.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:place_pickarte/src/services/google/core.dart';
import 'package:place_pickarte/src/widgets/place_pickarte_pin.dart';

final _initialDefaultLocationLatLng = Location(
  lat: 23.1311098,
  lng: -82.3975397,
);
const _initialCameraZoom = 16.5;

class PlacePickarteConfig {
  final GoogleMapConfig? googleMapConfig;
  final MapboxConfig? mapboxConfig;
  final PlacesAutocompleteConfig? placesAutocompleteConfig;
  final PinBuilder? pinBuilder;
  final bool myLocationAsInitial;
  final GoogleMapsGeocoding? googleMapsGeocoding;

  PlacePickarteConfig({
    this.googleMapConfig,
    this.mapboxConfig,
    Location? initialLocation,
    double initialZoom = _initialCameraZoom,
    this.pinBuilder,
    this.googleMapsGeocoding,
    this.myLocationAsInitial = true,
    this.placesAutocompleteConfig,
  }) {
    assert(
      [mapboxConfig, googleMapConfig].any((element) => element == null),
      'Can not specify both GoogleMapConfig and MapboxConfig: only either one of them can be used.',
    );

    assert(
      [mapboxConfig, googleMapConfig].any((element) => element != null),
      'Please provide either GoogleMapConfig or MapboxConfig while initializing PlacePickarteController',
    );

    _mapProvider = googleMapConfig != null ? MapProvider.googleMap : MapProvider.mapbox;

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

  late final MapProvider _mapProvider;
  MapProvider get mapProvider => _mapProvider;
}
