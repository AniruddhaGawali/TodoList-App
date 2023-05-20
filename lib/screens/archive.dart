import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/model/todo.dart';
import 'package:todolist/provider/todo_provider.dart';
import 'package:todolist/widgits/todocard.dart';

class ArchiveScreen extends ConsumerWidget {
  const ArchiveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Todo> archiveTodos = ref
        .watch(todoProvider)
        .where((element) => element.status == TodoStatus.archive)
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Archive'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ...archiveTodos.map((todo) {
              return TodoCard(todo: todo);
            }).toList()
          ],
        ),
      ),
    );
  }
}
