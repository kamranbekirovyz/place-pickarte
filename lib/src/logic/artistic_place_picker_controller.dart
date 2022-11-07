import 'package:artistic_place_picker/artistic_place_picker.dart';
import 'package:artistic_place_picker/src/logic/artistic_place_picker_bloc.dart';

class ArtisticPlacePickerController {
  late final ArtisticPlacePickerBloc _bloc;
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
}
