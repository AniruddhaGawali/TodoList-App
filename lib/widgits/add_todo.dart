import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:http/http.dart' as http;
import 'package:todolist/model/user.dart';
import 'package:todolist/provider/user_data_provider.dart';

class AddTodo extends ConsumerStatefulWidget {
  const AddTodo({Key? key}) : super(key: key);

  @override
  ConsumerState<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends ConsumerState<AddTodo> {
  void _addTodo(
    String title,
    String desc,
    DateTime dueDate,
    String sendTo,
  ) async {
    final Map<String, dynamic> requestBody = {
      "text": title,
      "desc": desc,
      "dueDate": DateFormat("yyyy-MM-dd'T'HH:mm").format(dueDate),
      "sendTo": sendTo,
      "owner": ref.read(userProvider).usertype,
      "name": ref.read(userProvider).username,
      "status": "OPEN",
      "tag": [],
    };

    http.Response response = await http.post(
      Uri.parse('https://intelligent-gold-production.up.railway.app/add_todo'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    Map<String, dynamic> result = jsonDecode(response.body);
    if (result["isSuccess"]) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Todo Added"),
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to Add Todo"),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
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
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
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
                Text(
                  "Add Todo",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 20),
                AddTodoForm(
                  addTodo: _addTodo,
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}

class AddTodoForm extends StatefulWidget {
  Function addTodo;
  AddTodoForm({Key? key, required this.addTodo}) : super(key: key);

  @override
  AddTodoFormState createState() => AddTodoFormState();
}

class AddTodoFormState extends State<AddTodoForm> {
  final _formKey = GlobalKey<FormState>();
  List<dynamic> _mentionUsers = [];
  List<String> _userList = [];

  UserType _selectedPost = UserType.frontend;
  String? _todoText;
  String? _selectedUser = '';
  DateTime? _dueDate;
  String? _todoDesc;

  @override
  void initState() {
    super.initState();
  }

  void dueDate(DateTime? value) {
    _dueDate = value;
  }

  IconData _getIcon(UserType userType) {
    switch (userType) {
      case UserType.backend:
        return Icons.cloud_upload;
      case UserType.frontend:
        return Icons.computer;
      case UserType.designer:
        return Icons.design_services;
      case UserType.tester:
        return Icons.bug_report;
    }
  }

  get mention async {
    http.Response response = await http.get(Uri.parse(
        'https://intelligent-gold-production.up.railway.app/mentions'));

    Map<String, dynamic> data = jsonDecode(response.body);

    List<dynamic> filterData = data['post'].map((e) {
      UserType post = UserType.frontend;

      for (var element in UserType.values) {
        if (element.name.toString().toUpperCase() == e['post']) {
          post = element;
        }
      }

      return {"nickName": e['nickName'], "value": post};
    }).toList();

    return filterData;
  }

  set user(_) {
    List<dynamic> users = _mentionUsers
        .where((element) => _selectedPost == element['value'])
        .toList();

    setState(() {
      _userList = users.map((e) => e['nickName'].toString()).toList();
    });
  }

  void _getMentions() async {
    var temp = await mention;
    setState(() {
      _mentionUsers = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    _getMentions();

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.check_box),
              hintText: 'Enter your Todo',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please Enter Todo';
              }
              return null;
            },
            autofocus: true, // Set autofocus to true
            onSaved: (value) {
              _todoText = value;
            },
          ),
          const SizedBox(height: 20),
          DateAndTimePicker(
            todeDate: dueDate,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                  child: DropdownButtonFormField(
                decoration:
                    InputDecoration(icon: Icon(_getIcon(_selectedPost))),
                value: _selectedPost,
                items: UserType.values
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.name.toString().toUpperCase()),
                        ))
                    .toList(),
                hint: const Text("Select Post"),
                icon: const Icon(Icons.arrow_drop_down),
                validator: (value) {
                  if (value == null) {
                    return 'Please Select Post';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _selectedPost = value as UserType;
                    _userList = [];
                  });
                  user = _selectedPost;
                },
              )),
              const SizedBox(width: 20),
              _userList.isNotEmpty
                  ? Expanded(
                      child: DropdownButtonFormField(
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person),
                        ),
                        items: _userList
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                        hint: const Text("Select User"),
                        icon: const Icon(Icons.arrow_drop_down),
                        onChanged: (value) {
                          _selectedUser = value as String;
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please Select Post';
                          }
                          return null;
                        },
                        onSaved: (newValue) => _selectedUser = newValue!,
                      ),
                    )
                  : const SizedBox()
            ],
          ),
          const SizedBox(height: 20),
          TextFormField(
            maxLines: 3,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please Enter Description';
              }
              return null;
            },
            decoration: const InputDecoration(
              hintText: "Description",
              icon: Icon(Icons.text_fields),
              border: OutlineInputBorder(),
            ),
            onSaved: (value) {
              _todoDesc = value;
            },
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        widget.addTodo(
                          _todoText,
                          _todoDesc,
                          _dueDate,
                          "$_selectedUser (${_selectedPost.name.toString().toUpperCase()})",
                        );
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.add_circle_rounded),
                        SizedBox(width: 20),
                        Text(
                          'Add Todo',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: OutlinedButton(
                    style: ButtonStyle(
                      side: MaterialStateProperty.all(
                        const BorderSide(color: Colors.red),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                        )),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DateAndTimePicker extends StatefulWidget {
  final Function todeDate;
  const DateAndTimePicker({Key? key, required this.todeDate}) : super(key: key);

  @override
  State<DateAndTimePicker> createState() => _DateAndTimePickerState();
}

class _DateAndTimePickerState extends State<DateAndTimePicker> {
  final format = DateFormat("dd-MMMM-yyyy HH:mm");

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: [
            const Icon(Icons.today_rounded),
            const SizedBox(width: 10),
            Expanded(
              child: DateTimeField(
                validator: (value) {
                  if (value == null) {
                    return 'Please Enter Date';
                  }
                  return null;
                },
                format: format,
                onShowPicker: (context, currentValue) async {
                  return await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(2100),
                  ).then((DateTime? date) async {
                    if (date != null) {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(
                          currentValue ?? DateTime.now(),
                        ),
                      );
                      return DateTimeField.combine(date, time);
                    } else {
                      return currentValue;
                    }
                  });
                },
                onSaved: (value) {
                  widget.todeDate(value);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
