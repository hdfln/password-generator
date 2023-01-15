import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:password_generator/utils.dart';
import 'package:provider/provider.dart';

import 'password_model.dart';

class PasswordField extends StatelessWidget {
  const PasswordField({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          elevation: 0,
          color: Colors.black87,
          child: ListTile(
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: AnimatedTextKit(
                key: UniqueKey(),
                isRepeatingAnimation: false,
                animatedTexts: [
                  TypewriterAnimatedText(
                    context.watch<PasswordModel>().text,
                    textStyle:
                        Theme.of(context).textTheme.displaySmall?.copyWith(
                              color: Colors.green,
                            ),
                  ),
                ],
                onTap: () => copyToClipboard(context),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
