import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:password_generator/password_model.dart';
import 'package:provider/provider.dart';

import 'my_home_page.dart';

void main() {
  usePathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Password Generator',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: ChangeNotifierProvider(
        create: (_) => PasswordModel(),
        child: const MyHomePage(),
      ),
    );
  }
}
