import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:todolist/model/todo.dart';

import 'package:todolist/widgits/tabletcontainer.dart';
import 'package:todolist/widgits/todo_model.dart';

class TodoCard extends StatelessWidget {
  final Todo todo;

  const TodoCard({
    super.key,
    required this.todo,
  });

  String _getCapitalizedText(String text) {
    return text[0].toUpperCase() + text.substring(1);
  }

  void _openTodoDetails(context, Todo todo) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bctx) {
        return TodoModel(
          todo: todo,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _openTodoDetails(context, todo);
      },
      child: Card(
        color: todo.getColor.withOpacity(.6),
        child: ListTile(
          title: Text(
            _getCapitalizedText(todo.text),
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color:
                      Theme.of(context).colorScheme.onPrimary.withOpacity(.9),
                  fontWeight: FontWeight.bold,
                ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Due Date: ${DateFormat("yyyy-MM-dd HH:mm:ss").format(todo.formatDueDate)}',
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimary
                          .withOpacity(.9),
                    ),
              ),
              const SizedBox(height: 15),
              TabletContainer(
                text: 'Owner: ${todo.owner[0]}',
              ),
            ],
          ),
          trailing: TabletContainer(
            text: _getCapitalizedText(todo.status.name),
          ),
        ),
      ),
    );
  }
}
