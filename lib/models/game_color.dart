import 'package:flutter/material.dart';

enum GameColor {
  red,
  blue,
  green,
  yellow,
  purple,
  orange;

  String get label {
    switch (this) {
      case GameColor.red:
        return '赤';
      case GameColor.blue:
        return '青';
      case GameColor.green:
        return '緑';
      case GameColor.yellow:
        return '黄';
      case GameColor.purple:
        return '紫';
      case GameColor.orange:
        return 'オレンジ';
    }
  }

  Color get color {
    switch (this) {
      case GameColor.red:
        return Colors.red;
      case GameColor.blue:
        return Colors.blue;
      case GameColor.green:
        return Colors.green;
      case GameColor.yellow:
        return Colors.yellow;
      case GameColor.purple:
        return Colors.purple;
      case GameColor.orange:
        return Colors.orange;
    }
  }

  Color get onColor {
    switch (this) {
      case GameColor.yellow:
        return Colors.black;
      default:
        return Colors.white;
    }
  }
}