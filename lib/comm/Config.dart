import 'package:flutter/foundation.dart';

enum ThemeType { light, dark, brown, blue }

class Config {
  ThemeType themeType;

  Config({
    @required this.themeType,
  }) : assert(themeType != null);

  Config copyWith({
    ThemeType themeType,
  }) {
    return Config(themeType: themeType ?? this.themeType);
  }
}
