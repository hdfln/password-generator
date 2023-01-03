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
  bool _withSymbol = false;
  late String _password = generatePassword(_length, _withSymbol);
  final _controller = TextEditingController();

  void _updatePassword() {
    setState(() {
      _password = generatePassword(_length, _withSymbol);
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
                  Column(
                    children: [
                      Checkbox(
                        onChanged: (bool? value) {
                          setState(() {
                            _withSymbol = value!;
                            _updatePassword();
                          });
                        },
                        value: _withSymbol,
                      ),
                      const Text('記号'),
                    ],
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

String generatePassword([int length = 20, bool withSymbol = false]) {
  const String alphaNumeric =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz';
  const String symbol = '!@#\$%^&*()\'"=_`:;?~|+-\\/[]{}<>';
  final charset = withSymbol ? alphaNumeric + symbol : alphaNumeric;
  final Random random = Random.secure();
  final String randomStr =
      List.generate(length, (_) => charset[random.nextInt(charset.length)])
          .join();
  return randomStr;
}
