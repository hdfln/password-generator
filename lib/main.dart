import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random Password Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Random Password Generator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final int _minLength = 8;
  final int _maxLength = 32;
  int _length = 16;
  bool _withNumber = true;
  bool _withSymbol = true;
  late String _password = generatePassword(_length, _withNumber, _withSymbol);
  final _controller = TextEditingController();

  void _updatePassword() {
    setState(() {
      _password = generatePassword(_length, _withNumber, _withSymbol);
      _controller.text = _password;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller.text = _password;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 32.0,
          ),
          constraints: const BoxConstraints(maxWidth: 640),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                child: ListTile(
                  leading: const Text('長さ'),
                  trailing: FractionallySizedBox(
                    widthFactor: 0.7,
                    child: Row(
                      children: [
                        IconButton(
                          splashRadius: 24,
                          onPressed: () {
                            if (_length > _minLength) {
                              setState(() {
                                _length--;
                              });
                            }
                          },
                          icon: const Icon(Icons.remove),
                        ),
                        Expanded(
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              thumbShape: PolygonSliderThumb(
                                thumbRadius: 16.0,
                                sliderValue: _length.toDouble(),
                              ),
                            ),
                            child: Slider(
                              value: _length.toDouble(),
                              min: _minLength.toDouble(),
                              max: _maxLength.toDouble(),
                              label: _length.toString(),
                              onChanged: (double value) {
                                final int newLength = value.round().toInt();
                                if (_length != newLength) {
                                  setState(() {
                                    _length = value.round().toInt();
                                    _updatePassword();
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                        IconButton(
                          splashRadius: 24,
                          onPressed: () {
                            if (_length < _maxLength) {
                              setState(() {
                                _length++;
                              });
                            }
                          },
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SwitchWithLabel(
                label: '数字',
                callbackOnChanged: (bool? value) {
                  setState(() {
                    _withNumber = value!;
                    _updatePassword();
                  });
                },
              ),
              SwitchWithLabel(
                label: '記号',
                callbackOnChanged: (bool? value) {
                  setState(() {
                    _withSymbol = value!;
                    _updatePassword();
                  });
                },
              ),
              const Divider(height: 64),
              TextFormField(
                controller: _controller,
                readOnly: true,
                maxLines: null,
                onTap: () {
                  _controller.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: _controller.value.text.length,
                  );
                },
                decoration: InputDecoration(
                  filled: true,
                  labelText: '生成されたパスワード',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    color: Theme.of(context).disabledColor,
                    icon: const Icon(Icons.autorenew),
                    splashRadius: 16,
                    onPressed: () {
                      setState(() {
                        _updatePassword();
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Clipboard.setData(ClipboardData(text: _password)).then(
          (_) => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Copied to your clipboard!'),
            ),
          ),
        ),
        tooltip: 'コピー',
        child: const Icon(Icons.copy),
      ),
    );
  }
}

String generatePassword(int length, bool withNumber, bool withSymbol) {
  const String alphabets =
      'ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz';
  const String numbers = '0123456789';
  const String symbols = '!@#\$%^&*()\'"=_`:;?~|+-\\/[]{}<>';
  String charset = alphabets;
  if (withNumber) charset += numbers;
  if (withSymbol) charset += symbols;
  final Random random = Random.secure();

  while (true) {
    final String randomStr =
        List.generate(length, (_) => charset[random.nextInt(charset.length)])
            .join();

    if (withNumber && !containsCharacterFrom(randomStr, numbers)) continue;
    if (withSymbol && !containsCharacterFrom(randomStr, symbols)) continue;
    return randomStr;
  }
}

bool containsCharacterFrom(String s, String chars) {
  return s.split('').toSet().intersection(chars.split('').toSet()).isNotEmpty;
}

class SwitchWithLabel extends StatefulWidget {
  const SwitchWithLabel({
    super.key,
    required this.label,
    required this.callbackOnChanged,
  });

  final String label;
  final Function callbackOnChanged;

  @override
  State<SwitchWithLabel> createState() => _SwitchWithLabelState();
}

class _SwitchWithLabelState extends State<SwitchWithLabel> {
  bool _value = true;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SwitchListTile(
        title: Text(widget.label),
        onChanged: (bool? value) {
          setState(() {
            _value = value!;
          });
          widget.callbackOnChanged(_value);
        },
        value: _value,
      ),
    );
  }
}

class PolygonSliderThumb extends SliderComponentShape {
  final double thumbRadius;
  final double sliderValue;

  const PolygonSliderThumb({
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
