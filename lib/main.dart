import 'package:flutter/material.dart';

//package files
import 'package:flutter_riverpod/flutter_riverpod.dart';

//screens
import 'package:todolist/screens/login.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final theme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: const Color(0xFF2066CC),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: const Login(),
    );
  }
}
