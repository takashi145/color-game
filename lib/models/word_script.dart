enum WordScript {
  kanji,
  hiragana,
  katakana,
  english;

  String get displayName {
    switch (this) {
      case WordScript.kanji:
        return '漢字';
      case WordScript.hiragana:
        return 'ひらがな';
      case WordScript.katakana:
        return 'カタカナ';
      case WordScript.english:
        return 'English';
    }
  }
}
