import 'package:artistic_place_picker/src/artistic_place_picker_bloc.dart';
import 'package:artistic_place_picker/src/artistic_place_picker_config.dart';
import 'package:artistic_place_picker/src/artistic_place_picker_map.dart';
import 'package:flutter/widgets.dart';

class ArtisticPlacePickerController {
  ArtisticPlacePickerController(ArtisticPlacePickerConfig config) {
    _initialize(config);
  }

  late final ArtisticPlacePickerBloc _bloc;

  void _initialize(ArtisticPlacePickerConfig config) {
    _bloc = ArtisticPlacePickerBloc(config: config);
  }

  void close() {}

  Widget get mapWidget {
    return ArtisticPlacePickerMap(
      bloc: _bloc,
    );
  }
}
