import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'password_model.dart';

class RenewButton extends StatelessWidget {
  const RenewButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      label: const Text('パスワードを再生成'),
      icon: const Icon(Icons.autorenew),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(56),
        foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      ),
      onPressed: () {
        Provider.of<PasswordModel>(
          context,
          listen: false,
        ).update();
      },
    );
  }
}
