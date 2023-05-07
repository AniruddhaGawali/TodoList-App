import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/model/user.dart';
import 'package:todolist/provider/fliter_provider.dart';

//package files
import 'package:todolist/provider/user_data_provider.dart';

//screens
import 'package:todolist/screens/login.dart';
import 'package:todolist/screens/role_task.dart';

class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({super.key});

  String _getCapterlised(String string) {
    string = string.toLowerCase();
    string = string[0].toUpperCase() + string.substring(1);
    return string;
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
        child: ListView(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(.8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Todo List',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                    ),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ref.read(userProvider.notifier).logout();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (BuildContext context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: SizedBox(
                    child: Row(
                      children: [
                        Icon(
                          Icons.logout,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Logout',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        ),
        ref.read(userProvider).isSuperUser
            ? Column(
                children: [
                  ...UserType.values.map((usertype) {
                    return ListTile(
                      leading: Icon(_getIcon(usertype)),
                      title: Text(_getCapterlised(usertype.name.toString())),
                      onTap: () {
                        ref.read(filterProvider.notifier).clear();
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return RoleTaskScreen(role: usertype);
                        }));
                      },
                    );
                  }).toList()
                ],
              )
            : Column(
                children: [
                  ...ref.read(userProvider).userTypeList.map((usertype) {
                    return ListTile(
                      leading: Icon(_getIcon(usertype)),
                      title: Text(_getCapterlised(usertype.name.toString())),
                      onTap: () async {
                        ref.read(filterProvider.notifier).clear();
                        Navigator.of(context).pop();
                        await Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                            return RoleTaskScreen(role: usertype);
                          }),
                        );
                      },
                    );
                  }).toList()
                ],
              ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Settings'),
          onTap: () {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Under Development"),
              ),
            );
          },
        ),
      ],
    ));
  }
}
