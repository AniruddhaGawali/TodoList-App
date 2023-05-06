import 'package:flutter/material.dart';
import 'dart:convert';

//package files
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:todolist/Screens/login.dart';
import 'package:todolist/model/user.dart';
import 'package:todolist/model/todo.dart';

//provider
import 'package:todolist/provider/user_data_provider.dart';
import 'package:todolist/provider/todo_provider.dart';
import 'package:todolist/screens/settings.dart';
import 'package:todolist/widgits/todolist.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _getTasks(User user, WidgetRef ref) async {
    late http.Response response;
    if (user.usertype.length <= 1) {
      response = await http.get(
        Uri.parse(
            'https://intelligent-gold-production.up.railway.app/get_todos?owner=${user.usertype[0]}'),
      );
    } else {
      response = await http.get(
        Uri.parse(
            'https://intelligent-gold-production.up.railway.app/get_todos?owner=${user.usertype}'),
      );
    }

    Map<String, dynamic> data = jsonDecode(response.body);
    ref.read(todoProvider.notifier).addAllTask(data['data']);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    _getTasks(user, ref);
    final List<Todo> todos = ref.watch(todoProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TODO LIST',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
        actions: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(.1),
              borderRadius: BorderRadius.circular(100),
            ),
            child: IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Under Development'),
                  ),
                );
              },
              icon: Icon(
                Icons.notifications,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(.1),
              borderRadius: BorderRadius.circular(100),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SettingScreen(),
                  ),
                );
              },
              icon: Icon(
                Icons.settings,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(child: TodoList(todo: todos)),
    );
  }
}
