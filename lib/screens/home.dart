import 'package:flutter/material.dart';
import 'dart:convert';

//package files
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:todolist/model/user.dart';
import 'package:todolist/model/todo.dart';

//provider
import 'package:todolist/provider/user_data_provider.dart';
import 'package:todolist/provider/todo_provider.dart';
import 'package:todolist/screens/settings.dart';
import 'package:todolist/widgits/todolist.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final List<TodoStatus> filter = [];

  String _getCapitalizedText(String text) {
    return text[0].toUpperCase() + text.substring(1);
  }

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

  List<Todo> get getFilteredTodo {
    final List<Todo> todos = ref.watch(todoProvider);
    if (filter.isEmpty) {
      return todos;
    } else {
      return todos
          .map((e) => filter.contains(e.status) ? e : null)
          .where((element) => element != null)
          .map((e) => e!)
          .toList();
    }
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
      body: SingleChildScrollView(
          child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ...TodoStatus.values.map((status) {
                return OutlinedButton(
                    style: ButtonStyle(
                      overlayColor: MaterialStatePropertyAll(
                          getColor(status).withOpacity(.3)),
                      side: MaterialStatePropertyAll(
                          BorderSide(color: getColor(status))),
                      backgroundColor: MaterialStatePropertyAll(
                        filter.contains(status)
                            ? getColor(status).withOpacity(.3)
                            : Colors.transparent,
                      ),
                      foregroundColor:
                          MaterialStatePropertyAll(getColor(status)),
                    ),
                    onPressed: () {
                      setState(() {
                        if (filter.contains(status)) {
                          filter.remove(status);
                        } else {
                          filter.add(status);
                        }
                      });
                    },
                    child: Text(
                      _getCapitalizedText(status.name),
                    ));
              }).toList()
            ],
          ),
          TodoList(todos: getFilteredTodo),
        ],
      )),
    );
  }
}
