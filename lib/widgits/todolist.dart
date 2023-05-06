import 'package:flutter/material.dart';

import 'package:todolist/model/todo.dart';
import 'package:todolist/widgits/todocard.dart';

class TodoList extends StatelessWidget {
  final List<Todo> todo;
  const TodoList({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        ...todo.map((todo) {
          return TodoCard(todo: todo);
        }).toList()
      ],
    );
  }
}
