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
                    icon: const Icon(Icons.redo),
                    splashRadius: 16,
                    onPressed: () {
                      setState(() {
                        _updatePassword();
                      });
                    },
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Slider(
                          value: _length.toDouble(),
                          min: 8,
                          max: 32,
                          divisions: 24,
                          label: _length.toString(),
                          onChanged: (double value) {
                            setState(() {
                              _length = value.round().toInt();
                              _updatePassword();
                            });
                          },
                        ),
                        Text('長さ：$_length'),
                      ],
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
                ],
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
    return Column(
      children: [
        Switch(
          onChanged: (bool? value) {
            setState(() {
              _value = value!;
            });
            widget.callbackOnChanged(_value);
          },
          value: _value,
        ),
        Text(widget.label),
      ],
    );
  }
}
