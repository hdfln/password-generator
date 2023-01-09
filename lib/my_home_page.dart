import 'package:flutter/material.dart';
import 'package:password_generator/copy_button.dart';
import 'package:provider/provider.dart';

import 'animated_renew_button.dart';
import 'list_tile_for_mobile.dart';
import 'list_tile_for_pc.dart';
import 'password_field.dart';
import 'password_model.dart';
import 'switch_with_label.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PasswordModel(),
      child: Scaffold(
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
                  child: LayoutBuilder(builder: (context, constraints) {
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
                const Divider(height: 64),
                IntrinsicHeight(
                  child: Row(
                    children: const [
                      Expanded(child: PasswordField()),
                      AnimatedRenewButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: const CopyButton(),
      ),
    );
  }
}
