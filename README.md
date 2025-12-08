
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

### Complete Place Picker in One File
Copy [`example/lib/place_picker_page.dart`](example/lib/place_picker_page.dart). You get **everything**:
- 🔍 **Search bar** with autocomplete overlay
- 📍 **Animated pin** that responds to map movement  
- 📱 **My location button** with permission handling
- 📋 **Bottom sheet** showing selected address
- ✅ **Continue button** to confirm selection
- 🎨 **Styled components** ready for your colors

**That's the main point** - we don't give you basic components. We give you a **complete, production-ready place picker** that you can customize to your brand.

### API Reference

**PlacePickarteConfig** - Start here, configure everything
```dart
PlacePickarteConfig(
  // Required: Google Maps setup
  googleMapConfig: GoogleMapConfig(
    iosApiKey: 'YOUR_IOS_KEY',
    androidApiKey: 'YOUR_ANDROID_KEY',
  ),
  
  // Optional: Initial map position
  initialLocation: Location(lat: 40.4093, lng: 49.8671),  // Default: Baku, Azerbaijan
  initialZoom: 16.5,                                       // Default: 16.5
  myLocationAsInitial: true,                               // Start at user's location
  
  // Optional: Address lookup (needed for bottom sheet address display)
  googleMapsGeocoding: GoogleMapsGeocoding(apiKey: 'KEY'),
  
  // Optional: Customize search behavior
  placesAutocompleteConfig: PlacesAutocompleteConfig(
    region: 'az',                                          // Bias results to country
    components: [Component(Component.country, 'az')],      // Restrict to Azerbaijan
    language: 'en',                                        // Result language
    types: ['establishment'],                              // Filter: restaurants, shops, etc
  ),
  
  // Optional: Custom pin design
  pinBuilder: (context, state) => YourCustomPin(state),
)
```

**PlacePickarteController** - Create with config, control everything
```dart
final controller = PlacePickarteController(config: yourConfig);

// Listen to real-time updates
controller.currentLocationStream        // Selected location with address
controller.autocompleteResultsStream    // Search results as user types
controller.pinStateStream              // Pin animation state (idle/dragging)

// Control the picker
controller.searchAutocomplete('pizza')           // Trigger search
controller.selectAutocompleteItem(prediction)   // Jump to search result  
controller.goToMyLocation()                     // Find user's location
controller.close()                              // Always call in dispose()
```

**PlacePickarteMap** - The map widget
```dart
PlacePickarteMap(controller) // Full map with pin, animations, everything
```

**Search Results UI** - Build your autocomplete list
```dart
StreamBuilder<List<Prediction>?>(
  stream: controller.autocompleteResultsStream,
  builder: (context, snapshot) {
    final predictions = snapshot.data ?? [];
    return ListView.builder(
      itemCount: predictions.length,
      itemBuilder: (context, index) => PlacePickarteAutocompleteItem(
        prediction: predictions[index],
        onTap: (prediction) {
          controller.selectAutocompleteItem(prediction); // Jump to location
          // Clear search, hide overlay, etc.
        },
      ),
    );
  },
)
```

**Custom Pin Design** - Replace default pin
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

**Map Styling** - 6 built-in themes
```dart
GoogleMapConfig(
  googleMapStyle: GoogleMapStyles.dark,    // Dark theme
  googleMapStyle: GoogleMapStyles.night,   // Night mode  
  googleMapStyle: GoogleMapStyles.retro,   // Vintage look
  googleMapStyle: GoogleMapStyles.silver,  // Minimal gray
  googleMapStyle: GoogleMapStyles.aubergine, // Purple theme
  // Or null for standard Google Maps style
)
```

**Location Permissions** - Handled automatically
```dart
final result = await controller.goToMyLocation();
switch (result) {
  case MyLocationResult.success:
    // Location found and map moved
  case MyLocationResult.permissionDenied:
    // Show permission dialog
  case MyLocationResult.serviceNotEnabled:
    // Ask user to enable GPS
}
```

## 💡 Inspired from/by

- Forked and modified <a href="https://github.com/lejard-h/google_maps_webservice">google_maps_webservice</a> according to this package's needs, specifically for not supporting null-safety.


## 📃 License

<a href="https://github.com/kamranbekirovyz/place-pickarte/LICENSE">MIT License</a>