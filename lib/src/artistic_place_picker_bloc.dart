import 'dart:async';

import 'package:artistic_place_picker/src/artistic_place_picker_config.dart';
import 'package:artistic_place_picker/src/enums/pin_state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ArtisticPlacePickerBloc {
  late final ArtisticPlacePickerConfig config;

  ArtisticPlacePickerBloc({
    required this.config,
  });

  final _pinState = StreamController<PinState>.broadcast()..add(PinState.idle);
  final _cameraPosition = StreamController<CameraPosition?>.broadcast();

  Stream<PinState> get pinStateStream => _pinState.stream;
  Stream<CameraPosition?> get cameraPositionStream => _cameraPosition.stream;

  void updatePinState(PinState event) => _pinState.add(event);
  void updateCameraPosition(CameraPosition event) => _cameraPosition.add(event);

  void close() {
    _pinState.close();
    _cameraPosition.close();
  }
}
