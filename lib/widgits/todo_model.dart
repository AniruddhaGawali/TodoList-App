import 'package:flutter/material.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:todolist/model/todo.dart';

import 'package:intl/intl.dart';
import 'package:todolist/widgits/tabletcontainer.dart';

class TodoModel extends StatelessWidget {
  final Todo todo;
  const TodoModel({super.key, required this.todo});

  String _getCapitalizedText(String text) {
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: Container(
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Theme.of(context).colorScheme.secondary,
              ),
              margin: const EdgeInsets.only(bottom: 30, top: 10),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Text(
              todo.text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Due Date: ${DateFormat("yyyy-MM-dd HH:mm:ss").format(todo.formatDueDate)}",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 20,
                ),
          ),
          Row(
            children: [
              Text(
                'Status: ',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              TabletContainer(
                  color: todo.getColor,
                  textColor: todo.getColor.withOpacity(.8),
                  text: _getCapitalizedText(
                    todo.status.name,
                  )),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            todo.desc,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 15,
                ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              TabletContainer(
                textColor: Theme.of(context).colorScheme.primary,
                text: _getCapitalizedText(
                  'Owner: ${todo.owner[0]}',
                ),
              ),
              const SizedBox(width: 5),
              TabletContainer(
                textColor: Theme.of(context).colorScheme.primary,
                text: _getCapitalizedText(
                  'By: ${todo.name}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TabletContainer(
            textColor: Theme.of(context).colorScheme.primary,
            text: _getCapitalizedText(
              'Send to: ${todo.sendTo}',
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: SlideAction(
              innerColor: Theme.of(context).colorScheme.onPrimary,
              outerColor: todo.getNextStatusColor.withOpacity(.7),
              text: todo.getNextStatus,
              elevation: 0,
              sliderButtonIcon: Icon(
                todo.getNextStatusIcon,
                color: todo.getNextStatusColor.withOpacity(.7),
              ),
              sliderRotate: false,
              onSubmit: () async {
                bool isSumbit = await todo.setNewStatus(todo.getNextStatusName);
                if (isSumbit) {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Status Changed to ${_getCapitalizedText(todo.getNextStatusName.name)}')),
                  );
                } else {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Status Not Changed')),
                  );
                }
                Navigator.pop(context);
              },
            ),
          )
        ]),
      ),
    );
  }
}
