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
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginState createState() => LoginState();
}

class LoginState extends ConsumerState<LoginScreen> {
  final _loginFormKey = GlobalKey<FormState>();
  static dynamic _loginId;
  static dynamic _loginPassword;
  bool _isLoading = false;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _autoLogin(context);
  }

  void _checkLogin() {
    if (_loginFormKey.currentState!.validate()) {
      _loginFormKey.currentState!.save();
      _login(context);
    }
  }

  void _login(context) async {
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
            _loginId,
            _loginPassword,
            response['isSuccess'],
            response['userType'],
          );

      if (_rememberMe) {
        ref.read(userProvider.notifier).saveUser();
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => const HomeScreen(),
        ),
      );
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Login Failed Wrong ID or Password"),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  void _autoLogin(context) async {
    if (await ref.read(userProvider.notifier).loadUser()) {
      setState(() {
        _loginId = ref.read(userProvider).userID;
        _loginPassword = ref.read(userProvider).password;
      });

      _login(context);
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
                  "Welcome Back To",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 20,
                      ),
                ),
                Text(
                  "TODO LIST",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 45,
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
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Password",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your Password";
                            }
                            return null;
                          },
                          onSaved: (newValue) => _loginPassword = newValue!,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (val) => setState(() {
                                _rememberMe = val!;
                              }),
                            ),
                            const Text("Remember Me")
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _checkLogin();
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
