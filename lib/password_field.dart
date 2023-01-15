import 'package:flutter/material.dart';
import 'package:password_generator/utils.dart';
import 'package:provider/provider.dart';

import 'password_model.dart';

class PasswordField extends StatelessWidget {
  const PasswordField({super.key});

  @override
  Widget build(BuildContext context) {
    final String text = context.watch<PasswordModel>().text;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text('生成されたパスワード'),
        ),
        Card(
          child: ListTile(
            title: Text(
              text,
              style: Theme.of(context).textTheme.headline6,
            ),
            onTap: () => copyToClipboard(context),
          ),
        ),
      ],
    );
  }
}
