import 'package:flutter/material.dart';
import 'dart:convert';

//import package files
import 'package:http/http.dart' as http;

enum TodoStatus { open, working, done, overdue }

TodoStatus setStatus(String statusg, String dueDate) {
  DateTime dartDateTime = DateTime.parse(dueDate);
  DateTime now = DateTime.now();
  if (dartDateTime.isBefore(now) &&
      (statusg == "OPEN" || statusg == "WORKING")) {
    return TodoStatus.overdue;
  } else if (statusg == "OPEN") {
    return TodoStatus.open;
  } else if (statusg == "WORKING") {
    return TodoStatus.working;
  } else if (statusg == "DONE") {
    return TodoStatus.done;
  }
  return TodoStatus.open;
}

class Todo {
  String id;
  String text;
  String desc;
  String dueDate;
  String sendTo;
  List owner;
  String name;
  TodoStatus status;
  List tag;

  Todo({
    required this.id,
    required this.text,
    required this.desc,
    required this.dueDate,
    required this.sendTo,
    required this.owner,
    required this.name,
    required this.status,
    required this.tag,
  });

  DateTime get formatDueDate {
    return DateTime.parse(dueDate);
  }

  Color get getColor {
    switch (status) {
      case TodoStatus.open:
        return Colors.blueAccent;
      case TodoStatus.working:
        return Colors.orangeAccent;
      case TodoStatus.done:
        return Colors.greenAccent;
      case TodoStatus.overdue:
        return Colors.redAccent;
    }
  }

  TodoStatus get getNextStatusName {
    switch (status) {
      case TodoStatus.open:
        return TodoStatus.working;
      case TodoStatus.working:
        return TodoStatus.done;
      case TodoStatus.done:
        return TodoStatus.done;
      case TodoStatus.overdue:
        return TodoStatus.done;
    }
  }

  String get getNextStatus {
    switch (status) {
      case TodoStatus.open:
        return "Working on it";
      case TodoStatus.working:
        return "Done";
      case TodoStatus.done:
        return "Delete";
      case TodoStatus.overdue:
        return "Done";
    }
  }

  Color get getNextStatusColor {
    switch (status) {
      case TodoStatus.open:
        return Colors.orangeAccent;
      case TodoStatus.working:
        return Colors.greenAccent;
      case TodoStatus.done:
        return Colors.redAccent;
      case TodoStatus.overdue:
        return Colors.greenAccent;
    }
  }

  IconData get getNextStatusIcon {
    switch (status) {
      case TodoStatus.open:
        return Icons.work_history;
      case TodoStatus.working:
        return Icons.done;
      case TodoStatus.done:
        return Icons.delete_sharp;
      case TodoStatus.overdue:
        return Icons.done;
    }
  }

  Future<bool> setNewStatus(TodoStatus status) async {
    this.status = status;

    Map submitData = {
      '_id': id,
      'status': status.name.toUpperCase(),
    };

    http.Response response = await http.post(
        Uri.parse(
            'https://intelligent-gold-production.up.railway.app/change_todo'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(submitData));

    Map<String, dynamic> result = jsonDecode(response.body);

    if (result['isSuccess'] == true) {
      return true;
    }

    return false;
  }
}
