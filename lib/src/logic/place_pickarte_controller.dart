import 'package:place_pickarte/place_pickarte.dart';
import 'package:place_pickarte/src/enums/my_location_result.dart';
import 'package:place_pickarte/src/helpers/extensions.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:place_pickarte/src/logic/place_pickarte_manager.dart';

// TODO: don't send request when map only zooms in out.

class PlacePickarteController {
  late final PlacePickarteManager _manager;
  late final GoogleMapController? _googleMapController;
  final PlacePickarteConfig config;

  PlacePickarteManager get manager => _manager;

  PlacePickarteController({
    required this.config,
  }) {
    _manager = PlacePickarteManager(config: config);
  }

  Stream<CameraPosition?> get cameraPositionStream => _manager.cameraPositionStream;
  Stream<GeocodingResult?> get currentLocationStream => _manager.currentLocationStream;
  Stream<List<Prediction>?> get predictionsStream => _manager.predictionsStream;
  Stream<PinState> get pinStateStream => _manager.pinStateStream;
  Stream<MapType> get googleMapTypeStream => _manager.googleMapTypeStream;
  Stream<String> get searchQueryStream => _manager.searchQueryStream;

  void updateSearchQuery(String value) => _manager.updateSearchQuery(value);
  void clearSearchQuery() => _manager.updateSearchQuery('');

  void close() {
    _manager.close();
  }

  // TODO: move heavy logic to another layer (service)
  Future<MyLocationResult> goToMyLocation({
    bool animate = true,
    LocationAccuracy accuracy = LocationAccuracy.best,
    double? zoom,
    double tilt = 0.0,
    double bearing = 0.0,
  }) async {
    zoom ??= _manager.config.initialCameraPosition.zoom;

    if (!await Geolocator.isLocationServiceEnabled()) {
      return MyLocationResult.serviceNotEnabled;
    }

    final permission = await Geolocator.checkPermission();
    final hasValidPermission = [
      LocationPermission.whileInUse,
      LocationPermission.whileInUse,
    ].contains(permission);

    if (!hasValidPermission) {
      switch (permission) {
        case LocationPermission.denied:
          return MyLocationResult.permissionDenied;
        case LocationPermission.deniedForever:
          return MyLocationResult.permissionDeniedForever;
        case LocationPermission.unableToDetermine:
        default:
          return MyLocationResult.permissionUnableToDetermine;
      }
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: accuracy,
    );

    final cameraUpdate = CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(
          position.latitude,
          position.longitude,
        ),
        zoom: zoom,
        tilt: tilt,
        bearing: bearing,
      ),
    );

    animate
        ? await _googleMapController?.animateCamera(
            cameraUpdate,
          )
        : await _googleMapController?.moveCamera(
            cameraUpdate,
          );

    return MyLocationResult.success;
  }

  void onGoogleMapCreated(GoogleMapController mapController) {
    _googleMapController = mapController;

    if (config.googleMapStyle != null) {
      'setting custom map style..'.logiosa();
      _googleMapController!.setMapStyle(config.googleMapStyle);
    }

    if (config.myLocationAsInitial) {
      goToMyLocation();
    }
  }

  Future<void> selectPrediction(
    Prediction prediction, {
    bool animate = true,
    LocationAccuracy accuracy = LocationAccuracy.best,
    double? zoom,
    double tilt = 0.0,
    double bearing = 0.0,
  }) async {
    final placeDetails = await _manager.getPlaceDetails(prediction.placeId!);
    zoom ??= _manager.config.initialCameraPosition.zoom;

    return _googleMapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            placeDetails.geometry!.location.lat,
            placeDetails.geometry!.location.lng,
          ),
          bearing: bearing,
          tilt: tilt,
          zoom: zoom,
        ),
      ),
    );
  }

  void changeGoogleMapType(MapType mapType) {
    return manager.changeGoogleMapType(mapType);
  }

  Future<void>? setGoogleMapStyle(String? mapStyle) {
    return _googleMapController?.setMapStyle(mapStyle);
  }

  Future<void>? resetGoogleMapStyle() {
    return _googleMapController?.setMapStyle(GoogleMapStyles.standard);
  }
}
