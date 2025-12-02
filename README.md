
# place_pickarte

A Flutter plugin that enables you to make pixel-by-pixel customizable map place pickers.

I'm polishing it for first stable 1.0.0 release. Feedback is welcome. Follow my journey on [X/Twitter](https://x.com/kamranbekirovyz).

## 📐 Features

🫟 **Fully Customizable**: adapt to your app's design system  
🗺️ **Google Maps Support**: Mapbox & Openstreetmap support planned
🔎 **Places Search & Autocomplete**: users can search and pick places  

## 📱 Screenshots

|Picker|Style|Search|
|---|---|---|
|<img width="200" src="https://github.com/kamranbekirovyz/place-pickarte/blob/main/res/idle.png?raw=true"/>|<img width="200" src="https://github.com/kamranbekirovyz/place-pickarte/blob/main/res/map-style.png?raw=true"/>|<img width="200" src="https://github.com/kamranbekirovyz/place-pickarte/blob/main/res/searching.png?raw=true"/>

## 🩵 Want to say "thanks"?

Check [UserOrient](https://userorient.com), my side project for Flutter apps to collect feedback from users.

<a href="https://userorient.com" target="_blank">
	<img src="https://www.userorient.com/assets/extras/sponsor.png">
</a>

## 🕹️ Usage

See the <a href="https://github.com/kamranbekirovyz/place-pickarte/tree/main/example">example</a> for a complete sample app.

Since the package uses Google Maps under the hood, please check [google_maps_flutter](https://pub.dev/packages/google_maps_flutter#getting-started)'s docs to learn native configurations and API key acquiring process.

### Sample Usage

<?code-excerpt "readme_sample.dart (MapSample)"?>
```dart
class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(37.43296265331129, -122.08832357078792),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}

```


## 💡 Inspired from/by

- Forked and modified <a href="https://github.com/lejard-h/google_maps_webservice">google_maps_webservice</a> according to this package's needs, specifically for not supporting null-safety.


## 📃 License

<a href="https://github.com/kamranbekirovyz/place-pickarte/LICENSE">MIT License</a>