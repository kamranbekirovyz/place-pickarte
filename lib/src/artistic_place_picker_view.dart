import 'dart:io';

import 'package:artistic_place_picker/src/artistic_place_picker_bloc.dart';
import 'package:artistic_place_picker/src/artistic_place_picker_config.dart';
import 'package:artistic_place_picker/src/artistic_place_picker_map.dart';
import 'package:artistic_place_picker/src/enums/pin_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ArtisticPlacePickerView extends StatefulWidget {
  final ArtisticPlacePickerConfig config;

  const ArtisticPlacePickerView({
    Key? key,
    required this.config,
  }) : super(key: key);

  @override
  State<ArtisticPlacePickerView> createState() => _ArtisticPlacePickerViewState();
}

class _ArtisticPlacePickerViewState extends State<ArtisticPlacePickerView> {
  late final ArtisticPlacePickerBloc _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = ArtisticPlacePickerBloc(config: widget.config);
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: later, add GoogleMaps' parameters as option while initializing.
    return Scaffold(
      body: Stack(
        children: [
          ArtisticPlacePickerMap(bloc: _bloc),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildBottom(),
          ),
        ],
      ),
    );
  }

  StreamBuilder<CameraPosition?> _buildBottom() {
    return StreamBuilder<CameraPosition?>(
      stream: _bloc.cameraPositionStream,
      builder: (context, snapshot) {
        final ready = snapshot.hasData;

        if (!ready) return const SizedBox.shrink();

        final cameraPosition = snapshot.data!;

        return Container(
          // margin: const EdgeInsets.all(16.0).copyWith(),
          padding: const EdgeInsets.all(16.0),
          color: Colors.white,
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: StreamBuilder<Object>(
                      initialData: PinState.idle,
                      stream: _bloc.pinStateStream,
                      builder: (context, snapshot) {
                        final pinState = snapshot.data;
                        final opacity = pinState != PinState.ready ? 1.0 : 0.8;

                        return AnimatedOpacity(
                          opacity: opacity,
                          duration: kThemeAnimationDuration,
                          child: const Text(
                            'Eiffel Tower, Paris, France',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(CupertinoIcons.search),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              CupertinoButton.filled(
                onPressed: () {},
                child: Container(
                  width: double.maxFinite,
                  alignment: Alignment.center,
                  child: const Text(
                    'Select address',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              SizedBox(height: Platform.isIOS ? 16.0 : 0.0),
            ],
          ),
        );
      },
    );
  }
}
