import 'dart:math';

import 'package:flutter/material.dart';

class PasswordModel extends ChangeNotifier {
  int length = 16;
  Map<IncludeCharType, bool> includeChars = {
    IncludeCharType.number: true,
    IncludeCharType.symbol: true,
  };
  late String text = generatePassword();

  void setLength(int length) {
    this.length = length;
    text = generatePassword();
    notifyListeners();
  }

  void setIncludeChars(IncludeCharType key, bool value) {
    includeChars[key] = value;
    text = generatePassword();
    notifyListeners();
  }

  void update() {
    text = generatePassword();
    notifyListeners();
  }

  String generatePassword() {
    const String alphabets =
        'ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz';
    const String numbers = '0123456789';
    const String symbols = '!@#\$%^&*()\'"=_`:;?~|+-\\/[]{}<>';
    String charset = alphabets;
    if (includeChars[IncludeCharType.number]!) charset += numbers;
    if (includeChars[IncludeCharType.symbol]!) charset += symbols;
    final Random random = Random.secure();

    while (true) {
      final String randomStr =
          List.generate(length, (_) => charset[random.nextInt(charset.length)])
              .join();

      if (includeChars[IncludeCharType.number]! &&
          !isCharOverlap(randomStr, numbers)) {
        continue;
      }
      if (includeChars[IncludeCharType.symbol]! &&
          !isCharOverlap(randomStr, symbols)) {
        continue;
      }
      return randomStr;
    }
  }

  bool isCharOverlap(String s, String chars) {
    return s.split('').toSet().intersection(chars.split('').toSet()).isNotEmpty;
  }
}

enum IncludeCharType {
  number,
  symbol,
}
