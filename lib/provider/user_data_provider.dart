import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/model/user.dart';

class UserNotifier extends StateNotifier<User> {
  UserNotifier()
      : super(
          User(
            username: '',
            isLogin: false,
            usertype: [],
          ),
        );

  void login(String username, bool isLogin, List usertype) {
    state = User(
      username: username,
      isLogin: isLogin,
      usertype: usertype,
    );
  }

  void logout() {
    state = User(
      username: '',
      isLogin: false,
      usertype: [],
    );
  }
}

final userProvider = StateNotifierProvider<UserNotifier, User>(
  (ref) => UserNotifier(),
);
