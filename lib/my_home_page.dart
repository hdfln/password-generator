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
    return ChangeNotifierProvider(
      create: (_) => PasswordModel(),
      child: Scaffold(
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
                Card(
                  child: LayoutBuilder(builder: (_, constraints) {
                    return constraints.maxWidth > 500
                        ? const ListTileForPc()
                        : const ListTileForMobile();
                  }),
                ),
                const SwitchWithLabel(
                  title: '数字',
                  type: IncludeCharType.number,
                ),
                const SwitchWithLabel(
                  title: '記号',
                  type: IncludeCharType.symbol,
                ),
                const SizedBox(height: 4),
                const RenewButton(),
                const Divider(height: 64),
                const PasswordField(),
              ],
            ),
          ),
        ),
        floatingActionButton: const CopyButton(),
      ),
    );
  }
}
