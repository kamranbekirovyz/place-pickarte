import 'package:place_pickarte/place_pickarte.dart';
import 'package:example/api_key.dart';
import 'package:flutter/material.dart';

class CustomizedPlacePicker extends StatefulWidget {
  const CustomizedPlacePicker({super.key});

  @override
  State<CustomizedPlacePicker> createState() => _CustomizedPlacePickerState();
}

class _CustomizedPlacePickerState extends State<CustomizedPlacePicker> {
  late final PlacePickarteController _controller;

  @override
  void initState() {
    super.initState();

    _controller = PlacePickarteController(
      PlacePickarteConfig(
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
          PlacePickarteMap(
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
            _controller.updateSearchQuery('44 xaqan');
          },
        ),
      ),
    );
  }
}
