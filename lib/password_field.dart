import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'password_model.dart';

class PasswordField extends StatelessWidget {
  const PasswordField({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    controller.text = context.watch<PasswordModel>().text;
    // print(controller.text);

    return TextFormField(
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
    );
  }
}
