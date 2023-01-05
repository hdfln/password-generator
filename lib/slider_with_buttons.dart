import 'package:flutter/material.dart';

class ListTileForPc extends StatefulWidget {
  const ListTileForPc({
    super.key,
    required this.value,
    required this.onChangeCallback,
  });

  final int value;
  final Function onChangeCallback;

  @override
  State<ListTileForPc> createState() => _ListTileForPcState();
}

class _ListTileForPcState extends State<ListTileForPc> {
  final int _min = 8;
  final int _max = 32;
  late int _value;

  @override
  void initState() {
    _value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          const Text('長さ'),
          const Spacer(),
          IconButtonWithBorder(
            icon: const Icon(Icons.remove),
            onPressedCallback: () {
              if (_value > _min) {
                setState(() {
                  _value--;
                });
                widget.onChangeCallback(_value);
              }
            },
          ),
          Expanded(
            flex: 10,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                  thumbShape: SliderThumbWithValue(
                    thumbRadius: 16.0,
                    sliderValue: _value.toDouble(),
                  ),
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 20,
                  )),
              child: Slider(
                value: _value.toDouble(),
                min: _min.toDouble(),
                max: _max.toDouble(),
                label: _value.toString(),
                onChanged: (double v) {
                  final int newValue = v.round().toInt();
                  if (_value != newValue) {
                    setState(() {
                      _value = newValue;
                    });
                    widget.onChangeCallback(_value);
                  }
                },
              ),
            ),
          ),
          IconButtonWithBorder(
            onPressedCallback: () {
              if (_value < _max) {
                setState(() {
                  _value++;
                });
                widget.onChangeCallback(_value);
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

class IconButtonWithBorder extends StatelessWidget {
  const IconButtonWithBorder(
      {super.key, required this.onPressedCallback, required this.icon});

  final Icon icon;
  final Function onPressedCallback;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size.zero,
        padding: EdgeInsets.zero,
      ),
      onPressed: () {
        onPressedCallback();
      },
      child: icon,
    );
  }
}
