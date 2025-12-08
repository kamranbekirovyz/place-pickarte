import 'package:flutter/foundation.dart';
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
          _StyledButton(
            onPressed: () {
              Navigator.of(
                context,
              ).pop(placePickarteController.currentLocation);
            },
            label: 'Continue',
          ),
        ],
      ),
    );
  }
}

class _StyledButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;

  const _StyledButton({required this.onPressed, required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.translucent,
      child: Container(
        height: 56,
        alignment: Alignment.center,
        width: double.maxFinite,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).primaryColor,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class PlacePickerSearch extends StatefulWidget implements PreferredSizeWidget {
  final PlacePickarteController controller;
  final GlobalKey appBarKey;

  const PlacePickerSearch({
    required this.controller,
    required this.appBarKey,
    super.key,
  });

  @override
  State<PlacePickerSearch> createState() => _PlacePickerSearchState();

  @override
  Size get preferredSize => const Size.fromHeight(64);
}

class _PlacePickerSearchState extends State<PlacePickerSearch> {
  late final TextEditingController _queryController;
  late final FocusNode _focusNode;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();

    /// Instead of calling updateSearchQuery(...) method on onChanged parameter
    /// of the TextField, we'are listening and updating it.
    ///
    /// Why? When controller.clear() called, it does not update search query as
    /// an empty string.
    _queryController = TextEditingController()
      ..addListener(() {
        widget.controller.searchAutocomplete(_queryController.text);
      });

    /// Listening focus changes on [TextField] and clearing predictions overlay
    /// when unfocused.
    ///
    /// Helpful when current screen is popped (via Navigator or back button),
    /// overlay is being visible until page transition animation ends, creating
    /// an ugly view.
    _focusNode = FocusNode()
      ..addListener(() {
        if (!_focusNode.hasFocus) {
          _clearOverlay();
        }
      });

    widget.controller.autocompleteResultsStream.listen((
      List<Prediction>? event,
    ) {
      _clearOverlay();

      final bool searching = _queryController.text.isNotEmpty;
      if (!searching) return;

      Widget child;

      if (event != null && event.isEmpty) {
        child = Container(
          height: 64.0,
          alignment: Alignment.center,
          child: Text(
            'No results.',
            style: TextStyle(color: Colors.black87, fontSize: 16.0),
          ),
        );
      } else if (event != null && event.isNotEmpty) {
        final predictions = <Widget>[];

        for (Prediction t in event) {
          predictions.add(
            AutocompleteItem(
              prediction: t,
              onTap: (Prediction item) {
                _queryController.clear();
                _clearOverlay();
                widget.controller.selectAutocompleteItem(item);
              },
            ),
          );
        }

        child = Column(children: predictions);
      } else {
        child = Container(
          height: 64.0,
          alignment: Alignment.center,
          child: const CircularProgressIndicator.adaptive(),
        );
      }

      _displayOverlay(child);
    });
  }

  void _displayOverlay(Widget child) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    Size size = renderBox.size;

    final RenderBox? appBarBox =
        widget.appBarKey.currentContext!.findRenderObject() as RenderBox?;

    _clearOverlay();

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          left: 0.0,
          width: size.width,
          top: appBarBox!.size.height,
          child: Material(elevation: 0, color: Colors.white, child: child),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  void dispose() {
    _clearOverlay();
    _queryController.dispose();
    _overlayEntry?.dispose();
    super.dispose();
  }

  void _clearOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(64),
      child: Container(
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: StyledSearchTextField(controller: _queryController),
      ),
    );
  }
}

class StyledSearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;
  final bool autofocus;

  const StyledSearchTextField({
    super.key,
    required this.controller,
    this.onChanged,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      autofocus: autofocus,
      cursorHeight: 16,
      cursorColor: Theme.of(context).primaryColor,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: 'Search',
        prefixIcon: Container(
          width: 20,
          height: 20,
          margin: EdgeInsets.only(left: 8),
          child: Center(child: Icon(Icons.search_rounded)),
        ),
        suffixIcon: ListenableBuilder(
          listenable: controller,
          builder: (context, child) {
            final bool isEmpty = controller.text.isEmpty;

            if (isEmpty) {
              return const SizedBox.shrink();
            }

            return IconButton(
              icon: Icon(Icons.clear_rounded),
              iconSize: 20,
              onPressed: () {
                controller.clear();
                onChanged?.call('');
              },
            );
          },
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 4),
        hintStyle: TextStyle(
          fontSize: 16,
          height: 24 / 16,
          color: Colors.black54,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide(color: Colors.black12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide(color: Colors.black12),
        ),
      ),
    );
  }
}

class BottomPadding extends StatelessWidget {
  final double defaultHeight;

  const BottomPadding([this.defaultHeight = 16.0, key]) : super(key: key);

  static double of(BuildContext context, {double defaultHeight = 16.0}) {
    final bool isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final double bottomPadding = isAndroid
        ? defaultHeight
        : MediaQuery.of(context).padding.bottom;
    final double height = bottomPadding > 0 ? bottomPadding : defaultHeight;

    return height;
  }

  @override
  Widget build(BuildContext context) {
    final height = of(context, defaultHeight: defaultHeight);

    return SizedBox(height: height);
  }
}

class AutocompleteItem extends StatelessWidget {
  final Prediction prediction;
  final Function(Prediction item) onTap;

  const AutocompleteItem({
    required this.prediction,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: ListTile(
        onTap: () {
          FocusScope.of(context).unfocus();
          onTap.call(prediction);
        },
        title: RichText(text: TextSpan(children: getStyledTexts(context))),
      ),
    );
  }

  List<TextSpan> getStyledTexts(BuildContext context) {
    final List<TextSpan> result = [];
    const style = TextStyle(color: Colors.grey, fontSize: 15);

    final startText = prediction.description!.substring(
      0,
      prediction.matchedSubstrings.first.offset.toInt(),
    );
    if (startText.isNotEmpty) {
      result.add(TextSpan(text: startText, style: style));
    }

    final boldText = prediction.description!.substring(
      prediction.matchedSubstrings.first.offset.toInt(),
      prediction.matchedSubstrings.first.offset.toInt() +
          prediction.matchedSubstrings.first.length.toInt(),
    );
    result.add(
      TextSpan(
        text: boldText,
        style: style.copyWith(
          color: Theme.of(context).textTheme.bodySmall!.color,
        ),
      ),
    );

    final remainingText = prediction.description!.substring(
      prediction.matchedSubstrings.first.offset.toInt() +
          prediction.matchedSubstrings.first.length.toInt(),
    );
    result.add(TextSpan(text: remainingText, style: style));

    return result;
  }
}
