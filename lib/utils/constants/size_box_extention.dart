import 'package:flutter/material.dart';

extension Sizedbox on num {
  SizedBox get sBH => SizedBox(height: toDouble());
  SizedBox get sBW => SizedBox(width: toDouble());
}

extension StringCasingExtension on String {
  String get toCapitalized =>
      isNotEmpty ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String get toTitleCase => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized)
      .join(' ');
}

SizedBox emptySpace() {
  return const SizedBox.shrink();
}
