
# place_pickarte

A Flutter plugin that enables you to make pixel-by-pixel customizable map place pickers. It also comes with clean built-in widgets for you to add this to your app in couple of minutes.

I'm polishing it for first stable 1.0.0 release. Feedback is welcome. Follow my journey on [X/Twitter](https://x.com/kamranbekirovyz).

## 📐 Features

🫟 **Fully Customizable**: adap to your app's design system  
🗺️ **Google Maps Support**: adap to your app's design system  
🖼️ **Built-in Widgets**: add place picker to your app in a minute  
🔎 **Places Search & Autocomplete**: users can search and pick places  
⏳ **Mapbox & Openstreetmap Support**: coming soon... [Want to help?](https://github.com/kamranbekirovyz/place-pickarte/issues) 

## 📱 Screenshots

|Console|API Request|Password|
|---|---|---|
|<img width="200" src="https://github.com/kamranbekirovyz/logarte/blob/main/res/s1.png?raw=true"/>|<img width="200" src="https://github.com/kamranbekirovyz/logarte/blob/main/res/s2.png?raw=true"/>|<img width="200" src="https://github.com/kamranbekirovyz/logarte/blob/main/res/s3.png?raw=true"/>

## 🩵 Want to say "thanks"?

If you like this package, consider checking [UserOrient](https://userorient.com), my side project for Flutter apps to collect feedback from users.

<a href="https://userorient.com" target="_blank">
	<img src="https://www.userorient.com/assets/extras/sponsor.png">
</a>

## 🕹️ Usage

See the <a href="https://github.com/kamranbekirovyz/place-pickarte/tree/main/example">example</a> directory for a complete sample app.

### The native side

Since the package uses [google_maps_flutter](https://pub.dev/packages/google_maps_flutter) under the hood, you need to configure Google Maps first:

* Get an API key at <https://cloud.google.com/maps-platform/>.

* Enable Google Map SDK for each platform.
  * Go to [Google Developers Console](https://console.cloud.google.com/).
  * Choose the project that you want to enable Google Maps on.
  * Select the navigation menu and then select "Google Maps".
  * Select "APIs" under the Google Maps menu.
  * To enable Google Maps for Android, select "Maps SDK for Android" in the "Additional APIs" section, then select "ENABLE".
  * To enable Google Maps for iOS, select "Maps SDK for iOS" in the "Additional APIs" section, then select "ENABLE".
  * To enable Google Maps for Web, enable the "Maps JavaScript API".
  * Make sure the APIs you enabled are under the "Enabled APIs" section.

For more details, see [Getting started with Google Maps Platform](https://developers.google.com/maps/gmp-get-started).

### Android

1. Specify your API key in the application manifest `android/app/src/main/AndroidManifest.xml`:

   ```xml
   <manifest ...
     <application ...
       <meta-data android:name="com.google.android.geo.API_KEY"
                  android:value="YOUR KEY HERE"/>
   ```

### iOS

1. Specify your API key in the application delegate `ios/Runner/AppDelegate.m`:

   ```objectivec
   #include "AppDelegate.h"
   #include "GeneratedPluginRegistrant.h"
   #import "GoogleMaps/GoogleMaps.h"

   @implementation AppDelegate

   - (BOOL)application:(UIApplication *)application
       didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     [GMSServices provideAPIKey:@"YOUR KEY HERE"];
     [GeneratedPluginRegistrant registerWithRegistry:self];
     return [super application:application didFinishLaunchingWithOptions:launchOptions];
   }
   @end
   ```

   Or in your Swift code, specify your API key
   in the application delegate `ios/Runner/AppDelegate.swift`:

   ```swift
   import UIKit
   import Flutter
   import GoogleMaps

   @UIApplicationMain
   @objc class AppDelegate: FlutterAppDelegate {
     override func application(
       _ application: UIApplication,
       didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
     ) -> Bool {
       GMSServices.provideAPIKey("YOUR KEY HERE")
       GeneratedPluginRegistrant.register(with: self)
       return super.application(application, didFinishLaunchingWithOptions: launchOptions)
     }
   }
   ```

### All

You can now add a `GoogleMap` widget to your widget tree.

The map view can be controlled with the `GoogleMapController` that is passed to
the `GoogleMap`'s `onMapCreated` callback.

The `GoogleMap` widget should be used within a widget with a bounded size. Using it
in an unbounded widget will cause the application to throw a Flutter exception.

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