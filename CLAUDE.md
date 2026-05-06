# CLAUDE.md

## 技術スタック

- Framework: Flutter
- Language: Dart
- Architecture: MVVM
- State Management: provider package / ChangeNotifier
- Target: Android / iOS
- Game Type: Stroop effect color game
- UI: Material 3

## 使用パッケージ
- provider
- shared_preferences

## フォルダ構成

```
lib/
├── main.dart               # エントリポイント・MultiProvider設定のみ
├── screens/                # 画面単位のWidget（UIのみ）
│   ├── home_screen.dart
│   ├── game_screen.dart
│   └── result_screen.dart
├── widgets/                # 再利用可能な小Widget
│   ├── color_word_display.dart
│   └── answer_button.dart
├── models/                 # immutableなデータクラス
│   ├── game_color.dart     # GameColor enum
│   ├── game_state.dart
│   └── color_pair.dart
├── logic/                  # ゲームロジック（UIに依存しない純粋Dart）
│   └── game_logic.dart
├── services/               # データ永続化などのサービスクラス
│   └── storage_service.dart
└── providers/              # ChangeNotifier
    └── game_provider.dart
```

## 設計ルール

- `screens/` にロジックを書かない。UIの組み立てのみ
- ビジネスロジックは `logic/` に、状態管理は `providers/` に分離する
- `ChangeNotifier` は `providers/` にのみ置く
- model クラスは `final` フィールドのみのイミュータブル設計にする
- 色定義は `GameColor` enum で一元管理し、UIで `Colors.red` などを直接使わない
- `GameColor` enum は `models/game_color.dart` で定義する
- Widget の `build()` 内でビジネスロジックを実行しない
- `Timer` の管理は `providers/` で行う
- 不要なアーキテクチャ、外部パッケージ、ファイルを勝手に追加しない

## コーディング規約

- `StatelessWidget` を優先する（状態は Provider に委譲）
- `const` constructor を必ず付ける
- magic number 禁止 → `const` 定数か enum で定義
- `setState` は原則使用しない。状態は Provider / ChangeNotifier に集約する
- `dynamic` 型の使用禁止
- null 安全を守る（`!` 演算子の乱用禁止）
- `print()` を本番コードに残さない（デバッグ用は `debugPrint()`）
- ファイル名: `snake_case`　クラス名: `PascalCase`　変数・関数名: `camelCase`
