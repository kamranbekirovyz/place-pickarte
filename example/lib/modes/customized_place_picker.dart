import 'package:example/modes/place_search_delegate.dart';
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
      config: PlacePickarteConfig(
        iosApiKey: iosApiKey,
        androidApiKey: androidApiKey,
        placesAutocompleteConfig: PlacesAutocompleteConfig(
          region: 'az',
          components: [
            Component(Component.country, 'tr'),
          ],
        ),
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
      appBar: _buildAppBar(),
      body: PlacePickarteMap(
        controller: _controller,
      ),
      bottomNavigationBar: _buildLocationDetails(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.location_searching_outlined),
        onPressed: () => _controller.goToMyLocation(animate: false),
      ),
    );
  }

  Widget _buildLocationDetails() {
    return StreamBuilder<GeocodingResult?>(
      stream: _controller.currentLocationStream,
      builder: (context, snapshot) {
        return SafeArea(
          child: Card(
            child: ListTile(
              title: !snapshot.hasData
                  ? const LinearProgressIndicator()
                  : Text(
                      '${snapshot.data?.formattedAddress.toString()}',
                    ),
            ),
          ),
        );
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      actions: [
        IconButton(
          onPressed: () {
            showSearch(
              context: context,
              delegate: PlaceSearchDelegate(_controller),
            );
          },
          icon: const Icon(Icons.search, size: 28.0),
        ),
        const SizedBox(width: 8.0),
      ],
    );
  }
}
