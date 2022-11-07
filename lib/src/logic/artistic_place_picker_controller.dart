import 'package:artistic_place_picker/artistic_place_picker.dart';
import 'package:artistic_place_picker/src/enums/my_location_result.dart';
import 'package:artistic_place_picker/src/logic/artistic_place_picker_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ArtisticPlacePickerController {
  late final ArtisticPlacePickerBloc _bloc;
  late final GoogleMapController? _googleMapController;

  ArtisticPlacePickerBloc get bloc => _bloc;

  ArtisticPlacePickerController(ArtisticPlacePickerConfig config) {
    _bloc = ArtisticPlacePickerBloc(config: config);
  }

  Stream<CameraPosition?> get cameraPositionStream => _bloc.cameraPositionStream;
  Stream<GeocodingResult?> get currentLocation => _bloc.currentLocation;
  void Function(String) get searchByAddress => _bloc.searchByAddress;

  void close() {
    _bloc.close();
  }

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
