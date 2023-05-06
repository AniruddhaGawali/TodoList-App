import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/provider/user_data_provider.dart';
import 'package:todolist/screens/login.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                ref.read(userProvider.notifier).logout();
                Navigator.of(context).pop;
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const Login(),
                ));
              },
              child: const Text("Logout"),
            ),
          )
        ]),
      ),
    );
  }
}
