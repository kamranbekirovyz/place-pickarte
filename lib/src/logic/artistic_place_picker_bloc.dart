import 'package:artistic_place_picker/src/models/artistic_place_picker_config.dart';
import 'package:artistic_place_picker/src/enums/pin_state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:rxdart/subjects.dart';

class ArtisticPlacePickerBloc {
  late final ArtisticPlacePickerConfig config;
  late final GoogleMapsGeocoding _googleMapsGeocoding;

  ArtisticPlacePickerBloc({
    required this.config,
  }) {
    _googleMapsGeocoding = GoogleMapsGeocoding(
      apiKey: config.iosApiKey,
    );

    _pinState.stream.listen((PinState event) {
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
  }

  Future<void> searchByAddress(String address) async {
    await _googleMapsGeocoding.searchByAddress(address);
  }

  Future<void> _searchByLocation(Location location) async {
    _updateCurrentLocation(null);
    final result = await _googleMapsGeocoding.searchByLocation(location);
    _updateCurrentLocation(result.results.first);
  }
}
