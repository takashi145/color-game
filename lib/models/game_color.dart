import 'package:flutter/material.dart';

import 'word_script.dart';

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
        return '橙';
    }
  }

  String labelFor(WordScript script) {
    switch (script) {
      case WordScript.kanji:
        return label;
      case WordScript.hiragana:
        switch (this) {
          case GameColor.red:
            return 'あか';
          case GameColor.blue:
            return 'あお';
          case GameColor.green:
            return 'みどり';
          case GameColor.yellow:
            return 'きいろ';
          case GameColor.purple:
            return 'むらさき';
          case GameColor.orange:
            return 'おれんじ';
        }
      case WordScript.katakana:
        switch (this) {
          case GameColor.red:
            return 'アカ';
          case GameColor.blue:
            return 'アオ';
          case GameColor.green:
            return 'ミドリ';
          case GameColor.yellow:
            return 'キイロ';
          case GameColor.purple:
            return 'ムラサキ';
          case GameColor.orange:
            return 'オレンジ';
        }
      case WordScript.english:
        switch (this) {
          case GameColor.red:
            return 'Red';
          case GameColor.blue:
            return 'Blue';
          case GameColor.green:
            return 'Green';
          case GameColor.yellow:
            return 'Yellow';
          case GameColor.purple:
            return 'Purple';
          case GameColor.orange:
            return 'Orange';
        }
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