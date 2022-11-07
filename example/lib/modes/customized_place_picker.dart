import 'package:artistic_place_picker/artistic_place_picker.dart';
import 'package:example/api_key.dart';
import 'package:flutter/material.dart';

class CustomizedPlacePicker extends StatefulWidget {
  const CustomizedPlacePicker({super.key});

  @override
  State<CustomizedPlacePicker> createState() => _CustomizedPlacePickerState();
}

class _CustomizedPlacePickerState extends State<CustomizedPlacePicker> {
  late final ArtisticPlacePickerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = ArtisticPlacePickerController(
      ArtisticPlacePickerConfig(
        iosApiKey: iosApiKey,
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ArtisticPlacePickerMap(
            controller: _controller,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: StreamBuilder<GeocodingResult?>(
              stream: _controller.currentLocation,
              builder: (context, snapshot) {
                return SafeArea(
                  child: Card(
                    child: ExpansionTile(
                      title: !snapshot.hasData
                          ? const LinearProgressIndicator()
                          : Text(
                              '${snapshot.data?.formattedAddress.toString()}',
                            ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 64.0),
        child: FloatingActionButton(
          child: const Icon(Icons.location_searching_outlined),
          onPressed: () {
            _controller.goToMyLocation();
          },
        ),
      ),
    );
  }
}
