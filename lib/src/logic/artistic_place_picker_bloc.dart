import 'dart:async';

import 'package:artistic_place_picker/src/helpers/extensions.dart';
import 'package:artistic_place_picker/src/models/artistic_place_picker_config.dart';
import 'package:artistic_place_picker/src/enums/pin_state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:rxdart/rxdart.dart';

class ArtisticPlacePickerBloc {
  late final ArtisticPlacePickerConfig config;
  late final GoogleMapsGeocoding _googleMapsGeocoding;
  late final GoogleMapsPlaces _googleMapsPlaces;
  late final StreamSubscription _pinStateSubscription;
  late final StreamSubscription _searchQuerySubscription;

  ArtisticPlacePickerBloc({
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

  Stream<PinState> get pinStateStream => _pinState.stream;
  Stream<CameraPosition?> get cameraPositionStream => _cameraPosition.stream;
  Stream<String> get searchQueryStream => _searchQuery.stream;
  Stream<GeocodingResult?> get currentLocation => _currentLocation.stream;

  CameraPosition? get cameraPosition => _cameraPosition.valueOrNull;

  void updatePinState(PinState event) => _pinState.add(event);
  void updateCameraPosition(CameraPosition event) => _cameraPosition.add(event);
  void updateSearchQuery(String event) => _searchQuery.add(event);
  void _updateCurrentLocation(GeocodingResult? event) => _currentLocation.add(event);

  void close() {
    _currentLocation.close();
    _searchQuery.close();
    _pinState.close();
    _cameraPosition.close();
    _pinStateSubscription.cancel();
    _searchQuerySubscription.cancel();
  }

  Future<void> _searchAutocomplete(String query) async {
    final result = await _googleMapsPlaces.autocomplete(query);

    result.predictions.map((e) => e.description).logiosa();
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
