
# place_pickarte

A Flutter plugin that enables you to make pixel-by-pixel customizable map place pickers.

I'm polishing it for first stable 1.0.0 release. Feedback is welcome. Follow my journey on [X/Twitter](https://x.com/kamranbekirovyz).

## 📐 Features

🎨 **Fully Customizable**: Adapt to any design system  
🗺️ **Google Maps Integration**: Built-in support with more providers coming  
🔍 **Places Search**: Autocomplete and location search  
✨ **Smooth Animations**: Responsive pin interactions  
🔐 **Permission Handling**: Location access managed automatically  
🎭 **Multiple Styles**: Six pre-built map themes  
🚀 **Production Ready**: Complete example included  

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

**Setup first**: We use Google Maps under the hood. Follow [google_maps_flutter setup](https://pub.dev/packages/google_maps_flutter#getting-started) for API keys and native config. We won't duplicate their docs here.

### Just want it working? 
Copy [`example/lib/pages/place_picker_page.dart`](example/lib/pages/place_picker_page.dart). It's production-ready with search, location display, error handling. Paste, tweak colors, done.

### Want to build custom? Here's everything:

**PlacePickarteController** - Your main interface
```dart
final controller = PlacePickarteController(config: PlacePickarteConfig(...));

// Streams - listen to everything
controller.currentLocationStream        // Stream<GeocodingResult?> - selected location
controller.autocompleteResultsStream    // Stream<List<Prediction>?> - search results  
controller.pinStateStream              // Stream<PinState> - idle/dragging
controller.cameraPositionStream        // Stream<CameraPosition?> - map camera
controller.googleMapTypeStream         // Stream<MapType> - normal/satellite/etc
controller.searchQueryStream           // Stream<String> - current search text

// Actions - control everything  
controller.searchAutocomplete('pizza')           // Search places
controller.selectAutocompleteItem(prediction)   // Go to search result
controller.goToMyLocation()                     // Find user location
controller.setGoogleMapType(MapType.satellite)  // Change map style
controller.clearSearchQuery()                   // Clear search
controller.close()                              // Cleanup (call in dispose)
```

**PlacePickarteMap** - The map widget
```dart
PlacePickarteMap(controller) // Renders map + pin + everything
```

**PlacePickarteConfig** - Configure everything
```dart
PlacePickarteConfig(
  googleMapConfig: GoogleMapConfig(
    iosApiKey: 'YOUR_IOS_KEY',
    androidApiKey: 'YOUR_ANDROID_KEY',
    googleMapType: MapType.normal,           // .satellite, .hybrid, .terrain
    googleMapStyle: GoogleMapStyles.dark,    // .night, .retro, .silver, .aubergine, .standard
    zoomControlsEnabled: false,              // Android zoom buttons
  ),
  initialLocation: Location(lat: 40.4093, lng: 49.8671),  // Starting position
  initialZoom: 16.5,                                       // Starting zoom
  myLocationAsInitial: true,                               // Start at user location
  googleMapsGeocoding: GoogleMapsGeocoding(apiKey: 'KEY'), // For address lookup
  placesAutocompleteConfig: PlacesAutocompleteConfig(
    region: 'us',                                    // Country bias
    language: 'en',                                  // Result language  
    components: [Component(Component.country, 'us')], // Restrict to country
    types: ['establishment'],                         // Filter place types
    radius: 50000,                                   // Search radius (meters)
    strictbounds: false,                             // Enforce radius
  ),
  pinBuilder: (context, state) => CustomPin(state),       // Custom pin widget
)
```

**PlacePickarteAutocompleteItem** - Search result UI
```dart
PlacePickarteAutocompleteItem(
  prediction: prediction,
  onTap: (prediction) => controller.selectAutocompleteItem(prediction),
)
```

**Custom Pin Builder**
```dart
pinBuilder: (context, state) {
  return AnimatedContainer(
    duration: Duration(milliseconds: 200),
    transform: Matrix4.translationValues(0, state == PinState.dragging ? -8 : 0, 0),
    child: Icon(
      state == PinState.dragging ? Icons.location_searching : Icons.location_on,
      size: 72,
      color: state == PinState.dragging ? Colors.grey : Colors.red,
    ),
  );
}
```

**Location Permission Results**
```dart
final result = await controller.goToMyLocation();
// Returns MyLocationResult enum:
// .success, .serviceNotEnabled, .permissionDenied, .permissionDeniedForever, .permissionUnableToDetermine
```

**Pin States**
```dart
// PinState enum: .idle, .dragging
StreamBuilder<PinState>(
  stream: controller.pinStateStream,
  builder: (context, snapshot) => Text(snapshot.data == PinState.dragging ? 'Moving...' : 'Ready'),
)
```

## 💡 Inspired from/by

- Forked and modified <a href="https://github.com/lejard-h/google_maps_webservice">google_maps_webservice</a> according to this package's needs, specifically for not supporting null-safety.


## 📃 License

<a href="https://github.com/kamranbekirovyz/place-pickarte/LICENSE">MIT License</a>