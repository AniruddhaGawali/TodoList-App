import 'package:flutter/material.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:todolist/model/todo.dart';

import 'package:intl/intl.dart';
import 'package:todolist/widgits/tabletcontainer.dart';

class TodoModel extends StatefulWidget {
  final Todo todo;
  const TodoModel({super.key, required this.todo});

  @override
  TodoModelState createState() => TodoModelState();
}

class TodoModelState extends State<TodoModel> {
  late final ScaffoldMessengerState _scaffoldMessenger;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scaffoldMessenger = ScaffoldMessenger.of(context);
  }

  String _getCapitalizedText(String text) {
    return text[0].toUpperCase() + text.substring(1);
  }

  void _changeStatus(TodoStatus status) async {
    bool isSumbit = await widget.todo.setNewStatus(status);
    if (isSumbit) {
      _scaffoldMessenger.clearSnackBars();
      _scaffoldMessenger.showSnackBar(
        SnackBar(
          content:
              Text('Status Changed to ${_getCapitalizedText(status.name)}'),
        ),
      );
    } else {
      _scaffoldMessenger.clearSnackBars();
      _scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Status Not Changed')),
      );
    }
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
              widget.todo.text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Due Date: ${DateFormat("yyyy-MM-dd HH:mm:ss").format(widget.todo.formatDueDate)}",
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
                  color: widget.todo.getColor,
                  textColor: widget.todo.getColor.withOpacity(.8),
                  text: _getCapitalizedText(
                    widget.todo.status.name,
                  )),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            widget.todo.desc,
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
                  'Owner: ${widget.todo.owner[0]}',
                ),
              ),
              const SizedBox(width: 5),
              TabletContainer(
                textColor: Theme.of(context).colorScheme.primary,
                text: _getCapitalizedText(
                  'By: ${widget.todo.name}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TabletContainer(
            textColor: Theme.of(context).colorScheme.primary,
            text: _getCapitalizedText(
              'Send to: ${widget.todo.sendTo}',
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                widget.todo.status != TodoStatus.open
                    ? SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _changeStatus(widget.todo.getPreviousStatusName);
                          },
                          child: const Text("Go to Last Status"),
                        ),
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: 5,
                ),
                SlideAction(
                  innerColor: Theme.of(context).colorScheme.onPrimary,
                  outerColor: widget.todo.getNextStatusColor.withOpacity(.7),
                  text: widget.todo.getNextStatus,
                  elevation: 0,
                  sliderButtonIcon: Icon(
                    widget.todo.getNextStatusIcon,
                    color: widget.todo.getNextStatusColor.withOpacity(.7),
                  ),
                  sliderRotate: false,
                  onSubmit: () {
                    Navigator.pop(context);
                    _changeStatus(widget.todo.getNextStatusName);
                  },
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
