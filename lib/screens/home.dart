import 'package:flutter/material.dart';
import 'dart:convert';

//package files
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:todolist/model/user.dart';
import 'package:todolist/provider/fliter_provider.dart';

//provider
import 'package:todolist/provider/user_data_provider.dart';
import 'package:todolist/provider/todo_provider.dart';
import 'package:todolist/widgits/custom_drawer.dart';
import 'package:todolist/widgits/filters_buttons.dart';
import 'package:todolist/widgits/todolist.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
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
  void dispose() {
    super.dispose();
    ref.read(todoProvider.notifier).clear();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    _getTasks(user, ref);

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
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const FilterButtons(),
            TodoList(
                todos: ref
                    .read(filterProvider.notifier)
                    .getFilteredTodos(ref.watch(todoProvider))),
          ],
        ),
      ),
      floatingActionButton: ref.read(userProvider).isSuperUser
          ? FloatingActionButton(
              onPressed: () {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Under Development'),
                  ),
                );
              },
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              disabledElevation: 0,
              child: Icon(
                Icons.add,
                size: 35,
                color: Theme.of(context).colorScheme.primary,
              ),
            )
          : null,
      drawer: const CustomDrawer(),
    );
  }
}
