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
        child: ref
                .read(filterProvider.notifier)
                .getFilteredTodos(ref.watch(todoProvider))
                .isNotEmpty
            ? Column(
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
              )
            : Center(
                child: Column(children: [
                  Image.network(
                      "https://img.freepik.com/free-vector/relaxing-home-concept-illustration_114360-1128.jpg?w=1480&t=st=1683480421~exp=1683481021~hmac=dc5360c1d18af237acf74b1086762e0f57c19a0c93161adf51597426d4e2c441"),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'No Tasks Take a Break',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ]),
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
