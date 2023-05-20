import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/model/todo.dart';

import 'package:todolist/widgits/filters_buttons.dart';
import 'package:todolist/widgits/todolist.dart';

import 'package:todolist/provider/fliter_provider.dart';
import 'package:todolist/provider/todo_provider.dart';

class RoleTaskScreen extends ConsumerWidget {
  final String role;
  const RoleTaskScreen({
    super.key,
    required this.role,
  });

  String _getCapterlised(String string) {
    string = string.toLowerCase();
    string = string[0].toUpperCase() + string.substring(1);
    return string;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Todo> todos = ref.watch(filterProvider.notifier).getFilteredTodos(ref
        .watch(todoProvider)
        .where(
          (element) => element.sendTo.contains(role),
        )
        .toList());

    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(_getCapterlised(role)),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const FilterButtons(),
            todos.isNotEmpty
                ? TodoList(
                    todos: ref
                        .read(filterProvider.notifier)
                        .getFilteredTodos(todos))
                : Center(
                    child: Column(children: [
                      Image.network(
                          "https://img.freepik.com/free-vector/relaxing-home-concept-illustration_114360-1128.jpg?w=1480&t=st=1683480421~exp=1683481021~hmac=dc5360c1d18af237acf74b1086762e0f57c19a0c93161adf51597426d4e2c441"),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'No Tasks Here',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ]),
                  ),
          ],
        )),
      ),
      onWillPop: () async {
        ref.read(filterProvider.notifier).clear();
        Navigator.of(context).pop();
        return false;
      },
    );
  }
}
