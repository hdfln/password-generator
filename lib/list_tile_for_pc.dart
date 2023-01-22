import 'package:flutter/material.dart';
import 'package:password_generator/password_model.dart';
import 'package:provider/provider.dart';

class ListTileForPc extends StatelessWidget {
  const ListTileForPc(
      {super.key, required this.minValue, required this.maxValue});

  final int minValue;
  final int maxValue;

  @override
  Widget build(BuildContext context) {
    int value = context.select((PasswordModel p) => p.length);
    return ListTile(
      title: Row(
        children: [
          const Text('長さ'),
          const Spacer(),
          ColoredIconButton(
            icon: const Icon(Icons.remove),
            onPressed: () {
              if (value > minValue) {
                value--;
                context.read<PasswordModel>().setLength(value);
              }
            },
          ),
          Expanded(
            flex: 10,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                thumbShape: SliderThumbWithValue(
                  thumbRadius: 20,
                  sliderValue: value.toDouble(),
                ),
                overlayShape: const RoundSliderOverlayShape(
                  overlayRadius: 24,
                ),
              ),
              child: Slider(
                value: value.toDouble(),
                min: minValue.toDouble(),
                max: maxValue.toDouble(),
                label: value.toString(),
                onChanged: (double v) {
                  final int newValue = v.round().toInt();
                  if (value != newValue) {
                    context.read<PasswordModel>().setLength(newValue);
                  }
                },
              ),
            ),
          ),
          ColoredIconButton(
            onPressed: () {
              if (value < maxValue) {
                value++;
                context.read<PasswordModel>().setLength(value);
              }
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

class SliderThumbWithValue extends SliderComponentShape {
  final double thumbRadius;
  final double sliderValue;

  const SliderThumbWithValue({
    required this.thumbRadius,
    required this.sliderValue,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    // Define the slider thumb design here
    final Canvas canvas = context.canvas;

    canvas.drawCircle(
      center,
      thumbRadius,
      Paint()
        ..color = sliderTheme.thumbColor ?? Colors.black
        ..style = PaintingStyle.fill,
    );

    TextSpan span = TextSpan(
      style: TextStyle(
        fontSize: thumbRadius,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      text: sliderValue.round().toString(),
    );

    TextPainter tp = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    tp.layout();

    Offset textCenter = Offset(
      center.dx - (tp.width / 2),
      center.dy - (tp.height / 2),
    );

    tp.paint(canvas, textCenter);
  }
}

class ColoredIconButton extends StatelessWidget {
  const ColoredIconButton(
      {super.key, required this.onPressed, required this.icon});

  final Icon icon;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: IconButton.styleFrom(
        minimumSize: const Size(48, 48),
        padding: EdgeInsets.zero,
      ),
      onPressed: () {
        onPressed();
      },
      icon: icon,
    );
  }
}
