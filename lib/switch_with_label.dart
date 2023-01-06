import 'package:flutter/material.dart';

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
