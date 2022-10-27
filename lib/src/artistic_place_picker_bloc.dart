import 'dart:async';

import 'package:artistic_place_picker/src/enums/pin_state.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ArtisticPlacePickerBloc {
  final _pinState = StreamController<PinState>.broadcast()..add(PinState.idle);
  final _cameraPosition = StreamController<CameraPosition?>.broadcast();

  Stream<PinState> get pinState$ => _pinState.stream;
  Stream<CameraPosition?> get cameraPosition$ => _cameraPosition.stream;

  void updatePinState(PinState event) => _pinState.add(event);
  void updateCameraPosition(CameraPosition event) => _cameraPosition.add(event);

  void close() {
    _pinState.close();
    _cameraPosition.close();
  }
}
