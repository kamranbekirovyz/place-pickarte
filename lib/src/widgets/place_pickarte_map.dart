import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart' as flutter_map;
import 'package:place_pickarte/place_pickarte.dart';
import 'package:place_pickarte/src/widgets/place_pickarte_pin.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong2/latlong.dart' as lat_lng2;

class PlacePickarteMap extends StatelessWidget {
  final PlacePickarteController controller;

  const PlacePickarteMap(
    this.controller, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (controller.config.mapProvider == MapProvider.googleMap)
          StreamBuilder<MapType>(
            initialData: controller.config.googleMapConfig?.googleMapType,
            stream: controller.googleMapTypeStream,
            builder: (context, snapshot) {
              final googleMapType = snapshot.requireData;

              return GoogleMap(
                zoomControlsEnabled: controller.config.googleMapConfig?.zoomControlsEnabled ?? false,
                myLocationButtonEnabled: false,
                myLocationEnabled: true,
                mapType: googleMapType,
                onMapCreated: controller.onGoogleMapCreated,
                initialCameraPosition: controller.config.initialGoogleMapCameraPosition,
                onCameraIdle: controller.onCameraIdle,
                onCameraMove: controller.onCameraMove,
                onCameraMoveStarted: controller.onCameraMoveStarted,
              );
            },
          )
        else if (controller.config.mapProvider == MapProvider.mapbox)
          flutter_map.FlutterMap(
            mapController: controller.mapBoxController,
            options: flutter_map.MapOptions(
              onPositionChanged: (position, hasGesture) {},
              center: lat_lng2.LatLng(40.395713, 49.8615043),
              zoom: 17.0,
            ),
            children: [
              MapboxTileLayerOptions(),
              // MarkerLayer(markers: markers),
            ],
          )
        else
          const Text(
            !kReleaseMode ? 'Some unexpected error happened. Please, open an issue on GitHub repository.' : 'Unable to launch the map.',
          ),
        PlacePickartePin(
          pinBuilder: controller.config.pinBuilder,
          pinStateStream: controller.pinStateStream,
        ),
      ],
    );
  }
}

class MapboxTileLayerOptions extends flutter_map.TileLayer {
  MapboxTileLayerOptions({
    Key? key,
    flutter_map.TileProvider? tileProvider,
    String? style,
  }) : super(
          key: key,
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
          tileProvider: tileProvider ?? CachedTileProvider(),
        );
}

class CachedTileProvider extends flutter_map.TileProvider {
  CachedTileProvider();

  @override
  ImageProvider getImage(flutter_map.Coords<num> coords, flutter_map.TileLayer options) {
    return CachedNetworkImageProvider(getTileUrl(coords, options));
  }
}
