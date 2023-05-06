import 'package:flutter/material.dart';

import 'package:todolist/model/todo.dart';
import 'package:todolist/widgits/todocard.dart';

class TodoList extends StatelessWidget {
  final List<Todo> todos;
  const TodoList({super.key, required this.todos});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const SizedBox(height: 30),
          ...todos.map((todo) {
            return TodoCard(todo: todo);
          }).toList()
        ],
      ),
    );
  }
}
