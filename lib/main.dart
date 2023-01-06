import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'animated_renew_button.dart';
import 'slider_with_buttons.dart';

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
  int length = 16;
  bool withNumber = true;
  bool withSymbol = true;
  late String _password = generatePassword(length, withNumber, withSymbol);
  final controller = TextEditingController();

  void _updatePassword(int length) {
    setState(() {
      this.length = length;
      _password = generatePassword(length, withNumber, withSymbol);
      controller.text = _password;
    });
  }

  @override
  void initState() {
    super.initState();
    controller.text = _password;
  }

  @override
  void dispose() {
    controller.dispose();
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
                child: ListTileForPc(
                  value: length,
                  onChangeCallback: _updatePassword,
                ),
              ),
              SwitchWithLabel(
                label: '数字',
                onChangedCallback: (bool? v) {
                  withNumber = v!;
                  _updatePassword(length);
                },
              ),
              SwitchWithLabel(
                label: '記号',
                onChangedCallback: (bool? v) {
                  withSymbol = v!;
                  _updatePassword(length);
                },
              ),
              const Divider(height: 64),
              IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        // TODO: TextFormField でなくても良いか検討
                        controller: controller,
                        readOnly: true,
                        maxLines: null,
                        onTap: () {
                          controller.selection = TextSelection(
                            baseOffset: 0,
                            extentOffset: controller.value.text.length,
                          );
                        },
                        decoration: InputDecoration(
                          filled: true,
                          labelText: '生成されたパスワード',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    AnimatedRenewButton(
                      onPressedCallback: () {
                        _updatePassword(length);
                      },
                    ),
                  ],
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
    required this.onChangedCallback,
  });

  final String label;
  final Function onChangedCallback;

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
          widget.onChangedCallback(_value);
        },
        value: _value,
      ),
    );
  }
}
