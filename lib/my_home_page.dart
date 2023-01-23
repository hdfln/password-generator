import 'package:flutter/material.dart';
import 'package:password_generator/copy_button.dart';
import 'package:password_generator/renew_button.dart';
import 'package:provider/provider.dart';

import 'list_tile_for_mobile.dart';
import 'list_tile_for_pc.dart';
import 'password_field.dart';
import 'password_model.dart';
import 'switch_with_label.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Text('Password Generator'),
            SizedBox(width: 8),
            Icon(Icons.lock),
          ],
        ),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 32.0,
          ),
          constraints: const BoxConstraints(maxWidth: 640),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const PasswordField(),
              const SizedBox(height: 8),
              Card(
                child: Column(
                  children: [
                    LayoutBuilder(builder: (_, constraints) {
                      return constraints.maxWidth > 500
                          ? ListTileForPc(
                              minValue: context.read<PasswordModel>().minLength,
                              maxValue: context.read<PasswordModel>().maxLength,
                            )
                          : ListTileForMobile(
                              minValue: context.read<PasswordModel>().minLength,
                              maxValue: context.read<PasswordModel>().maxLength,
                            );
                    }),
                    const SwitchWithLabel(
                      title: '大文字',
                      type: IncludeCharType.capital,
                    ),
                    const SwitchWithLabel(
                      title: '数字',
                      type: IncludeCharType.number,
                    ),
                    const SwitchWithLabel(
                      title: '記号',
                      type: IncludeCharType.symbol,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const RenewButton(),
            ],
          ),
        ),
      ),
      floatingActionButton: const CopyButton(),
    );
  }
}
