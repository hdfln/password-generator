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

  void _updatePassword() {
    setState(() {
      _password = generatePassword(_length, _withSymbol);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 32.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Theme.of(context).primaryColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  _password,
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                              )),
                          IconButton(
                            icon: const Icon(Icons.redo),
                            onPressed: () => _updatePassword(),
                            iconSize:
                                Theme.of(context).textTheme.headline4?.fontSize,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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
                            setState(
                              () {
                                _length = value.round().toInt();
                                _updatePassword();
                              },
                            );
                          },
                        ),
                        Text('長さ：$_length'),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Checkbox(
                        activeColor: Colors.blue,
                        onChanged: (bool? value) {
                          setState(
                            () {
                              _withSymbol = value!;
                              _updatePassword();
                            },
                          );
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
