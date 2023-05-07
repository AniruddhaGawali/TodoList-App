import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/model/user.dart';
import 'package:todolist/provider/fliter_provider.dart';

//package files
import 'package:todolist/provider/user_data_provider.dart';

//screens
import 'package:todolist/screens/login.dart';
import 'package:todolist/screens/role_task.dart';

// SizedBox(
//                 width: double.infinity,
//                 child: DrawerHeader(
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                         image: const NetworkImage(
//                           "https://images.unsplash.com/photo-1530569673472-307dc017a82d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=988&q=80",
//                         ),
//                         fit: BoxFit.cover,
//                         colorFilter: ColorFilter.mode(
//                             Theme.of(context)
//                                 .colorScheme
//                                 .primary
//                                 .withOpacity(.3),
//                             BlendMode.darken)),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Todo List',
//                         style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                               color: Theme.of(context).colorScheme.onPrimary,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 40,
//                             ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

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
      child: Column(
        children: [
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  'Todo List',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      ),
                ),
              ),
              const Divider(
                color: Colors.black,
                thickness: 1,
              ),
              ListTile(
                leading: Icon(
                  Icons.person,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                title: Text(
                  'Your Tasks',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(fontSize: 18),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
                    return RoleTaskScreen(
                        role: ref.read(userProvider).username);
                  }));
                },
              ),
              ref.read(userProvider).isSuperUser
                  ? Column(
                      children: [
                        ...UserType.values.map((usertype) {
                          return ListTile(
                            leading: Icon(
                              _getIcon(usertype),
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            ),
                            title: Text(
                              _getCapterlised(usertype.name.toString()),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(fontSize: 18),
                            ),
                            onTap: () {
                              ref.read(filterProvider.notifier).clear();
                              Navigator.of(context).pop();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return RoleTaskScreen(
                                    role: usertype.name.toUpperCase());
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
                            leading: Icon(
                              _getIcon(usertype),
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            ),
                            title: Text(
                              _getCapterlised(usertype.name.toString()),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(fontSize: 18),
                            ),
                            onTap: () async {
                              ref.read(filterProvider.notifier).clear();
                              Navigator.of(context).pop();
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return RoleTaskScreen(
                                      role: usertype.name.toUpperCase());
                                }),
                              );
                            },
                          );
                        }).toList()
                      ],
                    ),
              ListTile(
                leading: Icon(
                  Icons.settings,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                title: Text(
                  'Settings',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(fontSize: 18),
                ),
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
            ]),
          ),
          const Divider(
            color: Colors.black,
            thickness: 1,
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              ref.read(userProvider.notifier).logout();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) => const LoginScreen(),
                ),
              );
            },
            leading: Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.error,
            ),
            title: Text(
              'Logout',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ),
          const SizedBox(height: 10)
        ],
      ),
    );
  }
}
