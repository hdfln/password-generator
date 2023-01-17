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
            onTap: () {
              copyToClipboard(context);
            },
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: AnimatedText(
                key: UniqueKey(),
                text: context.watch<PasswordModel>().text,
                style: Theme.of(context)
                    .textTheme
                    .displaySmall
                    ?.copyWith(color: Colors.green),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AnimatedText extends StatefulWidget {
  const AnimatedText({super.key, required this.text, required this.style});
  final String text;
  final TextStyle? style;

  @override
  State<AnimatedText> createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  final int cursorBlinks = 3;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(
        milliseconds: (widget.text.length + cursorBlinks * 2) * 50,
      ),
      vsync: this,
    );
    animation =
        Tween<double>(begin: 0, end: widget.text.length + cursorBlinks * 2 + 1)
            .animate(controller)
          ..addListener(() {
            setState(() {
              // The state that has changed here is the animation object’s value.
            });
          });
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int virtualVisibleLength = animation.value.round();
    String cursor = '_';
    final int visibleLength;
    if (virtualVisibleLength >= widget.text.length) {
      visibleLength = widget.text.length;
      final bool blinkCursor =
          (virtualVisibleLength - widget.text.length) % 2 == 1;
      if (blinkCursor) {
        cursor = '';
      }
    } else {
      visibleLength = virtualVisibleLength;
    }

    final String visibleText =
        '${widget.text.substring(0, visibleLength)}$cursor';
    return Wrap(
      children: visibleText
          .split('')
          .map(
            (c) => Text(
              c,
              style: widget.style,
            ),
          )
          .toList(),
    );
  }
}
