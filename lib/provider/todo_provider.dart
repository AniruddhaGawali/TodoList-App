import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/model/todo.dart';

class TodoNotifier extends StateNotifier<List<Todo>> {
  TodoNotifier() : super([]);

  void addAllTask(List<dynamic> todos) {
    state = todos
        .map((e) {
          return Todo(
            id: e['_id'],
            text: e['text'],
            desc: e['desc'],
            dueDate: e['dueDate'],
            sendTo: e['sendTo'],
            owner: e['owner'],
            name: e['name'],
            status: setStatus(e['status'], e['dueDate']),
            tag: e['tag'],
          );
        })
        .toList()
        .reversed
        .toList();
  }

  void addTask(Todo todo) {
    state = [...state, todo];
  }

  void clear() {
    state = [];
  }
}

final todoProvider = StateNotifierProvider<TodoNotifier, List<Todo>>(
  (ref) => TodoNotifier(),
);
