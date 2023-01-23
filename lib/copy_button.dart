import 'package:flutter/material.dart';
import 'package:password_generator/password_model.dart';
import 'package:password_generator/utils.dart';
import 'package:provider/provider.dart';

class CopyButton extends StatelessWidget {
  const CopyButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        copyToClipboard(context);
        context.read<PasswordModel>().key.currentState?.finishAnimation();
      },
      tooltip: 'コピー',
      child: const Icon(Icons.copy),
    );
  }
}
