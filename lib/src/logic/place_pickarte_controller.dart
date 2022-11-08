import 'package:google_maps_webservice/places.dart';
import 'package:place_pickarte/place_pickarte.dart';
import 'package:place_pickarte/src/enums/my_location_result.dart';
import 'package:place_pickarte/src/logic/place_pickarte_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlacePickarteController {
  late final PlacePickarteBloc _bloc;
  late final GoogleMapController? _googleMapController;

  PlacePickarteBloc get bloc => _bloc;

  PlacePickarteController(PlacePickarteConfig config) {
    _bloc = PlacePickarteBloc(config: config);
  }

  Stream<CameraPosition?> get cameraPositionStream => _bloc.cameraPositionStream;
  Stream<GeocodingResult?> get currentLocationStream => _bloc.currentLocationStream;
  Stream<List<Prediction>?> get predictionsStream => _bloc.predictionsStream;

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

  void setGoogleMapController(GoogleMapController mapController) {
    _googleMapController = mapController;
  }
}
