import 'package:place_pickarte/place_pickarte.dart';

class GoogleMapConfig {
  /// Value for defining style for [GoogleMaps], to access some basic styles
  /// check out [GoogleMapStyles] class and its static members.
  ///
  /// The style string can be generated using [map style tool](https://mapstyle.withgoogle.com/).
  /// Also, refer [iOS](https://developers.google.com/maps/documentation/ios-sdk/style-reference)
  /// and [Android](https://developers.google.com/maps/documentation/android-sdk/style-reference)
  /// style reference for more information regarding the supported styles.
  final String? googleMapStyle;

  final MapType googleMapType;

  final String? androidApiKey;

  final String? iosApiKey;

  const GoogleMapConfig({
    this.googleMapStyle,
    this.googleMapType = MapType.normal,
    this.androidApiKey,
    this.iosApiKey,
  });
}
