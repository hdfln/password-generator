import 'package:flutter/material.dart';

class AnimatedText extends StatefulWidget {
  const AnimatedText({super.key, required this.text, required this.style});
  final String text;
  final TextStyle? style;

  @override
  State<AnimatedText> createState() => AnimatedTextState();
}

class AnimatedTextState extends State<AnimatedText>
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

  void finishAnimation() {
    controller.animateTo(1.0, duration: const Duration(microseconds: 1));
  }
}
