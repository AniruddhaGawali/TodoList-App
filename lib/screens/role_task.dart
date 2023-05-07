import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/model/todo.dart';
import 'package:todolist/model/user.dart';

import 'package:todolist/widgits/filters_buttons.dart';
import 'package:todolist/widgits/todolist.dart';

import 'package:todolist/provider/fliter_provider.dart';
import 'package:todolist/provider/todo_provider.dart';

class RoleTaskScreen extends ConsumerWidget {
  final UserType role;
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
          (element) => element.sendTo.contains(role.name.toUpperCase()),
        )
        .toList());

    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(_getCapterlised(role.name)),
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
                      .getFilteredTodos(todos)),
            ],
          ),
        ),
      ),
      onWillPop: () async {
        ref.read(filterProvider.notifier).clear();
        Navigator.of(context).pop();
        return false;
      },
    );
  }
}
