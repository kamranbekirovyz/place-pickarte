import 'package:flutter/material.dart';
import 'package:place_pickarte/place_pickarte.dart';

/// Default pin widget when [PlacePickarteController.pinBuilder] is not
/// specified.
class DefaultPinWidget extends StatelessWidget {
  final PinState pinState;

  const DefaultPinWidget({
    required this.pinState,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final pinIsBeingDragged = pinState == PinState.dragging;
    final iconColor = pinIsBeingDragged ? Colors.blueGrey.shade900 : const Color(0xff4285F4);
    final iconData = pinIsBeingDragged ? Icons.not_listed_location_rounded : Icons.location_on_rounded;

    return AnimatedContainer(
      duration: kThemeAnimationDuration,
      transform: Matrix4.translationValues(
        0.0,
        pinIsBeingDragged ? -8.0 : 0.0,
        0.0,
      ),
      child: Icon(
        iconData,
        size: 72.0,
        color: iconColor,
      ),
    );
  }
}
