import 'package:place_pickarte/place_pickarte.dart';
import 'package:place_pickarte/src/enums/my_location_result.dart';
import 'package:place_pickarte/src/helpers/extensions.dart';
import 'package:place_pickarte/src/logic/place_pickarte_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlacePickarteController {
  late final PlacePickarteBloc _bloc;
  late final GoogleMapController? _googleMapController;
  final PlacePickarteConfig config;

  PlacePickarteBloc get bloc => _bloc;

  PlacePickarteController({
    required this.config,
  }) {
    _bloc = PlacePickarteBloc(config: config);
  }

  Stream<CameraPosition?> get cameraPositionStream => _bloc.cameraPositionStream;
  Stream<GeocodingResult?> get currentLocationStream => _bloc.currentLocationStream;
  Stream<List<Prediction>?> get predictionsStream => _bloc.predictionsStream;
  Stream<PinState> get pinStateStream => _bloc.pinStateStream;

  void updateSearchQuery(String value) => _bloc.updateSearchQuery(value);
  void clearSearchQuery() => _bloc.updateSearchQuery('');

  void close() {
    _bloc.close();
  }

  // TODO: move heavy logic to another layer (service)
  Future<MyLocationResult> goToMyLocation({
    bool animate = true,
    LocationAccuracy accuracy = LocationAccuracy.best,
    double? zoom,
    double tilt = 0.0,
    double bearing = 0.0,
  }) async {
    zoom ??= _bloc.config.initialCameraPosition.zoom;

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
    final placeDetails = await _bloc.getPlaceDetails(prediction.placeId!);
    zoom ??= _bloc.config.initialCameraPosition.zoom;

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
}
