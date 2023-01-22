import 'dart:math';

import 'package:flutter/material.dart';

class PasswordModel extends ChangeNotifier {
  int minLength = 8;
  int maxLength = 64;
  int length = 16;

  Map<IncludeCharType, bool> includeCharTypes = {
    IncludeCharType.lowercase: true,
    IncludeCharType.capital: true,
    IncludeCharType.number: true,
    IncludeCharType.symbol: true,
  };
  late String text = generatePassword();

  void setLength(int length) {
    this.length = length;
    text = generatePassword();
    notifyListeners();
  }

  void setIncludeCharType(IncludeCharType key, bool value) {
    includeCharTypes[key] = value;
    text = generatePassword();
    notifyListeners();
  }

  void update() {
    text = generatePassword();
    notifyListeners();
  }

  String generatePassword() {
    const Map<IncludeCharType, String> includeChars = {
      IncludeCharType.lowercase: 'abcdefghijklmnopqrstuvwxyz',
      IncludeCharType.capital: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
      IncludeCharType.number: '0123456789',
      IncludeCharType.symbol: '!@#\$%^&*()\'"=_`:;?~|+-\\/[]{}<>'
    };
    String charset = '';
    for (IncludeCharType charType in includeCharTypes.keys) {
      if (includeCharTypes[charType]!) {
        charset += includeChars[charType]!;
      }
    }
    final Random random = Random.secure();

    while (true) {
      bool hasNecessaryChars = true;

      final String randomStr = List.generate(
        length,
        (_) => charset[random.nextInt(charset.length)],
      ).join();

      for (IncludeCharType charType in includeCharTypes.keys) {
        if (includeCharTypes[charType]! &&
            !hasCharIntersection(randomStr, includeChars[charType]!)) {
          hasNecessaryChars = false;
          break;
        }
      }

      if (!hasNecessaryChars) {
        continue;
      }

      return randomStr;
    }
  }

  bool hasCharIntersection(String a, String b) {
    return getCharSet(a).intersection(getCharSet(b)).isNotEmpty;
  }

  Set<String> getCharSet(String s) {
    return s.split('').toSet();
  }
}

enum IncludeCharType {
  lowercase,
  capital,
  number,
  symbol,
}
