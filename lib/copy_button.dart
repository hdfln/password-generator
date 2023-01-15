import 'package:flutter/material.dart';
import 'package:password_generator/utils.dart';

class CopyButton extends StatelessWidget {
  const CopyButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => copyToClipboard(context),
      tooltip: 'コピー',
      child: const Icon(Icons.copy),
    );
  }
}
