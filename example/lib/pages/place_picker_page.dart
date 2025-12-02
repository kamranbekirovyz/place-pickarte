import 'package:example/widgets/bottom_padding.dart';
import 'package:example/widgets/place_picker_search.dart';
import 'package:example/widgets/styled_button.dart';
import 'package:place_pickarte/place_pickarte.dart';
import 'package:flutter/material.dart';

const String googleMapsIosKey = '[YOUR_API_KEY]';
const String googleMapsAndroidKey = '[YOUR_API_KEY]';

class PlacePickerPage extends StatefulWidget {
  final double? latitude;
  final double? longitude;

  const PlacePickerPage({super.key, this.latitude, this.longitude});

  @override
  State<PlacePickerPage> createState() => _PlacePickerPageState();
}

class _PlacePickerPageState extends State<PlacePickerPage> {
  late final PlacePickarteController _controller;
  late final GlobalKey _appBarKey;

  @override
  void initState() {
    super.initState();

    _appBarKey = GlobalKey();

    bool hasLocation = widget.latitude != null && widget.longitude != null;

    _controller = PlacePickarteController(
      config: PlacePickarteConfig(
        initialLocation: hasLocation
            ? Location(lat: widget.latitude!, lng: widget.longitude!)
            : null,
        myLocationAsInitial: !hasLocation,
        googleMapConfig: const GoogleMapConfig(
          iosApiKey: googleMapsIosKey,
          androidApiKey: googleMapsAndroidKey,
        ),
        googleMapsGeocoding: GoogleMapsGeocoding(apiKey: googleMapsIosKey),
        placesAutocompleteConfig: PlacesAutocompleteConfig(
          region: 'az',
          components: [Component(Component.country, 'az')],
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
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          PlacePickarteMap(_controller),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _Bottom(placePickarteController: _controller),
          ),
          Positioned(
            bottom: BottomPadding.of(context) + 160,
            right: 16,
            child: _MyLocationButton(onPressed: _controller.goToMyLocation),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      key: _appBarKey,
      automaticallyImplyLeading: false,
      centerTitle: true,
      leading: BackButton(),
      title: Text(
        'Pick Place',
        style: TextStyle(
          fontSize: 16,
          height: 20 / 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      bottom: PlacePickerSearch(controller: _controller, appBarKey: _appBarKey),
    );
  }
}

class _MyLocationButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _MyLocationButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.translucent,
      child: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(Icons.my_location_rounded),
      ),
    );
  }
}

class _Bottom extends StatelessWidget {
  final PlacePickarteController placePickarteController;

  const _Bottom({required this.placePickarteController});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          StreamBuilder<GeocodingResult?>(
            stream: placePickarteController.currentLocationStream,
            builder: (context, snapshot) {
              final bool isLoading = !snapshot.hasData;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    Icon(Icons.location_city_rounded),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isLoading
                            ? 'Checking location, please wait...'
                            : snapshot.data!.formattedAddress!,
                        style: TextStyle(
                          fontSize: 14,
                          height: 16 / 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          StyledButton(
            onPressed: () {
              Navigator.of(
                context,
              ).pop(placePickarteController.currentLocation);
            },
            label: 'Continue',
          ),
          const BottomPadding(),
        ],
      ),
    );
  }
}
