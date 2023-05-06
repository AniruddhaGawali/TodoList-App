import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/model/user.dart';

import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

class UserNotifier extends StateNotifier<User> {
  UserNotifier()
      : super(
          User(
            username: '',
            userID: '',
            password: '',
            isLogin: false,
            usertype: [],
          ),
        );

  void login(String username, String userID, String password, bool isLogin,
      List usertype) {
    state = User(
      username: username,
      userID: userID,
      password: password,
      isLogin: isLogin,
      usertype: usertype,
    );
  }

  Future<Database> _getDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    final db = await sql.openDatabase(
      path.join(dbPath, 'userData.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE user(id TEXT PRIMARY KEY, username TEXT , userID TEXT , password TEXT ,  isLogin INTEGER, usertype TEXT)',
        );
      },
      version: 1,
    );

    return db;
  }

  void saveUser() async {
    final db = await _getDatabase();

    db.insert(
      'user',
      {
        'id': '1',
        'username': state.username.toString(),
        'userID': state.userID.toString(),
        'password': state.password.toString(),
        'isLogin': state.isLogin ? 1 : 0,
        'usertype': state.usertype.toString(),
      },
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  Future<bool> loadUser() async {
    final db = await _getDatabase();
    final data = await db.query('user');
    if (data.isNotEmpty) {
      state = User(
        username: data.first['username'] as String,
        userID: data.first['userID'] as String,
        password: data.first['password'] as String,
        isLogin: data.first['isLogin'] == 1 ? true : false,
        usertype: data.first['usertype'].toString().split(','),
      );
      return true;
    }
    return false;
  }

  Future<void> _deleteUser() async {
    final db = await _getDatabase();
    db.delete('user');
  }

  Future<bool> logout() async {
    state = User(
      username: '',
      userID: '',
      password: '',
      isLogin: false,
      usertype: [],
    );

    await _deleteUser();

    return true;
  }
}

final userProvider = StateNotifierProvider<UserNotifier, User>(
  (ref) => UserNotifier(),
);
