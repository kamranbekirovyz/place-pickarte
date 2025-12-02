import 'package:example/widgets/styled_search_text_field.dart';
import 'package:flutter/material.dart';
import 'package:place_pickarte/place_pickarte.dart';

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
            PlacePickarteAutocompleteItem(
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
