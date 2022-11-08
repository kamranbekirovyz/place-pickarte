import 'dart:async';

import 'package:place_pickarte/src/helpers/extensions.dart';
import 'package:place_pickarte/src/models/place_pickarte_config.dart';
import 'package:place_pickarte/src/enums/pin_state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:rxdart/rxdart.dart';

class PlacePickarteBloc {
  late final PlacePickarteConfig config;
  late final GoogleMapsGeocoding _googleMapsGeocoding;
  late final GoogleMapsPlaces _googleMapsPlaces;
  late final StreamSubscription _pinStateSubscription;
  late final StreamSubscription _searchQuerySubscription;

  PlacePickarteBloc({
    required this.config,
  }) {
    _googleMapsGeocoding = GoogleMapsGeocoding(
      apiKey: config.iosApiKey,
    );
    _googleMapsPlaces = GoogleMapsPlaces(
      apiKey: config.iosApiKey,
    );
    _pinStateSubscription = _pinState.stream.listen((PinState event) {
      /// CameraPosition subject is nullable: null check before using its value.
      if (cameraPosition == null) return;

      /// Search only when the user released the control of the map.
      if (_pinState.value == PinState.idle) {
        _searchByLocation(
          Location(
            lat: cameraPosition!.target.latitude,
            lng: cameraPosition!.target.longitude,
          ),
        );
      }
    });

    _searchQuerySubscription = _searchQuery
        .distinct()
        .debounceTime(
          const Duration(milliseconds: 500),
        )
        .listen((String event) {
      _searchAutocomplete(event);
    });
  }

  final _pinState = BehaviorSubject<PinState>.seeded(PinState.idle);
  final _cameraPosition = BehaviorSubject<CameraPosition?>();
  final _searchQuery = BehaviorSubject<String>.seeded('');
  final _currentLocation = BehaviorSubject<GeocodingResult?>();
  final _predictions = BehaviorSubject<List<Prediction>?>();

  Stream<PinState> get pinStateStream => _pinState.stream;
  Stream<CameraPosition?> get cameraPositionStream => _cameraPosition.stream;
  Stream<String> get searchQueryStream => _searchQuery.stream;
  Stream<GeocodingResult?> get currentLocationStream => _currentLocation.stream;
  Stream<List<Prediction>?> get predictionsStream => _predictions.stream;

  CameraPosition? get cameraPosition => _cameraPosition.valueOrNull;
  List<Prediction>? get predictions => _predictions.valueOrNull;

  void updatePinState(PinState event) => _pinState.add(event);
  void updateCameraPosition(CameraPosition event) => _cameraPosition.add(event);
  void updateSearchQuery(String event) => _searchQuery.add(event);
  void _updateCurrentLocation(GeocodingResult? event) => _currentLocation.add(event);
  void _updatePredictions(List<Prediction>? event) => _predictions.add(event);

  void close() {
    _predictions.close();
    _currentLocation.close();
    _searchQuery.close();
    _pinState.close();
    _cameraPosition.close();
    _pinStateSubscription.cancel();
    _searchQuerySubscription.cancel();
  }

  Future<void> _searchAutocomplete(String query) async {
    _updatePredictions(null);
    final result = await _googleMapsPlaces.autocomplete(
      query,
      sessionToken: config.placesAutocompleteConfig?.sessionToken,
      offset: config.placesAutocompleteConfig?.offset,
      origin: config.placesAutocompleteConfig?.origin,
      location: config.placesAutocompleteConfig?.location,
      radius: config.placesAutocompleteConfig?.radius,
      language: config.placesAutocompleteConfig?.language,
      types: config.placesAutocompleteConfig?.types ?? [],
      components: config.placesAutocompleteConfig?.components ?? [],
      strictbounds: config.placesAutocompleteConfig?.strictbounds ?? false,
      region: config.placesAutocompleteConfig?.region,
    );

    if (result.errorMessage != null && result.errorMessage!.isNotEmpty) {
      '📛 ${result.errorMessage!}'.logiosa();
    } else {
      _updatePredictions(result.predictions);
    }
  }

  Future<void> _searchByLocation(Location location) async {
    _updateCurrentLocation(null);
    final result = await _googleMapsGeocoding.searchByLocation(location);

    if (result.errorMessage != null && result.errorMessage!.isNotEmpty) {
      '📛 ${result.errorMessage!}'.logiosa();
    } else {
      _updateCurrentLocation(result.results.first);
    }
  }
}
