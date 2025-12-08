import 'package:example/place_picker_page.dart';
import 'package:flutter/material.dart';
import 'package:place_pickarte/place_pickarte.dart';

const Color primaryColor = Colors.lightBlueAccent;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(colorSchemeSeed: primaryColor),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GeocodingResult? _pickedPlace;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('package:place_pickarte'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('This is the place you\'ve picked:'),
            const SizedBox(height: 8),
            Text(
              '${_pickedPlace?.formattedAddress}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              '${_pickedPlace?.geometry.location}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          _pickedPlace = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return PlacePickerPage();
              },
            ),
          );

          setState(() {});
        },
        label: Text('Pick Place'),
        icon: const Icon(Icons.map),
      ),
    );
  }
}
