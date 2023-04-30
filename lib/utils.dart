import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';

int uniqueIdFromDate(DateTime date) {
  return date.millisecondsSinceEpoch.remainder(4000);
}

Color stringToColor(String string) {
  print(string);
  final valueString =
      string.split('(0x')[1].split(')')[0]; // What is this? don't ask me
  int value = int.parse(valueString, radix: 16);
  return Color(value);
}

DateTime mostRecentSunday(DateTime date) =>
    DateTime(date.year, date.month, date.day - date.weekday % 7);

List<Color> availableColors = [
  HexColor('#f6ead4'),
  HexColor('e52165'),
  HexColor('#e2d810'),
  HexColor('#12a4d9'),
  HexColor('#a2d5c6'),
  HexColor('#077b8a'),
  HexColor('#f57e7e'),
  HexColor('#e75874'),
  HexColor('#fbcbc9'),
  HexColor('#ff6e40'),
  HexColor('#f5f0e1'),
  HexColor('#77c593'),
  HexColor('#f162ff'),
  HexColor('#ffcce7'),
  HexColor('#f5beb4'),
  HexColor('#1fbfb8'),
];
