import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'password_model.dart';

void copyToClipboard(BuildContext context) {
  Clipboard.setData(
    ClipboardData(
      text: context.read<PasswordModel>().text,
    ),
  ).then(
    (_) => ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'コピーされました！',
        ),
      ),
    ),
  );
}
