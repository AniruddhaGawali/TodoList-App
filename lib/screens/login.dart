import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//import package files
import 'package:http/http.dart' as http;

//provider
import 'package:todolist/provider/user_data_provider.dart';

//import screens
import 'package:todolist/screens/home.dart';

@immutable
class Login extends ConsumerStatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  LoginState createState() => LoginState();
}

class LoginState extends ConsumerState<Login> {
  final _loginFormKey = GlobalKey<FormState>();
  static dynamic _loginId;
  static dynamic _loginPassword;

  bool _isLoading = false;

  void _login(context, WidgetRef ref) async {
    if (_loginFormKey.currentState!.validate()) {
      _loginFormKey.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      http.Response result = await http.post(
          Uri.parse('https://intelligent-gold-production.up.railway.app/login'),
          body: {
            'userID': _loginId,
            'password': _loginPassword,
          });

      Map<String, dynamic> response = jsonDecode(result.body);

      if (response['isSuccess'] == true) {
        ref.read(userProvider.notifier).login(
              response['name'],
              response['isSuccess'],
              response['userType'],
            );

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome Back",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                ),
                const SizedBox(height: 20),
                Form(
                    key: _loginFormKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "ID",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your ID";
                            }
                            return null;
                          },
                          onSaved: (newValue) => _loginId = newValue!,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Password",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your ID";
                            }
                            return null;
                          },
                          onSaved: (newValue) => _loginPassword = newValue!,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _login(context, ref);
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Theme.of(context).colorScheme.primary),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    "Login",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                            fontSize: 15),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ))
              ]),
        ),
      ),
    );
  }
}
