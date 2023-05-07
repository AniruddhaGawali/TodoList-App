import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:todolist/model/todo.dart';
import 'package:todolist/provider/fliter_provider.dart';

class FilterButtons extends ConsumerWidget {
  const FilterButtons({super.key});

  String _getCapitalizedText(String text) {
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<TodoStatus> filter = ref.watch(filterProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ...TodoStatus.values.map((status) {
          return OutlinedButton(
              style: ButtonStyle(
                overlayColor:
                    MaterialStatePropertyAll(getColor(status).withOpacity(.3)),
                side: MaterialStatePropertyAll(
                    BorderSide(color: getColor(status))),
                backgroundColor: MaterialStatePropertyAll(
                  filter.contains(status)
                      ? getColor(status).withOpacity(.3)
                      : Colors.transparent,
                ),
                foregroundColor: MaterialStatePropertyAll(getColor(status)),
              ),
              onPressed: () =>
                  ref.read(filterProvider.notifier).toggleFilter(status),
              child: Text(
                _getCapitalizedText(status.name),
              ));
        }).toList()
      ],
    );
  }
}
