import 'package:flutter/material.dart';
import 'package:password_generator/utils.dart';
import 'package:provider/provider.dart';

import 'animated_text.dart';
import 'password_model.dart';

class PasswordField extends StatelessWidget {
  const PasswordField({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<AnimatedTextState> animatedTextKey =
        GlobalKey<AnimatedTextState>();
    context.read<PasswordModel>().setKey(animatedTextKey);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          elevation: 0,
          color: Colors.black87,
          child: ListTile(
            onTap: () {
              copyToClipboard(context);
              animatedTextKey.currentState!.finishAnimation();
            },
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: AnimatedText(
                key: animatedTextKey,
                text: context.select((PasswordModel p) => p.text),
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(color: Colors.green),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
