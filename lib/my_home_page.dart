import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'animated_renew_button.dart';
import 'slider_with_buttons.dart';
import 'switch_with_label.dart';

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
  late String password = generatePassword(_length, _withNumber, _withSymbol);
  final _controller = TextEditingController();

  void _updatePassword(int length) {
    setState(() {
      _length = length;
      password = generatePassword(length, _withNumber, _withSymbol);
      _controller.text = password;
    });
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

  @override
  void initState() {
    super.initState();
    _controller.text = password;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool containsCharacterFrom(String s, String chars) {
    return s.split('').toSet().intersection(chars.split('').toSet()).isNotEmpty;
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
                  value: _length,
                  onChangeCallback: _updatePassword,
                ),
              ),
              SwitchWithLabel(
                label: '数字',
                onChangedCallback: (bool? v) {
                  _withNumber = v!;
                  _updatePassword(_length);
                },
              ),
              SwitchWithLabel(
                label: '記号',
                onChangedCallback: (bool? v) {
                  _withSymbol = v!;
                  _updatePassword(_length);
                },
              ),
              const Divider(height: 64),
              IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        // TODO: TextFormField でなくても良いか検討
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
                        ),
                      ),
                    ),
                    AnimatedRenewButton(
                      onPressedCallback: () {
                        _updatePassword(_length);
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
        onPressed: () => Clipboard.setData(ClipboardData(text: password)).then(
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
