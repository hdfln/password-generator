import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'password_model.dart';

class SwitchWithLabel extends StatefulWidget {
  const SwitchWithLabel({
    super.key,
    required this.title,
    required this.type,
  });

  final String title;
  final IncludeCharType type;

  @override
  State<SwitchWithLabel> createState() => _SwitchWithLabelState();
}

class _SwitchWithLabelState extends State<SwitchWithLabel> {
  bool _value = true;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(widget.title),
      onChanged: (bool? value) {
        setState(() {
          _value = value!;
        });
        Provider.of<PasswordModel>(
          context,
          listen: false,
        ).setIncludeChars(widget.type, _value);
      },
      value: _value,
    );
  }
}
