import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/model/todo.dart';

class FilterNotifier extends StateNotifier<List<TodoStatus>> {
  FilterNotifier() : super([]);

  void toggleFilter(TodoStatus status) {
    if (!state.contains(status)) {
      state = [...state, status];
    } else {
      state = state.where((element) => element != status).toList();
    }
  }

  bool doesItContain(TodoStatus status) {
    return state.contains(status);
  }

  void clear() {
    state = [];
  }

  List<Todo> getFilteredTodos(List<Todo> todos) {
    if (state.isEmpty) {
      return todos;
    } else {
      return todos.where((todo) => state.contains(todo.status)).toList();
    }
  }
}

final filterProvider = StateNotifierProvider<FilterNotifier, List<TodoStatus>>(
  (ref) => FilterNotifier(),
);
