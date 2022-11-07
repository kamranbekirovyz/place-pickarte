import 'package:artistic_place_picker/artistic_place_picker.dart';
import 'package:flutter/material.dart';

typedef PinBuilder = Widget Function(
  BuildContext context,
  PinState state,
);

class ArtisticPlacePickerPin extends StatelessWidget {
  final PinBuilder? pinBuilder;
  final Stream<PinState> pinStateStream;

  const ArtisticPlacePickerPin({
    super.key,
    this.pinBuilder,
    required this.pinStateStream,
  });

  @override
  Widget build(BuildContext context) {
    // TOOD: add custom pin builder based on PinState
    return Center(
      /// Ignoring pointer, helpful when user wants to zoom the map by double
      /// tap on screen: gets zoomed even when double tapped on the pin.
      child: IgnorePointer(
        child: StreamBuilder<PinState>(
          initialData: PinState.idle,
          stream: pinStateStream,
          builder: (context, snapshot) {
            final pinState = snapshot.data!;

            if (pinBuilder != null) {
              return pinBuilder!(context, pinState);
            }

            // TODO: ability to customize default pin's colors, size, animation, maybe?
            final iconColor = pinState == PinState.busy ? Colors.blueGrey.shade900 : const Color(0xff4285F4);
            final iconData = pinState == PinState.busy ? Icons.not_listed_location_rounded : Icons.location_on_rounded;

            return AnimatedContainer(
              duration: kThemeAnimationDuration,
              transform: Matrix4.translationValues(
                0.0,
                pinState == PinState.busy ? -8.0 : 0.0,
                0.0,
              ),
              child: Icon(
                iconData,
                size: 72.0,
                color: iconColor,
              ),
            );
          },
        ),
      ),
    );
  }
}
