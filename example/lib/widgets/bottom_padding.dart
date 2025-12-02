import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
