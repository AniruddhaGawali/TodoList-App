enum UserType {
  frontend,
  backend,
  designer,
  tester,
}

class User {
  String username;
  String userID;
  String password;
  bool isLogin;
  List usertype;

  User({
    required this.username,
    required this.userID,
    required this.password,
    required this.isLogin,
    required this.usertype,
  });

  bool get isSuperUser {
    return usertype.contains('LEADER') ||
        usertype.contains('CO-LEADER') ||
        usertype.contains('MANAGER');
  }

  List<UserType> get userTypeList {
    List<UserType> usertyplist = [];
    if (usertype.contains('FRONTEND')) {
      usertyplist.add(UserType.frontend);
    }
    if (usertype.contains('BACKEND')) {
      usertyplist.add(UserType.backend);
    }
    if (usertype.contains('DESIGNER')) {
      usertyplist.add(UserType.designer);
    }
    if (usertype.contains('TESTER')) {
      usertyplist.add(UserType.tester);
    }
    return usertyplist;
  }
}
