import 'package:flutter/material.dart';
import 'package:place_pickarte/place_pickarte.dart';

class PlaceSearchDelegate extends SearchDelegate {
  final PlacePickarteController controller;

  PlaceSearchDelegate(this.controller);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
        icon: const Icon(Icons.clear_outlined),
      ),
      const SizedBox(width: 8.0),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      icon: const Icon(
        Icons.arrow_back,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder(
      builder: (_, snapshot) {
        return const Placeholder();
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
