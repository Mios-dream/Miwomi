import 'package:flutter/material.dart';

class HexColor extends Color {
  static Color fromHex(String hexString) {
    hexString = hexString.toUpperCase().replaceAll('#', '');
    if (hexString.length == 6) {
      hexString = 'FF$hexString'; // 默认为完全不透明
    }
    return Color(int.parse(hexString, radix: 16));
  }

  HexColor.fromValue(int value) : super(value);
}
