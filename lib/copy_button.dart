import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'password_model.dart';

class CopyButton extends StatelessWidget {
  const CopyButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => Clipboard.setData(
        ClipboardData(
          text: context.read<PasswordModel>().text,
        ),
      ).then(
        (_) => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Copied to your clipboard!'),
          ),
        ),
      ),
      tooltip: 'コピー',
      child: const Icon(Icons.copy),
    );
  }
}
