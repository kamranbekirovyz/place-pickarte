import 'package:place_pickarte/place_pickarte.dart';
import 'package:flutter/material.dart';
import 'package:place_pickarte/src/widgets/default_pin_widget.dart';

typedef PinBuilder = Widget Function(
  BuildContext context,
  PinState state,
);

class PlacePickartePin extends StatefulWidget {
  final PinBuilder? pinBuilder;
  final Stream<PinState> pinStateStream;

  const PlacePickartePin({
    this.pinBuilder,
    required this.pinStateStream,
    super.key,
  });

  @override
  State<PlacePickartePin> createState() => _PlacePickartePinState();
}

class _PlacePickartePinState extends State<PlacePickartePin> {
  final _pinKey = GlobalKey();
  double _y = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      /// To make sure the pin's down side really points to the location user...
      Future.delayed(const Duration(milliseconds: 200), () {
        final box = _pinKey.currentContext?.findRenderObject() as RenderBox?;
        final height = box?.size.height;

        setState(() => _y = height! / 2);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      /// Ignoring pointer, helpful when user wants to zoom the map by double
      /// tap on screen: gets zoomed even when double tapped on the pin.
      child: IgnorePointer(
        child: AnimatedContainer(
          duration: kThemeAnimationDuration,
          transform: Matrix4.translationValues(
            0.0,
            -_y,
            0.0,
          ),
          child: SizedBox(
            key: _pinKey,
            child: StreamBuilder<PinState>(
              initialData: PinState.idle,
              stream: widget.pinStateStream,
              builder: (context, snapshot) {
                final pinState = snapshot.data!;

                if (widget.pinBuilder != null) {
                  return widget.pinBuilder!(context, pinState);
                }

                return DefaultPinWidget(pinState: pinState);
              },
            ),
          ),
        ),
      ),
    );
  }
}
