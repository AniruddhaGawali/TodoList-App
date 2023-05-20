import 'package:flutter/material.dart';
import 'dart:convert';

//import package files
import 'package:http/http.dart' as http;

enum TodoStatus { open, working, done, archive, overdue, delete }

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
  } else if (statusg == 'ARCHIVE') {
    return TodoStatus.archive;
  } else {
    return TodoStatus.open;
  }
}

Color getColor(TodoStatus status) {
  switch (status) {
    case TodoStatus.open:
      return Colors.blueAccent;
    case TodoStatus.working:
      return Colors.orangeAccent;
    case TodoStatus.done:
      return Colors.greenAccent;
    case TodoStatus.overdue:
      return Colors.redAccent;
    case TodoStatus.archive:
      return Colors.white;
    default:
      return Colors.white;
  }
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
      case TodoStatus.archive:
        return Colors.deepOrangeAccent;
      default:
        return Colors.blueAccent;
    }
  }

  TodoStatus get getPreviousStatusName {
    switch (status) {
      case TodoStatus.open:
        return TodoStatus.open;
      case TodoStatus.working:
        return TodoStatus.open;
      case TodoStatus.done:
        return TodoStatus.working;
      case TodoStatus.overdue:
        return TodoStatus.open;
      case TodoStatus.archive:
        return TodoStatus.done;
      default:
        return TodoStatus.open;
    }
  }

  TodoStatus get getNextStatusName {
    switch (status) {
      case TodoStatus.open:
        return TodoStatus.working;
      case TodoStatus.working:
        return TodoStatus.done;
      case TodoStatus.done:
        return TodoStatus.archive;
      case TodoStatus.overdue:
        return TodoStatus.done;
      case TodoStatus.archive:
        return TodoStatus.delete;
      default:
        return TodoStatus.open;
    }
  }

  String get getNextStatus {
    switch (status) {
      case TodoStatus.open:
        return "Working on it";
      case TodoStatus.working:
        return "Done";
      case TodoStatus.done:
        return "Archive";
      case TodoStatus.overdue:
        return "Done";
      case TodoStatus.archive:
        return "Delete";
      case TodoStatus.delete:
        return "Delete";
    }
  }

  Color get getNextStatusColor {
    switch (status) {
      case TodoStatus.open:
        return Colors.orangeAccent;
      case TodoStatus.working:
        return Colors.greenAccent;
      case TodoStatus.done:
        return Colors.deepOrangeAccent;
      case TodoStatus.overdue:
        return Colors.greenAccent;
      case TodoStatus.archive:
        return Colors.redAccent;
      default:
        return Colors.white;
    }
  }

  IconData get getNextStatusIcon {
    switch (status) {
      case TodoStatus.open:
        return Icons.work_history;
      case TodoStatus.working:
        return Icons.done;
      case TodoStatus.done:
        return Icons.archive;
      case TodoStatus.overdue:
        return Icons.done;
      case TodoStatus.archive:
        return Icons.delete;
      default:
        return Icons.delete;
    }
  }

  Future<bool> delete() async {
    Map submitData = {
      '_id': id,
    };

    http.Response response = await http.delete(
      Uri.parse(
          'https://intelligent-gold-production.up.railway.app/delete_todo'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(submitData),
    );

    Map<String, dynamic> result = jsonDecode(response.body);

    if (result['isSuccess'] == true) {
      return true;
    }
    return false;
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
